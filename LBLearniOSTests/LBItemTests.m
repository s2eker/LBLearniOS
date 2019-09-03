//
//  LBItemTests.m
//  LBLearniOSTests
//
//  Created by 李兵 on 2019/9/3.
//  Copyright © 2019 李兵. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "LBItem.h"

@interface LBItemTests : XCTestCase

@end

@implementation LBItemTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSLog(@"---------------------分割线---------------------");
    
    LBItem *rootItem = [LBItem rootItem];
    [rootItem showAllItem];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
