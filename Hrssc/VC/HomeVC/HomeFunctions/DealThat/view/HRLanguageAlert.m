
//
//  HRLanguageAlert.m
//  Hrssc
//
//  Created by Simon on 2017/5/9.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRLanguageAlert.h"

@implementation HRLanguageAlert

+(instancetype) initLanguageAlert{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRLanguageAlert" owner:nil options:nil];
    return [objs firstObject];
}
- (IBAction)la_click:(UIButton *)sender {
    if (self.languageBlock) {
        self.languageBlock(sender.titleLabel.text,sender.tag-10);
    }
    [self removeFromSuperview];

}

@end
