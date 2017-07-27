//
//  HRSuccessfulVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/10.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSuccessfulVC.h"

@interface HRSuccessfulVC ()

@end

@implementation HRSuccessfulVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navBtnleft setImage:[UIImage imageNamed:@"icon_cha"] forState:UIControlStateNormal];

}
-(void)backAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
