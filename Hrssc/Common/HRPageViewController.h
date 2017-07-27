//
//  HRPageViewController.h
//  Hrssc
//
//  Created by Simon on 2017/5/17.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRLeftCityView.h"

@interface HRPageViewController : UIViewController
//@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIImageView *tipImg;
@property (nonatomic,strong)UIButton* infomationBtn;
@property (nonatomic,strong)HRLeftCityView *cityView;

- (void) leftAction;

@end
