//
//  LBItemsCVC.m
//  LBLearniOS
//
//  Created by 李兵 on 2019/1/23.
//  Copyright © 2019 李兵. All rights reserved.
//

#import "LBItemsCVC.h"
#import "LBItem.h"
#import "LBItemCell.h"
#import "LBItemHeader.h"

@interface LBItemsCVC ()<UICollectionViewDelegateFlowLayout>

@end

@implementation LBItemsCVC

- (LBItem *)item {
    if (!_item) {
        _item = [LBItem rootItem];
    }
    return _item;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self initSet];
}

- (void)initSet {
    self.title = self.item.name;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBItemCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LBItemHeader" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
}

- (NSInteger)sectionCount {
    if (self.item.depth == 1) {
        return 1;
    }
    return self.item.subItemsCount;
}
- (NSInteger)rowCountOfSection:(NSInteger)section {
    if (self.item.depth == 1) {
        return self.item.subItemsCount;
    }
    LBItem *item = self.item.subItems[section];
    return item.subItems.count;
}
- (LBItem *)itemWithIndexPath:(NSIndexPath *)indexPath {
    if (self.item.depth == 1) {
        return self.item.subItems[indexPath.row];
    }else {
        LBItem *item = self.item.subItems[indexPath.section];
        return item.subItems[indexPath.row];
    }
}
- (LBItem *)itemWithSection:(NSInteger)section {
    if (self.item.depth == 1) {
        return self.item;
    }else {
        return self.item.subItems[section];
    }
}
- (CGFloat)widthOfItem:(LBItem *)item {
    CGRect rect1 = [item.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGRect rect2 = CGRectIntegral(rect1);
    CGFloat w = item.isEnd ? 0 : 25;
    return rect2.size.width + 30 + w;
}


#pragma mark -- <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self sectionCount];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self rowCountOfSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LBItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    LBItem *item = [self itemWithIndexPath:indexPath];
    cell.item = item;
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        LBItemHeader *v = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        LBItem *item = [self itemWithSection:indexPath.section];
        [v setText:item.name];
        return v;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LBItem *item = [self itemWithIndexPath:indexPath];
    if (item.subItemsCount <= 0) {
        if (item.vcCls) {
            LBBaseItemVC *vc;
            if (item.vcIsFromStoryboar) {
                vc  = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:item.vcClsName];
            }else {
                vc = [[item.vcCls alloc] init];
            }
            vc.item = item;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSLog(@"不存在:%@", item.name);
        }
    }else {
        LBItemsCVC *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([LBItemsCVC class])];
        vc.item = item;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(100, 40);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self widthOfItem:[self itemWithIndexPath:indexPath]], 30);
}




@end
