
//
//  PicCollectionViewCell.m
//  Hrssc
//
//  Created by Simon on 2017/5/10.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "PicCollectionViewCell.h"

@implementation PicCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cel_click:(UIButton *)sender {
    if (self.picBlock) {
        self.picBlock(sender.tag);
    }
    
}

@end
