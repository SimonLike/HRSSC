//
//  HRServiceVC.m
//  Hrssc
//
//  Created by admin on 17/4/19.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRServiceVC.h"
#import "HRMsgCenterVC.h"
@interface HRServiceVC ()
{
    UIButton* infomationBtn;
    UIImageView* tipImg;
}

@end

@implementation HRServiceVC

- (void)setUI
{
    self.title = @"客服";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];

    self.cityView.hidden = YES;
    
    UIImageView* bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50)];
    bgImg.image = PNG_FROM_NAME(@"pic_beijing");
    [self.view addSubview:bgImg];
    UIButton* kefuBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-140)/2, (SCREEN_HEIGHT-50-140)/2, 140, 140)];
    [kefuBtn setImage:PNG_FROM_NAME(@"icon_zixunan") forState:0];
    [kefuBtn addTarget:self action:@selector(kefuAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:kefuBtn];
}

- (void)kefuAction
{
    HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_392568"];
    // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
    [self.navigationController pushViewController:chatVC animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)infoMsg
{
    HRMsgCenterVC* vc = [HRMsgCenterVC new];
    [self.navigationController pushViewController:vc animated:YES];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
