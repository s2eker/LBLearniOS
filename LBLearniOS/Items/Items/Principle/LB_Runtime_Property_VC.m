//
//  LB_Runtime_Property_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2020/1/9.
//  Copyright © 2020 李兵. All rights reserved.
//

#import "LB_Runtime_Property_VC.h"
#import "LB_Runtime_Property_Model_Animal.h"

#import <objc/runtime.h>

@interface LB_Runtime_Property_VC ()

@end

@implementation LB_Runtime_Property_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self play];
}


- (void)play {
    //1. 获取属性数组
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(LB_Runtime_Property_Model_Animal.class, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t p = properties[i];
        const char *name = property_getName(p);
//        NSString *nameStr = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        const char *attributes = property_getAttributes(p);
//        NSString *attributesStr = [NSString stringWithCString:attributes encoding:NSUTF8StringEncoding];
        unsigned int count2 = 0;
        objc_property_attribute_t *attList = property_copyAttributeList(p, &count2);
        for (int i = 0; i < count2; i++) {
            objc_property_attribute_t att = attList[i];
//            NSLog(@"%s %s", att.name, att.value);
        }
        NSLog(@"---%s %s", name, attributes);
        free(attList);
        
    }
    free(properties);
}



@end
