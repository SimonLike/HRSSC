//
//  HRArchivesLibraryVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRArchivesLibraryVC.h"
#import "HRCategory2ListObj.h"
#import "HRSuccessfulVC.h"
#import "HRBackAlertView.h"

@interface HRArchivesLibraryVC ()
@property (nonatomic)int cid2;
@property (weak, nonatomic) IBOutlet UITextView *briefTextView;

@end

@implementation HRArchivesLibraryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"提交" forState:UIControlStateNormal];
    [self.navBtnRight setTitleColor:RGBCOLOR(23, 144, 210) forState:UIControlStateNormal];
    
    //获取二级子业务列表
    [Net Category2:[Utils readUser].token Cid:4 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            NSArray *array = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
            self.cid2 = [(HRCategory2ListObj*)array[0] id];
//            DLog(@"info-->%d",self.cid2);
        }
    } FailBack:^(NSError *error) {
        
    }];
}

//提交
-(void)rightAction{
    if([self.briefTextView.text isEqualToString:@""]){
        [SVProgressHUD showImage:nil status:@"请填写申请说明！"];
        return;
    }
    [self SubmitApply:1];
}

-(void)backAction{
    
    if([self.briefTextView.text isEqualToString:@""]){
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        HRBackAlertView *alert = [HRBackAlertView initBackAlertView];
        alert.frame = [UIApplication sharedApplication].keyWindow.bounds;
        alert.backBlock = ^(NSInteger tag) {
            if (tag == 10) {//退出不保存草稿
                [self.navigationController popViewControllerAnimated:YES];
            }else if (tag == 11){//退出并保存草稿
                [self SubmitApply:0];
            }else{//取消
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
    }
}

-(void)SubmitApply:(int)type{
    [Net SubmitApply:[Utils readUser].token
                Type:type
                City:[Utils getCity]
                Cid2:self.cid2
                 Aid:self.aid
             Get_way:3
             Address:@""
        Address_info:@""
           Recipient:@""
             Tpl_tid:0
            Tpl_form:@""
               Brief:self.briefTextView.text
             Comment:@""
            Language:0
              Images:@""
             Attachs:@""
            CallBack:^(BOOL isSucc, NSDictionary *info) {
                if (isSucc) {
//                    NSLog(@"info-->%@",info);
                    if (type == 1) {//提交成功的操作
                        [Utils showMSG:@"提交成功"];
                        HRSuccessfulVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRSuccessful"];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{//保存草稿成功的操作
                        [Utils showMSG:@"保存草稿成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            } FailBack:^(NSError *error) {
                
            }];

}

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
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
