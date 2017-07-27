//
//  HRContractDetailsVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/26.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRContractDetailsVC.h"
#import "HRContractObj.h"
#import "HRAlertView.h"
#import "HRWebViewVC.h"
#import "HRLocationVC.h"
#import "HRSignWebViewVC.h"

@interface HRContractDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *contractIDLab;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *ct_Image;
@property (weak, nonatomic) IBOutlet UILabel *contractNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *signAddressLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIButton *dmqBtn;
@property (weak, nonatomic) IBOutlet UIButton *dzqBtn;
@property (weak, nonatomic) IBOutlet UIButton *yjqBtn;
@property (nonatomic) int cont_id;
@property (nonatomic, strong)HRContractObj *contractObj;
@end

@implementation HRContractDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合同详情";
    // Do any additional setup after loading the view.
    
    [Net ContractInfo:[Utils readUser].token Id:self.contract_id.intValue CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            
            HRContractObj *obj = [HRContractObj objectWithKeyValues:info[@"data"][@"contractFlow"]];
            self.contractObj = obj;
//            DLog(@"info-->%@",info);
            self.cont_id = obj.id.intValue;
            
            self.contractIDLab.text = [NSString stringWithFormat:@"NO.%@",obj.work_order];
            self.contractNameLab.text = obj.tpl_name;
            self.timeLab.text = obj.create_time;
            if (obj.status.integerValue == 0) {//"status":1,   //状态0-待签署  1-待盖章  2-已撤销  3-已完成
                self.typeLab.text = @"待签署";
            }else if (obj.status.integerValue == 1){
                self.typeLab.text = @"待盖章";
            }else if (obj.status.integerValue == 2){
                self.typeLab.text = @"已撤销";
            }else if (obj.status.integerValue == 3){
                self.typeLab.text = @"已完成";
            }
            if(obj.sign_way.integerValue == 0){////签署方式  0电子签署1当面签署2邮寄签署
                self.signLabel.text = @"电子签署";
            }else if (obj.sign_way.integerValue == 1){
                self.signLabel.text = @"当面签署";
            }else if (obj.sign_way.integerValue == 1){
                self.signLabel.text = @"邮寄签署";
            }
            self.signAddressLab.text = obj.address;
            self.remarkTextView.text = obj.brief;
            
            if (obj.status.integerValue != 0) {//"status":1,   //状态0-待签署  1-待盖章  2-已撤销  3-已完成
                self.dmqBtn.enabled = NO;
                self.dzqBtn.enabled = NO;
                self.yjqBtn.enabled = NO;
                [self.dmqBtn setTitleColor:RGBCOLOR16(0x999999) forState:UIControlStateNormal];
                [self.dzqBtn setTitleColor:RGBCOLOR16(0x999999) forState:UIControlStateNormal];
                [self.yjqBtn setTitleColor:RGBCOLOR16(0x999999) forState:UIControlStateNormal];
            }
        }
    } FailBack:^(NSError *error) {
        
    }];
}

-(void)contractWay:(int)sign_way{

    [Net ContractWay:[Utils readUser].token Id:self.cont_id Sign_way:sign_way CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            DLog(@"info->%@",info);           
        }else{
            [SVProgressHUD showImage:nil status:info[@"msg"]];
        }
        
    } FailBack:^(NSError *error) {
    }];
}

- (IBAction)cdal_click:(UIButton *)sender {
    switch (sender.tag-10) {
        case 0://合同详情
        {
            HRWebViewVC *vc = [HRWebViewVC new];
            vc.typeUrl = @"showHetong";
            vc.attachStr = self.contractObj.tpl_document;
            vc.title = self.contractObj.tpl_name;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1://地址
        {
            HRLocationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRLocation"];
            vc.adr = self.contractObj.address;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 2://当面签
        {
            if (self.contractObj.status.integerValue == 0) {
                HRAlertView *alertView = [HRAlertView initAlertView];
                alertView.titleLabel.text = @"确认当面签署？";
                [alertView setContHidden:YES];
                alertView.frame = [UIApplication sharedApplication].keyWindow.bounds;
                alertView.alertBlock = ^(NSInteger tag) {
                    if (tag == 10) {//确定
                        [self contractWay:1];
                    }
                };
                [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            }
        }
            break;
        case 3://电子签章
        {
            if (self.contractObj.status.integerValue == 0) {

                HRSignWebViewVC *vc = [HRSignWebViewVC new];
                vc.signUrl = [NSString stringWithFormat:@"%@hrsscContractController/electronSign?token=%@&aid=%@",PIC_HOST,[Utils readUser].token,self.contractObj.id];
            
                [self.navigationController pushViewController:vc animated:YES];
            }
           
        }
            break;
        case 4://邮寄签署
        {
            if (self.contractObj.status.integerValue == 0) {
                HRAlertView *alertView = [HRAlertView initAlertView];
                alertView.titleLabel.text = @"确认邮寄签署？";
                alertView.contLabel.text = @"请在web端下载文档打印签署后邮寄回公司";
                alertView.frame = [UIApplication sharedApplication].keyWindow.bounds;
                alertView.alertBlock = ^(NSInteger tag) {
                    if (tag == 10) {//确定
                        [self contractWay:2];
                    }
                };
                [[UIApplication sharedApplication].keyWindow addSubview:alertView];
            }
        }
            break;
        default:
            break;
    }
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
