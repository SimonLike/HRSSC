//
//  HRCategory2ListObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/6.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRCategory2ListObj : NSObject
/*"name":"薪资证明办理",//二级业务名称
 "id":29,              //二级业务id
 "comment":null,    //二级业务描述
 "link":null,      //二级业务帮助描述
 "status":0,      //0-正常  1-隐藏
 "create_time":"2017-03-11 16:22:06.0",
 "city":"深圳市", //业务所属城市
 "can_agent":1,  //是否允许代办  0-不允许   1-允许
 "cid":1,        //一级业务的id
 "pageid":1},    //关联提交页id
 
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic) int id;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *can_agent;
@property (nonatomic) int cid;
@property (nonatomic) int pageid;
@end
