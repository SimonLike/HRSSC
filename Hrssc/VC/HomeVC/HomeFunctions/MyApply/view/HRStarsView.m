//
//  HRStarsView.m
//  Hrssc
//
//  Created by Simon on 2017/5/23.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRStarsView.h"

@implementation HRStarsView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((self.height + 10) * i, 0, self.height, self.height);
        [button setBackgroundImage:[UIImage imageNamed:@"icon_hxx"] forState:UIControlStateNormal];//icon_huangxx
        button.tag = 10 + i;
        [button addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

-(void)starClick:(UIButton *)sender{
    for (int i = 0; i < 5; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:10 + i];
        if (i + 10 <= sender.tag) {//选中的
            [button setBackgroundImage:[UIImage imageNamed:@"icon_huangxx"] forState:UIControlStateNormal];//icon_huangxx
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"icon_hxx"] forState:UIControlStateNormal];//icon_huangxx
        }
    }
    
    if (self.starsBlock) {
        self.starsBlock (sender.tag - 9);
    }
}

@end
