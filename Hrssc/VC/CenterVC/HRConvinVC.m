//
//  HRConvinVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRConvinVC.h"
#import "HRConCell.h"
#import "HRCommonWebVC.h"

@interface HRConvinVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray* dataAry;
    UITableView* conTable;
    int page;
    int pageSize;
}


@end

@implementation HRConvinVC

- (void)setUI
{
    self.title = @"快捷服务";
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    dataAry = [NSMutableArray new];
    page = 1;
    pageSize = 10;
    [self setUpTable];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self getData];
}

- (void)setUpTable
{
    conTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    conTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    conTable.backgroundColor = [UIColor clearColor];
    conTable.delegate = self;
    conTable.dataSource = self;
    [Utils setupRefresh:conTable WithDelegate:self HeaderSelector:@selector(headRefresh) FooterSelector:@selector(footRefresh)];
    [self.view addSubview:conTable];
    
}

- (void)headRefresh
{
    page = 1;
    [self getData];
}

- (void)footRefresh
{
    page += 1;
    [self getData];
}

- (void)getData
{
    [Net ServiceList:[Utils readUser].token Page:page Rows:pageSize CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            if(page == 1)
            {
                [conTable.mj_header endRefreshing];
                [conTable.mj_footer endRefreshing];
                [dataAry removeAllObjects];
            }
            NSArray* ary = [HRSericeVO objectArrayWithKeyValuesArray:info[@"data"][@"services"]];
            [conTable.mj_header endRefreshing];
            if(ary.count < 10)
                [conTable.mj_footer endRefreshingWithNoMoreData];
            else
                [conTable.mj_footer endRefreshing];
            [dataAry addObjectsFromArray:ary];
            [conTable reloadData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
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
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HRConCell";
    HRConCell *cell = (HRConCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [HRConCell getInstanceWithNib];
    }
    else{
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setUI:dataAry[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //缺少点击跳转
    
    HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
    vc.link = [(HRSericeVO *)dataAry[indexPath.row] url];
    vc.title = [(HRSericeVO *)dataAry[indexPath.row] name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
