//
//  HRAttachsView.m
//  Hrssc
//
//  Created by Simon on 2017/5/16.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAttachsView.h"
#import "BoderButton.h"

@implementation HRAttachsView

-(void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setAttachpathArr:(NSArray *)attachpathArr{
    
    self.attachArr = attachpathArr;
    float y = 10;
    for (int i = 0; i < attachpathArr.count; i++) {
        NSArray *aNl = [attachpathArr[i]  componentsSeparatedByString:@"/"];
        
        BoderButton *button = [[BoderButton alloc] init];
        button.frame = CGRectMake(0, y, self.width, 26);
        [button setImage:[UIImage imageNamed:@"icon_fujian"] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTitle:[aNl lastObject] forState:UIControlStateNormal];
        [button setTitleColor:RGBCOLOR16(0x666666) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 10 + i;
        [self addSubview:button];
        y  = y + 26 + 6;
    }
}

-(void)bClick:(UIButton *)sender{
    if (self.attachsBlock) {
        self.attachsBlock(self.attachArr[sender.tag - 10]);
    }
}
@end
