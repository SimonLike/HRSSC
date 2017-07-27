//
//  HRHistoricalRecordVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRHistoricalRecordVC.h"
#import "HRHistoricalRecordCell.h"
#import "HRSocialHistoryDetailsVC.h"

@interface HRHistoricalRecordVC ()
@property (weak, nonatomic) IBOutlet UITableView *hr_table;
@property (nonatomic, strong) NSMutableArray *recordArr;
@property (nonatomic) int page;//翻页page

@end

@implementation HRHistoricalRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认值
    self.page = 1;
    //请求数据
    [self SocialSecurityDate:self.page];
    
    [Utils setupRefresh:self.hr_table WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    
}
#pragma mark -- 数据请求
//刷新
-(void)headerRefresh{
    self.page = 1;
    [self.recordArr removeAllObjects];
    
    [self SocialSecurityDate:self.page];
}
//加载更多
-(void)footerRefresh{
    self.page += 1;
    [self SocialSecurityDate:self.page];
}
- (void)SocialSecurityDate:(int)page{
    //接口调用
    [Net SocialSecurityDate:[Utils readUser].token Page:page Rows:10 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            [self.recordArr addObjectsFromArray: info[@"data"][@"socialSecurityList"]];
            [self.hr_table reloadData];
        }
        [self.hr_table.mj_footer endRefreshing];
        [self.hr_table.mj_header endRefreshing];
    } FailBack:^(NSError *error) {
        [self.hr_table.mj_footer endRefreshing];
        [self.hr_table.mj_header endRefreshing];
    }];
}
#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    HRHistoricalRecordCell *cell = (HRHistoricalRecordCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRHistoricalRecordCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeLabel.text = self.recordArr[indexPath.row][@"data"];
    cell.amountLabel.text = [NSString stringWithFormat:@"%@元",self.recordArr[indexPath.row][@"total"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRSocialHistoryDetailsVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRSocialHistoryDetails"];
    vc.qryDate = self.recordArr[indexPath.row][@"data"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSMutableArray *)recordArr{
    if (!_recordArr) {
        _recordArr = [NSMutableArray array];
    }
    return _recordArr;
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
