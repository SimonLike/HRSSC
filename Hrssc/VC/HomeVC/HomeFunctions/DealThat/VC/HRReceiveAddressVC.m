
//
//  HRReceiveAddressVC.m
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRReceiveAddressVC.h"
#import "HRReceiveAddressCell.h"

@interface HRReceiveAddressVC ()
@property (weak, nonatomic) IBOutlet UITableView *ra_table;

@end

@implementation HRReceiveAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.addresArr.count == 0) {
        [Net SelfHelpAddress:[Utils readUser].token City:[Utils getCity] CallBack:^(BOOL isSucc, NSDictionary *info) {
            if (isSucc) {
                DLog(@"info--->%@",info);
                self.addresArr = [AddressObj objectArrayWithKeyValuesArray:info[@"data"][@"addrs"]];
                [self.ra_table reloadData];
            }
        } FailBack:^(NSError *error) {
            
        }];
    }

    // Do any additional setup after loading the view.
}

#pragma mark --delegate datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addresArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuseIdentifier";
    HRReceiveAddressCell *cell = (HRReceiveAddressCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HRReceiveAddressCell" owner:nil options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AddressObj *obj = self.addresArr[indexPath.row];
    cell.adr_label.text = obj.address;
    cell.adr_detLabel.text = obj.address_info;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.receiveBlock) {
        self.receiveBlock(self.addresArr[indexPath.row]);
    }
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
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
