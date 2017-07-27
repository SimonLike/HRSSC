//
//  HRScoreRecordVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRScoreRecordVC.h"
#import "HRScoreListCell.h"
#import "HRScoreProVC.h"

@interface HRScoreRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* buyTable;
    NSMutableArray* dataAry;
    int page;
    int pageSize;
}

@end

@implementation HRScoreRecordVC

- (void)setUI
{
    self.title = @"兑换记录";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [Utils creatBackItem:self Selector:@selector(back)];
    dataAry = [NSMutableArray new];
    page = 1;
    pageSize = 10;
    [self setUpTable];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self getData];
}

- (void)getData
{
    [Net OrderList:[Utils readUser].token Page:page Rows:pageSize CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            if(page == 1)
            {
                [buyTable.mj_header endRefreshing];
                [buyTable.mj_footer endRefreshing];
                [dataAry removeAllObjects];
            }
            NSArray* ary = [OrderListVO objectArrayWithKeyValuesArray:info[@"data"][@"orders"]];
            [buyTable.mj_header endRefreshing];
            if(ary.count < 10)
                [buyTable.mj_footer endRefreshingWithNoMoreData];
            else
                [buyTable.mj_footer endRefreshing];
            [dataAry addObjectsFromArray:ary];
            [buyTable reloadData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)setUpTable
{
    buyTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    buyTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    buyTable.backgroundColor = [UIColor clearColor];
    buyTable.delegate = self;
    buyTable.dataSource = self;
    [Utils setupRefresh:buyTable WithDelegate:self HeaderSelector:@selector(headRefresh) FooterSelector:@selector(footRefresh)];
    [self.view addSubview:buyTable];
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
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HRScoreListCell";
    HRScoreListCell *cell = (HRScoreListCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [HRScoreListCell getInstanceWithNib];
    }
    else{
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUI:dataAry[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderListVO *obj = dataAry[indexPath.row];
   
    HRScoreProVC* vc = [HRScoreProVC new];
    
    HRScoreProductVO *vos = [HRScoreProductVO new];
    vc.pid = [obj.pid intValue];
    vos.id = obj.pid;
    vos.name = obj.pname;
    vos.price = obj.points;
    vos.img_url = obj.img_url;
    vc.currentVO = vos;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
