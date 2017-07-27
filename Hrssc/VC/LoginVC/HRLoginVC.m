//
//  HRLoginVC.m
//  Hrssc
//
//  Created by admin on 17/4/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRLoginVC.h"
#import "HRNStaffLogin.h"
#import "HRForgetPswVC.h"
#import "AppDelegate.h"
#import "EMMSecurity.h"

@interface HRLoginVC ()<EMMSecurityVerifyDelegate>

@end

@implementation HRLoginVC

- (void)setUI
{
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [Utils cornerView:_enterView withRadius:0 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
    [Utils cornerView:_loginBtn withRadius:3 borderWidth:0 borderColor:nil];
    [Utils cornerView:_moaBtn withRadius:3 borderWidth:0 borderColor:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
//    [self setNeedsStatusBarAppearanceUpdate];
    
    
    //单点登录
    /*
     * 报错不能运行时 查看Third/HRSinglePoint
     * 我只提示下，被坑了半个小时。。。
     * 下位接手者你也欣赏下啊
     */
//    [[EMMSecurity share] applicationLaunchingWithAppId:@"A00262"];
//    [EMMSecurity share].delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.accoutTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
    //NSLog(@"%@",string);
    
    if(textField == self.accoutTxt)
    {
//        if(([@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.accoutTxt.text.length>=11&&range.length==0))
//            return NO;
//        else
            return YES;
    }
      if(textField == self.passwordTxt)
    {
        if(([@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:string].length == 0&&![string isEqualToString:@""]))
            return NO;
        else
            return YES;
    }
    
    else
        return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accoutTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    return YES;
}

#pragma mark - 登录
- (IBAction)moaLogin:(id)sender {

    [Net moaLogin:[EMMSecurity share].userInfo[@"UID"] Name:[EMMSecurity share].userInfo[@"CNM"] Mac:@"" Version:@"" Login_way:@"ios" CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            DLog(@"info--->%@",info)
            UserVO* vo = [UserVO objectWithKeyValues:info[@"data"][@"user"]];
            [Utils archiveUser:vo];
            [[XQTipInfoView getInstanceWithNib] appear:@"登录成功"];
            [(AppDelegate*)MyAppDelegate switchLoginStatue:YES];
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (IBAction)Login:(id)sender
{
    if([_accoutTxt.text isEqualToString:@""])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"请输入帐号"];
        return;
    }
    if([_passwordTxt.text isEqualToString:@""])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"请输入密码"];
        return;
    }
    self.loginBtn.enabled = NO;
    
    [Net Login:1 Account:_accoutTxt.text Password:_passwordTxt.text Mac:@"" Version:@"" Login_way:@"ios" CallBack:^(BOOL isSucc, NSDictionary *info) {
        self.loginBtn.enabled = YES;

        if(isSucc)
        {
            UserVO* vo = [UserVO objectWithKeyValues:info[@"data"][@"user"]];
            [Utils archiveUser:vo];
            [[XQTipInfoView getInstanceWithNib] appear:@"登录成功"];
            [(AppDelegate*)MyAppDelegate switchLoginStatue:YES];
        }
        else
            ;
    } FailBack:^(NSError *error) {
        
    }];
 
}
- (void)securityVerifySuccess:(NSInteger)verifyType{
    DLog(@"verifyType--->%ld",(long)verifyType);
}
- (void)securityVerifyFailureWithCode:(NSInteger)errorCode errorMsg:(NSString *)errorMsg{
    DLog(@"errorCode--->%ld",(long)errorCode);
}
#pragma mark - 忘记密码
- (IBAction)forgetPsw:(id)sender
{
    HRForgetPswVC* vc = [HRForgetPswVC new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 新员工登录
- (IBAction)nLogin:(id)sender
{
    HRNStaffLogin* vc = [HRNStaffLogin new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
