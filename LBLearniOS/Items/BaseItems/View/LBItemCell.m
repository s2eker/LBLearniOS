//
//  LBItemCell.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/2/15.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBItemCell.h"

@interface LBItemCell ()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLableWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLabelTrailing;

@end

@implementation LBItemCell

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255 alpha:1];
    
    self.textLabel.textColor = [UIColor whiteColor];
    self.numLabel.textColor = [UIColor whiteColor];
    self.numLabel.backgroundColor = [UIColor redColor];
}

- (void)layoutSubviews {
    self.numLabel.layer.cornerRadius = 10;
    self.numLabel.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = self.bounds.size.height/2;
    self.layer.masksToBounds = YES;
}


- (void)setItem:(LBItem *)item {
    self.textLabel.text = item.name;
    self.numLabel.text = @(item.subItemsCount).stringValue;
    if (item.subItemsCount > 0) {
        _numLableWidth.constant = 20;
        _numLabelTrailing.constant = 5;
    }else {
        _numLableWidth.constant = 0;
        _numLabelTrailing.constant = 0;
    }
}


@end
