//
//  HRMyApplyCell.m
//  Hrssc
//
//  Created by Simon on 2017/4/26.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMyApplyCell.h"

@implementation HRMyApplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.a_btndel.layer.masksToBounds = YES;
    self.a_btndel.layer.cornerRadius = 30;
    self.a_btnresubmit.layer.masksToBounds = YES;
    self.a_btnresubmit.layer.cornerRadius = 30;
    
    [self.a_btnresubmit setTitle:@"重新\n提交" forState:UIControlStateNormal];
    self.a_btnresubmit.titleLabel.lineBreakMode = 0;//换行
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

- (IBAction)ap_click:(id)sender {
    if (self.applyBlock) {
        self.applyBlock();
    }
    
}
- (IBAction)alt_clicl:(UIButton *)sender {
    if (sender.tag == 3) {
        self.a_view.hidden = YES;
    }else{
        if (self.alertBlock) {
            self.alertBlock(sender.tag);
        }
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.typeInt == 15) {
        if (selected) {
            self.a_view.hidden = NO;
        }else{
            self.a_view.hidden = YES;
        }
    }
    // Configure the view for the selected state
}

@end
