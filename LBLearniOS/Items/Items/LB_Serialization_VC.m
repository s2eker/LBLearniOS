//
//  LB_Serialization_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/28.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_Serialization_VC.h"

@interface LB_Serialization_VC ()
{
    NSMutableDictionary *_flags;
    NSData *_xmlData;
    NSDictionary *_options;
}
@end

@implementation LB_Serialization_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _flags = [NSMutableDictionary dictionary];
    _options = @{@"im": @(NSPropertyListImmutable),
                 @"m": @(NSPropertyListMutableContainers),
                 @"ml":@(NSPropertyListMutableContainersAndLeaves),
                 @"im+m":@(NSPropertyListImmutable|NSPropertyListMutableContainers),
                 @"im+ml":@(NSPropertyListImmutable|NSPropertyListMutableContainersAndLeaves),
                 @"m+ml":@(NSPropertyListMutableContainers|NSPropertyListMutableContainersAndLeaves),
                 @"im+m+ml":@(NSPropertyListImmutable|NSPropertyListMutableContainers|NSPropertyListMutableContainersAndLeaves),
                };
}

- (void)serializetoXML:(BOOL)toSerialize indexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    NSPropertyListMutabilityOptions opt = [_options[text] integerValue];
    
    if (toSerialize) {
        NSMutableDictionary *propertyList = @{@"name" : @"Li Si",
                                              @"sex" : @"female".mutableCopy}.mutableCopy;
        @try {
            NSError *error;
            NSData *data = [NSPropertyListSerialization dataWithPropertyList:propertyList format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
            if (!data) {
                NSLog(@"序列化错误, error:%@", error);
            }
            _xmlData = data;
            NSLog(@"序列化%@:%@", data!=nil ? @"成功" : @"失败", data);
            
        } @catch (NSException *exception) {
            NSLog(@"序列化异常:%@", exception);
        } @finally {
            
        }
        return;
    }
    
    @try {
        NSError *error;
        NSDictionary *dic = [NSPropertyListSerialization propertyListWithData:_xmlData options:opt format:nil error:&error];
        if (!dic) {
            NSLog(@"反序列化错误, error:%@", error);
        }
        NSLog(@"反序列化%@:%@", dic!=nil ? @"成功" : @"失败", dic);
        NSLog(@"!!!%ld, %@: %@ %@", opt, text, [dic class], [dic[@"sex"] class]);
    } @catch (NSException *exception) {
        NSLog(@"反序列化异常:%@", exception);
    } @finally {
        
    }
    
}

- (BOOL)inverseSerializationFlagOfIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row];
    BOOL isSerializated = NO;
    if (!_flags[key]) {
        isSerializated = NO;
    }else {
        isSerializated = [_flags[key] boolValue];
    }
    _flags[key] = @(!isSerializated);
    return [_flags[key] boolValue];
}
#pragma mark -- UITalbeViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BOOL toSerialize = [self inverseSerializationFlagOfIndexPath:indexPath];
    [self serializetoXML:toSerialize indexPath:indexPath];
}

@end
