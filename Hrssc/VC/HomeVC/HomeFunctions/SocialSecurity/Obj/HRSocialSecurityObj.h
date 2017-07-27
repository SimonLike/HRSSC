//
//  HRSocialSecurityObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/13.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocialSecurityObj : NSObject
/*
 "total": "11.10",                        //总缴纳
 "personalTotal": 5.55,                   //个人缴纳
 "showDates": [                           //缴交的所有日期
 "2017-05-11",
 "2017-05-12"
 ],
 "compantTotal": 5.55                    //单位缴纳
 */

@property (nonatomic, copy) NSString *total;
@property (nonatomic) float personalTotal;
@property (nonatomic) float compantTotal;
@property (nonatomic, copy) NSArray *showDates;

@end

@interface IndividualUnitObj : NSObject
/*
 "socialSecurity": {
 "city": "北京",                        //缴纳地
 "paytime": "2016-02",                  //缴纳月份
 "yanglao": "100.11,1.11,1.11,1.11",    //养老
 "yiliao": "100.11,1.11,1.11,1.11",     //医疗
 "gongshang": "100.11,1.11,1.11,1.11",  //工伤
 "shiye": "100.11,1.11,1.11,1.11",      //失业
 "shengyu": "100.11,1.11,1.11,1.11"     //生育
 },
 */

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *paytime;
@property (nonatomic, copy) NSString *yanglao;
@property (nonatomic, copy) NSString *yiliao;
@property (nonatomic, copy) NSString *gongshang;
@property (nonatomic, copy) NSString *shiye;
@property (nonatomic, copy) NSString *shengyu;


@end
