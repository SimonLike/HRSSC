
//
//  HRDraftBoxVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/20.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRDraftBoxVC.h"

#import "HRDraftBoxCell.h"
#import "HRApplyObj.h"
#import "HRDealThatDeatilVC.h"
#import "HRArchivesLibraryVC.h"
#import "HRPublicDealtVC.h"
#import "HREmployeeModelVC.h"
#import "HRNotInfosView.h"


@interface HRDraftBoxVC ()
@property (weak, nonatomic) IBOutlet UITableView *db_table;
@property (strong, nonatomic) NSMutableArray *db_array;
@property (nonatomic, strong) NSMutableArray *selectedArray;//选中项所用数组
@property (strong, nonatomic) UIView *delView;
@property (strong, nonatomic) UIButton *btncel;
@property (strong, nonatomic) UIButton *btnsure;
@property (strong, nonatomic) HRNotInfosView *notInfosView;
@property (nonatomic) int page;//翻页page

@end

@implementation HRDraftBoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"草稿箱";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.navBtnRight setTitle:@"删除" forState:UIControlStateNormal];
    self.navBtnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navBtnRight.hidden = NO;
    
    self.page = 1;
    [self getApplys];

    [Utils setupRefresh:self.db_table WithDelegate:self HeaderSelector:@selector(headerRefresh) FooterSelector:@selector(footerRefresh)];

}

-(void)rightAction{

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.delView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //左边返回按钮向左边框偏移位置
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = - 15.0f;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:space, rightItem, nil];
   
    self.db_table.allowsMultipleSelection = YES;
    [self.db_table reloadData];
}

-(void)boxdel:(UIButton *)sender{
    switch (sender.tag) {
        case 1://取消
        {
            UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.navBtnRight];
            self.navigationItem.rightBarButtonItem = rightItem;
            self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightItem, nil, nil];
            [self.selectedArray removeAllObjects];
            self.db_table.allowsMultipleSelection = NO;
            [self.db_table reloadData];
        }
            break;
        case 2://确认删除
        {
            
            if (self.selectedArray.count == 0) {
                [SVProgressHUD showImage:nil status:@"请选择要删除的草稿！"];
                return;
            }
            NSString *aids = @"";
            for (int i = 0; i < self.selectedArray.count; i++) {
                HRApplyObj *obj = self.selectedArray[i];

                if (i == self.selectedArray.count - 1) {
                    aids = [aids stringByAppendingString:[NSString stringWithFormat:@"%d",[obj id]]];
                }else{
                    aids = [aids stringByAppendingString:[NSString stringWithFormat:@"%d;",[obj id]]];
                }
                
            }
            
            [Net BatchDeleteBusiness:[Utils readUser].token Aids:aids CallBack:^(BOOL isSucc, NSDictionary *info) {
                if (isSucc) {
                    [self.selectedArray removeAllObjects];
                    [self.db_array removeAllObjects];
                    [self getApplys];//删除成功后 更新列表
                }
            } FailBack:^(NSError *error) {
                
            }];
            
        }
            break;
        default:
            break;
    }
}
#pragma mark -- 数据请求
//刷新
-(void)headerRefresh{
    self.page = 1;
    [self.db_array removeAllObjects];
    
    [self getApplys];
}
//加载更多
-(void)footerRefresh{
    self.page += 1;
    [self getApplys];
}
-(void)getApplys{
    [Net GetApplys:[Utils readUser].token Status:6 Search:@"" Page:self.page Rows:20 CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            [self.db_array addObjectsFromArray:[HRApplyObj objectArrayWithKeyValuesArray:info[@"data"][@"applys"]]];
            [self.db_table reloadData];
        }
        [self.db_table.mj_footer endRefreshing];
        [self.db_table.mj_header endRefreshing];
        if(self.db_array.count == 0){
            [self.view addSubview:self.notInfosView];
        }else{
            [self.notInfosView removeFromSuperview];
        }
        
    } FailBack:^(NSError *error) {
        [self.db_table.mj_footer endRefreshing];
        [self.db_table.mj_header endRefreshing];
        if(self.db_array.count == 0){
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
    return self.db_array.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"HRDraftBoxCell";
    HRDraftBoxCell *cell = (HRDraftBoxCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:reuseIdentifier owner:nil options:nil] firstObject];
    }
    cell.nameLabel.text = [(HRApplyObj *)self.db_array[indexPath.row] name];
    cell.timeLabel.text = [(HRApplyObj *)self.db_array[indexPath.row] create_time];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.db_table.allowsMultipleSelection) {
        cell.selectImage.hidden = NO;
    }else{
        cell.selectImage.hidden = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRApplyObj *obj = self.db_array[indexPath.row];

    if(self.db_table.allowsMultipleSelection){
        [self.selectedArray addObject:obj];
    }else{
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
}
//取消tableView选中 点击事件
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    HRApplyObj *curobj = self.db_array[indexPath.row];
    NSArray *array = [self.selectedArray mutableCopy];
        for (HRApplyObj *obj in array) {
            if ([obj id] == [curobj id]) {
                [self.selectedArray removeObject:obj];
            }
        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}

-(NSMutableArray *)db_array{
    if (!_db_array) {
        _db_array = [NSMutableArray array];
    }
    return _db_array;
}
-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

-(UIView *)delView{
    if (!_delView) {
        _delView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 130, SCREEN_STATUS, 130, SCREEN_NAVIGATION_HEIGHT)];
        _delView.backgroundColor = [UIColor clearColor];
    }
    [_delView addSubview:self.btncel];
    [_delView addSubview:self.btnsure];
    return _delView;
}

-(UIButton *)btncel{
    if(!_btncel){
        _btncel = [UIButton buttonWithType:UIButtonTypeCustom];
        _btncel.frame = CGRectMake(0, 0, SCREEN_NAVIGATION_HEIGHT, SCREEN_NAVIGATION_HEIGHT);
        [_btncel addTarget: self action: @selector(boxdel:) forControlEvents: UIControlEventTouchUpInside];
        _btncel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btncel setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        [_btncel setTitle:@"取消" forState:UIControlStateNormal];
        _btncel.tag = 1;
    }
    return _btncel;
}

-(UIButton *)btnsure{
    if(!_btnsure){
        _btnsure = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnsure.frame = CGRectMake(self.delView.width - 82, 0, 82, SCREEN_NAVIGATION_HEIGHT);
        [_btnsure addTarget: self action: @selector(boxdel:) forControlEvents: UIControlEventTouchUpInside];
        _btnsure.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnsure setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];
        [_btnsure setTitle:@"确认删除" forState:UIControlStateNormal];
        _btnsure.tag = 2;
    }
    return _btnsure;
}


- (HRNotInfosView *)notInfosView{
    if (!_notInfosView) {
        _notInfosView = [HRNotInfosView initNotInfosView];
        _notInfosView.frame = CGRectMake(0, 64, self.view.width, self.view.height-64);
        _notInfosView.cz_image.image = [UIImage imageNamed:@"icon_shenqing"];
        _notInfosView.cz_label1.text = @"";
        _notInfosView.cz_label2.text = @"暂无草稿";
//        _notInfosView.centerTop.constant = - 100;
    }
    return _notInfosView;
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
