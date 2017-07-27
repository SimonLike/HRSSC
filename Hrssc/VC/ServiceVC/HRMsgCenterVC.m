//
//  HRMsgCenterVC.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMsgCenterVC.h"
#import "HRMsgCell.h"
#import "HRMsgDetialVC.h"

@interface HRMsgCenterVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView* conTable;
    NSMutableArray* dataAry;
    int page;
    int pageSize;
}

@end

@implementation HRMsgCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    page = 1;
    pageSize = 10;
    dataAry = [NSMutableArray new];
    
    [self setUpTable];
    [self getData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)getData
{
    [Net InfoList:[Utils readUser].token Page:page Rows:pageSize CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
            if(page == 1)
            {
                [conTable.mj_header endRefreshing];
                [conTable.mj_footer endRefreshing];
                [dataAry removeAllObjects];
            }
            NSArray* ary = [HRMsgVO objectArrayWithKeyValuesArray:info[@"data"][@"messages"]];
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
    conTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    conTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
    return 114;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    HRMsgVO* vo = dataAry[row];
    static NSString *cellIdentifier = @"AddCell";
    HRMsgCell *cell = (HRMsgCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [HRMsgCell getInstanceWithNib];
    }
    else{
        //NSLog(@"FixMentCell");
    }
    [cell setUI:vo];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HRMsgVO* vo = dataAry[indexPath.row];
    HRMsgDetialVC* vc = [HRMsgDetialVC new];
    vc.mId = [vo.id intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//删除按钮的title赋值
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
//删除用到的函数
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
   
        [Net InfoDel:[Utils readUser].token Mid:[[(HRMsgVO*)dataAry[indexPath.row] id] intValue] CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            [dataAry removeObjectAtIndex:indexPath.row];
            [conTable reloadData];
        }
    } FailBack:^(NSError *error) {
        
    }];
        
//        if (self.listArray.count > 0) {
//            [self.listArray removeObjectAtIndex:indexPath.row];
//            [_tableview reloadData];
//        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
