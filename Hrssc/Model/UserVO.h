//
//  UserVO.h
//  Beautiful
//
//  Created by S on 16/1/25.
//  Copyright © 2016年 B. All rights reserved.
//

#import <Foundation/Foundation.h>
//个人基本信息
@interface UserVO : NSObject
@property (nonatomic, strong) NSString* id;//用户id
@property (nonatomic, strong) NSString* account;//帐号
@property (nonatomic, strong) NSString* uin;//工号
@property (nonatomic, strong) NSString* signature;//签名图片地址
@property (nonatomic, strong) NSString* name;//姓名
@property (nonatomic, strong) NSString* head;//头像地址
@property (nonatomic, strong) NSString* status;//0-试用期  1-正式员工  2-离职员工
@property (nonatomic, strong) NSString* password;//密码-已处理
@property (nonatomic, strong) NSString* login_time;//登录时间
@property (nonatomic, strong) NSString* creat_time;//创建时间
@property (nonatomic, strong) NSString* token;//token
@property (nonatomic, strong) NSString* sex;//0-男 1-女
@property (nonatomic, strong) NSString* birthday;//生日
@property (nonatomic, strong) NSString* marry;//0-未婚，1已婚，2离异
@property (nonatomic, strong) NSString* minority;//民族
@property (nonatomic, strong) NSString* id_card;//身份证
@property (nonatomic, strong) NSString* amount;//积分余额
@property (nonatomic, strong) NSString* phone;//手机
@property (nonatomic, strong) NSString* email;//邮箱

@end
