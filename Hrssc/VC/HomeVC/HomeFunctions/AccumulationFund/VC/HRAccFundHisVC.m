//
//  HRAccFundHisVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAccFundHisVC.h"
#import "HRAccFundHisCell.h"
#import "HRPublicFundObj.h"

@interface HRAccFundHisVC ()
@property (weak, nonatomic) IBOutlet UITableView *afh_table;
@property (strong, nonatomic) NSMutableArray *hisArray;
@property (nonatomic) int page;//翻页page

@end

@implementation HRAccFundHisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGBCOLOR16(0xf1f1f1);

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 54)];
    header.backgroundColor = RGBCOLOR(203, 234, 247);
    
    UIView *w_v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    w_v.backgroundColor = RGBCOLOR16(0xf1f1f1);
    [header addSubview:w_v];
    
    NSArray *list = @[@"缴纳地",@"缴纳月份",@"缴纳基数",@"单位比例",@"个人比例",@"缴纳金额"];
    for (int i = 0; i < list.count; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(self.view.width/6*i, 10, self.view.width/6, header.height - 10);
        label.textColor = RGBCOLOR16(0x333333);
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = list[i];
        [header addSubview:label];
    }
    self.afh_table.tableHeaderView = header;
    
    //默认值
    self.page = 1;
    //请求数据
    [self GetPublicFunds:self.page];
    
    [Utils setupRefresh:self.afh_table WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
  
}
#pragma mark -- 数据请求
//刷新
-(void)headerRefresh{
    self.page = 1;
    [self.hisArray removeAllObjects];
    
    [self GetPublicFunds:self.page];
}
//加载更多
-(void)footerRefresh{
    self.page += 1;
    [self GetPublicFunds:self.page];
}

-(void)GetPublicFunds:(int)page{
    //    @"3522e253684a45fba70854f23191ce49"
    [Net GetPublicFunds:[Utils readUser].token Page:page Rows:20 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (info) {
            DLog(@"info--->%@",info);
            [self.hisArray addObjectsFromArray: [HRPublicFundObj objectArrayWithKeyValuesArray:info[@"data"][@"publicFunds"]]];
            [self.afh_table reloadData];
        }
        [self.afh_table.mj_footer endRefreshing];
        [self.afh_table.mj_header endRefreshing];
    } FailBack:^(NSError *error) {
        [self.afh_table.mj_footer endRefreshing];
        [self.afh_table.mj_header endRefreshing];
    }];
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hisArray.count;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 54)];
//    header.backgroundColor = RGBCOLOR(203, 234, 247);
//    
//    UIView *w_v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
//    w_v.backgroundColor = RGBCOLOR(255, 255, 255);
//    [header addSubview:w_v];
//
//    NSArray *list = @[@"缴纳地",@"缴纳月份",@"缴纳基数",@"单位比例",@"个人比例",@"缴纳金额"];
//    for (int i = 0; i < list.count; i ++) {
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(self.view.width/6*i, 10, self.view.width/6, header.height - 10);
//        label.textColor = RGBCOLOR16(0x333333);
//        label.font = [UIFont systemFontOfSize:13];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = list[i];
//        [header addSubview:label];
//    }
//    return header;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    HRAccFundHisCell *cell = (HRAccFundHisCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRAccFundHisCell" owner:nil options:nil] firstObject];
    }
    HRPublicFundObj *obj = self.hisArray[indexPath.row];
    cell.label1.text = obj.city;
    cell.label2.text = obj.paytime;
    cell.label3.text = obj.base;
    cell.label4.text = obj.percent_company;
    cell.label5.text = obj.percent_personal;
    cell.label6.text = obj.payamount;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

-(NSMutableArray *)hisArray{
    if (!_hisArray) {
        _hisArray = [NSMutableArray array];
    }
    return _hisArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
