//
//  HRContractObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/5.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRContractObj : NSObject
/*"id":43,             //合同id
 "status":3,
 "city":"北京市",
 "brief":"哈哈",
 "tpl_cid":100018,
 "tpl_name":"北京地区开发人员劳动合同（中文）",
 "tpl_form":"",
 "sender":"",
 "sign_way":2,
 "print_code":"1493104018912"    //新增打印码字段
 "sign_time":"2017-04-21 19:15:04",
 "work_order":"0330c8ac7bd24a",
 "tpl_document":"/uploadFiles/contract/20170420/181504/北京地区管理人员劳动合同（中文）-小明.doc",
 "finish_time":"2017-04-22 18:15:04",
 “address”:“面签地址”   //当面签署地址
 "uid":1,
 "create_time":"2017-04-20 18:15:04"*/

@property (nonatomic, copy) NSString* id;//合同id
@property (nonatomic, copy) NSString* status;//状态0-待签署  1-待盖章  2-已撤销  3-已完成
@property (nonatomic, copy) NSString* city;//城市
@property (nonatomic, copy) NSString* brief;//备注 （已处理为空，前端忽略）
@property (nonatomic, copy) NSString* tpl_cid;//模板id(前端忽略)
@property (nonatomic, copy) NSString* tpl_name;//业务名称
@property (nonatomic, copy) NSString* tpl_form;//前端忽略
@property (nonatomic, copy) NSString* sender;//前端忽略
@property (nonatomic, copy) NSString* sign_way;//签署方式  0电子签署1当面签署2邮寄签署
@property (nonatomic, copy) NSString* sign_time;//签署时间 （待盖章中显示）
@property (nonatomic, copy) NSString* create_time;//创建时间（待签署中显示）
@property (nonatomic, copy) NSString* work_order;//工单号
@property (nonatomic, copy) NSString* tpl_document;//合同保存路径
@property (nonatomic, copy) NSString* finish_time;//完成时间（已完成中显示）
@property (nonatomic, copy) NSString* uid;//用户id
@property (nonatomic, copy) NSString* print_code;
@property (nonatomic, copy) NSString* address;//
@end
