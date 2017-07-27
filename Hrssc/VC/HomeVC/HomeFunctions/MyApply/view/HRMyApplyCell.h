//
//  HRMyApplyCell.h
//  Hrssc
//
//  Created by Simon on 2017/4/26.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ApplyBlock)();
typedef void(^AlertBlock)(NSInteger tag);

@interface HRMyApplyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *printCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *operationButton;
@property (weak, nonatomic) IBOutlet UILabel *rejectedLabel;
@property (nonatomic, copy) ApplyBlock applyBlock;
@property (nonatomic, copy) AlertBlock alertBlock;

@property (weak, nonatomic) IBOutlet UIButton *a_btndel;
@property (weak, nonatomic) IBOutlet UIButton *a_btnresubmit;
@property (weak, nonatomic) IBOutlet UIView *a_view;

@property (nonatomic) NSInteger typeInt;

@end
