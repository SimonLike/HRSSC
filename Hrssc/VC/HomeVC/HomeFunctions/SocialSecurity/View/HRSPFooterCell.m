
//
//  HRSPFooterCell.m
//  Hrssc
//
//  Created by Simon on 2017/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSPFooterCell.h"

@implementation HRSPFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)ft_click:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
