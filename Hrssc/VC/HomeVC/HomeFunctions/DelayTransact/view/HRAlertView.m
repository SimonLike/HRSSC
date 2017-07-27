

//
//  HRAlertView.m
//  Hrssc
//
//  Created by Simon on 2017/5/5.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAlertView.h"

@implementation HRAlertView

+(instancetype) initAlertView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRAlertView" owner:nil options:nil];
    return [objs firstObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.sureBtn.layer.borderWidth = 1;
    self.sureBtn.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
}
-(void)setContHidden:(BOOL)hidden{
    self.contLabel.hidden = hidden;
    if (hidden) {
        self.conTop.constant = 50;
    }
}
- (IBAction)a_click:(UIButton *)sender {
    if (self.alertBlock) {
        self.alertBlock(sender.tag);
    }
    [self removeFromSuperview];
}

@end
