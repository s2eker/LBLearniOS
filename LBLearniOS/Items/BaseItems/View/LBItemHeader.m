//
//  LBItemHeader.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/9/3.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBItemHeader.h"

@interface LBItemHeader()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation LBItemHeader

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
}

@end
