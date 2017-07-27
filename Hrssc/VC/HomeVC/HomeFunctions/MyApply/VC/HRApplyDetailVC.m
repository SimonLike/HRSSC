
//
//  HRApplyDetailVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/27.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRApplyDetailVC.h"
#import "HRContentDetailVC.h"
#import "HRWaybillRecordVC.h"
#import "HRApplyDetailObj.h"
#import "HRProgressCell.h"
#import "HRWebViewVC.h"
#import "HREvaluationVC.h"

@interface HRApplyDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *progressTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progresCont;
@property (weak, nonatomic) IBOutlet UILabel *workCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stausLabel;
@property (weak, nonatomic) IBOutlet UILabel *printCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *auditLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealLabel;
@property (weak, nonatomic) IBOutlet UIButton *stautsBtn;

@property (weak, nonatomic) IBOutlet UIView *docPrintView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *docPrintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *docPrintHeight;



@property (nonatomic ,strong) NSMutableArray *progressArr;
@property (nonatomic ,strong) ApplyDetailObj *detailObj;

@end

@implementation HRApplyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"申请详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self docPrint:YES];

    [self findApplyDetail];
}

#pragma mark --接口
-(void)findApplyDetail{
    [Net FindApplyDetail:[Utils readUser].token Aid:self.aid CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {

            self.detailObj = [ApplyDetailObj objectWithKeyValues:info[@"data"][@"apply"]];
            [self.progressArr addObjectsFromArray: [ProgressListObj objectArrayWithKeyValuesArray:info[@"data"][@"progressList"]]];
            
            self.workCodeLabel.text = [NSString stringWithFormat:@"NO.%@",self.detailObj.work_order];
            self.typeLabel.text = self.detailObj.name;
            self.timeLabel.text = self.detailObj.create_time;
            self.printCodeLabel.text = self.detailObj.print_code;
            self.auditLabel.text = self.detailObj.audit_name;
            self.dealLabel.text = self.detailObj.aid_deal;
            
            switch (self.detailObj.status) {
                case 0:
                    [self.stautsBtn setTitle:@"待审核" forState:UIControlStateNormal];
                    break;
                case 1:
                    [self.stautsBtn setTitle:@"待办理" forState:UIControlStateNormal];
                    break;
                case 2:
                    [self.stautsBtn setTitle:@"待领取" forState:UIControlStateNormal];
                    break;
                case 3:
                    [self.stautsBtn setTitle:@"待评价" forState:UIControlStateNormal];
                    break;
                case 4:
                    [self.stautsBtn setTitle:@"已完成" forState:UIControlStateNormal];
                    break;
                case 5:
                    [self.stautsBtn setTitle:@"已驳回" forState:UIControlStateNormal];
                    break;
                case 6:
                    [self.stautsBtn setTitle:@"草稿箱" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            
            //状态：0待审核，1待办理，2待领取，3待评价，4已完成,5-已驳回 ，6-草稿箱
            if (! ((self.detailObj.status == 2 || self.detailObj.status == 3 || self.detailObj.status == 4) && self.detailObj.get_way == 2)) {//自助打印
                [self docPrint:NO];
            }
            [self.progressTable reloadData];
            
        }
    } FailBack:^(NSError *error) {
        
    }];

}
//文档打印模板
-(void)docPrint:(BOOL)hide{
    if (hide) {//不显示文档打印
        self.docPrintView.hidden = YES;
        self.docPrintTop.constant = 0;
        self.docPrintHeight.constant = 0;
    }
//    else{
//        self.docPrintView.hidden = NO;
//        self.docPrintTop.constant = 10;
//        self.docPrintHeight.constant = 110;
//    }
}
#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.progressArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    HRProgressCell *cell = (HRProgressCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRProgressCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ProgressListObj *obj = self.progressArr[indexPath.row];
    cell.tleLabel.text = obj.comment;
    cell.timeLabel.text = obj.create_time;

    if ([obj.images isEqualToString:@""]) {
        cell.picView.hidden = YES;
        cell.attachTopCont.constant = 0;
        cell.picHeightCont.constant = 0;
        cell.picTopCont.constant = 0;
    }else{
        NSArray *arrPic = [obj.images componentsSeparatedByString:@";"];
        [cell pics:arrPic];
    }
    if ([obj.attachs isEqualToString:@""]) {
        cell.attachView.hidden = YES;
        cell.attachTopCont.constant = 0;
        cell.attachHeightCont.constant = 0;
    }else{
        NSArray *arrAttch = [obj.attachs componentsSeparatedByString:@";"];

        [cell attachs:arrAttch];
    }
    __weak typeof(self)weakSelf = self;
    cell.attachView.attachsBlock = ^(NSString *str) {
        DLog(@"str-->%@",str);
        HRWebViewVC *vc = [HRWebViewVC new];
        vc.typeUrl = @"attach";
        vc.attachStr = str;
        NSArray *aNl = [str  componentsSeparatedByString:@"/"];
        vc.title = [aNl lastObject];    
        
        vc.tpBlock = ^(NSString *tpl_form) {
          
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    if (indexPath.row == 0) {
        cell.rleIma.image = [UIImage imageNamed:@"icon_dian"];
        cell.rleWith.constant = 10;
        cell.rleIma.layer.cornerRadius = 5;
        cell.rleLeft.constant = 1;
    }

    [cell layoutIfNeeded];
    
    return cell;
}

//
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){//判断tableView加载完成
        //end of loading
        dispatch_async(dispatch_get_main_queue(),^{
            float th = 0;
            for (HRProgressCell *cells in self.progressTable.visibleCells) {
                th = th + cells.height;
            }
            if (self.progressTable.visibleCells.count == self.progressArr.count) {
                self.progresCont.constant = th;
            }else{
                self.progresCont.constant = th + cell.height;
            }
            [self.progressTable layoutIfNeeded];
        });
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:_progressTable cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (IBAction)hrad_click:(UIButton *)sender {
    switch (sender.tag - 10) {
        case 0:{//内容详情
            HRContentDetailVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRContentDetail"];
            vc.detailObj = self.detailObj;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:{//运单记录
            HRWaybillRecordVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRWaybillRecord"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}
- (IBAction)ad_click:(UIButton *)sender {
    if (self.detailObj.status==3) {
        HREvaluationVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HREvaluation"];
        vc.aid = self.aid;
        vc.work_order = self.detailObj.work_order;
        vc.name = self.detailObj.name;
        [self.navigationController pushViewController:vc animated:YES];
        __weak typeof(self)weakSelf = self;
        
        vc.successBlock = ^{
            [weakSelf backAction];
            [weakSelf.progressArr removeAllObjects];
            [weakSelf findApplyDetail];//刷新当前页面
        };
    }
    
}

- (NSMutableArray *)progressArr{
    if (!_progressArr) {
        _progressArr = [NSMutableArray array];
    }
    return _progressArr;
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
