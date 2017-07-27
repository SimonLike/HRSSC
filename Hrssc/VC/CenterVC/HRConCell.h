//
//  HRConCell.h
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRConCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* detial;
@property (nonatomic, strong) IBOutlet UILabel* title;
@property (nonatomic, strong) IBOutlet UIImageView* icon;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;
+ (HRConCell*)getInstanceWithNib;
- (void)setUI:(HRSericeVO*)vo;
@end
