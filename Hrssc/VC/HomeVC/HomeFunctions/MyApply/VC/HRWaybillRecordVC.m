
//
//  HRWaybillRecordVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/27.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRWaybillRecordVC.h"
#import "HRWaybillRecordCell.h"

@interface HRWaybillRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *wr_table;

@end

@implementation HRWaybillRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"运单记录";

    self.wr_table.delegate = self;
    self.wr_table.dataSource = self;
    self.wr_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *heder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 15)];
    heder.backgroundColor = [UIColor whiteColor];
    return heder;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    HRWaybillRecordCell *cell = (HRWaybillRecordCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRWaybillRecordCell" owner:nil options:nil] firstObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    HRContractDetailsVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRContractDetails"];
//    [self.navigationController pushViewController:vc animated:YES];
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
