//
//  NSString+Extend.h
//  ZJBDMIOS
//
//  Created by 转角街坊 on 16/1/22.
//  Copyright © 2016年 转角街坊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)

/**
 *  过滤一些特殊的字符串
 */
- (NSString *)trim;

// 判断字符串为空或只为空格
+ (BOOL)isBlankString:(NSString *)string;

+ (BOOL)isPhoneNumberString:(NSString *)phoneNumberStgring;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
//判断是否含有表情字符，有的话过滤掉
+ (BOOL)stringContainsEmoji:(NSString *)string;

//获取年月日时分秒
+ (NSString *)getYearMonthDayHourMinuteSecond;
//获取年月
+ (NSString *)getYearMonth;
//获取年月日
+ (NSString *)getYearMonthDay;
//获取时分秒
+ (NSString *)getHourMinuteSecond;
//转换成NSUTF8
+ (NSString *)changeToNSUTF8:(NSString *)str;

//获取13为系统时间戳
+ (NSString *)get13TimeStamp;
//判断是否是整型
+ (BOOL)isPureInt:(NSString*)string;
//判断是否是浮点型
+ (BOOL)isPureFloat:(NSString*)string;
//安全判断
+ (NSString *)judgeSafe:(NSString *)str;
//安全判断并转化0
+ (NSString *)judgeSafeTo0:(NSString *)str;

+ (NSString *)changeQianfenweiInter:(NSString *)string;

+ (NSString *)changeQianfenWei:(NSString *)string;

+ (NSNumber *)changeNumber:(NSString *)string;

+ (NSString *)changeToWStr:(NSString *)string;

+ (NSString *)stringToMD5:(NSString *)str;

+ (NSString *)changeToYearMonthDayHourMinute:(NSString *)str;
@end
