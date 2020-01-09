//
//  LBItem.h
//  LBLearniOS
//
//  Created by 李兵 on 2019/1/23.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBBaseModel.h"

/**
 为了保证所有项目按照在Items.plist文件中的顺序显示,
 故设计数据结构为: 数组:[字典{UI:[Label,...]},...]
 其中字典元素只有一个,该字典就代表一个分类,如UI,网络等.如有子目,则在字典的value设为数组
 */

typedef NS_ENUM(NSInteger, LBLearnLevel) {
    LBLearnLevelUnknown,        //不了解
    LBLearnLevelKnown,          //了解
    LBLearnLevelSkilled,        //掌握
    LBLearnLevelProficient,     //精通
    
};

@interface LBItem : LBBaseModel

/**
 技能名字及描述
 */
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *des;

/**
 学习程度
 */
@property (nonatomic, assign)LBLearnLevel level;
@property (nonatomic, copy, readonly)NSString *levelDes;

/**
 深度
 */
@property (nonatomic, assign, readonly)NSInteger depth;
@property (nonatomic, assign, readonly, getter=isEnd)BOOL end;

/**
  节点
 */
@property (nonatomic, strong, readonly)NSArray <LBItem *> *subItems;
@property (nonatomic, assign, readonly)NSInteger subItemsCount;
@property (nonatomic, weak, readonly)LBItem *superItem;
@property (nonatomic, weak, readonly)LBItem *preItem;
@property (nonatomic, weak, readonly)LBItem *nexItem;
+ (LBItem *)rootItem;

/**
 对应的控制器
*/
@property (nonatomic, strong, readonly)Class vcCls;
@property (nonatomic, copy, readonly)NSString *vcClsName;
@property (nonatomic, assign, readonly, getter=vcIsFromStoryboar)BOOL vcFromStoryboard;


#pragma mark -- For Test
- (NSArray *)allEndItems;       //所有末端Item
- (NSDictionary *)toJson;       //转为JSON
- (NSArray *)allAvailableVCs;   //所有可用的VC
@end
