//
//  PicCollectionViewCell.h
//  Hrssc
//
//  Created by Simon on 2017/5/10.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PicBlock)(NSInteger tag);

@interface PicCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picIma;
@property (weak, nonatomic) IBOutlet UIButton *celBtn;
@property (nonatomic, copy) PicBlock picBlock;

@end
