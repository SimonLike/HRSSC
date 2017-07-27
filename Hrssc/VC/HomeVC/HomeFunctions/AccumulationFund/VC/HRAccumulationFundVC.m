
//
//  HRAccumulationFundVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAccumulationFundVC.h"
#import "HRDealThatDeatilVC.h"
#import "HRAccFundPayDetailsVC.h"
#import "HRCategory2ListObj.h"

@interface HRAccumulationFundVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *cx_label;
@property (weak, nonatomic) IBOutlet UILabel *bg_label;
@property (weak, nonatomic) IBOutlet UILabel *lmk_label;
@property (weak, nonatomic) IBOutlet UILabel *zm_label;
@property (nonatomic, strong) NSArray *fundArr;

@end

@implementation HRAccumulationFundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取banner
    [Net GetBanner:[Utils readUser].token Location:2 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
//            DLog(@"info-->%@",info);
            HRBannerVO *obj = [HRBannerVO objectWithKeyValues:info[@"data"][@"banner"]];
            [self.bannerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PIC_HOST,obj.image]] placeholderImage:nil];
        }
    } FailBack:^(NSError *error) {
        
    }];
    //获取二级子业务列表
    [Net Category2:[Utils readUser].token Cid:3 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.fundArr = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
            self.cx_label.text = [self.fundArr[0] name];
            self.bg_label.text = [self.fundArr[1] name];
            self.lmk_label.text = [self.fundArr[2] name];
            self.zm_label.text = [self.fundArr[3] name];
        }
    } FailBack:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view.
}
- (IBAction)af_click:(UIButton *)sender {
    
    if (sender.tag == 10) {
        HRAccFundPayDetailsVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRAccFundPayDetails"];
        vc.cid = 3;
        vc.cid2 = [(HRCategory2ListObj *)self.fundArr[0] id];
        [self.navigationController pushViewController:vc animated:YES];
 
    }else{
        HRDealThatDeatilVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDealThatDeatil"];
        vc.title = [self.fundArr[sender.tag - 11] name];
        vc.proveName = [self.fundArr[sender.tag - 11] name];
        vc.cid2 = [(HRCategory2ListObj *)self.fundArr[sender.tag - 11] id];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
