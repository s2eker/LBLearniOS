//
//  LB_Archive_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/26.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_Archive_VC.h"

@interface LBArchiveM : NSObject
@end
@implementation LBArchiveM
@end


@interface LBArchiveModel : NSObject <NSCoding>
{
    int _value;
}

@property (nonatomic, copy)NSString *string;
+ (instancetype)modelWithValue:(int)value string:(NSString *)string;
@end
@implementation LBArchiveModel
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:_value forKey:@"value"];
    [coder encodeObject:self.string forKey:@"string"];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    int v = [coder decodeIntForKey:@"value"];
    NSString *s = [coder decodeObjectForKey:@"string"];
    _value = v;
    self.string = s;
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"class:%@ _value:%d string:%@", self.class, _value, _string];
}
+ (instancetype)modelWithValue:(int)value string:(NSString *)string {
    LBArchiveModel *m = [self new];
    m->_value = value;
    m.string = string;
    return m;
}
@end

@interface LBArchiveSubModel : LBArchiveModel
@property (nonatomic, assign)CGFloat value1;
@end
@implementation LBArchiveSubModel
@end


@interface LBArchiveTmp : NSObject <NSSecureCoding>
@property (nonatomic, copy)NSString *text;
+ (instancetype)modelWithText:(NSString *)text;
@end
@implementation LBArchiveTmp
+ (BOOL)supportsSecureCoding {
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeInt:0xffffffff forKey:@"int value"];
    [coder encodeObject:@[@1, @2, @3] forKey:@"array"];
    [coder encodeObject:@{@1:@"a", @2:@"b", @3:@"c"} forKey:@"dictionary"];
    [coder encodeObject:[NSSet setWithObjects:@4, @5, @6, nil] forKey:@"set"];
    
    
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]) {
        self.text = [coder decodeObjectForKey:@"text"];
        
        //测试集合类型, 集合类型和自定义对象一样, 需要指明类, 因为编码器不确定集合里放的是什么类型
        NSArray *arr = [coder decodeObjectOfClass:NSArray.class forKey:@"array"];
        NSArray *dic = [coder decodeObjectOfClass:NSDictionary.class forKey:@"dictionary"];
        NSArray *set = [coder decodeObjectOfClass:NSSet.class forKey:@"set"];
        NSLog(@"集合类型 arr:%@, dic:%@, set:%@", arr, dic, set);
        
        
        //测试类型不匹配
        int num = [coder decodeIntForKey:@"int value"];
        long num1 = [coder decodeIntForKey:@"int value"];
        NSLog(@"int to long, %x:%lx", num, num1);
        
        //测试不存在的key
        NSLog(@"不存在的key的返回值 noObject:%@", [coder decodeObjectForKey:@"noObject"]);
        NSLog(@"不存在的key的返回值 noBool:%d", [coder decodeBoolForKey:@"noBool"]);
        NSLog(@"不存在的key的返回值 noInt:%d", [coder decodeIntForKey:@"noInt"]);
        NSLog(@"不存在的key的返回值 noFloat:%f", [coder decodeFloatForKey:@"noFloat"]);
        NSLog(@"不存在的key的返回值 noDouble:%lf", [coder decodeDoubleForKey:@"noDouble"]);

    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %@>", self.class, self.text];
}
+ (instancetype)modelWithText:(NSString *)text {
    LBArchiveTmp *m = [LBArchiveTmp new];
    m.text = text;
    return m;
}

@end

@interface LBArchiveSecureModel : NSObject <NSSecureCoding>
{
    int _value;
}

@property (nonatomic, copy)NSString *string;
@property (nonatomic, strong)LBArchiveTmp *tmp;
+ (instancetype)modelWithValue:(int)value string:(NSString *)string;
@end
@implementation LBArchiveSecureModel
+ (BOOL)supportsSecureCoding {
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:_value forKey:@"value"];
    [coder encodeObject:self.string forKey:@"string"];
    [coder encodeObject:self.tmp forKey:@"tmp"];
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _value = [coder decodeIntForKey:@"value"];
        self.string = [coder decodeObjectForKey:@"string"];
        // 反归档 自定义类的对象, 如今, 必须用 - decodeObjectOfClass:forKey: 方法, 否则报错
//        self.tmp = [coder decodeObjectForKey:@"tmp"];
        self.tmp = [coder decodeObjectOfClass:LBArchiveTmp.class forKey:@"tmp"];
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"class:%@ _value:%d string:%@ tmp:%@", self.class, _value, self.string, self.tmp];
}
+ (instancetype)modelWithValue:(int)value string:(NSString *)string {
    LBArchiveSecureModel *m = [self new];
    m->_value = value;
    m.string = string;
    m.tmp = [LBArchiveTmp modelWithText:@"play"];
    return m;
}
@end

@interface LBArchiveSecureSubModel : LBArchiveSecureModel
@property (nonatomic, assign)CGFloat value1;
@end
@implementation LBArchiveSecureSubModel
// 子类如果要归档自己独有的实例变量, 需要重写 -encodeWithCoder: 方法
- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    [coder encodeFloat:_value1 forKey:@"value1"];
}

// 子类如果要反归档自己独有的实例变量, 必须要:
// 1. 重写 +supportsSecureCoding 的方法, 并返回YES
// 2. 如果属性中有其它自定义的非值对象类型, 则
+ (BOOL)supportsSecureCoding {
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    LBArchiveSecureSubModel *m = [super initWithCoder:coder];
    m->_value1 = [coder decodeFloatForKey:@"value1"];
    return m;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"class:%@ _value:%d _value:%lf string:%@", self.class, _value, _value1, self.string];
}
+ (instancetype)modelWithValue:(int)value string:(NSString *)string {
    LBArchiveSecureSubModel *m = [super modelWithValue:value string:string];
    m->_value1 = 55.66;
    return m;
}
@end





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
    LBArchiveTypeM,
    LBArchiveTypeModel,
    LBArchiveTypeSubModel,
    LBArchiveTypeTmp,
    LBArchiveTypeSecureModel,
    LBArchiveTypeSecureSubModel,
    
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
               @(LBArchiveTypeM):@"LBArchiveM",
               @(LBArchiveTypeModel):@"LBArchiveModel",
               @(LBArchiveTypeSubModel):@"LBArchiveSubModel",
               @(LBArchiveTypeTmp):@"LBArchiveTmp",
               @(LBArchiveTypeSecureModel):@"LBArchiveSecureModel",
               @(LBArchiveTypeSecureSubModel):@"LBArchiveSecureSubModel",
               
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
        case LBArchiveTypeM: obj = [LBArchiveM new]; break;
        case LBArchiveTypeModel: obj = [LBArchiveModel modelWithValue:10 string:@"model"]; break;
        case LBArchiveTypeSubModel: obj = [LBArchiveSubModel modelWithValue:11 string:@"subModel"]; break;
        case LBArchiveTypeTmp: obj = [LBArchiveTmp modelWithText:@"something"]; break;
        case LBArchiveTypeSecureModel: obj = [LBArchiveSecureModel modelWithValue:10 string:@"secure model"]; break;
        case LBArchiveTypeSecureSubModel: obj = [LBArchiveSecureSubModel modelWithValue:11 string:@"secure subModel"]; break;
        
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
        NSLog(@"归档,输入有误, obj: %@ fileName:%@", obj, fileName);
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
        NSLog(@"反归档,输入有误, type:%@ cls:%@", type, cls);
        return nil;
    }
    
    NSData *data = [self _readDataFrom:type];
    
    id obj = [NSKeyedUnarchiver lb_unarchiveObjectWithData:data cls:cls];
    NSLog(@"反归档%@, obj:%@ data.length:%ld", obj!=nil ? @"成功" : @"失败", obj, data.length);
    
    return obj;
}
- (BOOL)_writeData:(NSData *)data to:(NSString *)fileName {
    if (!data || fileName.length <= 0) {
        NSLog(@"写入,输入有误:fileName:%@", fileName);
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
