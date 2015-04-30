//
//  ZYCoreData.m
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-6.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import "ZYCoreData.h"
static ZYCoreData* _dataBase;

@implementation ZYCoreData

+(instancetype)sharedCoreData{
    if (!_dataBase) {
        _dataBase = [[ZYCoreData alloc] init];
    }
    return _dataBase;
}

- (BOOL)save
{
    BOOL result = YES;
    
    NSError *error = nil;
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
    if (context != nil)
    {
        if ([context hasChanges] && ![context save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            
            result = NO;
        }
        else
        {
            NSLog( @"数据保存成功");
        }
        
    }
    else
    {
        result = NO;
    }
    
    return result;
}

//获取记录
- (NSArray *)getrRecord:(NSString *)table sortKey:(NSString *)sortStr predicate:(NSString *)predicateStr
{
    NSFetchRequest      *fetch   = [[NSFetchRequest alloc] init];
    NSEntityDescription *object  = [NSEntityDescription entityForName:table inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor *sort;
    NSPredicate      *predicate;
    NSArray          *sortarr;
    
    [fetch setEntity: object ];
    
    if (sortStr)
    {
        // keys may be key paths
        sort    = [[NSSortDescriptor alloc] initWithKey:sortStr ascending:NO];
        sortarr = [[NSArray alloc] initWithObjects:sort, nil];
        
        [fetch setSortDescriptors:sortarr];
    }
    
    if (predicateStr)
    {
        predicate = [NSPredicate predicateWithFormat:predicateStr];
        
        [fetch setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *fetchresult = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    
    return fetchresult;
}

//插入记录
- (BOOL)insertRecord:(NSDictionary *)insertObj tableName:(NSString *)table
{
    BOOL result = YES;
    
    [self insertRecordDontSave:insertObj tableName:table];
    
    result = [self save];
    return result;
}

//插入记录不保存
- (void)insertRecordDontSave:(NSDictionary *)insertObj tableName:(NSString *)table
{
    NSEntityDescription *object = [NSEntityDescription insertNewObjectForEntityForName:table inManagedObjectContext:self.managedObjectContext];
    
    for(NSString *key in [insertObj allKeys])
    {
        if ([self isNull:[insertObj objectForKey:key]] && [[object getAllProperties] containsObject:key])
        {//这里用一个扩展去遍历一下属性，如果没有的，那就不执行操作，否则会崩溃掉
            //NSLog(@"key===%@",key);
            
            [object setValue:[insertObj objectForKey:key] forKey:key];
        }
    }
}

-(BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]])
    {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if(object==nil)
    {
        return NO;
    }
    return YES;
}

//删除记录
- (BOOL)deleteRecord:(NSString *)table predicate:(NSString *)predicateStr
{
    BOOL result = YES;
    
    NSArray *fetchresult = [self getrRecord:table sortKey:nil predicate:predicateStr];
    
    for (NSManagedObject *object in fetchresult)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    result = [self save];
    
    return result;
}

//更新记录
-(BOOL)updateRecord:(NSString *)table predicate:(NSString *)predicateStr updateProperties:(NSDictionary *)properties{
    //    首先查表找到这条记录，当然查表的时候不需要顺序
    NSArray* objects = [self getrRecord:table sortKey:nil predicate:predicateStr];
    for (NSEntityDescription* object in objects) {
        for(NSString *key in [properties allKeys])
        {
            if ([self isNull:[properties objectForKey:key]] && [[object getAllProperties] containsObject:key])
            {//这里用一个扩展去遍历一下属性，如果没有的，那就不执行操作，否则会崩溃掉
                //NSLog(@"key===%@",key);
                
                [object setValue:[properties objectForKey:key] forKey:key];
            }
        }
    }
    
    //    保存
    BOOL result = YES;
    result = [self save];
    return result;
}

//删除记录
- (BOOL)removeObject:(NSManagedObject *)object
{
    BOOL result = YES;
    
    [self.managedObjectContext deleteObject:object];
    
    result = [self save];
    
    return result;
}

- (BOOL)deleteObjectes:(NSArray *)objes
{
    BOOL result = YES;
    
    for (NSManagedObject *object in objes)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    result = [self save];
    
    return result;
}

- (BOOL)clearTable:(NSString *)table
{
    return [self deleteRecord:table predicate:nil];
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
    return url;
}

- (NSPersistentStoreCoordinator *)getPersistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    //链接数据库，备数据存储
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent: [NSString stringWithFormat:@"%@.%@",CHAR_NSSTR(DATABASE_NAME), @"sqlite"]];
    
    NSError *error = nil;
    
    //持久化存储调度器由托管对象模型初始化
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    //设置数据存储方式为SQLITE
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)getManagedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)getMmanagedObjectModel
{
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL     = [[NSBundle mainBundle] URLForResource:CHAR_NSSTR(DATABASE_NAME) withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}
@end
