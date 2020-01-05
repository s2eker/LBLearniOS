//
//  LB_AFNetworking.h
//  LBLearniOS
//
//  Created by 李兵 on 2019/9/3.
//  Copyright © 2019 李兵. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LB_AFNetworking : NSObject

+ (instancetype)sharedInstance;
- (void)download:(NSURL *)url progress:(void(^)(CGFloat fraction, NSInteger completionSize, NSInteger totalSize))progress  completion:(void(^)(NSURL *fileURL))completion;

@end

NS_ASSUME_NONNULL_END
