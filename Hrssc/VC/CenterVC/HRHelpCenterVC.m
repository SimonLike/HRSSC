//
//  HRHelpCenterVC.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRHelpCenterVC.h"
#import "HRHelpSectionVC.h"
@interface HRHelpCenterVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView* conTable;
    UITextField* searchTxt;
    int page;
    int pageSize;
    UITapGestureRecognizer* tapGes;
}
@property (nonatomic,strong) NSMutableArray* dataAry;

@end

@implementation HRHelpCenterVC

- (void)setUI
{
    //self.title = @"我的";
    [Utils setNavBarBgUI:self.navigationController.navigationBar];
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
    [Utils creatBackItem:self Selector:@selector(back)];
    UIButton* searchBtn = [Utils createButtonWith:CustomButtonType_Text text:@"取消"];
    [searchBtn setTitleColor:[Utils colorWithHexString:@"1978CA"] forState:0];
    [searchBtn addTarget:self action:@selector(infoMsg) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
     
    page = 1;
    pageSize = 10;
    tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self setUpTable];
    [self setUpSearchBar];
    [self getData];

}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)infoMsg
{
    [self back];
}

- (void)tap:(UITapGestureRecognizer*)ges
{
    [searchTxt resignFirstResponder];
    [conTable removeGestureRecognizer:tapGes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)getData
{
    [Net HelpCenter:[Utils readUser].token Page:page Rows:pageSize CallBack:^(BOOL isSucc, NSDictionary *info) {
        DLog(@"info --%@",info);

        if(isSucc)
        {
           
            [self.dataAry addObjectsFromArray:[HRFQVO objectArrayWithKeyValuesArray:info[@"data"][@"classes"]]];
            
            [self endtableRef:[HRFQVO objectArrayWithKeyValuesArray:info[@"data"][@"classes"]]];
        }
        else
        {
            [self endtableRef:[HRFQVO objectArrayWithKeyValuesArray:info[@"data"][@"classes"]]];

        }
        [conTable reloadData];

    } FailBack:^(NSError *error) {
        [conTable.mj_header endRefreshing];
        [conTable.mj_footer endRefreshing];
    }];
}

-(void)endtableRef:(NSArray *)ary{
    [conTable.mj_header endRefreshing];
    if(ary.count < 10)
        [conTable.mj_footer endRefreshingWithNoMoreData];
    else
        [conTable.mj_footer endRefreshing];
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

- (void)setUpSearchBar
{
    UIView* searchView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH-100, 34)];
    searchView.backgroundColor = [UIColor whiteColor];
    [Utils cornerView:searchView withRadius:17 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
    searchTxt = [[UITextField alloc] initWithFrame:CGRectMake(17, 0, CGRectGetWidth(searchView.frame)-24, 34)];
    searchTxt.placeholder = @"输入关键词搜索";
    searchTxt.textColor = [Utils colorWithHexString:@"535353"];
    searchTxt.font = [UIFont systemFontOfSize:14];
    searchTxt.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTxt.returnKeyType = UIReturnKeySearch;
    searchTxt.delegate = self;
    [searchView addSubview:searchTxt];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:searchView];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [conTable addGestureRecognizer:tapGes];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [searchTxt resignFirstResponder];
    [conTable removeGestureRecognizer:tapGes];
    //跳转到二级菜单
    HRHelpSectionVC* vc = [HRHelpSectionVC new];
    vc.seStr = searchTxt.text;
    vc.cId = NULL;
    [self.navigationController pushViewController:vc animated:YES];
    //跳转到二级菜单
    return YES;
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
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if (self.dataAry.count >0) {
        HRFQVO* vo = self.dataAry[indexPath.row];
        
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = [Utils colorWithHexString:@"353535"];
        cell.textLabel.text = vo.name;
    }
  
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HRFQVO* vo = self.dataAry[indexPath.row];
    HRHelpSectionVC* vc = [HRHelpSectionVC new];
    vc.seStr = @"";
    vc.cId = [vo.id intValue];
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
