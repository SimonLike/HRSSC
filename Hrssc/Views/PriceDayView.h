//
//  PriceDayView.h
//  Hotel
//
//  Created by S on 15/10/14.
//  Copyright © 2015年 UU. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PriceDayViewDelegate <NSObject>

- (void)OKDayPress:(NSString*)nomalPrice Row:(NSInteger)row;

@end

@interface PriceDayView : UIView
@property (nonatomic, strong) IBOutlet UILabel* moneyQLabel;
@property (nonatomic, strong) IBOutlet UILabel* moneyBLabel;
@property (nonatomic, strong) IBOutlet UILabel* moneySLabel;
@property (nonatomic, strong) IBOutlet UILabel* moneyGLabel;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, strong) IBOutlet UIButton* commitBtn;
@property (nonatomic, strong) id<PriceDayViewDelegate>delegate;
@property (nonatomic, strong) NSString* perPrice;
@property (nonatomic, strong) IBOutlet UILabel* tipLabel;
@property (nonatomic, strong) IBOutlet UILabel* tipTitle;
- (void)appearWithTitle:(NSInteger)title Delegate:(id)de;
- (void)appearWithTitle:(NSString*)title Tip:(NSString*)tip CommitTitle:(NSString*)commitTitle Delegate:(id)de Row:(NSInteger)row;
+ (PriceDayView*)getInstanceWithNib;
@end
