//
//  Person.h
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-5.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"

@interface Person : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic) NSInteger age;
@property (nonatomic, copy) NSString* sex;
@property (nonatomic, weak) Person* child_p;
@property (nonatomic, strong) Student* student;

- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;
-(void)printMothList;
@end
