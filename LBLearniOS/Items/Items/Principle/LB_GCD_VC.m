//
//  LB_GCD_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/28.
//  Copyright © 2019 李兵. All rights reserved.
//

#define forLoop(flag, count)\
for (int _i = 0; _i < count; _i++) {\
    NSLog(@"%d-%d %@", flag, _i, [NSThread currentThread]);\
}

#import "LB_GCD_VC.h"

@interface LB_GCD_VC ()

@end

@implementation LB_GCD_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"%@", dispatch_get_main_queue());
    NSLog(@"%@", dispatch_get_global_queue(0, 0));
    [self testDemo3];
}

- (void)testDemo1 {
    dispatch_queue_t q = dispatch_queue_create("demo1", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"[%d] %s %@", __LINE__, __func__, [NSThread currentThread]);
    NSLog(@"1");
    dispatch_async(q, ^{
        NSLog(@"2");
        dispatch_async(q, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}
- (void)testDemo2 {
    dispatch_queue_t q = dispatch_queue_create("demo2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(q, ^{
        forLoop(1, 10)
    });
    dispatch_async(q, ^{
        forLoop(2, 10)
    });
    dispatch_sync(q, ^{
        forLoop(3, 10)
    });
    for (int i = 0; i < 10; i++) {
        forLoop(0, 10)
    }
    dispatch_async(q, ^{
        forLoop(7, 10)
    });
    dispatch_async(q, ^{
        forLoop(8, 10)
    });
    
    
}

- (void)testDemo3 {
    __block int a = 0;
    while (a < 5) {
//        NSLog(@"当前a :%d", a);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            a++;
            NSLog(@"[%d] %@", a, [NSThread currentThread]);
        });
    }
    NSLog(@"out %d", a);
}

@end
