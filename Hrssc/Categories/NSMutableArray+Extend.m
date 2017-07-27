//
//  NSMutableArray+Extend.m
//  ZJBDMIOS
//
//  Created by 转角街坊 on 16/7/18.
//  Copyright © 2016年 转角街坊. All rights reserved.
//

#import "NSMutableArray+Extend.h"

@implementation NSMutableArray (Extend)

- (void)addNil:(id)anObject{
    
    if ([NSString isBlankString:anObject]) {
        
        [self addObject:@""];
        return;
    }
    if (anObject)
    {
        [self addObject:anObject];
    }
}

- (void)addNilNullObject:(id)anObject{
    
    if ([NSString isBlankString:anObject]) {
        
        [self addObject:@""];
        return;
    }
    if ([anObject isEqualToString:@"1"]) {
        [self addObject:@"有"];
        
        return;
    }
    if ([anObject isEqualToString:@"0"]) {
    
        [self addObject:@"无"];
        return;
    }
    if (anObject)
    {
        [self addObject:[anObject stringByReplacingOccurrencesOfString:@"[:rn]" withString:@"\n"]];
    }
}

@end
