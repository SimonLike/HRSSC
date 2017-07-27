//
//  HRProDetialVO.m
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRProDetialVO.h"

@implementation HRProDetialVO
- (NSDictionary *)objectClassInArray
{
    return @{
             @"images" : [NSMutableDictionary class],
             @"product": [HRScoreProductVO class],
             };
}
@end

