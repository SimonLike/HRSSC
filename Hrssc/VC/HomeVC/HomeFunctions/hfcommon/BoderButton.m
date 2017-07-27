//
//  BoderButton.m
//  Hrssc
//
//  Created by Simon on 2017/4/27.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "BoderButton.h"

@implementation BoderButton

-(instancetype)init{
    self = [super init];
    if (self) {
        self.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
}

@end
