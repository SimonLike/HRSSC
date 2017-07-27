
//
//  HRMailingAddressVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMailingAddressVC.h"
#import "HRAddCell.h"
#import "HRAddSelectVC.h"

@interface HRMailingAddressVC ()<HRAddCellDelegate>
{
    HRAddVO* currentAVO;
}
@property (weak, nonatomic) IBOutlet UITableView *ma_table;

@end

@implementation HRMailingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBtnRight.hidden = NO;
    [self.navBtnRight setTitle:@"确定" forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view.
}

-(void)rightAction{
    if (self.mailingBlock) {
        self.mailingBlock(currentAVO);
    }
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    return vv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *vv = [[UIView alloc]init];
    vv.backgroundColor = [UIColor clearColor];
    return vv;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"HRAddVO";
    HRAddCell *cell = (HRAddCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [HRAddCell getInstanceWithNib];
    }
    else{
        //NSLog(@"FixMentCell");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setUI:currentAVO];
    cell.delegate = self;
    return cell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0)
    {
        [self choseAdr];
    }
}
#pragma mark --HRAddCellDelegate
- (void)seAdd
{
    [self choseAdr];
}

-(void)choseAdr{
    HRAddSelectVC* vc = [HRAddSelectVC new];
    vc.aBlock = ^(HRAddVO* vo)
    {
        currentAVO = vo;
        [self.ma_table reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
