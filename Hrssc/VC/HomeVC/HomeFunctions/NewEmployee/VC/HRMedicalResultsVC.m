//
//  HRMedicalResultsVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/4.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMedicalResultsVC.h"
#import "HRLocationVC.h"

#import "HRCategoryBaseinfoObj.h"
#import "HRMapView.h"
#import "HRLocationVC.h"
#import "HRCheckResultObj.h"
#import "HRPicCollectionView.h"
#import "HRCommonWebVC.h"

@interface HRMedicalResultsVC ()
@property (weak, nonatomic) IBOutlet UILabel *dnLabel;
@property (weak, nonatomic) IBOutlet UILabel *adrLabel;
@property (nonatomic,strong) HRCategoryBaseinfoObj *baseinfoObj;
@property (weak, nonatomic) IBOutlet HRMapView *hrMapView;
@property (weak, nonatomic) IBOutlet UILabel *medicalLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet HRPicCollectionView *picCView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightCont;
@property (weak, nonatomic) IBOutlet UILabel *noresLabel;

@property (strong, nonatomic) NSString  *link;

@end

@implementation HRMedicalResultsVC

-(void)viewWillAppear:(BOOL)animated {
    [self.hrMapView map_viewWillAppear];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.hrMapView map_viewWillDisappear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.ndStr;
    self.dnLabel.text =self.ndStr;
    
    [Net GetWebsite:[Utils readUser].token Cid:self.cid Cid2:self.cid2 City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
//            DLog(@"info-->%@",info);
            self.baseinfoObj = [HRCategoryBaseinfoObj objectWithKeyValues:info[@"data"][@"categoryBaseinfo"]];
            self.adrLabel.text = self.baseinfoObj.baodao_addr;
            [self.hrMapView setSearchAddress:self.baseinfoObj.baodao_addr];
            self.link = info[@"data"][@"link"];
        }
    } FailBack:^(NSError *error) {
        
    }];
    
    //体检结果
    [Net HealthCheck:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            HRCheckResultObj *obj = [HRCheckResultObj objectWithKeyValues:info[@"data"][@"checkResult"]];
            self.medicalLabel.text = obj.result;
            self.timeLabel.text = obj.create_time;
            
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:[obj.images dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
            if (arr.count == 0) {
                self.picHeightCont.constant = 0;
                self.picCView.hidden = YES;
            }else{
                [self pics:arr];
            }
        }else{
            self.picCView.hidden = YES;
            self.noresLabel.hidden = NO;
        }
    } FailBack:^(NSError *error) {
        self.picCView.hidden = YES;
        self.noresLabel.hidden = NO;
    }];
    
    //地图
    __weak typeof(self)weakSelf = self;
    self.hrMapView.hrBlock = ^(NSString *address) {
        HRLocationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRLocation"];
        vc.adr = address;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}
//图片
-(void)pics:(NSArray *)array{
    self.picCView.picTypeTnt = 1;//显示
    self.picCView.picspathArr = array;
    
    if (array.count%3 == 0) {
        self.picHeightCont.constant = array.count/3 * ((self.picCView.width - 30)/3 + 10);
    }else{
        self.picHeightCont.constant = (array.count/3 + 1) * ((self.picCView.width - 30)/3 + 10);
    }
    CGRect frame = self.picCView.pic_collection.frame;
    frame.size.height = self.picHeightCont.constant;
    self.picCView.pic_collection.frame = frame;
    
    [self.picCView.pic_collection reloadData];
}

- (IBAction)rs_click:(UIButton *)sender {
    switch (sender.tag) {
        case 10:{
            HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
            vc.link = self.link;
            vc.title = @"体检须知";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 11:
        {
            HRLocationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRLocation"];
            vc.adr = self.baseinfoObj.baodao_addr;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
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
