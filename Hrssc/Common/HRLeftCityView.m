
//
//  HRLeftCityView.m
//  Hrssc
//
//  Created by Simon on 2017/5/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRLeftCityView.h"

@implementation HRLeftCityView

+(instancetype) initLeftCityView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRLeftCityView" owner:nil options:nil];
    return [objs firstObject];
}

- (IBAction)c_click:(id)sender {
    if (self.leftBlock) {
        self.leftBlock();
    }
}


@end
