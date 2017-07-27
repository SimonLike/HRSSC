//
//  HRSPHerderCell.m
//  Hrssc
//
//  Created by Simon on 2017/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSPHerderCell.h"

@implementation HRSPHerderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.unitBtn.layer.borderWidth=1;
    self.personalBtn.layer.borderWidth=1;
 
    
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (self.tag==11) {
        self.personalBtn.layer.borderColor = RGBCOLOR16(0x1790D2).CGColor;
        self.unitBtn.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
    }else{
   
        self.unitBtn.layer.borderColor = RGBCOLOR16(0x1790D2).CGColor;
        self.personalBtn.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
    }
//    CGRect frame = self.roundView.frame;
//    frame.size.width = self.roundView.width;
//    self.roundView.frame = frame;
//    self.roundView.layer.masksToBounds = YES;
//    self.roundView.layer.cornerRadius = self.roundView.width/2;
    
    DLog(@"roundView-->%f",self.roundView.width/2);
}
- (IBAction)sp_click:(UIButton *)sender {
//    for (int i=0; i < 2; i++) {
//        UIButton *btn = (UIButton *)[self.btnView viewWithTag:10+i];
//        if (sender.tag - 10 == i) {
//            btn.layer.borderColor = RGBCOLOR16(0x1790D2).CGColor;
//        }else{
//            btn.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
//        }
//    }
    if (self.block) {
        self.block(sender.tag);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
