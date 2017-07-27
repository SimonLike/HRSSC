//
//  HRMsgCell.h
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRMsgCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* title;
@property (nonatomic, strong) IBOutlet UILabel* time;
@property (nonatomic, strong) IBOutlet UIView* bgView;
+ (HRMsgCell*)getInstanceWithNib;
- (void)setUI:(HRMsgVO*)vo;
@end
