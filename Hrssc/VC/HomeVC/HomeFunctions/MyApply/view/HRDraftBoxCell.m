
//
//  HRDraftBoxCell.m
//  Hrssc
//
//  Created by Simon on 2017/5/20.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRDraftBoxCell.h"

@implementation HRDraftBoxCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectImage.image = [UIImage imageNamed:@"icon_gouxuan"];
    }else{
        self.selectImage.image = [UIImage imageNamed:@"icon_wxz"];
    }
    // Configure the view for the selected state
}
@end
