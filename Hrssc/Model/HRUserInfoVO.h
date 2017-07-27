//
//  HRUserInfoVO.h
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRUserInfoVO : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* account;
@property (nonatomic, strong) NSString* uin;
@property (nonatomic, strong) NSString* position;
@property (nonatomic, strong) NSString* hiredate;
@property (nonatomic, strong) NSString* birthday;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* sex;
@property (nonatomic, strong) NSString* minority;
@property (nonatomic, strong) NSString* recruit_from;
@property (nonatomic, strong) NSString* department;
@property (nonatomic, strong) NSString* id_card;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* probation;
@property (nonatomic, strong) NSString* graduation;
@property (nonatomic, strong) NSString* amount;
@property (nonatomic, strong) NSString* channel;
@property (nonatomic, strong) NSString* level;
@property (nonatomic, strong) NSString* leader;
@property (nonatomic, strong) NSString* head;
@property (nonatomic, strong) NSString* school;
@property (nonatomic, strong) NSString* major;
@property (nonatomic, strong) NSString* signature;
@property (nonatomic, strong) NSString* marry;
@property (nonatomic, strong) NSString* positive_time;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* emergency_name;
@property (nonatomic, strong) NSString* emergency_relation;
@property (nonatomic, strong) NSString* emergency_phone;
@property (nonatomic, strong) NSString* diploma;
@property (nonatomic, strong) NSString* bank_name;
@property (nonatomic, strong) NSString* bank_number;
@property (nonatomic, strong) NSString* social_number;
@property (nonatomic, strong) NSString* fund_number;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* work_prov;
@property (nonatomic, strong) NSString* work_city;
@property (nonatomic, strong) NSString* hukou_prov;
@property (nonatomic, strong) NSString* hukou_city;
@end
//"name":"小明",    //姓名
//"id":1,        //id
//“account”:xaioming，//账号
//“uin”:123,           //工号
//"position":"开发工程师", //职位
//"hiredate":"2017-01-01", //入职时间
//"birthday":"2017-05-12", //生日
//"phone":"13397100547",   //手机
//"sex":0,                 //0-男  1-女
//"minority":"汉族",        //民族
//"recruit_from":"社会招聘", //招聘来源
//"department":"研发部",
//"id_card":"420625XXXXXXXX0000",//身份证
//"type":"职员",           //员工类型
//"probation":3,           //试用期  单位月
//"graduation":"1900-01-01", //毕业时间
//"amount":100,            //积分余额
//"channel":"T",            //员工通道   通道和职级一起显示 T2
//"level":2,               //员工职级
//"leader":"",          //领导
//"head":"http://qiniu.ccvrzb.com//Desert.jpg",   //头像
//"school":"华中科技大学",
//"major":"自动化", //专业
//"signature":"http://qiniu.ccvrzb.com//Desert.jpg", //签名图片路径
//"marry":0,                             //0-未婚  1-已婚  2 -离异
//"positive_time":"2017-05-05",  //转正时间
//"status":0,                     //0-使用 1-正式  2-离职
//"emergency_name":"大宝哥",      //紧急联系人
//"emergency_relation":"朋友",    //紧急联系人 关系
//"emergency_phone":"13397100000", //紧急联系人电话
//"diploma":"本科",                  //学历
//"bank_name":"中国银行深圳支行",    //开户支行
//"bank_number":"123456789",         //银行卡号
//"social_number":"123456",           //社保电脑号
//"fund_number":"123456789",         //公积金账户
//"email":"wang13397100547@126.com", //
//"work_prov":"广东省",            //工作所在省
//"work_city":"深圳市",            //工作所在市
//"hukou_prov":"湖北省",           //户口所在省
//"hukou_city":"襄阳市"            //户口所在市
