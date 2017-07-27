//
//  HRCenterHeadCell.h
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HRCenterHeadCellDelegate ;

@interface HRCenterHeadCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* uId;
@property (nonatomic, strong) IBOutlet UIImageView* icon;
@property (nonatomic, strong) IBOutlet UIButton* signBtn;
@property (nonatomic, strong) id<HRCenterHeadCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *handIma;
+ (HRCenterHeadCell*)getInstanceWithNib;
- (void)setUI:(HRUserInfoVO*)vo;
- (void)setSign:(BOOL)state;
@end
@protocol HRCenterHeadCellDelegate <NSObject>
- (void)signNow:(HRCenterHeadCell *)headcell;
@end
