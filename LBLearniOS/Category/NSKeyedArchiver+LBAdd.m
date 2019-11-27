//
//  NSKeyedArchiver+LBAdd.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/26.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "NSKeyedArchiver+LBAdd.h"

@implementation NSKeyedArchiver (LBAdd)
+ (NSData *)lb_archivedDataWithRootObject:(id)rootObject {
    NSData *data;
    if (@available(iOS 12.0, *)) {
        @try {
            NSError *error;
            data = [self archivedDataWithRootObject:rootObject requiringSecureCoding:NO error:&error];
            if (!data) {
                NSLog(@"归档失败, error:%@", error);
            }
        } @catch (NSException *exception) {
            NSLog(@"归档异常:%@", exception);
        } @finally {
            
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        @try {
            data = [self archivedDataWithRootObject:rootObject];
        } @catch (NSException *exception) {
            NSLog(@"归档异常:%@", exception);
        } @finally {
        }
#pragma clang diagnostic pop
    }
    return data;
}

@end


@implementation NSKeyedUnarchiver (LBAdd)
+ (id)lb_unarchiveObjectWithData:(NSData *)data cls:(Class)cls {
    id obj;
    if (@available(iOS 12.0, *)) {
        @try {
            NSError *error;
            obj = [self unarchivedObjectOfClass:cls fromData:data error:&error];
            if (error) {
                NSLog(@"反归档失败, error:%@", error);
            }
        } @catch (NSException *exception) {
            NSLog(@"反归档异常:%@", exception);
        } @finally {
        }
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        @try {
            obj = [self unarchiveObjectWithData:data];
        } @catch (NSException *exception) {
            NSLog(@"反归档异常:%@", exception);
        } @finally {
        }
#pragma clang diagnostic pop
    }
    return obj;
    
}

@end
