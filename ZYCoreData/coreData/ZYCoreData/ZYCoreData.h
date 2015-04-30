//
//  ZYCoreData.h
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-6.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSEntityDescription+Ext.h"

#define DATABASE_NAME "Model"
#define CHAR_NSSTR(x) [[NSString alloc] initWithUTF8String:x]

@interface ZYCoreData : NSObject
{
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel         *_managedObjectModel;
    NSManagedObjectContext       *_managedObjectContext;
}

@property(getter = getPersistentStoreCoordinator, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(getter = getManagedObjectContext,       readonly) NSManagedObjectContext       *managedObjectContext;
@property(getter = getMmanagedObjectModel,        readonly) NSManagedObjectModel         *managedObjectModel;

//生成一个单例
+(instancetype) sharedCoreData;
//删除记录
- (BOOL)removeObject:(NSManagedObject *)object;
- (BOOL)deleteObjectes:(NSArray *)objes;
- (BOOL)clearTable:(NSString *)table;
//删除记录
- (BOOL)deleteRecord:(NSString *)table predicate:(NSString *)predicateStr;
//插入记录
- (BOOL)insertRecord:(NSDictionary *)insertObj tableName:(NSString *)table;
//插入记录不保存
- (void)insertRecordDontSave:(NSDictionary *)insertObj tableName:(NSString *)table;
//获取记录
- (NSArray *)getrRecord:(NSString *)table sortKey:(NSString *)sortStr predicate:(NSString *)predicateStr;
- (BOOL)save;

//更新记录
-(BOOL)updateRecord:(NSString*)table predicate:(NSString *)predicateStr updateProperties:(NSDictionary*)properties;
@end
