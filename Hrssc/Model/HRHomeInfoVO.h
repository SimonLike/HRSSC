//
//  HRHomeInfoVO.h
//  Hrssc
//
//  Created by admin on 17/4/24.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRNewsVO : NSObject
@property (nonatomic, strong) NSString* id;//资讯id
@property (nonatomic, strong) NSString* content;//资讯内容，已处理为空
@property (nonatomic, strong) NSString* count;//阅读次数
@property (nonatomic, strong) NSString* status;//状态  无效字段
@property (nonatomic, strong) NSString* city;//城市   已处理为空
@property (nonatomic, strong) NSString* aid;//发布人员id
@property (nonatomic, strong) NSString* title;//内容
@property (nonatomic, strong) NSString* cid;//资讯分类id
@property (nonatomic, strong) NSString* create_time;//创建时

@end

@interface HRBannerVO : NSObject
@property (nonatomic, strong) NSString* id;//banner   id
@property (nonatomic, strong) NSString* name;//banner名称
@property (nonatomic, strong) NSString* link;//跳转链接   为空或者null不跳转
@property (nonatomic, strong) NSString* status;//状态   前端忽略，后端处理
@property (nonatomic, strong) NSString* order;//排序字段   后端处理  前端忽略
@property (nonatomic, strong) NSString* image;//图片链接  相对路径  域名待确定
@property (nonatomic, strong) NSString* create_time;//创建时间
@end

@interface HRHomeInfoVO : NSObject
@property (nonatomic, strong) NSString* myTransaction;//待我办理
@property (nonatomic, strong) NSString* myMessage;//我的未读消息数量
@property (nonatomic, strong) NSString* myApply;//待我申请
@property (nonatomic, strong) NSMutableArray* news;
@property (nonatomic, strong) NSMutableArray* banners;
@end
