//
//  HRScoreProductVO.h
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRScoreProductVO : NSObject
@property (nonatomic, strong) NSString* id;//商品id
@property (nonatomic, strong) NSString* name;//商品名称
@property (nonatomic, strong) NSString* price;//价格
@property (nonatomic, strong) NSString* worth;//价值
@property (nonatomic, strong) NSString* lefts;//剩余数量
@property (nonatomic, strong) NSString* brief;//"商品简介"
@property (nonatomic, strong) NSString* description;//商品详情。图文
@property (nonatomic, strong) NSString* create_time;//发布时间
@property (nonatomic, strong) NSString* status;//  0-上架  1-下架
@property (nonatomic, strong) NSString* img_url;//商品图片
@end
