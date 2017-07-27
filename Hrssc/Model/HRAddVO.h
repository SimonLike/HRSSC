//
//  HRAddVO.h
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRAddVO : NSObject
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* uid;
@property (nonatomic, strong) NSString* is_default;
@property (nonatomic, strong) NSString* area;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* prov;
@property (nonatomic, strong) NSString* addr;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* create_time;
@end
//name":"小张",    //收货人姓名
//"id":8,           //地址id
//"uid":1000,       //工号
//"is_default":1,   //1-默认收货地址   0-非默认
//"area":"南山区",  //县/区
//"city":"深圳市",  //市
//"prov":"广东省",  //省
//"addr":"深大科兴", //详细地址
//"delete":0,        //忽略
//"phone":"13397100222", //手机号码
//"create_time":"2017-03-10 20:36:15" //创建时间
