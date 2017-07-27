//
//  HRCenterVC.m
//  Hrssc
//
//  Created by admin on 17/4/19.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRCenterVC.h"
#import "HRCenterHeadCell.h"
#import "HRUserInfoVC.h"
#import "HRMySignVC.h"
#import "HRPSWVC.h"
#import "HRConvinVC.h"
#import "HRAdviceVC.h"
#import "HRAboutUsVC.h"
#import "HRSettingVC.h"
#import "HRHelpCenterVC.h"
#import "AddressManageVC.h"
#import "HRMsgCenterVC.h"
#import "HRCityVC.h"

@interface HRCenterVC ()<UITableViewDelegate,UITableViewDataSource,HRCenterHeadCellDelegate>
{
    UITableView* homeTable;
    UIButton* infomationBtn;
    UIImageView* tipImg;
    HRUserInfoVO* currentVO;
    BOOL signState;
}


@end

@implementation HRCenterVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setSignState];

    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    
    [self setUpTable];
}

- (void)leftAction
{
    HRCityVC* vc = [HRCityVC new];
    NALNavigationController *nav = [[NALNavigationController alloc] initWithRootViewController:vc];
    [Utils setNavBarBgUI:nav.navigationBar];
    vc.cBlock = ^(NSString* cityStr)
    {
        self.cityView.cityLabel.text = cityStr;
        [Utils archiveCity:cityStr];
        [self setSignState];
    };
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)setSignState
{
    [Net SignOrNot:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            if([info[@"data"][@"signed"] intValue] == 0)
                signState = NO;
            else
                signState = YES;
            [self setUpData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)setUpData
{
    [Net UserDetialInfo:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            DLog(@"info -->%@",info);
            currentVO = [HRUserInfoVO objectWithKeyValues:info[@"data"][@"user"]];
            [homeTable reloadData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)signNow:(HRCenterHeadCell *)headcell
{

    if(signState)
        return;
    [Net Sign:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            headcell.handIma.hidden = NO;
            headcell.handIma.transform = CGAffineTransformMakeScale(0.05, 0.05);
            
            [UIView animateWithDuration:0.5 animations:^{
                headcell.handIma.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
                headcell.handIma.hidden = YES;
                
                signState = YES;
                [homeTable beginUpdates];
                [homeTable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                [homeTable endUpdates];
            }];
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)setUpTable
{
    homeTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    homeTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    homeTable.backgroundColor = [UIColor clearColor];
    homeTable.delegate = self;
    homeTable.dataSource = self;
    [self.view addSubview:homeTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
        case 2:
            return 3;
        default:
            return 2;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0)
                return 130;
            else
                return 56;
            break;
            
        default:
            return 56;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if(section == 0)
    {
        static NSString *cellIdentifier = @"MineHeaderCell";
        HRCenterHeadCell *cell = (HRCenterHeadCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [HRCenterHeadCell getInstanceWithNib];
        }
        else{
            //NSLog(@"FixMentCell");
        }
        [cell setUI:currentVO];
        [cell setSign:signState];
        cell.delegate = self;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"Key";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 55)];
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 16, 16)];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.textColor = [Utils colorWithHexString:@"353535"];
        switch (section)
        {
            case 1:
            {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                switch (row) {
                    case 0:
                    {
                        img.image = PNG_FROM_NAME(@"icon_qianming");
                        titleLabel.text = @"我的签名";
                    }
                        break;
                    case 1:
                    {
                        img.image = PNG_FROM_NAME(@"icon_xiugaimima");
                        titleLabel.text = @"修改密码";
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 2:
            {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                switch (row) {
                    case 0:
                    {
                        img.image = PNG_FROM_NAME(@"icon_shoujiandizhi");
                        titleLabel.text = @"收件地址管理";
                    }
                        break;
                    case 1:
                    {
                        img.image = PNG_FROM_NAME(@"icon_kuaijie");
                        titleLabel.text = @"快捷服务";
                    }
                        break;
                    case 2:
                    {
                        img.image = PNG_FROM_NAME(@"icon_bangzhuzhongxin");
                        titleLabel.text = @"帮助中心";
                    }
                        break;
                    default:
                        break;
                }
            }
                break;
            case 3:
            {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                switch (row) {
                    case 0:
                    {
                        img.image = PNG_FROM_NAME(@"icon_yijian");
                        titleLabel.text = @"意见反馈";
                    }
                        break;
                    case 1:
                    {
                        img.image = PNG_FROM_NAME(@"icon_shezhi");
                        titleLabel.text = @"设置";
                    }
                        break;
                    default:
                        break;
                }
                break;
            default:
                break;
            }
        }
        [cell.contentView addSubview:img];
        [cell.contentView addSubview:titleLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            HRUserInfoVC* vc = [HRUserInfoVC new];
            vc.currentVO = currentVO;
            [self.navigationController pushViewController:vc animated:YES];
            [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
        }
            break;
        case 1:
        {
            switch (row) {
                case 0:
                {
                    HRMySignVC* vc = [HRMySignVC new];
                    vc.signature = currentVO.signature;
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
                    break;
                }
                case 1:
                {
                    HRPSWVC* vc = [HRPSWVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
                    break;
                }

                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (row) {
                case 0:
                {
                    AddressManageVC* vc = [AddressManageVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
                }
                    break;
                case 1:
                {
                    HRConvinVC* vc = [HRConvinVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
                }
                    break;
                case 2:
                {
                    HRHelpCenterVC* vc = [HRHelpCenterVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (row) {
                case 0:
                {
                    HRAdviceVC* vc = [HRAdviceVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
                }
                    break;
                case 1:
                {
                    HRSettingVC* vc = [HRSettingVC new];
                    [self.navigationController pushViewController:vc animated:YES];
                    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
