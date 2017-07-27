//
//  OrderListVO.h
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderListVO : NSObject
@property (nonatomic, strong) NSString* id;//订单id
@property (nonatomic, strong) NSString* img_url;//商品图片
@property (nonatomic, strong) NSString* count;//购买数量
@property (nonatomic, strong) NSString* status;//0-待发货  1-已发货  2已收货  3-退款中 4-已退款
@property (nonatomic, strong) NSString* create_time;//下单时间
@property (nonatomic, strong) NSString* pname;//商品名称
@property (nonatomic, strong) NSString* pid;//商品id
@property (nonatomic, strong) NSString* points;//所使用的积分
@end
