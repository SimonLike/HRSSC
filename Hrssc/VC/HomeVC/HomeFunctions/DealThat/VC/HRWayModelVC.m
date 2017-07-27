//
//  HRWayModelVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRWayModelVC.h"
#import "HRWayModelCell.h"
#import "HRWebViewVC.h"
#import "HRReceiveAddressVC.h"
#import "HRMailingAddressVC.h"
#import "HRBankTemplateVC.h"
#import "TemplatesObj.h"

@interface HRWayModelVC ()
@property (weak, nonatomic) IBOutlet UITableView *wm_table;
@property (nonatomic, strong)NSMutableArray *wayModelArray;
@end

@implementation HRWayModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.wayModelArray removeAllObjects];
    if ([self.fromVC isEqualToString: @"way"]) {
        [self.wayModelArray addObject:@{@"sing_id":@"2",@"name":@"自助打印"}];
        [self.wayModelArray addObject:@{@"sing_id":@"0",@"name":@"自助领取"}];
        [self.wayModelArray addObject:@{@"sing_id":@"1",@"name":@"邮寄"}];
    }else if ([self.fromVC isEqualToString: @"model"]){
        [self.wayModelArray addObjectsFromArray:self.templateArr];
    }
    [self.wm_table reloadData];
}

//-(void)setFromVC:(NSString *)fromVC{
//   
//}
#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.wayModelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    HRWayModelCell *cell = (HRWayModelCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRWayModelCell" owner:nil options:nil] firstObject];
    }
    if ([self.fromVC isEqualToString: @"way"]) {
        cell.textLabel.text = [self.wayModelArray[indexPath.row] objectForKey:@"name"];
    }else if ([self.fromVC isEqualToString: @"model"]){
        TemplatesObj *obj = self.wayModelArray[indexPath.row];
        cell.textLabel.text = obj.name;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if ([self.fromVC isEqualToString: @"way"]) {//打印方式
        NSDictionary *dict = self.wayModelArray[indexPath.row];
        if (self.wmBlock) {
            self.wmBlock([[dict objectForKey:@"sing_id"] intValue], [dict objectForKey:@"name"]);
        }
        if (indexPath.row == 0) {//自助打印
            [self backAction];
        }else if (indexPath.row == 1) {//自助领取
            HRReceiveAddressVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRReceiveAddress"];
            vc.addresArr = self.addresArr;
            
            vc.receiveBlock = ^(AddressObj *obj) {
                if (self.objBlock) {
                    self.objBlock(obj);
                }
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 2) {//邮寄
           HRMailingAddressVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRMailingAddress"];
            vc.mailingBlock = ^(HRAddVO *rAddObj) {
                if (self.addBlock) {
                    self.addBlock(rAddObj);
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if ([self.fromVC isEqualToString: @"model"]){//选取模板
        
        if (self.templateBlock) {
            self.templateBlock(self.wayModelArray[indexPath.row]);
        }
        HRWebViewVC *vc = [HRWebViewVC new];
        vc.templatesObj = self.wayModelArray[indexPath.row];
        
        vc.tpBlock = ^(NSString *tpl_form) {
            if (self.wtpBlock) {
                self.wtpBlock(tpl_form);
            }
        };
        [self.navigationController pushViewController:vc animated:YES];

    }
    
}


#pragma mark --懒加载

-(NSMutableArray *)wayModelArray{
    if (!_wayModelArray) {
        _wayModelArray = [NSMutableArray array];
    }
    return _wayModelArray;
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
