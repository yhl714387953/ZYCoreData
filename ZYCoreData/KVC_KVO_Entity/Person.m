//
//  Person.m
//  testKVC&KVO
//
//  Created by yuhailong on 15-4-5.
//  Copyright (c) 2015年 polystor. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

#warning 只能获取当前对象的属性(不能获取父类的属性)，继承过来的属性和方法是没有的，如果继承一个BaseEntity,那么还要遍历BaseEntity 的属性去进行赋值操作
//1、/* 获取对象的所有属性，不包括属性值 */
- (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}

//2、/* 获取对象的所有属性 以及属性值 */
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

//3、/* 获取对象的所有方法 */
-(void)printMothList
{//cxx_destruct 这里除了属性的六个方法，三个对象方法，还会调用cxx_destruct方法，如下注释部分的解析
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
    {
        Method temp_f = mothList_f[i];
        IMP imp_f = method_getImplementation(temp_f);
        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,[NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}

/*
// NSObject的析构过程
// 
// 通过apple的runtime源码，不难发现NSObject执行dealloc时调用_objc_rootDealloc继而调用object_dispose随后调用objc_destructInstance方法，前几步都是条件判断和简单的跳转，最后的这个函数如下：

void *objc_destructInstance(id obj)
{
    if (obj) {
        Class isa_gen = _object_getClass(obj);
        class_t *isa = newcls(isa_gen);
        
        // Read all of the flags at once for performance.
        bool cxx = hasCxxStructors(isa);
        bool assoc = !UseGC && _class_instancesHaveAssociatedObjects(isa_gen);
        
        // This order is important.
        if (cxx) object_cxxDestruct(obj);
        if (assoc) _object_remove_assocations(obj);
        
        if (!UseGC) objc_clear_deallocating(obj);
    }
    
    return obj;
}
*/


@end
