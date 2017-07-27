
//
//  HRSocialPaymentVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSocialPaymentVC.h"
#import "HRSPHerderCell.h"
#import "HRSocialPaymentCell.h"
#import "HRSPFooterCell.h"
#import "HRHistoricalRecordVC.h"
#import "HRSocialPaymentVC.h"
#import "HRSocialSecurityObj.h"
#import "HRCommonWebVC.h"
#import "HRCategoryBaseinfoObj.h"


@interface HRSocialPaymentVC ()
@property (weak, nonatomic) IBOutlet UITableView *sp_table;
@property (nonatomic,strong)NSArray *paymentArr;

@property (nonatomic,strong)SocialSecurityObj *securityObj;
@property (nonatomic,strong)IndividualUnitObj *unitObj;

@property (nonatomic)NSInteger selecBtnTag;


@end

@implementation HRSocialPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社保详情";
    
    [Net SocialSecurityFirst:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.securityObj = [SocialSecurityObj objectWithKeyValues:info[@"data"]];
            self.unitObj= [IndividualUnitObj objectWithKeyValues:info[@"data"][@"socialSecurity"]];
//            DLog(@"info-->%@",info);
//            if (![self.unitObj.city isEqualToString:@"china"]) {
                [self setClick:10];//默认单位
//            }
        }
    } FailBack:^(NSError *error) {
        
    }];
}

-(void)setClick:(NSInteger)tag{
    
    NSArray *yl_array = [self.unitObj.yanglao componentsSeparatedByString:@","];
    NSArray *yil_array = [self.unitObj.yiliao componentsSeparatedByString:@","];
    NSArray *gs_array = [self.unitObj.gongshang componentsSeparatedByString:@","];
    NSArray *sy_array = [self.unitObj.shiye componentsSeparatedByString:@","];
    NSArray *sg_array = [self.unitObj.shengyu componentsSeparatedByString:@","];
    NSString *compantTotal = [NSString stringWithFormat:@"%.2f",self.securityObj.compantTotal];
    NSString *personalTotal = [NSString stringWithFormat:@"%.2f",self.securityObj.personalTotal];
    
    if(tag ==10){//单位
        self.paymentArr = [NSMutableArray arrayWithObjects:
                           @[@"缴纳项目",@"缴纳地",@"缴纳年月",@"缴纳基数",@"缴纳金额"],
                           @[@"养老保险",self.unitObj.city,self.unitObj.paytime,yl_array[0],yl_array[1]],
                           @[@"医疗保险",self.unitObj.city,self.unitObj.paytime,yil_array[0],yil_array[1]],
                           @[@"工伤保险",self.unitObj.city,self.unitObj.paytime,gs_array[0],gs_array[1]],
                           @[@"失业保险",self.unitObj.city,self.unitObj.paytime,sy_array[0],sy_array[1]],
                           @[@"生育保险",self.unitObj.city,self.unitObj.paytime,sg_array[0],sg_array[1]],
                           @[@"缴纳合计",@"",@"",@"",compantTotal],
                           nil];
    }else{//个人
        self.paymentArr = [NSMutableArray arrayWithObjects:
                           @[@"缴纳项目",@"缴纳地",@"缴纳年月",@"缴纳基数",@"缴纳金额"],
                           @[@"养老保险",self.unitObj.city,self.unitObj.paytime,yl_array[2],yl_array[3]],
                           @[@"医疗保险",self.unitObj.city,self.unitObj.paytime,yil_array[2],yil_array[3]],
                           @[@"工伤保险",self.unitObj.city,self.unitObj.paytime,gs_array[2],gs_array[3]],
                           @[@"失业保险",self.unitObj.city,self.unitObj.paytime,sy_array[2],sy_array[3]],
                           @[@"生育保险",self.unitObj.city,self.unitObj.paytime,sg_array[2],sg_array[3]],
                           @[@"缴纳合计",@"",@"",@"",personalTotal],
                           nil];
    }
   
    [self.sp_table reloadData];
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paymentArr.count + 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    if (indexPath.row == 0) {
        HRSPHerderCell *cell = (HRSPHerderCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HRSPHerderCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.totalLabel.text = self.securityObj.total;
        cell.tag = self.selecBtnTag;
        __weak typeof(self) weakSelf = self;
      
        cell.block = ^(NSInteger tag) {
            if (tag == 10) {//单位
            }else{//个人
            }
            weakSelf.selecBtnTag = tag;
            if (self.unitObj) {
                [weakSelf setClick:tag];
            }
            [SVProgressHUD setStatus:@"暂无数据"];
        };
        return cell;
    }else if (indexPath.row == self.paymentArr.count + 1){//
        HRSPFooterCell *cell = (HRSPFooterCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HRSPFooterCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        cell.block = ^(NSInteger tag) {
            if (tag == 1) {//历史记录
                HRHistoricalRecordVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRHistoricalRecord"];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{//网站
                
                [Net GetWebsite:[Utils readUser].token Cid:self.cid Cid2:self.cid2 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
                    if (isSucc) {
                        HRCategoryBaseinfoObj *baseinfoObj = [HRCategoryBaseinfoObj objectWithKeyValues:info[@"data"][@"categoryBaseinfo"]];
                        
                        HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
                        vc.title = @"网站";
                        vc.link = baseinfoObj.website;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }
                } FailBack:^(NSError *error) {
                    
                }];

            }
        };
        return cell;
    }else{
        HRSocialPaymentCell *cell = (HRSocialPaymentCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HRSocialPaymentCell" owner:nil options:nil] firstObject];
        }
        if (indexPath.row == 1 || indexPath.row == self.paymentArr.count) {
            cell.contentView.backgroundColor = RGBCOLOR(119, 195, 233);
            cell.label1.textColor = RGBCOLOR16(0xffffff);
            cell.label2.textColor = RGBCOLOR16(0xffffff);
            cell.label3.textColor = RGBCOLOR16(0xffffff);
            cell.label4.textColor = RGBCOLOR16(0xffffff);
            cell.label5.textColor = RGBCOLOR16(0xffffff);
        }else{
            cell.backgroundColor = RGBCOLOR16(0xEAF8FE);
        }

        NSArray *array = self.paymentArr[indexPath.row - 1];
        cell.label1.text = array[0];
        cell.label2.text = array[1];
        cell.label3.text = array[2];
        cell.label4.text = array[3];
        cell.label5.text = array[4];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 215;
    }else if (indexPath.row == self.paymentArr.count + 1){
        return 90;
    }else{
        return 36;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
