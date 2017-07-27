//
//  HRAddSelectVC.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAddSelectVC.h"
#import "AddCell.h"
#import "AddressDetialVC.h"
@interface HRAddSelectVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AddCellDelegate>
{
    UITableView* conTable;
    NSMutableArray* dataAry;
    int page;
    int pageSize;
}

@end

@implementation HRAddSelectVC

- (void)setUI
{
    self.title = @"收件地址选择";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [Utils creatBackItem:self Selector:@selector(back)];
    page = 1;
    pageSize = 10;
    dataAry = [NSMutableArray new];
    //[self getData];
    [self setUpTable];
    UIButton* bottowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
    [bottowBtn setBackgroundColor:[Utils colorWithHexString:@"1978CA"]];
    bottowBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bottowBtn setTitleColor:[UIColor whiteColor] forState:0];
    [bottowBtn setTitle:@"添加收件地址" forState:0];
    [self.view addSubview:bottowBtn];
    [bottowBtn addTarget:self action:@selector(addAdd) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAdd
{
    AddressDetialVC* vc = [[AddressDetialVC alloc] initWithNibName:@"AddressDetialVC" bundle:nil];
    vc.currentVO = nil;
    vc.adType = 1;
    vc.title = @"添加收货地址";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    page = 1;
    [self getData];
}

- (void)getData
{
    [Net AddressGet:[Utils readUser].token Page:page Rows:pageSize CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            if(page == 1)
            {
                [conTable.mj_header endRefreshing];
                [conTable.mj_footer endRefreshing];
                [dataAry removeAllObjects];
            }
            NSArray* ary = [HRAddVO objectArrayWithKeyValuesArray:info[@"data"][@"addrs"]];
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

- (void)setUpTable
{
    conTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    conTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50);
    conTable.backgroundColor = [UIColor clearColor];
    conTable.delegate = self;
    conTable.dataSource = self;
    conTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [Utils setupRefresh:conTable WithDelegate:self HeaderSelector:@selector(headRefresh) FooterSelector:@selector(footRefresh)];
    [self.view addSubview:conTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataAry.count;
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
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    HRAddVO* vo = dataAry[row];
    static NSString *cellIdentifier = @"AddCell";
    AddCell *cell = (AddCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [AddCell getInstanceWithNib];
    }
    else{
        //NSLog(@"FixMentCell");
    }
    [cell setUI:vo];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    HRAddVO* vo = dataAry[row];
    if(_aBlock)
        _aBlock(vo);
    [self back];
}

- (void)setDefault:(UITableViewCell*)cell
{
    
    NSIndexPath* index = [conTable indexPathForCell:cell];
    HRAddVO* aVO = dataAry[index.row];
    if([aVO.is_default isEqualToString:@"1"])
        return;
    [Net AddressSet:[Utils readUser].token Aid:[aVO.id intValue] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            [[XQTipInfoView getInstanceWithNib] appear:@"设置成功"];
            for (HRAddVO* aVO in dataAry) {
                if([dataAry indexOfObject:aVO] == index.row)
                {
                    if([aVO.is_default isEqualToString:@"1"])
                        return;
                    else
                        aVO.is_default = @"1";
                }
                else
                    aVO.is_default = @"0";
            }
            [conTable reloadData];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}

- (void)edit:(UITableViewCell*)cell
{
    NSIndexPath* index = [conTable indexPathForCell:cell];
    HRAddVO* aVO = dataAry[index.row];
    AddressDetialVC* vc = [[AddressDetialVC alloc] initWithNibName:@"AddressDetialVC" bundle:nil];
    vc.currentVO = dataAry[index.row];
    vc.adType = 2;
    vc.aId = [aVO.id intValue];
    vc.title = @"编辑收货地址";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)del:(UITableViewCell*)cell
{
    NSIndexPath* index = [conTable indexPathForCell:cell];
    HRAddVO* aVO = dataAry[index.row];
    
    [Net AddressDel:[Utils readUser].token Aid:[aVO.id intValue] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            [dataAry removeObjectAtIndex:index.row];
            [conTable beginUpdates];
            [conTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
            [conTable endUpdates];
        }
        else
        {
            
        }
    } FailBack:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
