//
//  LB_AFNetworking_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/9/3.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_AFNetworking_VC.h"
#import "LB_AFNetworking.h"


@interface LB_AFNetworking_VC()
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LB_AFNetworking_VC

- (IBAction)downloadAction:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1567543020938&di=17e174e686fe761522b3988bb5970ade&imgtype=0&src=http%3A%2F%2Fwww.33lc.com%2Farticle%2FUploadPic%2F2012-7%2F201272714212210783.jpg"];
    [[LB_AFNetworking sharedInstance] download:url progress:^(CGFloat fraction, NSInteger completionSize, NSInteger totalSize) {
        self.progressLabel.text = [NSString stringWithFormat:@"%ld/%ld, %lf", completionSize, totalSize, fraction];
    } completion:^(NSURL * _Nonnull fileURL) {
        NSData *data = [NSData dataWithContentsOfURL:fileURL];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            self.imageView.image = image;
        }
    }];
}

@end
