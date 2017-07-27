//
//  HRModifyPswVC.m
//  Hrssc
//
//  Created by admin on 17/4/19.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRModifyPswVC.h"

@interface HRModifyPswVC ()

@end

@implementation HRModifyPswVC

- (void)setUI
{
    self.title = @"忘记密码";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    //self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    UIButton* backBtn = [Utils createButtonWith:CustomButtonType_Back text:nil];
    [backBtn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    [Utils cornerView:_enterView withRadius:0 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
    [Utils cornerView:_codeView withRadius:0 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
    [Utils cornerView:_commitBtn withRadius:3 borderWidth:0 borderColor:nil];
    [Utils cornerView:_codeBtn withRadius:3 borderWidth:0 borderColor:nil];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.codeTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    [self.configPasswordTxt resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
    //NSLog(@"%@",string);
    
    if(textField == self.codeTxt)
    {
        if(([@"0123456789" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.codeTxt.text.length>=6&&range.length==0))
            return NO;
        else
            return YES;
    }
    else if(textField == self.passwordTxt)
    {
        if(([@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.passwordTxt.text.length>=16&&range.length==0))
            return NO;
        else
            return YES;
    }
    else if(textField == self.configPasswordTxt)
    {
        if(([@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.configPasswordTxt.text.length>=16&&range.length==0))
            return NO;
        else
            return YES;
    }
    else
        return NO;
}

#pragma mark - 确定
- (IBAction)finish:(id)sender
{
    if([_codeTxt.text isEqualToString:@""])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"请输入验证码"];
        return;
    }
    if([_passwordTxt.text isEqualToString:@""])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"请输入密码"];
        return;
    }
    if(![_passwordTxt.text isEqualToString:_configPasswordTxt.text])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"密码不一致"];
        return;
    }
    
    [Net ForgetPSW2:self.account Phone:self.phone Code:_codeTxt.text NewPassword:_passwordTxt.text CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            [Utils showMSG:@"修改成功！"];

            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } FailBack:^(NSError *error) {
        
    }];
    
}

#pragma mark - 验证码
- (IBAction)codeAction:(id)sender
{
    [self.codeTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    [self.configPasswordTxt resignFirstResponder];
    if(!isTimer)
    {
        [Net sendAuthPhone:self.phone CallBack:^(BOOL isSucc, NSDictionary *info) {
            if (isSucc) {
                if([info[@"status"] intValue] == 1)
                {
                    [[XQTipInfoView getInstanceWithNib] appear:@"验证码已发送"];
                    timeCount = 60;
                    isTimer = YES;
                    self.codeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%i)",timeCount];
                    [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%i)",timeCount] forState:UIControlStateNormal];
                    self.codeBtn.backgroundColor = [Utils colorWithHexString:@"eeeeee"];
                    [self.codeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(couter) userInfo:nil repeats:YES];
                    //[[XQTipInfoView getInstanceWithNib]appear:[[dic[@"data"] objectForKey:@"code"] stringValue]];
                    //NSLog(@"timeInit");
                    //[self.navigationController popToRootViewControllerAnimated:YES];
                }
                else
                {
                    [[XQTipInfoView getInstanceWithNib]appear:info[@"msg"]];
                }
            }else{
                [[XQTipInfoView getInstanceWithNib]appear:info[@"msg"]];
            }
        } FailBack:^(NSError *error) {
            [[XQTipInfoView getInstanceWithNib]appear:@"网络错误"];
        }];
        
       
    }
    
}

- (void)couter
{
    if(timeCount > 0)
    {
        timeCount -= 1;
        self.codeBtn.titleLabel.text = [NSString stringWithFormat:@"重新获取(%i)",timeCount];
        [self.codeBtn setTitle:[NSString stringWithFormat:@"重新获取(%i)",timeCount] forState:UIControlStateNormal];
        self.codeBtn.enabled = NO;
    }
    else
    {
        isTimer = NO;
        [timer invalidate];
        timer = nil;
        self.codeBtn.enabled = YES;
        self.codeBtn.titleLabel.text = @"获取验证码";
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeBtn.backgroundColor = [Utils colorWithHexString:@"1978CA"];
        [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.codeTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    [self.configPasswordTxt resignFirstResponder];
    return YES;
}

@end
