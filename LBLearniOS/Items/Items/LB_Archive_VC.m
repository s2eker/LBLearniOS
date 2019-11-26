//
//  LB_Archive_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/26.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_Archive_VC.h"

typedef NS_ENUM(NSUInteger, LBArchiveType) {
    LBArchiveTypeString,
    LBArchiveTypeNumber,
    LBArchiveTypeData,
    LBArchiveTypeArray,
    LBArchiveTypeDictionary,
    LBArchiveTypeSet,
    LBArchiveTypeView,
    LBArchiveTypeLabel,
    LBArchiveTypeImage,
    LBArchiveTypeButton,
    LBArchiveTypeImageView,
    LBArchiveTypeTextView,
    LBArchiveTypeTableView,
};

@interface LB_Archive_VC ()
{
    NSDictionary *_types;
    NSMutableDictionary *_flags;
}

@end

@implementation LB_Archive_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _types = @{@(LBArchiveTypeString):@"NSString",
               @(LBArchiveTypeNumber):@"NSNumber",
               @(LBArchiveTypeData):@"NSData",
               @(LBArchiveTypeArray):@"NSArray",
               @(LBArchiveTypeDictionary):@"NSDictionary",
               @(LBArchiveTypeSet):@"NSSet",
               @(LBArchiveTypeView):@"UIView",
               @(LBArchiveTypeLabel):@"UILabel",
               @(LBArchiveTypeImage):@"UIImage",
               @(LBArchiveTypeButton):@"UIButton",
               @(LBArchiveTypeImageView):@"UIImageView",
               @(LBArchiveTypeTextView):@"UITextView",
               @(LBArchiveTypeTableView):@"UITableView",
    };
    
    _flags = [NSMutableDictionary dictionary];
}

#pragma mark -- Utilities
- (id)objectOfType:(NSString *)type {
    id obj;
    LBArchiveType t = [(NSNumber *)[_types allKeysForObject:type].firstObject integerValue];
    
    char data[10] = {0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x20};
    switch (t) {
        case LBArchiveTypeString: obj = [NSString stringWithFormat:@"hello world!"]; break;
        case LBArchiveTypeNumber: obj = [NSNumber numberWithFloat:12345678.87654321]; break;
        case LBArchiveTypeData: obj = [NSData dataWithBytes:data length:10]; break;
        case LBArchiveTypeArray: obj = [NSArray arrayWithObjects:@"a", @"b", @"c", nil]; break;
        case LBArchiveTypeDictionary: obj = [NSDictionary dictionaryWithObjects:@[@1,@2,@3] forKeys:@[@"a", @"b", @"c"]]; break;
        case LBArchiveTypeSet: obj = [NSSet setWithObjects:@1,@2, @3, nil]; break;
        case LBArchiveTypeView: obj = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; break;
        case LBArchiveTypeLabel: obj = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; break;
        case LBArchiveTypeImage: obj = [UIImage imageNamed:@"avatar"]; break;
        case LBArchiveTypeButton: obj = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; break;
        case LBArchiveTypeImageView: obj = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; break;
        case LBArchiveTypeTextView: obj = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; break;
        case LBArchiveTypeTableView: obj = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)]; break;
        
        default: break;
    }
    
    return obj;
}
- (BOOL)inverseArchivedFlagOfIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld%ld", indexPath.section, indexPath.row];
    BOOL isArchived = NO;
    if (!_flags[key]) {
        isArchived = NO;
    }else {
        isArchived = [_flags[key] boolValue];
    }
    _flags[key] = @(!isArchived);
    return [_flags[key] boolValue];
}


#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *text = cell.textLabel.text;
    
    BOOL toArchive = [self inverseArchivedFlagOfIndexPath:indexPath];
    if (toArchive) {
        [self archiveObjType:text];
    }else {
        [self unarchiveObjType:text];
    }
}


#pragma mark -- Archive & Unarchive
- (void)archiveObjType:(NSString *)type {
    id obj = [self objectOfType:type];
    [self _archiveObj:obj to:type];
}
- (void)unarchiveObjType:(NSString *)type {
    [self _unarchiveObjOfType:type];
}

- (BOOL)_archiveObj:(id) obj to:(NSString *)fileName {
    if (!obj || fileName.length <= 0) {
        NSLog(@"输入有误, obj: %@ fileName:%@", obj, fileName);
        return NO;
    }
    
    NSData *data = [NSKeyedArchiver lb_archivedDataWithRootObject:obj];
    NSLog(@"归档%@, obj:%@ data.length:%ld", data!=nil ? @"成功" : @"失败", obj, data.length);
    
    BOOL ret = [self _writeData:data to:fileName];
    return ret;
}
- (nullable id)_unarchiveObjOfType:(NSString *)type {
    Class cls = NSClassFromString(type);
    if (type.length <= 0 || !cls) {
        NSLog(@"输入有误, type:%@ cls:%@", type, cls);
        return nil;
    }
    
    NSData *data = [self _readDataFrom:type];
    
    id obj = [NSKeyedUnarchiver lb_unarchiveObjectWithData:data cls:cls];
    NSLog(@"反归档%@, obj:%@ data.length:%ld", obj!=nil ? @"成功" : @"失败", obj, data.length);
    
    return obj;
}
- (BOOL)_writeData:(NSData *)data to:(NSString *)fileName {
    if (!data || fileName.length <= 0) {
        NSLog(@"输入有误:fileName:%@", fileName);
        return NO;
    }
    
    NSString *folder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"Archives"];
    NSFileManager *m = [NSFileManager defaultManager];
    BOOL isFolder;
    BOOL existed = [m fileExistsAtPath:folder isDirectory:&isFolder];
    if (!existed) {
        NSError *error;
        [m createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件夹失败:%@ error:%@", folder, error);
            return NO;
        }
    }
    
    NSString *filePath = [folder stringByAppendingPathComponent:fileName];
    BOOL ret = [m createFileAtPath:filePath contents:data attributes:nil];
    NSLog(@"写入%@, filePath:%@", ret ? @"成功" : @"失败", filePath);
    return ret;
}
- (NSData *)_readDataFrom:(NSString *)fileName {
    if (fileName.length <= 0) {
        NSLog(@"输入有误:fileName:%@", fileName);
    }
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingFormat:@"/Archives/%@", fileName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"读取%@, filePath:%@", data !=nil ? @"成功" : @"失败", filePath);
    return data;
}

@end
