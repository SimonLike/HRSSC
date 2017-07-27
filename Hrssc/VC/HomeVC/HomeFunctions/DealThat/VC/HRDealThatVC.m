
//
//  HRDealThatVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRDealThatVC.h"
#import "HRDealThatDeatilVC.h"
#import "HRCategory2ListObj.h"

@interface HRDealThatVC ()
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UILabel *xz_label;
@property (weak, nonatomic) IBOutlet UILabel *jhsy_label;
@property (weak, nonatomic) IBOutlet UILabel *xznx_label;
@property (weak, nonatomic) IBOutlet UILabel *zz_label;
@property (nonatomic, strong) NSArray *categoryArr;
@end

@implementation HRDealThatVC

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
    [Net Category2:[Utils readUser].token Cid:1 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.categoryArr = [HRCategory2ListObj objectArrayWithKeyValuesArray:info[@"data"][@"category2List"]];
            self.xz_label.text = [self.categoryArr[0] name];
            self.jhsy_label.text = [self.categoryArr[1] name];
            self.xznx_label.text = [self.categoryArr[2] name];
            self.zz_label.text = [self.categoryArr[3] name];
        }
    } FailBack:^(NSError *error) {
        
    }];
}
- (IBAction)dt_click:(UIButton *)sender {
    if (self.categoryArr.count>0) {
        HRDealThatDeatilVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDealThatDeatil"];
        HRCategory2ListObj *obj = self.categoryArr[sender.tag - 10];
        vc.cid2 = [obj id];
        vc.proveName = [obj name];
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
