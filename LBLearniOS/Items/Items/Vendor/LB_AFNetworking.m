//
//  LB_AFNetworking.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/9/3.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_AFNetworking.h"
#import <AFNetworking/AFNetworking.h>


@implementation LB_AFNetworking
+ (instancetype)sharedInstance {
    static LB_AFNetworking *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


- (void)download:(NSURL *)url progress:(void(^)(CGFloat fraction, NSInteger completionSize, NSInteger totalSize))progress  completion:(void(^)(NSURL *fileURL))completion {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"下载进度:[%@]  progress:%@ fraction:%lf",  [NSThread currentThread], downloadProgress, downloadProgress.fractionCompleted);
        NSLog(@"%@", downloadProgress.userInfo);
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(downloadProgress.fractionCompleted, downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSLog(@"下载到:[%@] targetPath:%@", [NSThread currentThread], targetPath);
        NSURL *documentURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *fileURL = [documentURL URLByAppendingPathComponent:[response suggestedFilename]];
        return fileURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成:[%@] filePath:%@", [NSThread currentThread], filePath);
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(filePath);
        });
        
    }];
    [task resume];
}



@end
