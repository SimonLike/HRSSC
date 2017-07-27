//
//  HRAboutUsVC.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAboutUsVC.h"

@interface HRAboutUsVC ()

@end

@implementation HRAboutUsVC

- (void)setUI
{
    self.title = @"关于我们";
    self.view.backgroundColor = [Utils colorWithHexString:@"F0F2F5"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
