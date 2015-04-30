//
//  NSEntityDescription+Ext.h
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-6.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (Ext)

//以下这几个方法当使用的时候，实体里是一定要实现的，否则遍历属性的时候会崩溃，当然在这个扩展里可以不用实现，这里保证能访问到这个方法就可以了
- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;
//-(void)printMothList;
@end
