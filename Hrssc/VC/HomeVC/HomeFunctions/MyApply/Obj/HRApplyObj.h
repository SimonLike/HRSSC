//
//  HRApplyObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/12.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRApplyObj : NSObject
/*
 "id": 62,                //申请id
"result": "",            //被驳回时的说明
"status": 6,             //状态
"name": "薪资证明办理",  //业务名称
"create_time": "2017-05-04 18:34:04", //发起时间
"print_code": "940433275172"   //打印码
“pageid”: 1 ,                     //模板id
“get_way”: 2                     //领取方式
//前端根据pageid和get_way判断是否显示打印码。  只有pageid==1 && get_way==2时显示打印码
*/
@property (nonatomic) int id;
@property (nonatomic) int cid1;
@property (nonatomic) int cid2;
@property (nonatomic, copy) NSString* result;//
@property (nonatomic) int status;
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* create_time;
@property (nonatomic, copy) NSString* print_code;
@property (nonatomic) int pageid;
@property (nonatomic) int get_way;
@property (nonatomic, copy) NSString *work_order;

@end
