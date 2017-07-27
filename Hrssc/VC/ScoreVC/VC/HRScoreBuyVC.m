//
//  HRScoreBuyVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRScoreBuyVC.h"
#import "HRAddCell.h"
#import "HRProbuyCell.h"
#import "HRAddSelectVC.h"
@interface HRScoreBuyVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,HRAddCellDelegate>
{
    UITableView* buyTable;
    HRAddVO* currentAVO;
}
@end

@implementation HRScoreBuyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"兑换";
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    buyTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    buyTable.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-50-64);
    buyTable.backgroundColor = [UIColor clearColor];
    buyTable.delegate = self;
    buyTable.dataSource = self;
    [self.view addSubview:buyTable];
    
    UIButton* commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-150, SCREEN_WIDTH-40, 50)];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [commitBtn setTitle:@"确认兑换" forState:0];
    [commitBtn setBackgroundColor:[Utils colorWithHexString:@"1978CA"]];
    [Utils cornerView:commitBtn withRadius:3 borderWidth:0 borderColor:nil];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
}

- (void)commit
{
    
    if(currentAVO.id.intValue == 0){
        [SVProgressHUD showImage:nil status:@"请添加收件地址"];
        return;
    }
    
    [Net ScoreToProduct:[Utils readUser].token Count:1 Pid:[_currentVO.id intValue] Aid:[currentAVO.id intValue] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            [[XQTipInfoView getInstanceWithNib] appear:@"兑换成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 136;
    else
        return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section == 0)
    {
        static NSString *cellIdentifier = @"HRAddVO";
        HRAddCell *cell = (HRAddCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [HRAddCell getInstanceWithNib];
        }
        else{
            //NSLog(@"FixMentCell");
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setUI:currentAVO];
        cell.delegate = self;
        return cell;
    }
    else
    {
        static NSString *cellIdentifier = @"HRProbuyCell";
        HRProbuyCell *cell = (HRProbuyCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [HRProbuyCell getInstanceWithNib];
        }
        else{
            //NSLog(@"FixMentCell");
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCellUI:_currentVO];
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        HRAddSelectVC* vc = [HRAddSelectVC new];
        vc.aBlock = ^(HRAddVO* vo)
        {
            currentAVO = vo;
            [buyTable reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)seAdd
{
    HRAddSelectVC* vc = [HRAddSelectVC new];
    vc.aBlock = ^(HRAddVO* vo)
    {
        currentAVO = vo;
        [buyTable reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
