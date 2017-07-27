//
//  HRLoginVC.h
//  Hrssc
//
//  Created by admin on 17/4/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRLoginVC : UIViewController
@property (nonatomic, strong) IBOutlet UITextField* accoutTxt;
@property (nonatomic, strong) IBOutlet UITextField* passwordTxt;
@property (nonatomic, strong) IBOutlet UIButton* loginBtn;
@property (nonatomic, strong) IBOutlet UIButton* nLoginBtn;
@property (nonatomic, strong) IBOutlet UIView* enterView;
@property (weak, nonatomic) IBOutlet UIButton *moaBtn;
@end
