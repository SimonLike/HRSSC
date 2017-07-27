//
//  HRModifyPswVC.h
//  Hrssc
//
//  Created by admin on 17/4/19.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRModifyPswVC : UIViewController
{
    NSTimer * timer;
    BOOL isTimer;
    int timeCount;
}
@property (nonatomic, strong) IBOutlet UITextField* codeTxt;
@property (nonatomic, strong) IBOutlet UITextField* passwordTxt;
@property (nonatomic, strong) IBOutlet UITextField* configPasswordTxt;
@property (nonatomic, strong) IBOutlet UIButton* commitBtn;
@property (nonatomic, strong) IBOutlet UIButton* codeBtn;
@property (nonatomic, strong) IBOutlet UIView* enterView;
@property (nonatomic, strong) IBOutlet UIView* codeView;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *account;
@end
