//
//  HRSericeVO.h
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRSericeVO : NSObject
@property (nonatomic, strong) NSString* name;//服务名称
@property (nonatomic, strong) NSString* id;//服务id
@property (nonatomic, strong) NSString* status;//状态  0-正常  1-异常隐藏
@property (nonatomic, strong) NSString* brief;//简介
@property (nonatomic, strong) NSString* icon;//
@property (nonatomic, strong) NSString* url;//跳转路径  为空或null不跳转
@property (nonatomic, strong) NSString* create_time;//创建时间
@property (nonatomic, strong) NSString* order_number;//排序
@end
