

//
//  HRPageViewController.m
//  Hrssc
//
//  Created by Simon on 2017/5/17.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRPageViewController.h"
#import "HRCityVC.h"
#import "HRMsgCenterVC.h"

@interface HRPageViewController ()

@end

@implementation HRPageViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.cityView.cityLabel.text = [Utils getCity];

    [Net GetMessageCount:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            NSString *messageCount = info[@"data"][@"myMessageCount"];
            //消息红点
            if([messageCount integerValue] <= 0){
                self.tipImg.hidden = YES;
            }else{
                self.tipImg.hidden = NO;
            }
        }
    } FailBack:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;

    self.cityView = [HRLeftCityView initLeftCityView];
    [self.cityView.leftButton addTarget:self action: @selector(leftAction) forControlEvents: UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.cityView];
    self.navigationItem.leftBarButtonItem = leftItem;
    //    __weak typeof (self)weakSelf = self;
    //    self.cityView.leftBlock = ^{
    //        [weakSelf leftAction];
    //    };
    //
    self.tipImg = [[UIImageView alloc] initWithFrame:CGRectMake(38, 3, 8, 8)];
    self.tipImg.image = [UIImage imageWithColor:[UIColor redColor]];
    [Utils cornerView:self.tipImg withRadius:4 borderWidth:0 borderColor:0];
    
    self.tipImg.hidden = YES;
    
    self.infomationBtn = [Utils createButtonWith:CustomButtonType_More text:@""];
    [self.infomationBtn addTarget:self action:@selector(infoMsg) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.infomationBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.infomationBtn addSubview:self.tipImg];
}

- (void) leftAction
{
    
}

- (void)infoMsg
{
    HRMsgCenterVC* vc = [HRMsgCenterVC new];
    [self.navigationController pushViewController:vc animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
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
