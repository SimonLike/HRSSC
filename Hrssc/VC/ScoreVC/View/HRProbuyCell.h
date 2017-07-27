//
//  HRProbuyCell.h
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRProbuyCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* title;
@property (nonatomic, strong) IBOutlet UIImageView* img;
@property (nonatomic, strong) IBOutlet UILabel* score;
+ (HRProbuyCell*)getInstanceWithNib;
- (void)setCellUI:(HRScoreProductVO*)vo;
@end
