//
//  LBExceptionHandler.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/26.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBExceptionHandler.h"

@implementation LBExceptionHandler

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)setup {
    NSSetUncaughtExceptionHandler(handleException);
}

void handleException(NSException *exception) {
    NSLog(@"%@", exception);
}




+ (void)setup {
    [[self sharedInstance] setup];
}


@end
