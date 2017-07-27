//
//  HRDealVO.h
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>
//待我办理对象
@interface HRDealVO : NSObject
@property (nonatomic, strong) NSString* id;//合同id
@property (nonatomic, strong) NSString* status;//状态0-待签署  1-待盖章  2-已撤销  3-已完成
@property (nonatomic, strong) NSString* city;//城市
@property (nonatomic, strong) NSString* brief;//备注 （已处理为空，前端忽略）
@property (nonatomic, strong) NSString* tpl_cid;//模板id(前端忽略)
@property (nonatomic, strong) NSString* tpl_name;//业务名称
@property (nonatomic, strong) NSString* tpl_form;//前端忽略
@property (nonatomic, strong) NSString* sender;//前端忽略
@property (nonatomic, strong) NSString* sign_way;//签署方式  0电子签署1当面签署2邮寄签署
@property (nonatomic, strong) NSString* sign_time;//签署时间 （待盖章中显示）
@property (nonatomic, strong) NSString* create_time;//创建时间（待签署中显示）
@property (nonatomic, strong) NSString* work_order;//工单号
@property (nonatomic, strong) NSString* tpl_document;//合同保存路径
@property (nonatomic, strong) NSString* finish_time;//完成时间（已完成中显示）
@property (nonatomic, strong) NSString* uid;//用户id
@end