//
//  HRSocialHistoryDetailsVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSocialHistoryDetailsVC.h"
#import "HRSocialPaymentCell.h"
#import "HRSocialSecurityObj.h"

@interface HRSocialHistoryDetailsVC ()
@property (weak, nonatomic) IBOutlet UITableView *shd_table;
@property (nonatomic, strong) NSArray *shDetailArr;
@property (nonatomic,strong)IndividualUnitObj *unitObj;
@property (nonatomic,strong)SocialSecurityObj *securityObj;
@property (weak, nonatomic) IBOutlet UILabel *hj_label;

@end

@implementation HRSocialHistoryDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [Net SocialSecurityByDate:[Utils readUser].token QryDate:self.qryDate CallBack:^(BOOL isSucc, NSDictionary *info) {
        if (isSucc) {
            self.securityObj = [SocialSecurityObj objectWithKeyValues:info[@"data"]];
            self.unitObj= [IndividualUnitObj objectWithKeyValues:info[@"data"][@"socialSecurity"]];
            //数据拼接处理
            NSArray *yl_array = [self.unitObj.yanglao componentsSeparatedByString:@","];
            NSArray *yil_array = [self.unitObj.yiliao componentsSeparatedByString:@","];
            NSArray *gs_array = [self.unitObj.gongshang componentsSeparatedByString:@","];
            NSArray *sy_array = [self.unitObj.shiye componentsSeparatedByString:@","];
            NSArray *sg_array = [self.unitObj.shengyu componentsSeparatedByString:@","];
            NSString *compantTotal = [NSString stringWithFormat:@"%.2f",self.securityObj.compantTotal];
            NSString *personalTotal = [NSString stringWithFormat:@"%.2f",self.securityObj.personalTotal];
            self.hj_label.text = [NSString stringWithFormat:@"合计金额：%.2f元",self.securityObj.compantTotal + self.securityObj.personalTotal];
            self.shDetailArr = [NSMutableArray arrayWithObjects:
                                [NSMutableArray arrayWithObjects:
                                 @[@"缴纳项目",@"缴纳地",@"缴纳年月",@"缴纳基数",@"缴纳金额"],
                                 @[@"养老保险",self.unitObj.city,self.unitObj.paytime,yl_array[0],yl_array[1]],
                                 @[@"医疗保险",self.unitObj.city,self.unitObj.paytime,yil_array[0],yil_array[1]],
                                 @[@"工伤保险",self.unitObj.city,self.unitObj.paytime,gs_array[0],gs_array[1]],
                                 @[@"失业保险",self.unitObj.city,self.unitObj.paytime,sy_array[0],sy_array[1]],
                                 @[@"生育保险",self.unitObj.city,self.unitObj.paytime,sg_array[0],sg_array[1]],
                                 @[@"缴纳合计",@"",@"",@"",compantTotal],
                                 nil],
                                [NSMutableArray arrayWithObjects:
                                 @[@"缴纳项目",@"缴纳地",@"缴纳年月",@"缴纳基数",@"缴纳金额"],
                                 @[@"养老保险",self.unitObj.city,self.unitObj.paytime,yl_array[2],yl_array[3]],
                                 @[@"医疗保险",self.unitObj.city,self.unitObj.paytime,yil_array[2],yil_array[3]],
                                 @[@"工伤保险",self.unitObj.city,self.unitObj.paytime,gs_array[2],gs_array[3]],
                                 @[@"失业保险",self.unitObj.city,self.unitObj.paytime,sy_array[2],sy_array[3]],
                                 @[@"生育保险",self.unitObj.city,self.unitObj.paytime,sg_array[2],sg_array[3]],
                                 @[@"缴纳合计",@"",@"",@"",personalTotal],
                                 nil],
                                nil];
            
            [self.shd_table reloadData];
        }
    } FailBack:^(NSError *error) {
        
    }];
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shDetailArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *ar = self.shDetailArr[section];
    return [ar count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 36)];
    header.backgroundColor = RGBCOLOR16(0xf1f1f1);
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, header.width-20, header.height-10)];
    lab.textColor = RGBCOLOR16(0x333333);
    lab.font = [UIFont systemFontOfSize:13];
    if (section == 0) {
        lab.text = @"单位缴纳";
    }else{
        lab.text = @"个人缴纳";
    }
    [header addSubview:lab];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    
    HRSocialPaymentCell *cell = (HRSocialPaymentCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRSocialPaymentCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *sc_array = self.shDetailArr[indexPath.section];
    NSArray *array = sc_array[indexPath.row];

    if (indexPath.row == 0 || indexPath.row == array.count + 1) {
        cell.contentView.backgroundColor = RGBCOLOR(119, 195, 233);
        cell.label1.textColor = RGBCOLOR16(0xffffff);
        cell.label2.textColor = RGBCOLOR16(0xffffff);
        cell.label3.textColor = RGBCOLOR16(0xffffff);
        cell.label4.textColor = RGBCOLOR16(0xffffff);
        cell.label5.textColor = RGBCOLOR16(0xffffff);
      
    }else{
        cell.backgroundColor = RGBCOLOR16(0xEAF8FE);
    }
    
    cell.label1.text = array[0];
    cell.label2.text = array[1];
    cell.label3.text = array[2];
    cell.label4.text = array[3];
    cell.label5.text = array[4];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
   return 42;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
