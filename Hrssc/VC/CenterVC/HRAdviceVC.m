//
//  HRAdviceVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAdviceVC.h"

@interface HRAdviceVC ()<UITextViewDelegate>
{
    UITextView* tView;
    UIButton* commitBtn;
}
@end

@implementation HRAdviceVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self setUpAdView];
}

- (void)setUpAdView
{
    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(14, 84, SCREEN_WIDTH-28, 200)];
    bgView.backgroundColor = [UIColor whiteColor];
    [Utils cornerView:bgView withRadius:3 borderWidth:0 borderColor:nil];
    [self.view addSubview:bgView];

    tView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, bgView.width, bgView.height)];
    tView.delegate = self;
//    tView.backgroundColor = [UIColor redColor];
    [bgView addSubview:tView];
    
    commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, bgView.frameY+bgView.height+40, SCREEN_WIDTH-40, 50)];
    [commitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundColor:[Utils colorWithHexString:@"1978CA"]];
    [Utils cornerView:commitBtn withRadius:5 borderWidth:0 borderColor:nil];
    [commitBtn setTitle:@"提交" forState:0];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:commitBtn];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [tView resignFirstResponder];
}

- (IBAction)commit:(id)sender
{
    
    if ([tView.text isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"请填写意见！"];
        return;
    }
    [Net Feedback:[Utils readUser].token Title:@"" Content:tView.text CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            [[XQTipInfoView getInstanceWithNib] appear:@"提交成功"];
            [self backAction];
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
