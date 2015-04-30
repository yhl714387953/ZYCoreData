//
//  Child.h
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-6.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import "Person.h"

@interface Child : Person
@property (nonatomic, copy) NSString* kid;
- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;
-(void)printMothList;
@end
