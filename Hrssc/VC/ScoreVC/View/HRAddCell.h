//
//  HRAddCell.h
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HRAddCellDelegate <NSObject>
- (void)seAdd;
@end

@interface HRAddCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIView* seView;
@property (nonatomic, strong) IBOutlet UIButton* addBtn;
@property (nonatomic, strong) IBOutlet UIView* addView;
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* phone;
@property (nonatomic, strong) IBOutlet UILabel* address;
@property (nonatomic, strong) id<HRAddCellDelegate>delegate;
+ (HRAddCell*)getInstanceWithNib;
- (void)setUI:(HRAddVO*)vo;
@end
