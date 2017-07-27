//
//  HRPublicFundObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/15.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRPublicFundObj : NSObject
/*
 "city": "中国",          //缴纳地
 "paytime": "2016-05",    //缴纳月份
 "base": 111.11,          //缴纳基数
 "payamount": 10,         //缴纳实际
 "percent_company": 50,   //单位比例
 "percent_personal": 50    //个人比例
 */
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *paytime;
@property (nonatomic, copy) NSString *base;
@property (nonatomic, copy) NSString *payamount;
@property (nonatomic, copy) NSString *percent_company;
@property (nonatomic, copy) NSString *percent_personal;

/*
   "create_time": "2017-05-12",  //记录日期
 */

@property (nonatomic, copy) NSString *create_time;

@end
