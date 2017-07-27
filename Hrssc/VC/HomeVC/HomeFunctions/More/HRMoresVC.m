//
//  HRMoresVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMoresVC.h"

#import "HRCategory2ListObj.h"
#import "HRDealThatDeatilVC.h"
#import "HRArchivesLibraryVC.h"
#import "HRPublicDealtVC.h"
#import "HREmployeeModelVC.h"
#import "HRMedicalResultsVC.h"
#import "HRSocialPaymentVC.h"
#import "HRAccFundPayDetailsVC.h"
#import "HRCommonWebVC.h"
#import "HRReportedAddressVC.h"

@interface HRMoresVC ()
@property (weak, nonatomic) IBOutlet UITableView *more_table;
@property (nonatomic, strong) NSArray *moreArray;
@end

@implementation HRMoresVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //获取二级子业务列表
    [Net Category2:[Utils readUser].token Cid:8 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            if (isSucc) {
                self.moreArray = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
                [self.more_table reloadData];
            }
        }
    } FailBack:^(NSError *error) {
        
    }];

}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moreArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"HRMoreCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil] firstObject];
    }
    cell.textLabel.text = [self.moreArray[indexPath.row] name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HRCategory2ListObj *obj = self.moreArray[indexPath.row];
    /*
     pageid	二级页面名称	适用模块
     1	证明提交类	证明办理->所有二级页面
     社保->社保变更、社保/医保卡办理、社保转入、社保转出、医疗备案、社保报销、社保证明
     公积金->住房公积金变更、住房公积金联名卡、住房公积金证明
     2	户口办理类	户口办理->所有二级页面
     3	学位验证类	新员工->学位验证
     4	工卡照片类	新员工->工卡照片
     5	预约入职类	新员工->预约入职
     6	报到查询页	新员工->报到地址
     7	体检查询页	新员工->体检
     8	社保查询页	社保->社保缴纳详情
     9	公积金查询页	公积金->公积金缴纳详情
     10	查询跳转页	支持二级业务直接跳转到指定的URL
     */
    switch (obj.pageid) {
        case 1:{
            HRDealThatDeatilVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDealThatDeatil"];
            vc.proveName = [obj name];
            vc.cid2 = [obj id];
            [self.navigationController pushViewController:vc animated:YES];
        }
             break;
        case 2:{
            HRPublicDealtVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRPublicDealt"];
            if (obj.cid == 6) {
                vc.hkName = @"居住证办理";
            }else{
                vc.cid2 = [obj id];
                vc.hkName = obj.name;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
             break;
        case 3:
        case 4:
        case 5:{
            HREmployeeModelVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HREmployeeModel"];
            vc.cid = 7;
            vc.cid2 = [obj id];
            vc.ndStr = obj.name;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:{
            HRReportedAddressVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRReportedAddress"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:{
            HRMedicalResultsVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRMedicalResults"];
            vc.cid = 7;
            vc.cid2 = [obj id];
            vc.ndStr = [obj name];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:{//
            HRSocialPaymentVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRSocialPayment"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 9:{
            HRAccFundPayDetailsVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRAccFundPayDetails"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 10:{
            HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
            vc.link = obj.link;
            vc.title = @"网站";
            [self.navigationController pushViewController:vc animated:YES];
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
