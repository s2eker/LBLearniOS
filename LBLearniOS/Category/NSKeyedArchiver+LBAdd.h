//
//  NSKeyedArchiver+LBAdd.h
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/26.
//  Copyright © 2019 李兵. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSKeyedArchiver (LBAdd)

+ (NSData *)lb_archivedDataWithRootObject:(id)rootObject;

@end


@interface NSKeyedUnarchiver (LBAdd)

+ (id)lb_unarchiveObjectWithData:(NSData *)data cls:(Class)cls;

@end

NS_ASSUME_NONNULL_END
