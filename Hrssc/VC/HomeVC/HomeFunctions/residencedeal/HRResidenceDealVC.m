

//
//  HRResidenceDealVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRResidenceDealVC.h"
#import "HRPublicDealtVC.h"
#import "HRCategory2ListObj.h"

@interface HRResidenceDealVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *jy_label;
@property (weak, nonatomic) IBOutlet UILabel *snqr_label;
@property (weak, nonatomic) IBOutlet UILabel *qcsb_label;
@property (weak, nonatomic) IBOutlet UILabel *swqr_label;
@property (nonatomic, strong) NSArray *fundArr;

@end

@implementation HRResidenceDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //获取banner
    [Net GetBanner:[Utils readUser].token Location:2 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            HRBannerVO *obj = [HRBannerVO objectWithKeyValues:info[@"data"][@"banner"]];
            [self.bannerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.image]] placeholderImage:nil];
        }
    } FailBack:^(NSError *error) {
        
    }];
    //获取二级子业务列表
    [Net Category2:[Utils readUser].token Cid:5 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
//            DLog(@"info-->%@",info);

            self.fundArr = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
            self.jy_label.text = [self.fundArr[0] name];
            self.snqr_label.text = [self.fundArr[1] name];
            self.qcsb_label.text = [self.fundArr[2] name];
            self.swqr_label.text = [self.fundArr[3] name];
        }
    } FailBack:^(NSError *error) {
        
    }];

}

- (IBAction)rd_clcik:(UIButton *)sender {
    HRPublicDealtVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRPublicDealt"];
    vc.cid2 = [(HRCategory2ListObj *)self.fundArr[sender.tag - 10] id];
    vc.hkName = [(HRCategory2ListObj *)self.fundArr[sender.tag - 10] name];
    [self.navigationController pushViewController:vc animated:YES];
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
