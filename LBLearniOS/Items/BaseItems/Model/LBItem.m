//
//  LBItem.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/1/23.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBItem.h"

@interface LBItem()
@property (nonatomic, assign, readwrite)NSInteger depth;
@property (nonatomic, strong, readwrite)NSMutableArray <LBItem *> *privateSubItems;
@property (nonatomic, strong, readwrite)LBItem *superItem;
@property (nonatomic, strong, readwrite)NSArray <LBItem *> *subItems;

@end

@implementation LBItem

#pragma mark -- Init
- (instancetype)init {
    self = [super init];
    if (self) {
        [self initSet];
    }
    return self;
}

- (void)initSet {
    _depth = -1;
    _privateSubItems = [NSMutableArray arrayWithCapacity:0];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"name" : _name ?: @"",
                                               @"des" : _des ?: @"",
                                               @"clsName" : _clsName ?: @"",
                                               @"level" : self.levelDes,
                                               @"count" : @(self.subItemsCount)
                                               }];
}

+ (instancetype)modelWithJsonDic:(NSDictionary *)dic {
    LBItem *i = [LBItem new];
    i.name = dic[@"name"];
    i.des = dic[@"des"];
    i.level = [dic[@"level"] integerValue];;
    return i;
}
+ (instancetype)modelWithName:(NSString *)name {
    LBItem *i = [LBItem new];
    i.name = name;
    return i;
}

#pragma mark -- Getter
- (NSString *)levelDes {
    switch (_level) {
        case LBLearnLevelUnknown: return @"不了解"; break;
        case LBLearnLevelKnown: return @"了解"; break;
        case LBLearnLevelSkilled: return @"掌握"; break;
        case LBLearnLevelProficient: return @"精通"; break;
        default: return @"不了解"; break;
    }
}
- (NSInteger)subItemsCount {
    return self.subItems.count;
}
- (BOOL)isLast {
    return self.subItems.count <= 0;
}
- (NSArray<LBItem *> *)subItems {
    if (!_subItems) {
        _subItems = _privateSubItems.copy;
    }
    return _subItems;
}
- (NSString *)clsName {
    if (self.subItemsCount <= 0) {
        return [NSString stringWithFormat:@"LB_%@_VC", self.name];
    }
    return nil;
}


#pragma mark -- Private
- (void)_parseDepth {
    self.depth = 0;
    while (self.subItems.count > 0) {
        NSInteger depth2 = 0;
        for (LBItem *i in self.subItems) {
            [i _parseDepth];
            depth2 = MAX(i.depth, depth2);
        }
        self.depth = depth2 + 1;
        break;
    }
}
+ (void)_parseJson:(id)json inItem:(LBItem *)superItem {
    if (!superItem) return;
        
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)json;
        if (dic.count == 1) {
            LBItem *i = [LBItem modelWithName:dic.allKeys.firstObject];
            [self _parseJson:dic.allValues.firstObject inItem:i];
            [superItem.privateSubItems addObject:i];
        }else {
            LBItem *i = [LBItem modelWithJsonDic:dic];
            [superItem.privateSubItems addObject:i];
        }
        
    }else if ([json isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)json;
        if (arr.count > 0) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self _parseJson:obj inItem:superItem];
            }];            
        }
    }else if ([json isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)json;
        LBItem *i = [LBItem modelWithName:str];
        [superItem.privateSubItems addObject:i];
    }
}
- (NSDictionary *)_showAllItem {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.subItemsCount > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (LBItem *item in self.subItems) {
            if (item.subItemsCount > 0) {
                NSDictionary *subDic = [item _showAllItem];
                [arr addObject:subDic];
            }else {
                [arr addObject:item.name];
            }
        }
        dic[self.name] = arr;
    }
    return dic.copy;
}


#pragma mark -- Public
+ (LBItem *)rootItem {
    static LBItem *rootItem;
    if (!rootItem) {
        rootItem = [LBItem modelWithName:@"Root"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Items" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        [self _parseJson:arr inItem:rootItem];
        [rootItem _parseDepth];
    }
    return rootItem;
}
- (void)showAllItem {
    NSDictionary *dic = [self _showAllItem];
    NSLog(@"%@", dic);
}


@end
