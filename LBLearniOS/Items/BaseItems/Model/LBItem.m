//
//  LBItem.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/1/23.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBItem.h"

/*
 记录storyboard中用到的item, 元素名须与 Items.plist文件中Item名字一致.
*/
static NSArray *_storyboardItems;

@interface LBItem()
@property (nonatomic, assign, readwrite)NSInteger depth;

@property (nonatomic, strong)NSMutableArray <LBItem *> *privateSubItems;
@property (nonatomic, strong, readwrite)NSArray <LBItem *> *subItems;
@property (nonatomic, weak, readwrite)LBItem *superItem;
@property (nonatomic, weak, readwrite)LBItem *preItem;
@property (nonatomic, weak, readwrite)LBItem *nexItem;

@property (nonatomic, strong, readwrite)Class vcCls;
@property (nonatomic, copy, readwrite)NSString *vcClsName;
@property (nonatomic, assign, readwrite, getter=vcIsFromStoryboar)BOOL vcFromStoryboard;

@end

@implementation LBItem
#pragma mark -- Load
+ (void)load {
    _storyboardItems = @[@"AFNetworking",
                         @"Archive",
                         @"Serialization",
                         @"Recycle",
                        ];
}


#pragma mark -- Init
- (instancetype)init {
    self = [super init];
    if (self) {
        _depth = -1;
        _privateSubItems = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@", @{@"name" : self.name ?: @"",
                                               @"des" : self.des ?: @"",
                                               @"vcClsName" : self.vcClsName ?: @"",
                                               @"level" : self.levelDes,
                                               @"count" : @(self.subItemsCount)
                                               }];
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
- (BOOL)isEnd {
    return self.subItems.count <= 0;
}
- (NSArray<LBItem *> *)subItems {
    if (!_subItems) {
        _subItems = _privateSubItems.copy;
    }
    return _subItems;
}
- (NSInteger)subItemsCount {
    return self.subItems.count;
}
- (LBItem *)preItem {
    if (!_preItem) {
        NSInteger index = [self.superItem.subItems indexOfObject:self];
        if (index > 0) {
            _preItem = self.superItem.subItems[index-1];
        }
    }
    return _preItem;
}
- (LBItem *)nexItem {
    if (!_nexItem) {
        NSInteger index = [self.superItem.subItems indexOfObject:self];
        if (index < self.superItem.subItems.count - 1) {
            _nexItem = self.superItem.subItems[index+1];
        }
    }
    return _nexItem;
}


- (Class)vcCls {
    if (!_vcCls) {
        LBItem *item = self;
        NSMutableString *clsName = [NSMutableString stringWithFormat:@"LB_%@_VC", self.name];
        Class cls = NSClassFromString(clsName);
        while (!cls) {
            item = item.superItem;
            if (!item) {
                break;
            }
            [clsName insertString:[NSString stringWithFormat:@"_%@", item.name] atIndex:2];
            cls = NSClassFromString(clsName);
        }
        _vcCls = cls;
    }
    return _vcCls;
}
- (NSString *)vcClsName {
    if (!_vcClsName) {
        _vcClsName = NSStringFromClass(self.vcCls);
    }
    return _vcClsName;
}
- (BOOL)vcIsFromStoryboar {
    _vcFromStoryboard = [_storyboardItems containsObject:self.name];
    return _vcFromStoryboard;
}


#pragma mark -- Private
+ (instancetype)_modelWithJsonDic:(NSDictionary *)dic {
    LBItem *i = [LBItem new];
    i.name = dic[@"name"];
    i.des = dic[@"des"];
    i.level = [dic[@"level"] integerValue];;
    return i;
}
+ (instancetype)_modelWithName:(NSString *)name {
    LBItem *i = [LBItem new];
    i.name = name;
    return i;
}
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
            LBItem *i = [LBItem _modelWithName:dic.allKeys.firstObject];
            [self _parseJson:dic.allValues.firstObject inItem:i];
            [superItem.privateSubItems addObject:i];
            i.superItem = superItem;
        }else {
            LBItem *i = [LBItem _modelWithJsonDic:dic];
            [superItem.privateSubItems addObject:i];
            i.superItem = superItem;
        }
        
    }else if ([json isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)json;
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self _parseJson:obj inItem:superItem];
        }];
    }else if ([json isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)json;
        LBItem *i = [LBItem _modelWithName:str];
        [superItem.privateSubItems addObject:i];
        i.superItem = superItem;
    }
}


#pragma mark - Public
+ (LBItem *)rootItem {
    static LBItem *rootItem;
    if (!rootItem) {
        rootItem = [LBItem _modelWithName:@"Root"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Items" ofType:@"plist"];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        [self _parseJson:arr inItem:rootItem];
        [rootItem _parseDepth];
    }
    return rootItem;
}


#pragma mark -- For Test
- (NSArray *)allEndItems {
    NSMutableArray *items = [NSMutableArray array];
    for (LBItem *item in self.subItems) {
        if (item.isEnd) {
            [items addObject:item];
        }else {
            NSArray *subItems = [item allEndItems];
            [items addObjectsFromArray:subItems];
        }
    }
    return items.copy;
}
- (NSDictionary *)toJson {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.subItemsCount > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (LBItem *item in self.subItems) {
            if (item.subItemsCount > 0) {
                NSDictionary *subDic = [item toJson];
                [arr addObject:subDic];
            }else {
                [arr addObject:item.name];
            }
        }
        dic[self.name] = arr;
    }
    return dic.copy;
}

- (NSArray *)allAvailableVCs {
    NSMutableArray *arr = [NSMutableArray array];
    for (LBItem *i in [self allEndItems]) {
        if (i.vcClsName) {
            [arr addObject:i.vcClsName];            
        }
    }
    return arr;
}
@end
