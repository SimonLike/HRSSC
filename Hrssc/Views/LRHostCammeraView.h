//
//  LRHostCammeraView.h
//  LRVideo
//
//  Created by S on 16/5/27.
//  Copyright © 2016年 S. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LRHostCammeraViewDelegate <NSObject>

- (void)turnCammera;
- (void)switchFilter:(BOOL)isFilter;
- (void)switchFlight:(BOOL)isFlight;

@end

@interface LRHostCammeraView : UIView
@property (nonatomic, strong) IBOutlet UIButton* flightBtn;
@property (nonatomic, strong) IBOutlet UIButton* turnOverBtn;
@property (nonatomic, strong) IBOutlet UIButton* filterBtn;
@property (nonatomic, strong) id<LRHostCammeraViewDelegate>delegate;
+ (LRHostCammeraView*)getInstanceWithNib;
- (void)appear:(UIView*)hostView;
- (void)initBtnState;
@end
