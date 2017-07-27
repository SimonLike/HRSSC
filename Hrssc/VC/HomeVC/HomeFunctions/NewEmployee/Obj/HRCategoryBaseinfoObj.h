//
//  HRCategoryBaseinfoObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/11.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRCategoryBaseinfoObj : NSObject
//"id":5,              //id
//"city":"深圳市",      //城市
//"cid1":2,            //所属一级业务
//"cid2":5,            //所属二级业务
//"website":"http://www.baidu.com",  //官方网站
//"create_time":"2017-04-28 12:27:28.0",
//"baodao_addr":"",   //报到地址  或者 体检地址，共用字段
//"baodao_contact":"", //报到联系人
//"baodao_phone":""  }  //联系电话
//,"link":"http://asssss"  //帮助链接（办理说明） ，为空或null则不跳转


@property (nonatomic) int id;
@property (nonatomic, copy) NSString *city;
@property (nonatomic) int cid1;
@property (nonatomic) int cid2;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *baodao_addr;
@property (nonatomic, copy) NSString *baodao_contact;
@property (nonatomic, copy) NSString *baodao_phone;
@property (nonatomic, copy) NSString *link;

@end
