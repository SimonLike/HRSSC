//
//  HRHelpSectionVC.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRHelpSectionVC.h"
#import "HRCommonWebVC.h"

@interface HRHelpSectionVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView* conTable;
    int page;
    int pageSize;
}
@property (nonatomic,strong) NSMutableArray* dataAry;

@end

@implementation HRHelpSectionVC

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)infoMsg
{
    //跳转到二级菜单
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题分类";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [Utils creatBackItem:self Selector:@selector(back)];
    page = 1;
    pageSize = 10;
    [self getData];
    [self setUpTable];
}

- (void)getData
{
    [Net HelpList:[Utils readUser].token Search:_seStr?_seStr:@"" Cid:_cId Page:page Rows:pageSize CallBack:^(BOOL isSucc, NSDictionary *info) {
        if(isSucc)
        {
         
            NSArray* ary = [HRSQVO objectArrayWithKeyValuesArray:info[@"data"][@"questions"]];
            [self.dataAry addObjectsFromArray:ary];
            [conTable reloadData];
            
            [conTable.mj_header endRefreshing];

            if(ary.count < 10)
                [conTable.mj_footer endRefreshingWithNoMoreData];
            else
                [conTable.mj_footer endRefreshing];
           
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
    [self.dataAry removeAllObjects];

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
    [Utils setupRefresh:conTable WithDelegate:self HeaderSelector:@selector(headRefresh) FooterSelector:@selector(footRefresh)];
    [self.view addSubview:conTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
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
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Key";
    UITableViewCell *cell = [tableView   dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (self.dataAry.count > 0) {
        HRSQVO* vo = self.dataAry[indexPath.row];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [Utils colorWithHexString:@"353535"];
        cell.textLabel.text = vo.title;
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HRSQVO* vo = self.dataAry[indexPath.row];
    HRCommonWebVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRCommonWeb"];
    vc.qid = [vo.id intValue];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(NSMutableArray  *)dataAry{
    if (!_dataAry) {
        _dataAry = [NSMutableArray array];
    }
    return _dataAry;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
