//
//  HRPSWVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRPSWVC.h"

@interface HRPSWVC ()

@end

@implementation HRPSWVC

- (void)setUI
{
    self.title = @"修改密码";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    [Utils creatBackItem:self Selector:@selector(clickBack)];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [Utils cornerView:_commitBtn withRadius:3 borderWidth:0 borderColor:nil];
    [Utils cornerView:_enterView withRadius:3 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.oriTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
    [self.configPasswordTxt resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
    //NSLog(@"%@",string);
    
    if(textField == self.oriTxt)
    {
        if(([@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" rangeOfString:string].length == 0&&![string isEqualToString:@""])||(self.oriTxt.text.length>=16&&range.length==0))
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

#pragma mark - 登录
- (IBAction)finish:(id)sender
{
    if([_oriTxt.text isEqualToString:@""])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"请输入原密码"];
        return;
    }
    if([_passwordTxt.text isEqualToString:@""])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"请输入新密码"];
        return;
    }
    if(![_passwordTxt.text isEqualToString:_configPasswordTxt.text])
    {
        [[XQTipInfoView getInstanceWithNib] appear:@"密码不一致"];
        return;
    }
    [Net ModifyPSW:[Utils readUser].token OldPassword:_oriTxt.text NewPassword:_passwordTxt.text CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            [[XQTipInfoView getInstanceWithNib] appear:@"修改成功"];
            [self clickBack];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
