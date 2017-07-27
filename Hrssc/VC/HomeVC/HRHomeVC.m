//
//  HRHomeVC.m
//  Hrssc
//
//  Created by admin on 17/4/19.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRHomeVC.h"
#import "HRHomeInfoCell.h"
#import "HRCityVC.h"
#import "HRDelayTransactVC.h"
#import "HRMyApplyVC.h"
#import "HRDealThatVC.h"
#import "HRSocialSecurityVC.h"
#import "HRMsgCenterVC.h"
#import "HRAccumulationFundVC.h"
#import "HRArchivesLibraryVC.h"
#import "HRResidenceDealVC.h"
#import "HRPublicDealtVC.h"
#import "HRNewEmployeeVC.h"
#import "HRInformationVC.h"
#import "HRInformationDetailVC.h"
#import "HRMoresVC.h"
#import "HRCommonWebVC.h"

@interface HRHomeVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,HRHomeInfoCellDelegate>
{
    UITableView* homeTable;
    NSMutableArray* infoArray;
    SDCycleScrollView *cycleScrollView;
}
@property(strong, nonatomic)HRHomeInfoVO* currentVO;

@end

@implementation HRHomeVC


- (void)leftAction
{
    HRCityVC* vc = [HRCityVC new];
    NALNavigationController *nav = [[NALNavigationController alloc] initWithRootViewController:vc];
    [Utils setNavBarBgUI:nav.navigationBar];
    vc.cBlock = ^(NSString* cityStr)
    {
        self.cityView.cityLabel.text = cityStr;
        [Utils archiveCity:cityStr];
        [self getData];
    };
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    [self getData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    infoArray = [[NSMutableArray alloc] init];
    [self setUpTable];
    [self checkCity];
    
}

- (void)getData
{
    [Net HomeInfo:[Utils readUser].token City:self.cityView.cityLabel.text CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            _currentVO = nil;
            _currentVO = [HRHomeInfoVO objectWithKeyValues:info[@"data"]];

            NSMutableArray* urlAry = [[NSMutableArray alloc] init];
            for(HRBannerVO* vo in _currentVO.banners)
            {
                [urlAry addObject:[NSString stringWithFormat:@"%@%@",PIC_HOST,vo.image]];
            }
            if(!cycleScrollView)
            {
                cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) imageURLStringsGroup:urlAry];
                [cycleScrollView setPlaceholderImage:DEFAULTIMG];
                cycleScrollView.delegate = self;
                cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            }
            else
                cycleScrollView.imageURLStringsGroup = urlAry;

            __weak typeof(self) weakSelf = self;
            cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
                HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
                vc.link = [(HRBannerVO *)weakSelf.currentVO.banners[currentIndex] link];
                vc.title = [(HRBannerVO *)weakSelf.currentVO.banners[currentIndex] name];
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [weakSelf.rdv_tabBarController setTabBarHidden:YES animated:YES];

            };
            [homeTable reloadData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)checkCity
{
    [Net CityInfo:[Utils readUser].token Page:1 Rows:10000 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            NSArray* cityArray = [HRCityVO objectArrayWithKeyValuesArray:info[@"data"][@"cities"]];
            [Utils archiveCityData:cityArray];
        }
        else
            ;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return 2;
    else if(section == 1)
        return 1;
    else
        return _currentVO.news.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 200;
    else
        return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    if(section == 0)
    {
        vv.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        [vv addSubview:cycleScrollView];
    }
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 56;
    else if (indexPath.section == 1)
        return 235;
    else if (indexPath.section == 2&&indexPath.row == 0)
        return 30;
    else if (indexPath.section == 2)
        return 46;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if(section == 0)
    {
        static NSString *cellIdentifier = @"Key";
        UITableViewCell *cell = [tableView   dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH - 44, 56)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = [Utils colorWithHexString:@"535353"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(14, 18, 20, 20)];
        UILabel* tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 21, 14, 14)];
        tipLabel.backgroundColor = [UIColor redColor];
        [Utils cornerView:tipLabel withRadius:7 borderWidth:0 borderColor:nil];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = [UIFont systemFontOfSize:10];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        switch (row) {
            case 0:
                titleLabel.text = @"待我办理";
                img.image = PNG_FROM_NAME(@"icon_hetong");
                if (_currentVO.myTransaction.intValue <= 0) {
                    tipLabel.hidden = YES;
                }else{
                    tipLabel.hidden = NO;
                    tipLabel.text = _currentVO.myTransaction;
                }
                break;
            case 1:
                titleLabel.text = @"我的申请";
                img.image = PNG_FROM_NAME(@"icon_shengqing");
                if (_currentVO.myApply.intValue <= 0) {
                    tipLabel.hidden = YES;
                }else{
                    tipLabel.hidden = NO;
                    tipLabel.text = _currentVO.myApply;
                }
                break;
            default:
                break;
        }
        [cell.contentView addSubview:tipLabel];
        [cell.contentView addSubview:img];
        [cell.contentView addSubview:titleLabel];
        return cell;
    }
    else if(section == 1)
    {
        static NSString *cellIdentifier = @"HRHomeInfoCell";
        HRHomeInfoCell *cell = (HRHomeInfoCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [HRHomeInfoCell getInstanceWithNib];
        }
        else{
            //NSLog(@"FixMentCell");
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }
    else if(section == 2 && row == 0)
    {
        static NSString *cellIdentifier = @"Key";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH - 44, 30)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = [Utils colorWithHexString:@"535353"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        titleLabel.text = @"最新";
        [cell.contentView addSubview:titleLabel];
        UILabel* moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 24 - 100, 30)];
        moreLabel.font = [UIFont systemFontOfSize:12.0];
        moreLabel.textColor = [Utils colorWithHexString:@"666666"];
        moreLabel.textAlignment = NSTextAlignmentRight;
        moreLabel.text = @"更多";
        [cell.contentView addSubview:moreLabel];
        return cell;
        
    }
    else
    {
        HRNewsVO* vo = _currentVO.news[indexPath.row-1];
        static NSString *cellIdentifier = @"Key";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, SCREEN_WIDTH - 46, 46)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.textColor = [Utils colorWithHexString:@"535353"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(14, 21, 4, 4)];
        img.image = [Utils createImageWithColor:[Utils colorWithHexString:@"1978CA"]];
        [Utils cornerView:img withRadius:2 borderWidth:0 borderColor:nil];
        titleLabel.text = vo.title;
        [cell.contentView addSubview:img];
        [cell.contentView addSubview:titleLabel];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//待我办理
            if ([[Utils readUser].status integerValue] == 0) {
                [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
                return;
            }
            HRDelayTransactVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDelayTransact"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{//我的申请
            if ([[Utils readUser].status integerValue] == 0) {
                [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
                return;
            }
            HRMyApplyVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRMyApply"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
        
    }else if (indexPath.section == 1){
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            HRInformationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRInformation"];
            [self.navigationController pushViewController:vc animated:YES];
            
            [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
        }else{
            HRInformationDetailVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRInformationDetail"];
            vc.nid = [[_currentVO.news[indexPath.row - 1] id] intValue];
            [self.navigationController pushViewController:vc animated:YES];
            
            [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
        }
    }
    
    NSLog(@"deselectRowAtIndexPath-%ld-%ld",(long)indexPath.section,(long)indexPath.row);
}


-(void)objAction:(NSInteger)actionTag{
    if (actionTag - 100 == 0) {//证明办理
        if ([[Utils readUser].status integerValue] == 0) {
            [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
            return;
        }
        HRDealThatVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDealThat"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(actionTag - 100 == 1){//社保
        if ([[Utils readUser].status integerValue] == 0) {
            [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
            return;
        }
        HRSocialSecurityVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRSocialSecurity"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(actionTag - 100 == 2){//公积金
        if ([[Utils readUser].status integerValue] == 0) {
            [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
            return;
        }
        HRAccumulationFundVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRAccumulationFund"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(actionTag - 100 == 3){//档案借阅
        if ([[Utils readUser].status integerValue] == 0) {
            [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
            return;
        }
        HRArchivesLibraryVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRArchivesLibrary"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(actionTag - 100 == 4){//户口办理
        if ([[Utils readUser].status integerValue] == 0) {
            [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
            return;
        }
        HRResidenceDealVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRResidenceDeal"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(actionTag - 100 == 5){//居住证办理
        if ([[Utils readUser].status integerValue] == 0) {
            [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
            return;
        }
        HRPublicDealtVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRPublicDealt"];
        vc.hkName = @"居住证办理";
        [self.navigationController pushViewController:vc animated:YES];
    }else if(actionTag - 100 == 6){//新员工
        HRNewEmployeeVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRNewEmployee"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(actionTag - 100 == 7){//更多
        if ([[Utils readUser].status integerValue] == 0) {
            [SVProgressHUD showImage:nil status:@"新员工不能使用该功能"];
            return;
        }
        HRMoresVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRMores"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
