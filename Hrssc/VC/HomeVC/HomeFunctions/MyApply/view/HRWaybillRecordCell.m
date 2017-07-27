//
//  HRWaybillRecordCell.m
//  Hrssc
//
//  Created by Simon on 2017/4/27.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRWaybillRecordCell.h"

@implementation HRWaybillRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lgView.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
    self.lgView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
