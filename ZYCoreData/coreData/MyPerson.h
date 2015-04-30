//
//  MyPerson.h
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-6.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyPerson : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSMutableArray* members;//这个字段不存储数据，外部处理数据的时候使用
//这里可以不声明这两个方法，为了外部测试使用，才公开了这两个方法
- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;

@end
