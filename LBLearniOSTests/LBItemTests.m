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
@property (nonatomic, strong) LBItem *rootItem;
@end

@implementation LBItemTests

- (void)setUp {
    _rootItem = [LBItem rootItem];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testRootItem {
    NSLog(@"[%d] %s root item: %@", __LINE__, __func__, self.rootItem);
    XCTAssert(self.rootItem, @"root item is not exist, parse failed!");
}

- (void)testItemToJson {
    NSDictionary *json = [self.rootItem toJson];
    NSLog(@"[%d] %s json: %@", __LINE__, __func__, json);
    XCTAssert(json, @"convert item to json failed!");
}
- (void)testAllEndItems {
    NSArray *arr = [self.rootItem allEndItems];
    NSLog(@"[%d] %s end items: %@", __LINE__, __func__, arr);
    XCTAssert(arr, @"get all end items failed!");
    XCTAssert(arr.count > 0, @"no items provided!");
}
- (void)testAllAvailableVCs {
    NSArray *arr = [self.rootItem allAvailableVCs];
    NSLog(@"[%d] %s available view controllers: %@", __LINE__, __func__, arr);
    XCTAssert(arr, @"get all available view controller failed!");
    XCTAssert(arr.count > 0, @"no one available view controller provided!");
}

@end
