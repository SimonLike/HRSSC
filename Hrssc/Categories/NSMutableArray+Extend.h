//
//  NSMutableArray+Extend.h
//  ZJBDMIOS
//
//  Created by 转角街坊 on 16/7/18.
//  Copyright © 2016年 转角街坊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Extend)
/**
 安全判断
 */
- (void)addNil:(id)anObject;

- (void)addNilNullObject:(id)anObject;

@end
