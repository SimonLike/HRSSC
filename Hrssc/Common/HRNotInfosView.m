
//
//  HRNotInfosView.m
//  Hrssc
//
//  Created by Simon on 2017/5/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRNotInfosView.h"

@implementation HRNotInfosView

+(instancetype) initNotInfosView{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRNotInfosView" owner:nil options:nil];
    return [objs firstObject];
}
@end
