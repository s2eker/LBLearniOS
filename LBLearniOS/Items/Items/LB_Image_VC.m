//
//  LB_Image_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/11/29.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_Image_VC.h"

@interface LB_Image_VC ()

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation LB_Image_VC
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _imageView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    
    [self testDemo1];
}

- (void)testDemo1 {
    UIImage *image = [UIImage imageNamed:@"bigImage"];
    self.imageView.image = image;
    CFDataRef rawData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    NSLog(@"data of image: %ld", [(__bridge NSData *)rawData length]);
}
- (void)testDemo2 {
    
}


@end
