

//
//  HRBankTemplateVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRBankTemplateVC.h"

@interface HRBankTemplateVC ()
{
    UIView *viewbg;
}

@property (nonatomic, strong)NSArray *t_array;

@end

@implementation HRBankTemplateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"保存" forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:RGBCOLOR(23, 144, 210) forState:UIControlStateNormal];
    self.t_array = [self.tpStr componentsSeparatedByString:@";"];
    
    for (int i = 0; i < self.t_array.count; i++) {
        NSArray *nameList = [self.t_array[i] componentsSeparatedByString:@"="];
        
        viewbg = [UIView new];
        viewbg.frame = CGRectMake(0, 74 + 42 * i, self.view.width, 42);
        viewbg.backgroundColor = RGBCOLOR16(0xffffff);
        viewbg.tag = 10+i;
        [self.view addSubview:viewbg];
        
        UILabel *label = [UILabel label];
        label.frame = CGRectMake(10, 0, 100, viewbg.height);
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = RGBCOLOR16(0x333333);
        label.text = nameList[0];
        label.textAlignment = NSTextAlignmentLeft;
        [viewbg addSubview:label];
        
        UITextField *textField = [UITextField new];
        textField.frame = CGRectMake(120, 0, viewbg.width - 130, viewbg.height);
        textField.font = [UIFont systemFontOfSize:14];
        textField.textColor = RGBCOLOR16(0x333333);
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = @"请填写";
        [viewbg addSubview:textField];
        
        UIView *xian = [UIView new];
        xian.frame = CGRectMake(10, viewbg.height - 1, viewbg.width - 20, 1);
        xian.backgroundColor = RGBCOLOR16(0xeeeeee);
        [viewbg addSubview:xian];

    }
}

-(void)rightAction{
    //判断输入框不能为空
    for (int i = 0; i < self.t_array.count; i++) {
        UIView *view = (UILabel *)[self.view viewWithTag:10+i];
        if ([[view.subviews[1] text]  isEqual: @""]) {
            [SVProgressHUD showImage:nil status:[NSString stringWithFormat:@"%@不能为空",[view.subviews[0] text]]];
            return;
        }
    }
    NSString *tpl_form = @"";
    for (int i = 0; i < self.t_array.count; i++) {
        UIView *view = (UILabel *)[self.view viewWithTag:10+i];

        if (i == self.t_array.count-1) {
            tpl_form = [tpl_form stringByAppendingString:[NSString stringWithFormat:@"%@=%@",[view.subviews[0] text],[view.subviews[1] text]]];
        }else{
            tpl_form = [tpl_form stringByAppendingString:[NSString stringWithFormat:@"%@=%@;",[view.subviews[0] text],[view.subviews[1] text]]];
        }
    }
    
    if (self.btBlock) {
        self.btBlock(tpl_form);
    }
    DLog(@"muStr-->%@",tpl_form);
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4] animated:YES];
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
