//
//  HRBackAlertView.m
//  Hrssc
//
//  Created by Simon on 2017/5/11.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRBackAlertView.h"

@implementation HRBackAlertView

+(instancetype) initBackAlertView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRBackAlertView" owner:nil options:nil];
    return [objs firstObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.bbcBtn.layer.borderWidth = 1;
    self.bbcBtn.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
    self.bcBtn.layer.borderWidth = 1;
    self.bcBtn.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
}
- (IBAction)bc_click:(UIButton *)sender {
    if (self.backBlock) {
        self.backBlock(sender.tag);
    }
    [self removeFromSuperview];
}
@end
