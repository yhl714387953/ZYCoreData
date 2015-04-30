//
//  ViewController.m
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-5.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Child.h"
#import "ZYCoreData.h"
#import "MyPerson.h"

@interface ViewController ()
{
    Person* _person;
}

@property (nonatomic, strong) NSTimer* timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self test_KVC_KVO_Attributes];
    [self testCoreDataAttributes];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark -
#pragma mark - initMethod
-(void)test_KVC_KVO_Attributes{
    _person = [[Person alloc] init];
    _person.student = [[Student alloc] init];
    
    [_person addObserver:self forKeyPath:@"age" options:NSKeyValueObservingOptionNew context:nil];//KVO  添加观察者
    _person.name = @"张三";
    _person.age = 20;//由于添加了观察者，当age改变的时候会在控制台输出age的值
    _person.sex = @"M";
    NSLog(@"name:%@    age:%ld     sex:%@", _person.name, (long)_person.age, _person.sex);
    NSDictionary* dic = @{@"name": @"lisi", @"age": @"30", @"sex": @"F", @"education": @"Doctor"};
    for (id key in dic.allKeys)
        if ([[_person getAllProperties] containsObject:key] && [dic objectForKey:key]) //这个判断是一定要有的，否则Person没有这个属性会崩掉的，当然set的value值也不能是空的
            [_person setValue:[dic objectForKey:key] forKey:key];//KVC 键值编码
    
    [_person setValue:[dic objectForKey:@"education"] forKeyPath:@"student.education"];
    
    NSLog(@"name:%@    age:%ld     sex:%@    student_education:%@", [_person valueForKey:@"name"], (long)[[_person valueForKey:@"age"] integerValue], [_person valueForKey:@"sex"], [_person valueForKeyPath:@"student.education"]);
    
    NSLog(@"%@", [_person getAllProperties]);
    NSLog(@"%@", [_person properties_aps]);
    NSLog(@"-----%s", object_getClassName(_person.student));//获取对象的类名
    [_person printMothList];
    
    NSLog(@"**********************************************");
    Child* ccc = [[Child alloc] init];
    ccc.kid = @"aa";
    NSLog(@"%@", [ccc getAllProperties]);
    NSLog(@"%@", [ccc properties_aps]);
    [ccc printMothList];
    
    [ccc setValue:@"wangWu" forKey:@"name"];
    NSLog(@"====%@", ccc.name);
    
}

-(void)testCoreDataAttributes{

// 插入两条数据
    [[ZYCoreData sharedCoreData] insertRecord:@{@"name":@"zhangSan", @"sex":@"F", @"age":@30, @"haha": @"hehe"} tableName:@"MyPerson"];
    [[ZYCoreData sharedCoreData] insertRecord:@{@"name":@"liSi", @"sex":@"M", @"age":@31} tableName:@"MyPerson"];
    
    NSArray* persons = [[ZYCoreData sharedCoreData] getrRecord:@"MyPerson" sortKey:nil predicate:@"name = 'wangWu'"];
    if (persons.count == 0) {//如果没有查询到,那就插入一条数据
        [[ZYCoreData sharedCoreData] insertRecord:@{@"name":@"wangWu", @"sex":@"M", @"age":@48} tableName:@"MyPerson"];
    }
    
//    多条件正则表达式
//    NSString* predicateStr = [NSString stringWithFormat:@"name = '%@' AND age > 30", self.name];
//    @"name = 'wangWu' AND age > 30"
    
//    修改
    [[ZYCoreData sharedCoreData] updateRecord:@"MyPerson" predicate:@"name = 'zhangSan'" updateProperties:@{@"age": @100, @"sex": @"MF", @"haha": @"hehe"}];
    
    // keys may be key paths sortKey可能是@"age" 或则@"student.age"
    NSArray* person1s = [[ZYCoreData sharedCoreData] getrRecord:@"MyPerson" sortKey:@"age" predicate:nil];//获取所有，排序方式：按照年龄大到小，其实还应该公开一个参数，升序还是降序的，现在如果按时间排序的话，大的时间急最新的在第一条
    for (MyPerson* p in person1s){
        NSLog(@"name:%@     age:%ld      sex:%@", p.name, [p.age integerValue], p.sex);
        p.members = [NSMutableArray array];
        [p.members addObjectsFromArray:@[@"1", @"2"]];
        NSLog(@"----------------%@", p.members);
        NSLog(@"%@", [p properties_aps]);
    }
    

//    清空当前的表
//    [[ZYCoreData sharedCoreData] deleteRecord:@"MyPerson" predicate:nil];
//    [[ZYCoreData sharedCoreData] clearTable:@"MyPerson"];
}

#pragma mark -
#pragma mark - Action
-(void)clicked:(UIButton*)sender{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun:) userInfo:nil repeats:YES];
}

-(void)timeRun:(NSTimer*)timer{
    _person.age++;
}

#pragma mark -
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    Person* p = (Person*)object;
    NSLog(@"%ld", (long)p.age);
}

#pragma mark -
#pragma mark - dealloc
-(void)dealloc{
    //移除观察者
    [_person removeObserver:self forKeyPath:@"age" context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Utils 方法，暂写这里，倒是没用上，感觉名字跟返回值反着的
//返回NO的时候表示空
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

@end
