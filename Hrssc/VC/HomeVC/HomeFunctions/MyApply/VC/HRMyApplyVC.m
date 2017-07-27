//
//  HRMyApplyVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/26.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMyApplyVC.h"
#import "HRMyApplyCell.h"
#import "HRApplyDetailVC.h"
#import "HRApplyObj.h"
#import "HRDraftBoxVC.h"
#import "HREvaluationVC.h"

#import "HRDealThatDeatilVC.h"
#import "HRArchivesLibraryVC.h"
#import "HRPublicDealtVC.h"
#import "HREmployeeModelVC.h"
#import "HRNotInfosView.h"

@interface HRMyApplyVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleTyView;
@property (weak, nonatomic) IBOutlet UITableView *ma_table;
@property (nonatomic,strong) NSArray *typeArr;
@property (nonatomic) NSInteger typeInt;
@property (nonatomic, strong) NSMutableArray *ma_array;
@property (nonatomic, strong)UIView *downxian;
@property (nonatomic, strong)HRNotInfosView *notInfosView;

@property (nonatomic) int page;//翻页page
@property (nonatomic) int status;//@"待审核",@"待办理",@"待领取",@"待评价",@"已完成",@"驳回"

@end

@implementation HRMyApplyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的申请";
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"草稿箱" forState:UIControlStateNormal];
    self.navBtnRight.frame = CGRectMake(SCREEN_WIDTH - SCREEN_NAVIGATION_HEIGHT - 3, SCREEN_STATUS, 100, SCREEN_NAVIGATION_HEIGHT);
    self.navBtnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.ma_table.delegate = self;
    self.ma_table.dataSource = self;
    self.ma_table.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    _typeArr = @[@"待审核",@"待办理",@"待领取",@"待评价",@"已完成",@"驳回"];
    float btnWith = self.view.width/_typeArr.count;
    self.typeInt = 10;
    for (int i = 0; i < _typeArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWith*i, 0, btnWith, self.titleTyView.height);
        [btn setTitle:_typeArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleTyView addSubview:btn];
        
        if (i==0) {
            [btn setTitleColor:RGBCOLOR16(0x007AFF) forState:UIControlStateNormal];
        }
    }
    
    self.downxian = [UIView new];
    self.downxian.frame = CGRectMake(0, self.titleTyView.height-3, btnWith, 3);
    self.downxian.backgroundColor = RGBCOLOR16(0x007CD0);
    [self.titleTyView addSubview:self.downxian];
    
    //默认值
    self.page = 1;
    self.status = 0;
    [Utils setupRefresh:self.ma_table WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];

    //请求数据
    [self GetApplys:self.status];
}

-(void)rightAction{
    HRDraftBoxVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDraftBox"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 数据请求
//刷新
-(void)headerRefresh{
    self.page = 1;
    [self.ma_array removeAllObjects];
    
    [self GetApplys:self.status];
}
//加载更多
-(void)footerRefresh{
    self.page += 1;
    [self GetApplys:self.status];
}
//接口请求
-(void)GetApplys:(int)status{
    
    [Net GetApplys:[Utils readUser].token Status:status Search:@"" Page:self.page Rows:20 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {

            [self.ma_array addObjectsFromArray:[HRApplyObj objectArrayWithKeyValuesArray:info[@"data"][@"applys"]]];
        }
        [self.ma_table.mj_footer endRefreshing];
        [self.ma_table.mj_header endRefreshing];
        if (self.ma_array.count == 0) {
            [self.view addSubview:self.notInfosView];
        }else{
            [self.notInfosView removeFromSuperview];
            [self.ma_table reloadData];

        }
    } FailBack:^(NSError *error) {
        [self.ma_table.mj_footer endRefreshing];
        [self.ma_table.mj_header endRefreshing];
        if (self.ma_array.count == 0) {
            [self.view addSubview:self.notInfosView];
        }else{
            [self.notInfosView removeFromSuperview];
        }
    }];
}
//确认领取
-(void)gain:(int)aid{
   [Net Gain:[Utils readUser].token Aid:aid CallBack:^(BOOL isSucc, NSDictionary *info) {
       if (isSucc) {
           [self.ma_array removeAllObjects];

           [self GetApplys:self.status];
       }
   } FailBack:^(NSError *error) {
       
   }];
}



#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ma_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    HRMyApplyCell *cell = (HRMyApplyCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRMyApplyCell" owner:nil options:nil] firstObject];
    }
    if (self.ma_array.count>0) {
        HRApplyObj *obj = self.ma_array[indexPath.row];
        cell.nameLabel.text = obj.name;
        cell.timeLabel.text = obj.create_time;
        if (obj.create_time) {
            cell.timeLabel.text = [obj.create_time substringToIndex:16];
        }

        cell.rejectedLabel.text = obj.result;
        
        if (self.typeInt == 10) {//@"待审核",
            cell.typeLabel.text = @"待审核";
        }else if(self.typeInt == 11){//@"待办理"
            cell.typeLabel.text = @"待办理";
        }else if(self.typeInt == 12){//,@"待领取",
            if (![obj.print_code isEqualToString:@""]) {
                cell.printCodeLabel.text = [NSString stringWithFormat:@"文档打印码: %@",obj.print_code];
                cell.printCodeLabel.hidden = NO;
            }
            cell.operationButton.hidden = NO;
            
            cell.typeLabel.text = @"待领取";
            
            __weak typeof(self)weakSelf = self;
            cell.applyBlock = ^{
                [weakSelf gain:obj.id];
            };
        }else if(self.typeInt == 13){//@"待评价"
            cell.operationButton.hidden = NO;
            cell.operationButton.backgroundColor = RGBCOLOR(26, 155, 252);
            [cell.operationButton setTitle:@"去评价" forState:UIControlStateNormal];
            cell.typeLabel.text = @"待评价";
            if (![obj.print_code isEqualToString:@""]) {
                cell.printCodeLabel.text = [NSString stringWithFormat:@"文档打印码: %@",obj.print_code];
                cell.printCodeLabel.hidden = NO;
            }
            __weak typeof(self)weakSelf = self;
            
            cell.applyBlock = ^{
                HREvaluationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HREvaluation"];
                vc.aid = [obj id];
                vc.work_order = obj.work_order;
                vc.name = obj.name;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                
                vc.successBlock = ^{
                    [weakSelf backAction];
                    [weakSelf.ma_array removeAllObjects];
                    [weakSelf GetApplys:weakSelf.status];//刷新当前页面
                };
                
            };
        }else if(self.typeInt == 14){//,@"已完成"
            cell.typeLabel.text = @"已完成";
            if (![obj.print_code isEqualToString:@""]) {
                cell.printCodeLabel.text = [NSString stringWithFormat:@"文档打印码: %@",obj.print_code];
                cell.printCodeLabel.hidden = NO;
            }
            cell.operationButton.hidden = YES;
            
        }else{//,@"驳回"
            cell.typeLabel.textColor = RGBCOLOR(252, 9, 52);
            cell.typeLabel.text = @"驳回";
            cell.rejectedLabel.hidden = NO;
            cell.typeInt = self.typeInt;
            __weak typeof(self)weakSelf = self;
            
            cell.alertBlock = ^(NSInteger tag) {
                switch (tag) {
                    case 1://删除
                    {
                        [Net DeleteBusines:[Utils readUser].token Aid:[obj id] CallBack:^(BOOL isSucc, NSDictionary *info) {
                            if (isSucc) {
                                [weakSelf.ma_array removeAllObjects];
                                [weakSelf GetApplys:weakSelf.status];//刷新当前页面
                            }
                        } FailBack:^(NSError *error) {
                            
                        }];
                    }
                        break;
                    case 2://重新提交
                        [weakSelf joinVC:obj];
                        break;
                    default:
                        break;
                }
            };
        }
        
    }
       cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.typeInt == 15) {
        return 112;
    }else{
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.typeInt == 15){
//        HRMyApplyCell *cell = [self.ma_table cellForRowAtIndexPath:indexPath];
//        cell.a_view.hidden = NO;

    }else{
        
        if (self.ma_array.count > 0) {
            HRApplyDetailVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRApplyDetail"];
            vc.aid = [(HRApplyObj *)self.ma_array[indexPath.row] id];
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }
}
//重新填写模板跳转
-(void)joinVC:(HRApplyObj *)obj{
    switch (obj.cid1) {
        case 1:
        case 2:
        case 3:{//证明办理模板
            HRDealThatDeatilVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRDealThatDeatil"];
            vc.aid = [obj id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:{//档案借阅
            HRArchivesLibraryVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRArchivesLibrary"];
            vc.aid = [obj id];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5://户口办理
        case 6:{//居住证办理
            HRPublicDealtVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRPublicDealt"];
            vc.aid = [obj id];
            if (obj.cid1 == 6) {
                vc.hkName = @"居住证办理";
            }else{
                vc.cid2 = obj.cid2;
                vc.hkName = obj.name;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:{
            HREmployeeModelVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HREmployeeModel"];
            vc.aid = [obj id];
            vc.cid = 7;
            vc.cid2 = obj.cid2;
            vc.ndStr = obj.name;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}

//类型切换
-(void)btnClick:(UIButton *)sender{
    self.typeInt = sender.tag;
    for (int i=0; i < _typeArr.count; i++) {
        UIButton *btn = (UIButton *)[self.titleTyView viewWithTag:10+i];
        if (sender.tag - 10 == i) {
            [btn setTitleColor:RGBCOLOR16(0x1790D2) forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        }
    }
  
    CGRect frame = self.downxian.frame;
    frame.origin.x = self.view.width/_typeArr.count * (sender.tag - 10);
    self.downxian.frame = frame;
    
    //切换类型
    [self.ma_array removeAllObjects];
    self.page = 1;
    self.status = [[NSString stringWithFormat:@"%ld",sender.tag - 10] intValue];
    [self GetApplys:self.status];
}

#pragma mark --懒加载
-(NSMutableArray *)ma_array{
    if (!_ma_array) {
        _ma_array = [NSMutableArray array];
    }
    return _ma_array;
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
