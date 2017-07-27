//
//  HRForgetPswVC.m
//  Hrssc
//
//  Created by admin on 17/4/19.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRForgetPswVC.h"
#import "HRModifyPswVC.h"
@interface HRForgetPswVC ()

@end

@implementation HRForgetPswVC

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
    [Utils cornerView:_loginBtn withRadius:3 borderWidth:0 borderColor:nil];
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
    [self.accoutTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
    //NSLog(@"%@",string);
    
//    if(textField == self.accoutTxt)
//    {
//        if(([@"0123456789" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.accoutTxt.text.length>=11&&range.length==0))
//            return NO;
//        else
//            return YES;
//    } else
    if(textField == self.passwordTxt)
    {
        if(([@"0123456789" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.passwordTxt.text.length>=11&&range.length==0))
            return NO;
        else
            return YES;
    }
    
//    else
//        return NO;
    
    return YES;
}

#pragma mark - 登录
- (IBAction)findPsw:(id)sender
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
    HRModifyPswVC* vc = [HRModifyPswVC new];
    vc.account =self.accoutTxt.text;
    vc.phone =self.passwordTxt.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.accoutTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    return YES;
}

@end
