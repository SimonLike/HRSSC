//
//  HRAccFundPayDetailsVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAccFundPayDetailsVC.h"
#import "HRSPHerderCell.h"
#import "HRSPFooterCell.h"
#import "HRAccFundPDCell.h"
#import "HRAccFundHisVC.h"
#import "HRPublicFundObj.h"
#import "HRCommonWebVC.h"
#import "HRCategoryBaseinfoObj.h"

@interface HRAccFundPayDetailsVC ()
@property (weak, nonatomic) IBOutlet UITableView *apd_table;
@property (nonatomic, strong) NSArray *apdARrr;
@property (nonatomic, strong) NSString *payamount;


@end

@implementation HRAccFundPayDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    @"3522e253684a45fba70854f23191ce49"
    [Net PublicFundFirst:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (info) {
            DLog(@"info--->%@",info);
            
            HRPublicFundObj *obj = [HRPublicFundObj objectWithKeyValues:info[@"data"][@"publicFund"]];
            self.payamount = obj.payamount;//合计金额
            self.apdARrr = [NSMutableArray arrayWithObjects:
                            @[@"缴纳地",obj.city],
                            @[@"缴纳月份",obj.paytime],
                            @[@"缴纳基数",obj.base],
                            @[@"单位比例",obj.percent_company],
                            @[@"个人比例",obj.percent_personal],
                            nil];
            [self.apd_table reloadData];
        }
    } FailBack:^(NSError *error) {
        
    }];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.apdARrr.count + 2;

}

//-(UIView *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    if (indexPath.row == 0) {
        HRSPHerderCell *cell = (HRSPHerderCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HRSPHerderCell" owner:nil options:nil] firstObject];
        }
        cell.btnView.hidden = YES;
        cell.totalLabel.text = [NSString stringWithFormat:@"%@元",self.payamount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        return cell;
    }else if (indexPath.row == self.apdARrr.count+1){//
        HRSPFooterCell *cell = (HRSPFooterCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HRSPFooterCell" owner:nil options:nil] firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        cell.block = ^(NSInteger tag) {
            if (tag == 1) {//历史记录
                HRAccFundHisVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRAccFundHis"];
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
        HRAccFundPDCell *cell = (HRAccFundPDCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HRAccFundPDCell" owner:nil options:nil] firstObject];
        }
  
        NSArray *array = self.apdARrr[indexPath.row - 1];
        cell.nLabel.text = array[0];
        cell.tLabel.text = array[1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 190;
    }else if (indexPath.row == self.apdARrr.count+1){
        return 90;
    }else{
        return 39;
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
