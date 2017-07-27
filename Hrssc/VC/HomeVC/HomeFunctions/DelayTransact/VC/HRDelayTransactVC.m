//
//  HRDelayTransactVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/26.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRDelayTransactVC.h"
#import "HRDelayTransactCell.h"
#import "HRContractDetailsVC.h"
#import "HRNotInfosView.h"

@interface HRDelayTransactVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *titleTypeView;
@property (weak, nonatomic) IBOutlet UIButton *signedBtn;
@property (weak, nonatomic) IBOutlet UIButton *sealedBtn;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;
@property (weak, nonatomic) IBOutlet UITableView *dt_table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnconts;
@property (nonatomic,strong) NSMutableArray *dt_array;
@property (nonatomic,strong) HRNotInfosView *notInfosView;
@property (nonatomic) int page;//翻页page
@property (nonatomic) int status;//待签署 待盖章 已完成

@end

@implementation HRDelayTransactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待我办理";

    self.page = 1;
    self.status = 0;
    
    self.dt_table.delegate = self;
    self.dt_table.dataSource = self;
    self.dt_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
    [self WaitingDeal:self.status];
    
    [Utils setupRefresh:self.dt_table WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
}
#pragma mark -- 数据请求
//刷新
-(void)headerRefresh{
    self.page = 1;
    [self.dt_array removeAllObjects];

    [self WaitingDeal:self.status];
}
//加载更多
-(void)footerRefresh{
    self.page += 1;
    [self WaitingDeal:self.status];
}

-(void)WaitingDeal:(int)status{
    [Net WaitingDeal:[Utils readUser].token Status:status Page:self.page Rows:10 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            [self.dt_array addObjectsFromArray:[HRDealVO objectArrayWithKeyValuesArray:info[@"data"][@"clist"]]];
        }
        [self.dt_table.mj_footer endRefreshing];
        [self.dt_table.mj_header endRefreshing];
        
        if (self.dt_array.count == 0) {
            [self.view addSubview:self.notInfosView];
        }else{
            [self.notInfosView removeFromSuperview];
            [self.dt_table reloadData];

        }
    } FailBack:^(NSError *error) {
        [self.dt_table.mj_footer endRefreshing];
        [self.dt_table.mj_header endRefreshing];
        if (self.dt_array.count == 0) {
            [self.view addSubview:self.notInfosView];
        }else{
            [self.notInfosView removeFromSuperview];
        }
    }];
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dt_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    HRDelayTransactCell *cell = (HRDelayTransactCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRDelayTransactCell" owner:nil options:nil] firstObject];
    }
    if (indexPath.row == 0) {
        cell.xian.hidden = NO;
    }
    if (self.dt_array.count>0) {
        HRDealVO *obj = self.dt_array[indexPath.row];
        cell.contractNameLab.text = obj.tpl_name;
        if (obj.status.integerValue == 0) {//"status":1,   //状态0-待签署  1-待盖章  2-已撤销  3-已完成
            cell.typeLab.text = @"待签署";
        }else if (obj.status.integerValue == 1){
            cell.typeLab.text = @"待盖章";
        }else if (obj.status.integerValue == 2){
            cell.typeLab.text = @"已撤销";
        }else if (obj.status.integerValue == 3){
            cell.typeLab.text = @"已完成";
        }
        if (obj.status.integerValue != 0) {
            cell.signLab.hidden = NO;
        }
        if (obj.sign_way.integerValue == 0) {//"sign_way":1,     //签署方式  0电子签署1当面签署2邮寄签署
            cell.signLab.text = @"电子签署";
        }else if (obj.sign_way.integerValue == 1){
            cell.signLab.text = @"当面签署";
        }else if (obj.sign_way.integerValue == 2){
            cell.signLab.text = @"邮寄签署";
        }
        if (obj.create_time) {
            cell.timeLab.text = [obj.create_time substringToIndex:16];
        }
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dt_array.count > 0) {
        HRDealVO *obj = self.dt_array[indexPath.row];
        
        HRContractDetailsVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRContractDetails"];
        vc.contract_id = obj.id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)dtclick:(UIButton *)sender {
//     RGBACOLOR16
    for (int i=0; i < 3; i++) {
        UIButton *btn = (UIButton *)[self.titleTypeView viewWithTag:10+i];
        if (sender.tag - 10 == i) {
            [btn setTitleColor:RGBCOLOR16(0x1790D2) forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        }
    }
    self.btnconts.constant = self.view.width/3 * (sender.tag - 10);
    if (sender.tag == 10) {
        self.status = 0;
    }else if (sender.tag == 11){
        self.status = 1;
    }else if (sender.tag == 12){
        self.status = 3;
    }
    [self.dt_array removeAllObjects];//移除
    self.page = 1;
    [self WaitingDeal:self.status];

}

#pragma mark --l懒加载
-(NSMutableArray *)dt_array{
    if (!_dt_array) {
        _dt_array = [NSMutableArray array];
    }
    return _dt_array;
}
- (HRNotInfosView *)notInfosView{
    if (!_notInfosView) {
        _notInfosView = [HRNotInfosView initNotInfosView];
        _notInfosView.frame = CGRectMake(0, 108, self.view.width, self.view.height-108);
        _notInfosView.cz_image.image = [UIImage imageNamed:@"icon_shenqing"];
        _notInfosView.cz_label1.text = @"";
        _notInfosView.cz_label2.text = @"暂无该项申请";
//        _notInfosView.centerTop.constant = - 100;
    }
    return _notInfosView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
