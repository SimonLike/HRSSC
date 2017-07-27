//
//  TemplatesObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/6.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplatesObj : NSObject
/*
 {"name":"深圳地区薪资证明模板",    //模板名称
 "id":12,                          //模板id
 "comment":"使用地区：深圳",      //使用地区
 "status":0,                      //前端忽略
 "create_time":"2017-04-30 18:00:49.0",//创建时间
 "order":5,           //排序字段，后端已经按倒序排列，排在第一的为默认 模板
 "city":"深圳市",     //模板所属城市
 "cid1":1,           //
 "cid2":1,            //模板所属二级业务
 "template":"<p align=\"center\"><font size=\"5\"><strong>工资收入   证明</strong></font></p><p>　　zx{姓名} (身份证号zx{身份证号码})系我单位员工,任职zx{职位},月收入zx{月收入}元人民币,特此证明.</p><p>　　主管单位(公章)</p><p>　　时间：zx{时间}</p><p><br></p>",
 "form":"姓名=zx{姓名};身份证号码=zx{身份证号码};职位=zx{职位};月收入=zx{月收入};时间=zx{时间}"}]
 
 ,"link":"www.baidu.com"},   //帮助连接（办理说明）
 "addrs": [  //自取地址
 {
 "address": "福田区办事处",     //地址名称
 "id": 2,                       //地址id
 "city": "深圳市",              //所属城市
 "address_info": "深圳市福田区xx路xx大厦8808室",//地址详情
 "create_time": "2017-05-02 15:30:03.0"
 }
 ]
 "msg":"操作成功"
 }
 */
@property (nonatomic, copy)NSString *name;
@property (nonatomic)int id;
@property (nonatomic, copy)NSString *comment;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *create_time;
@property (nonatomic, copy)NSString *order;
@property (nonatomic, copy)NSString *city;
@property (nonatomic)int cid1;
@property (nonatomic)int cid2;
@property (nonatomic, copy)NSString *template;
@property (nonatomic, copy)NSString *form;
@property (nonatomic, copy)NSString *link;

@end


@interface AddressObj : NSObject
@property (nonatomic, copy)NSString *address;
@property (nonatomic)int id;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *address_info;
@property (nonatomic, copy)NSString *create_time;
@end

