//
//  OrderDetialVO.h
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetialVO : NSObject
@property (nonatomic, strong) NSString* address;//收货地址
@property (nonatomic, strong) NSString* id;//订单id
@property (nonatomic, strong) NSString* count;//购买数量
@property (nonatomic, strong) NSString* logistics_no;//物流单号
@property (nonatomic, strong) NSString* deliver_time;//发货时间
@property (nonatomic, strong) NSString* deliver_user;//发货人员姓名
@property (nonatomic, strong) NSString* status;//0-待发货  1-已发货 2-已收货  3-退款中  4-已退款
@property (nonatomic, strong) NSString* create_time;//下单时间
@property (nonatomic, strong) NSString* order_no;//订单号
@property (nonatomic, strong) NSString* pname;//商品名称
@property (nonatomic, strong) NSString* pimage;//商品头图
@property (nonatomic, strong) NSString* points;//所用积分数量
@property (nonatomic, strong) NSString* receiver;//收货人姓名
@property (nonatomic, strong) NSString* contact;//收货人电话
@property (nonatomic, strong) NSString* lid;//物流id
@property (nonatomic, strong) NSString* logistics;//物流名称
@property (nonatomic, strong) NSString* uid;//用户id
@property (nonatomic, strong) NSString* pid;//商品id
@end
