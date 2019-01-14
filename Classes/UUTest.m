//
//  UUTest.m
//  ui-util
//
//  Created by 张超 on 2019/1/14.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "UUTest.h"
#import <ObjC/Runtime.h>
#import "UUTableViewController.h"
#import "UUHeader.h"
@implementation UUTest

+ (NSArray*)allChildClass
{
    int numClasses;
    Class *classes = NULL;
    
    classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    //    NSLog(@"Number of classes: %d", numClasses);
    NSMutableArray* a = [[NSMutableArray alloc] initWithCapacity:numClasses];
    if (numClasses > 0 )
    {
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            //            NSLog(@"Class name: %s", class_getName(classes[i]));
            if (class_getSuperclass(classes[i]) == [UUTest class]) {
                [a addObject:NSStringFromClass(classes[i])];
            }
        }
        free(classes);
    }
    return [a copy];
}

 

+ (NSArray *)ob_propertysWithClass:(Class)c
{
    unsigned int count = 0;
    //获取属性的列表
    objc_property_t *propertyList =  class_copyPropertyList(c, &count);
    NSMutableArray *propertyArray = [NSMutableArray array];
    for(int i=0;i<count;i++)
    {
        //取出每一个属性
        objc_property_t property = propertyList[i];
        //获取每一个属性的变量名
        const char* propertyName = property_getName(property);
        NSString *proName = [[NSString alloc] initWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propertyArray addObject:proName];
    }
    //c语言的函数，所以要去手动的去释放内存
    free(propertyList);
    return propertyArray.copy;
}

+ (NSArray *)ob_methodsWithClass:(Class)c
{
    NSMutableArray *mutArr = [NSMutableArray array];
    unsigned int outCount;
    /** 第一个参数：要获取哪个类的方法
     * 第二个参数：获取到该类的方法的数量
     */
    Method *methodList = class_copyMethodList(c, &outCount);
    // 遍历所有属性列表
    for (int i = 0; i<outCount; i++) {
        SEL name = method_getName(methodList[i]);
        [mutArr addObject:NSStringFromSelector(name)];
    }
    return [NSArray arrayWithArray:mutArr];
}

+ (void)showInView:(__kindof UIViewController *)vc
{
    UUTableViewController* u = [[UUTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    NSArray* a = [[self class] allChildClass];
    NSMutableDictionary* actions = [NSMutableDictionary dictionaryWithCapacity:10];
    [a enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Class cla  = NSClassFromString(obj);
//        NSLog(@"%@",[self ob_propertysWithClass:cla]);
//        NSLog(@"%@",[self ob_methodsWithClass:cla]);
        [actions setObject:[[self class] ob_methodsWithClass:cla] forKey:obj];
    }];
    
    u.allChildClass = a;
    u.methods = [actions copy];
    u.type = UUTableViewControllerTypeClass;
    
    if (vc) {
        UINavigationController* n = [[UINavigationController alloc] initWithRootViewController:u];
        [vc presentViewController:n animated:YES completion:nil];
    }
}


- (id)valueForUndefinedKey:(NSString *)key
{
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
       SuppressPerformSelectorLeakWarning(return [self performSelector:NSSelectorFromString(key) withObject:nil]);
    }
    return nil;
}

@end
