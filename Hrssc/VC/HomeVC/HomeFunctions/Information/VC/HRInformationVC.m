
//
//  HRInformationVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/4.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRInformationVC.h"
#import "HRInformationCell.h"
#import "HRInformationDetailVC.h"

#import "HRHomeInfoVO.h"

@interface HRInformationVC ()
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titconst;
@property (weak, nonatomic) IBOutlet UITableView *inf_table;
@property (nonatomic, strong) NSArray *arrlist;//分类数组
@property (nonatomic, strong) NSMutableArray *newsArr;//消息列表数组
@property (nonatomic) int page;//翻页page
@property (nonatomic) int cid;//分类id

@end

@implementation HRInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    //默认值
    self.page = 1;
    [Utils setupRefresh:self.inf_table WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];
    
    //分类接口数据
    [Net NewsClass:[Utils readUser].token CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.arrlist = info[@"data"][@"newsClass"];
            if(self.arrlist.count > 0){
                self.cid = [self.arrlist[0][@"id"] intValue];
                [self newsClassList:self.cid];
            }
            
            for (int i = 0; i < self.arrlist.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(55 * i, 0, 55, self.titleView.height);
                [button setTitle:self.arrlist[i][@"name"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                button.tag = 10 + i;
                [button addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
                if (i == 0) {
                    [button setTitleColor:RGBCOLOR(0, 150, 213) forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
                }
                [self.titleView addSubview:button];
            }
        }
    } FailBack:^(NSError *error) {
        
    }];

 
}

#pragma mark -- 数据请求
//刷新
-(void)headerRefresh{
    self.page = 1;
    [self.newsArr removeAllObjects];
    [self newsClassList:self.cid];
}
//加载更多
-(void)footerRefresh{
    self.page += 1;
    [self newsClassList:self.cid];
}

//根据分类id获取资讯列表
-(void)newsClassList:(int)cid{
    [Net NewsClassList:[Utils readUser].token Cid:cid City:[Utils getCity] Page:self.page Rows:10 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            [self.newsArr addObjectsFromArray:[HRNewsVO objectArrayWithKeyValuesArray:info[@"data"][@"news"]]];
            [self.inf_table reloadData];
        }
        [self.inf_table.mj_footer endRefreshing];
        [self.inf_table.mj_header endRefreshing];
    } FailBack:^(NSError *error) {
        [self.inf_table.mj_footer endRefreshing];
        [self.inf_table.mj_header endRefreshing];
    }];
    
}
-(void)btnclick:(UIButton *)sender{
    for (int i=0; i < self.arrlist.count; i++) {
        UIButton *btn = (UIButton *)[self.titleView viewWithTag:10+i];
        if (sender.tag - 10 == i) {
            [btn setTitleColor:RGBCOLOR(0, 150, 213) forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        }
    }
    self.page = 1;
    self.cid = [self.arrlist[sender.tag - 10][@"id"] intValue];
    [self.newsArr removeAllObjects];
    [self newsClassList:self.cid];
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    HRInformationCell *cell = (HRInformationCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRInformationCell" owner:nil options:nil] firstObject];
    }
    if (indexPath.row == 0) {
        cell.xian.hidden = NO;
    }
    HRNewsVO *obj = self.newsArr[indexPath.row];
    cell.tltLabel.text = obj.title;
    cell.timeLabel.text = obj.create_time;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRInformationDetailVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRInformationDetail"];
    vc.nid = [[self.newsArr[indexPath.row] id] intValue];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --l懒加载
-(NSMutableArray *)newsArr{
    if (!_newsArr) {
        _newsArr = [NSMutableArray array];
    }
    return _newsArr;
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
