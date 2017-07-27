//
//  HRScoreCell.h
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRScoreCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView* icon;
@property (nonatomic, strong) IBOutlet UILabel* title;
@property (nonatomic, strong) IBOutlet UILabel* score;
@property (nonatomic, strong) IBOutlet UIView* bgView;
+ (HRScoreCell*)getInstanceWithNib;
- (void)setUI:(HRScoreProductVO*)vo;
@end
