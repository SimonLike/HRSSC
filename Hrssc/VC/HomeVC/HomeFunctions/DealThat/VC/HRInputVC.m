//
//  HRInputVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/6.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRInputVC.h"

@interface HRInputVC ()
@property (weak, nonatomic) IBOutlet UITextView *distaTextView;

@end

@implementation HRInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.titleLabel.text = @"描述";
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"确定" forState:UIControlStateNormal];
}
-(void)rightAction{
    
    if ([self.distaTextView.text isEqualToString:@""]) {
        [SVProgressHUD showImage:nil status:@"描述不能为空！"];
        return;
    }
    if (self.inputBlock) {
        self.inputBlock(self.distaTextView.text);
    }
    [self backAction];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
