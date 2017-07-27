//
//  BGHelper.m
//  BeautyCircle
//
//  Created by 冉彬 on 16/5/23.
//  Copyright © 2016年 成都伟航创达科技有限公司. All rights reserved.
//

#import "BGHelper.h"
#include <sys/sysctl.h>

@implementation BGHelper

#pragma mark - 控件相关
//View画圆角以及边框
+ (void)cornerView:(UIView *)aView withRadius:(CGFloat)aR borderWidth:(CGFloat)aB borderColor:(UIColor*)aColor
{
    if (aR>0.) {
        aView.layer.cornerRadius = aR;
    }
    if (aB>0.) {
        aView.layer.borderWidth = aB;
        aView.layer.borderColor = aColor.CGColor;//
    }
    aView.clipsToBounds = YES;
}

+ (void)setNavBarBgUI:(UINavigationBar*)navBar
{
    navBar.barTintColor = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIColor whiteColor],[UIFont systemFontOfSize:16],nil]
                                                      forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    navBar.titleTextAttributes = dict;
    //navBar.barStyle=UIBarStyleDefault;
    //[navBar setTranslucent:YES];
}


#pragma mark - 图片
//图片拉伸
+ (UIImage *)stretchableImage:(UIImage *)oriImg
{
    UIImage *resultImg = [oriImg stretchableImageWithLeftCapWidth:oriImg.size.width/2. topCapHeight:oriImg.size.height/2];
    return resultImg;
}


// 计算labelsize
+(CGSize)getSizeWithLabelFont:(UIFont *)font maxWidth:(CGFloat)width maxHigth:(CGFloat)higth text:(NSString *)text;
{
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = font;
    label.text = text;
    CGSize size = [label sizeThatFits:CGSizeMake(width, higth)];
    return size;
}


#pragma mark -数据转换

/*!
 * @brief 把字典转化为JSON格式的字符串
 * @param dic 字典
 * @return 返回JSON格式的字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


// 32b随机名
+(NSString *)random32bitString
{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

//// 保存个人信息到本地
//+(void)setMine:(UserModel *)user
//{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USERINFO];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//// 获取本地个人信息
//+ (UserModel *)getMine
//{
////    NSData *oldData = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
////    if (!oldData) {
////        return nil;
////    }
////    NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:oldData];
////    UserModel *ary = [myKeyedUnarchiver decodeObject];
////    [myKeyedUnarchiver finishDecoding];
////    return ary;
//    NSUserDefaults *de = [NSUserDefaults standardUserDefaults];
//    
//    NSData *data = [de objectForKey:USERINFO];
//    
//    UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    return user;
//}


// 表情转换
+ (NSString *)convertToSystemEmoticons:(NSString *)text
{
    if (![text isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([text length] == 0) {
        return @"";
    }
    int allEmoticsCount = 35;
    NSMutableString *retText = [[NSMutableString alloc] initWithString:text];
    for(int i=0; i<allEmoticsCount; ++i) {
        NSRange range;
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[):]"
                                 withString:@"😊"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:D]"
                                 withString:@"😃"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[;)]"
                                 withString:@"😉"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:-o]"
                                 withString:@"😮"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:p]"
                                 withString:@"😋"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(H)]"
                                 withString:@"😎"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:@]"
                                 withString:@"😡"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:s]"
                                 withString:@"😖"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:$]"
                                 withString:@"😳"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:(]"
                                 withString:@"😞"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:'(]"
                                 withString:@"😭"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:|]"
                                 withString:@"😐"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(a)]"
                                 withString:@"😇"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[8o|]"
                                 withString:@"😬"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[8-|]"
                                 withString:@"😆"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[+o(]"
                                 withString:@"😱"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[<o)]"
                                 withString:@"🎅"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[|-)]"
                                 withString:@"😴"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[*-)]"
                                 withString:@"😕"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:-#]"
                                 withString:@"😷"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[:-*]"
                                 withString:@"😯"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[^o)]"
                                 withString:@"😏"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[8-)]"
                                 withString:@"😑"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(|)]"
                                 withString:@"💖"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(u)]"
                                 withString:@"💔"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(S)]"
                                 withString:@"🌙"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(*)]"
                                 withString:@"🌟"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(#)]"
                                 withString:@"🌞"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(R)]"
                                 withString:@"🌈"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"[(})]"
                                 withString:@"😚"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        
        [retText replaceOccurrencesOfString:@"[({)]"
                                 withString:@"😍"
                                    options:NSLiteralSearch
                                      range:range];
        
        
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(k)]"
                                 withString:@"💋"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(F)]"
                                 withString:@"🌹"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(W)]"
                                 withString:@"🍂"
                                    options:NSLiteralSearch
                                      range:range];
        
        range.location = 0;
        range.length = retText.length;
        [retText replaceOccurrencesOfString:@"[(D)]"
                                 withString:@"👍"
                                    options:NSLiteralSearch
                                      range:range];
    }
    
    return retText;
}

//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
