//
//  NSString+Regex.m
//  MXapp
//
//  Created by congyang on 16/6/16.
//  Copyright © 2016年 zeb. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isMatch = [phoneTest evaluateWithObject:mobileNum];
    return isMatch;
}
//以类目的形式写
- (CGSize)computeSizeWithFont:(CGFloat)font maxW:(CGFloat)maxW{
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:font] } context:nil].size;
}

-(BOOL)isTelNumber{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

-(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (NSString *)StringFromLongTime{
    if (!self || self.length == 0 || [self isEqualToString:@""]) {
        return @"时间去了火星";
    }
    NSDate *date = [NSDate date];
    NSTimeInterval interval = date.timeIntervalSince1970;
    NSInteger differ = interval - [self floatValue];
    if (differ< 60) {
        return @"刚刚";
    }else if (differ > 60 && differ < 3600){
        return [NSString stringWithFormat:@"%d分钟前",(int)differ/60];
    }else if (differ > 3600 && differ < 86400){
        return [NSString stringWithFormat:@"%d小时前",(int)differ/3600];
    }else if (differ > 86400 && differ < 86400 *2){
        return @"昨天";
    }else{
        NSDate *distDate = [NSDate dateWithTimeIntervalSince1970:[self floatValue]];
        NSDateFormatter *forma = [[NSDateFormatter alloc] init];
        [forma setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *cdate = [forma stringFromDate:distDate];
        NSString *abc = @"";
        @try {
            abc = [cdate substringWithRange:NSMakeRange(5, 11)];
        } @catch (NSException *exception) {
            abc = cdate;
        } @finally {
            
        }
        return abc;
    }
}
- (NSString *)timeWithString{
    if (!self || self.length == 0 || [self isEqualToString:@""]) {
        return @"时间去了火星";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self floatValue]];
    NSDateFormatter *forma = [[NSDateFormatter alloc] init];
    [forma setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *cdate = [forma stringFromDate:date];
    return cdate;
}
@end
