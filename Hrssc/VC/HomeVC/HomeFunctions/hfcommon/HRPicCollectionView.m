//
//  HRPicCollectionView.m
//  Hrssc
//
//  Created by Simon on 2017/5/11.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRPicCollectionView.h"
#import "PicCollectionViewCell.h"

@implementation HRPicCollectionView

- (void)initCollection{
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    //        layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //该方法也可以设置itemSize
    //        layout.itemSize =CGSizeMake(110, 150);
    
    //2.初始化collectionView
    self.pic_collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.pic_collection.backgroundColor = [UIColor clearColor];
    self.pic_collection.delegate = self;
    self.pic_collection.dataSource = self;
    [self addSubview:self.pic_collection];
    
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.pic_collection registerNib:[UINib nibWithNibName:@"PicCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"PicCollectionViewCell"];

}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initCollection];
}

#pragma --mark UICollectionViewDelegate UICollectionViewDatasoure
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.picTypeTnt == 1) {
        return self.picspathArr.count;
    }else{
        return self.picspathArr.count + 1;
    }
//    return 1;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"PicCollectionViewCell";
    PicCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    if (self.picTypeTnt == 1) {
        cell.celBtn.hidden = YES;
        [cell.picIma sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,self.picspathArr[indexPath.row]]] placeholderImage:nil] ;
    }else{
        if (indexPath.row != self.picspathArr.count) {
            [cell.picIma sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,self.picspathArr[indexPath.row]]] placeholderImage:nil] ;
            cell.celBtn.hidden = NO;
            cell.celBtn.tag = indexPath.row;
        }else{
            cell.picIma.image = [UIImage imageNamed:@"icon_upiantianjia"];
            cell.celBtn.hidden = YES;
        }
        cell.picBlock = ^(NSInteger tag) {
            if (self.delPicBlock) {
                self.delPicBlock(tag);
            }
        };
    }
  
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.pic_collection.width - 30)/3, (self.pic_collection.width - 30)/3);
}
////定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.picTypeTnt != 1) {
        if (indexPath.row == self.picspathArr.count) {
            
            if (self.addPicBlock) {
                self.addPicBlock();
            }
        }
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
