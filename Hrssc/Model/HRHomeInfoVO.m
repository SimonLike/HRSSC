//
//  HRHomeInfoVO.m
//  Hrssc
//
//  Created by admin on 17/4/24.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRHomeInfoVO.h"

@implementation HRNewsVO
@end

@implementation HRBannerVO
@end

@implementation HRHomeInfoVO
- (NSDictionary *)objectClassInArray
{
    return @{
             @"news" : [HRNewsVO class],
             @"banners" : [HRBannerVO class],
             };
}
@end
