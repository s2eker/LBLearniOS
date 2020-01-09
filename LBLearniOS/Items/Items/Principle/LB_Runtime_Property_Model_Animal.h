//
//  LB_Runtime_Property_Model_Animal.h
//  LBLearniOS
//
//  Created by 李兵 on 2020/1/9.
//  Copyright © 2020 李兵. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LB_Runtime_Property_Model_Animal : NSObject
/*
 property 语义
 类型        原子性                内存          读写          getter/setter       实例变量
            atomic             assign         readwrite    getter=newGetter    @synthesize a1 = newName
            nonatomic          strong         readonly     setter=newSetter
                                weak
                                unsafe_unretained
                                copy
        默认:atomic          strong|assign      readwrite     getter=属性名,setter=set驼峰  _属性名
 符号对应:
        类型: T @encode(type)
        读写: readonly(R),rewrite(无)
        原子性: nonatomic(N),atomic(无)
        set/get: setter(S), getter(G)
        内存: assign(无), strong(&), weak(W), unsafe_unretained(无), copy(C)
                
 */

@property int a1;

@property NSNumber *a11;

@property (atomic) NSNumber *a21;
@property (nonatomic) NSNumber *a22;

@property (assign) NSNumber *a31;
@property (strong) NSNumber *a32;
@property (weak) NSNumber *a33;
@property (unsafe_unretained) NSNumber *a34;
@property (copy) NSNumber *a35;

@property (readwrite) NSNumber *a41;
@property (readonly) NSNumber *a42;

@property (getter=xyz51) NSNumber *a51;
@property (getter=xyz52) NSNumber *a52;

@property (setter=opq61:) NSNumber *a61;
@property (setter=opq62:) NSNumber *a62;


@property (nonatomic, assign, readwrite, getter=uvw71, setter=rst71:) NSNumber *a71;
@property (nonatomic, strong, readwrite, getter=uvw72, setter=rst72:) NSNumber *a72;
@property (atomic, weak, readwrite, getter=uvw73, setter=rst73:) NSNumber *a73;
@property (atomic, unsafe_unretained, readwrite, getter=uvw74, setter=rst74:) NSNumber *a74;
@property (atomic, copy, readwrite, getter=uvw75, setter=rst75:) NSNumber *a75;




@end

NS_ASSUME_NONNULL_END
