//
//  LB_Recycle_VC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/12/6.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LB_Recycle_VC.h"

@interface LB_Recycle_View : UIView
@property (nonatomic, strong) id strongProperty;
@end
@implementation LB_Recycle_View
- (void)dealloc {
    NSLog(@"[%d] %s %@", __LINE__, __func__, self);
}
@end

@interface LB_Recycle_Model : NSObject
@property (nonatomic, strong) id strongProperty;
@end
@implementation LB_Recycle_Model
- (void)dealloc {
    NSLog(@"[%d] %s %@", __LINE__, __func__, self);
}
@end




@interface LB_Recycle_VC ()

@property (nonatomic, strong) LB_Recycle_View *view1;
@property (nonatomic, strong) LB_Recycle_Model *m1;

@end

@implementation LB_Recycle_VC

#pragma mark -- Getter
- (LB_Recycle_View *)view1 {
    if (!_view1) {
        _view1 = [[LB_Recycle_View alloc] initWithFrame:CGRectZero];
    }
    return _view1;
}
- (LB_Recycle_Model *)m1 {
    if (!_m1) {
        _m1 = [[LB_Recycle_Model alloc] init];
    }
    return _m1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: [self _strong_subView_self]; break;
        case 1: [self _strong_model_self]; break;
        
        default:
            break;
    }
}

- (void)_strong_subView_self {
    [self.view addSubview:self.view1];
    self.view1.strongProperty = self;
}
- (void)_strong_model_self {
    self.m1.strongProperty = self;
}

- (void)dealloc {
    NSLog(@"[%d] %s %@", __LINE__, __func__, self);
}

@end
