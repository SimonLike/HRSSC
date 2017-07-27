//
//  NSString+Extend.m
//  ZJBDMIOS
//
//  Created by 转角街坊 on 16/1/22.
//  Copyright © 2016年 转角街坊. All rights reserved.
//

#import "NSString+Extend.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Extend)

- (NSString *)trim
{
    NSString *afterTrimString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return afterTrimString;
}
// 判断字符串为空或只为空格
+(BOOL)isBlankString:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        
        return YES;
    }
    if([string isKindOfClass:[NSString class]] == NO)
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string.lowercaseString isEqualToString:@"(null)"] || [string.lowercaseString isEqualToString:@"null"] || [string.lowercaseString isEqualToString:@"<null>"])
    {
        return YES;
    }
    return NO;
}
/*
 * 正则表达法判断
 */
#pragma mark ---判定手机号
+ (BOOL)isPhoneNumberString:(NSString *)phoneNumberStgring
{
    /*
     中国移动：134（不含1349）、135、136、137、138、139、147、150、151、152、157、158、159、182、183、184、187、188
     中国联通：130、131、132、145（上网卡）、155、156、185、186
     中国电信：133、1349（卫星通信）、153、180、181、189
     4G号段：170：[1700(电信)、1705(移动)、1709(联通)]、176(联通)、177(电信)、178(移动)
     未知号段：140、141、142、143、144、146、148、149、154
     */
    //    NSString *MOBILE = @"^1(3[0-9]|4[0-9]|5[0-35-9]|7[0678]|8[025-9])\\d{8}$";
    //    NSString  *CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[1-478])\\d)\\d{7}$";
    //    NSString *CU = @"^1(3[0-2]|5[2456]|8[56])\\d{8}$";
    //    NSString *CT = @"^1((33|53|70[059]|8[09])[0-9]|349)\\d{7}$";
    //    NSPredicate  *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    //    NSPredicate *regextestcm = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",CM];
    //    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    //    NSPredicate  *regextestct = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",CT];
    //
    //    if (([regextestmobile evaluateWithObject:phoneNumberStgring] == YES)||
    //        ([regextestcm evaluateWithObject:phoneNumberStgring] == YES)||
    //        ([regextestct evaluateWithObject:phoneNumberStgring] == YES)||
    //        ([regextestcu evaluateWithObject:phoneNumberStgring]== YES))
    //    {
    //        return  YES;
    //    }else{
    //        return NO;
    //    }
    //1 开头 11位的 手机号码就通过
    NSString *phone = @"^1\\d{10}$";
    NSString * TelMatchStr = @"^[0][0-9]{2,3}[0-9]{5,10}$";
    NSString *TelMatch = @"^[1-9]{1}[0-9]{5,8}$";
    NSPredicate *regextestPhone = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",phone];
    NSPredicate *regextestFixPhone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",TelMatchStr];
    NSPredicate *regextestFixPhone1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",TelMatch];
    if ([regextestPhone evaluateWithObject:phoneNumberStgring] == YES || [regextestFixPhone evaluateWithObject:phoneNumberStgring] || [regextestFixPhone1 evaluateWithObject:phoneNumberStgring]) {
        return YES;
    } else {
        return NO;
    }
}
//判断是否为整型
+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
/**
 *   判断字符串中 是否包含表情emoji 符号 如果存在 过滤掉表情符号
 */
+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//获取年月日时分秒
+ (NSString *)getYearMonthDayHourMinuteSecond{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    return currentTime;
}
//获取年月
+ (NSString *)getYearMonth{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    return currentTime;

}
//获取年月日
+ (NSString *)getYearMonthDay{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    return currentTime;
}

//获取时分秒
+ (NSString *)getHourMinuteSecond{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    
    return currentTime;
}

//获取13为时间戳
+ (NSString *)get13TimeStamp{
    
    NSString *timeStr = [NSString getYearMonthDayHourMinuteSecond];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    return timeSp;
}
+ (NSString *)changeToNSUTF8:(NSString *)str{
    
    CGFloat device = [[UIDevice currentDevice].systemVersion floatValue];
    if (device >= 9) {
        
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }else{
        
        str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return str;
}

+ (NSString *)judgeSafe:(NSString *)str{
    
    if ([NSString isBlankString:str]) {
        
        return @"";
    }
    return str;
}
+ (NSString *)judgeSafeTo0:(NSString *)str{
    
    if ([NSString isBlankString:str]) {
        
        return @"0";
    }
    return str;

}
+ (NSString *)changeQianfenweiInter:(NSString *)string{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *str = [formatter stringFromNumber:[NSNumber numberWithInteger:[string integerValue]]];
    
    return str;

}
+ (NSString *)changeQianfenWei:(NSString *)string{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSString *str = [formatter stringFromNumber:[NSNumber numberWithFloat:[string floatValue]]];
    
    return str;
}
+ (NSNumber *)changeNumber:(NSString *)string{
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *numTemp = [numberFormatter numberFromString:string];
    return numTemp;
}
+ (NSString *)changeToWStr:(NSString *)string{
    
    NSInteger number1;
    CGFloat number2;
    if ([string floatValue] >= 100000) {
        
        number1 = [string integerValue];
        NSInteger f = number1/10000;
        NSString *str = [NSString stringWithFormat:@"%ldW+",f];
        return str;
    }else{
        
        number2 = [string floatValue];
        CGFloat f = number2/10000.0;
        NSString *str = [NSString stringWithFormat:@"%0.1fW+",f];
        return str;
    }
}
+ (NSString *)changeToYearMonthDayHourMinute:(NSString *)str{
    
    NSString *time = [str substringToIndex:str.length - 3];
    return time;
}
+ (NSString *)stringToMD5:(NSString *)str
{
    
    //1.首先将字符串转换成UTF-8编码, 因为MD5加密是基于C语言的,所以要先把字符串转化成C语言的字符串
    const char *fooData = [str UTF8String];
    
    //2.然后创建一个字符串数组,接收MD5的值
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    //3.计算MD5的值, 这是官方封装好的加密方法:把我们输入的字符串转换成16进制的32位数,然后存储到result中
    CC_MD5(fooData, (CC_LONG)strlen(fooData), result);
    /**
     第一个参数:要加密的字符串
     第二个参数: 获取要加密字符串的长度
     第三个参数: 接收结果的数组
     */
    
    //4.创建一个字符串保存加密结果
    NSMutableString *saveResult = [NSMutableString string];
    
    //5.从result 数组中获取加密结果并放到 saveResult中
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [saveResult appendFormat:@"%02x", result[i]];
    }
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
    return saveResult;
}
@end
