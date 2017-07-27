
//
//  HRNewEmployeeVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/4.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRNewEmployeeVC.h"
#import "HRMedicalResultsVC.h"
#import "HRCategory2ListObj.h"
#import "HRCategoryBaseinfoObj.h"
#import "HRCommonWebVC.h"
#import "HREmployeeModelVC.h"
#import "HRMapView.h"
#import "HRLocationVC.h"

@interface HRNewEmployeeVC ()
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet HRMapView *hrMapView;

@property (weak, nonatomic) IBOutlet UILabel *tj_label;
@property (weak, nonatomic) IBOutlet UILabel *xwyz_label;
@property (weak, nonatomic) IBOutlet UILabel *gkzp_label;
@property (weak, nonatomic) IBOutlet UILabel *yyrz_label;
@property (nonatomic, strong) NSArray *employeeArr;
@property (nonatomic, strong) HRCategoryBaseinfoObj *baseinfoObj;
@property (nonatomic, copy) NSString *link;

@end

@implementation HRNewEmployeeVC


-(void)viewWillAppear:(BOOL)animated {
    [self.hrMapView map_viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.hrMapView map_viewWillDisappear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //获取二级子业务列表
    [Net Category2:[Utils readUser].token Cid:7 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.employeeArr = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
            self.tj_label.text = [self.employeeArr[1] name];
            self.xwyz_label.text = [self.employeeArr[2] name];
            self.gkzp_label.text = [self.employeeArr[3] name];
            self.yyrz_label.text = [self.employeeArr[4] name];
//            DLog(@"info-->%@",info);
            [self GetWebsite:7 Cid2:[(HRCategory2ListObj *)[self.employeeArr firstObject] id]];
        }
    } FailBack:^(NSError *error) {
        
    }];
    //地图
    __weak typeof(self)weakSelf = self;
    self.hrMapView.hrBlock = ^(NSString *address) {
        HRLocationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRLocation"];
        vc.adr = address;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark -- 接口

-(void)GetWebsite:(int)cid Cid2:(int)cid2{
    [Net GetWebsite:[Utils readUser].token Cid:cid Cid2:cid2 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
//            DLog(@"info-->%@",info);
            self.baseinfoObj = [HRCategoryBaseinfoObj objectWithKeyValues:info[@"data"][@"categoryBaseinfo"]];
            self.adrLabel.text = self.baseinfoObj.baodao_addr;
            self.nameLabel.text = self.baseinfoObj.baodao_contact;
            self.phoneLabel.text = self.baseinfoObj.baodao_phone;
            [self.hrMapView setSearchAddress:self.baseinfoObj.baodao_addr];
            
            self.link = info[@"data"][@"link"];

        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)np_click:(UIButton *)sender {
    if (sender.tag == 10) {//体检
        HRMedicalResultsVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRMedicalResults"];
        vc.cid = 7;
        vc.cid2 = [(HRCategoryBaseinfoObj*)self.employeeArr[sender.tag - 9] id];
        vc.ndStr = [self.employeeArr[sender.tag - 9] name];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        HREmployeeModelVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HREmployeeModel"];
        vc.cid = 7;
        vc.cid2 = [(HRCategoryBaseinfoObj*)self.employeeArr[sender.tag - 9] id];
        vc.ndStr = [self.employeeArr[sender.tag - 9] name];
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}
- (IBAction)bd_click:(UIButton *)sender {
    if (sender.tag == 100) {//办理说明
        if (self.link) {
            HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
            vc.link = self.link;
            vc.title = @"说明";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (sender.tag == 101) {//报道地址
        HRLocationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRLocation"];
        vc.adr = self.baseinfoObj.baodao_addr;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 102) {//联系电话
        NSString *allString = [NSString stringWithFormat:@"tel:%@",self.baseinfoObj.baodao_phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
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
