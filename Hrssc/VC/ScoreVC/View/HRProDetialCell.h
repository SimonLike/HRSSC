//
//  HRProDetialCell.h
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRProDetialCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* title;
@property (nonatomic, strong) IBOutlet UILabel* score;
@property (nonatomic, strong) IBOutlet UILabel* detial;
+ (HRProDetialCell*)getInstanceWithNib;
- (void)setUI:(HRProDetialVO*)vo;
@end
