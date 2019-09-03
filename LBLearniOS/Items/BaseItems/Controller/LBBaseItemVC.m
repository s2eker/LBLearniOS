//
//  LBBaseItemVC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/9/3.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBBaseItemVC.h"

@interface LBBaseItemVC ()

@end

@implementation LBBaseItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.item.name;
    self.view.backgroundColor = [UIColor whiteColor];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
