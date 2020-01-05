//
//  LB_Protocal_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/26.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_Protocal_VC.h"

@protocol LBProtocalA <NSObject>
@optional
- (void)func1;
@required
- (void)func2;
@end

@interface LBProtocalModelA : NSObject <LBProtocalA>
@end
@implementation LBProtocalModelA
- (void)func2 {
    NSLog(@"11 %@", self);
}
@end

@interface LBProtocalModelB : NSObject <LBProtocalA>
@end
@implementation LBProtocalModelB
- (void)func2 {
    NSLog(@"22 %@", self);
}
@end

@interface LBProtocalModelSubB : LBProtocalModelB
@end
@implementation LBProtocalModelSubB
@end


@interface LB_Protocal_VC ()

@end

@implementation LB_Protocal_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LBProtocalModelA *objA = [LBProtocalModelA new];
    [objA func2];
    
    LBProtocalModelB *objB = [LBProtocalModelB new];
    [objB func2];
    
    LBProtocalModelSubB *objSubB = [LBProtocalModelSubB new];
    [objSubB func2];
    
}


@end
