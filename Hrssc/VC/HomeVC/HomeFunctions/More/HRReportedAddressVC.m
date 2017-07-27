//
//  HRReportedAddressVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRReportedAddressVC.h"
#import "HRMapView.h"
#import "HRCategoryBaseinfoObj.h"


#import "HRCommonWebVC.h"
#import "HRMapView.h"
#import "HRLocationVC.h"

@interface HRReportedAddressVC ()
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet HRMapView *hrMapView;
@property (nonatomic, strong) HRCategoryBaseinfoObj *baseinfoObj;

@end

@implementation HRReportedAddressVC
-(void)viewWillAppear:(BOOL)animated {
    [self.hrMapView map_viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.hrMapView map_viewWillDisappear];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getWebsite];
    
    //地图
    __weak typeof(self)weakSelf = self;
    self.hrMapView.hrBlock = ^(NSString *address) {
        HRLocationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRLocation"];
        vc.adr = address;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark -- 接口

-(void)getWebsite{
    [Net GetWebsite:[Utils readUser].token Cid:7 Cid2:24 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.baseinfoObj = [HRCategoryBaseinfoObj objectWithKeyValues:info[@"data"][@"categoryBaseinfo"]];
            self.adrLabel.text = self.baseinfoObj.baodao_addr;
            self.nameLabel.text = self.baseinfoObj.baodao_contact;
            self.phoneLabel.text = self.baseinfoObj.baodao_phone;
            [self.hrMapView setSearchAddress:self.baseinfoObj.baodao_addr];
        }
    } FailBack:^(NSError *error) {
        
    }];
}
- (IBAction)bd_click:(UIButton *)sender {
    if (sender.tag == 100) {//办理说明
        if (self.baseinfoObj.link) {
            HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
            vc.link = self.baseinfoObj.link;
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
