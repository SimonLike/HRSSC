//
//  NSDictionary+BGFormattedToString.m
//  BeautyCircle
//
//  Created by 冉彬 on 16/6/14.
//  Copyright © 2016年 成都伟航创达科技有限公司. All rights reserved.
//

#import "NSDictionary+BGFormattedToString.h"

@implementation NSDictionary (BGFormattedToString)

- (NSString *)safeObjectForKey:(id)key
{
    id safeObject = [self objectForKey:key];
    if (safeObject == [NSNull null] || !safeObject) {
        safeObject = @"";
    } else {
        safeObject = [NSString stringWithFormat:@"%@", safeObject];
    }
    return safeObject;
}

@end
