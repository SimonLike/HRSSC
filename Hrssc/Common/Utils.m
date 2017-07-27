//
//  Utils.m
//  XQExpressCourier
//
//  Created by xf.lai on 14/8/11.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//

#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#import <QuartzCore/QuartzCore.h>
#import "MarkupParser.h"

@implementation Utils


+ (UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (void)showMSG:(NSString*)msg
{
    [JDStatusBarNotification showWithStatus:msg dismissAfter:1.5 styleName:JDStatusBarStyleDark];
}

+ (BOOL)NetStatus:(NSDictionary*)infoDic
{
    if([infoDic[@"status"] intValue] == 1)
        return YES;
    else
        return NO;
}

+ (BOOL)TokenOutDate:(NSDictionary*)infoDic
{
    if([infoDic[@"status"] intValue] == 2)
        return YES;
    else
        return NO;
}

+ (void)creatBackItemNIL:(UIViewController*)vc Selector:(SEL)selector
{
    UIButton* backBtn = [Utils createButtonWith:CustomButtonType_Back text:nil];
    UIImage *img = [UIImage imageNamed:@""];
    [backBtn setImage:img forState:UIControlStateNormal];
    [backBtn setImage:img forState:UIControlStateNormal];

    [backBtn addTarget:vc action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    vc.navigationItem.leftBarButtonItem = leftItem;
}

+ (void)creatBackItem:(UIViewController*)vc Selector:(SEL)selector
{
    UIButton* backBtn = [Utils createButtonWith:CustomButtonType_Back text:nil];
    [backBtn addTarget:vc action:selector forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    vc.navigationItem.leftBarButtonItem = leftItem;
}

+(void)setupRefresh:(UIScrollView*)scrollView WithDelegate:(id)delegate HeaderSelector:(SEL)headSelector FooterSelector:(SEL)footSelector
{
    if(headSelector)
    {
        MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:delegate refreshingAction:headSelector];
        [header setTitle:MJREFRESH_DOWN_Title1 forState:MJRefreshStateIdle];
        [header setTitle:MJREFRESH_DOWN_Title2 forState:MJRefreshStatePulling];
        [header setTitle:MJREFRESH_DOWN_Title3 forState:MJRefreshStateRefreshing];
        scrollView.mj_header = header;

    }
    if(footSelector)
    {
        MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:delegate refreshingAction:footSelector];
        [footer setTitle:MJREFRESH_UP_Title1 forState:MJRefreshStateIdle];
        [footer setTitle:MJREFRESH_UP_Title2 forState:MJRefreshStatePulling];
        [footer setTitle:MJREFRESH_UP_Title3 forState:MJRefreshStateRefreshing];
        [footer setTitle:MJREFRESH_UP_Title4 forState:MJRefreshStateNoMoreData];
        scrollView.mj_footer = footer;
    }
}

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

+ (NSString*)getTimeCounter:(NSString*)exStr
{
    NSDate* exDate = [Utils getDateFromStrHMS:exStr];
    //NSString* timeNow = [Utils getStrFromDate:[NSDate date]];
    //NSDate* nowDate = [Utils getDateFromStrHMS:timeNow];
    NSTimeInterval interval = [exDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",interval];;
}

+ (NSString*)getStrFromArray:(NSMutableArray*)ary
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:ary
                                                   options:0 // non-pretty printing
                                                     error:&error];
    if(error)
        DLog(@"JSON Parsing Error: %@", error);
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


//+ (UserVO*)getUserInfo{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:USERINFO];
//}

+ (NSString*)getAccount{
    return [[NSUserDefaults standardUserDefaults] objectForKey:IMACCOUNT];
}

+ (NSString*)getPsw{
    return [[NSUserDefaults standardUserDefaults] objectForKey:IMPASSWORD];
}

//+ (NSString*)getLat{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_CLIENT_VO_LAT];
//}
//
//+ (NSString*)getLng{
//    return [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_CLIENT_VO_LNG];
//}


+ (BOOL)isIOSVersion7
{
    BOOL isIOS7 = NO;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 7.0)
    {
        isIOS7 = YES;
    }  
    return isIOS7;
}

//+ (void)archiveUserVO:(XQUserVO *)aVO {
//    if (aVO) {
//        NSMutableData *mData = [[NSMutableData alloc] init];
//        NSKeyedArchiver *myKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mData];
//        [myKeyedArchiver encodeObject:aVO];
//        [myKeyedArchiver finishEncoding];
//        
//        [[NSUserDefaults standardUserDefaults] setObject:mData forKey:USERDEFAULTS_USER_VO_KEY];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//    }
//}
//
//+ (XQUserVO*)readUnarchiveUserVO {
//    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_USER_VO_KEY];
//    if (!data) {
//        return nil;
//    }
//    NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    XQUserVO *uVO = [myKeyedUnarchiver decodeObject];
//    [myKeyedUnarchiver finishDecoding];
//    return uVO;
//}

//+ (NetworkType)getCurrentNetworkType{
//    NSNumber *numObj = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_NETWORK_KEY];
//    NetworkType aType = [numObj intValue];
//    return aType;
//}

//+ (BOOL)getBoolOfShowImgOnlyInWifi{
//    NSNumber *numObj = [[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULTS_SHOW_IMG_ONLY_IN_WIFI_KEY];
//    if (numObj) {
//        return [numObj boolValue];
//    }
//    return YES;
//}

+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont {
	CGFloat result;
	CGSize textSize = { width, 20000.0f };
    CGSize size  = CGSizeZero;
    
#ifdef IOS7_SDK_AVAILABLE
    NSDictionary *attribute =@{NSFontAttributeName: aFont};
    size = [text boundingRectWithSize:textSize
                              options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:attribute
                              context:nil].size;
#else
     size = [text sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
  

	result = size.height;
	return result;
}
+ (CGFloat)widthOfText:(NSString *)text theHeight:(float)height theFont:(UIFont*)aFont {
	CGFloat result;
	CGSize textSize = { 20000.0f,  height};
    CGSize size  = CGSizeZero;
    
#ifdef IOS7_SDK_AVAILABLE
    NSDictionary *attribute =@{NSFontAttributeName: aFont};
    size = [text boundingRectWithSize:textSize
                              options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                           attributes:attribute
                              context:nil].size;
#else
    size = [text sizeWithFont:aFont constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
#endif
    
    
	result = size.width ;
	return result;
}

+ (NSString *)getDicDataByKey:(NSDictionary *)dic key:(NSString *)strKey{
    if ([dic.allKeys containsObject:strKey]) {
        return [NSString stringWithFormat:@"%@",dic[strKey]];
    }
    else return @"";
}

+(void)showTipViewWhenFailed:(NSError *)error
{
    NSString *strError = [error localizedDescription];
    if (!strError || [strError isEqualToString:@""]) {
        strError = @"Unknown error";
    }
    [[XQTipInfoView getInstanceWithNib] appear:strError];

}

+ (UIImage *)stretchableImage:(UIImage *)oriImg{
    UIImage *resultImg = [oriImg stretchableImageWithLeftCapWidth:oriImg.size.width/2. topCapHeight:oriImg.size.height/2];
    return resultImg;
}

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor redColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor redColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *) colorWithHexStringWithAlpha: (NSString *) stringToConvert Alpha:(float)alpha
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor redColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor redColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (void)cornerView:(UIView *)aView withRadius:(CGFloat)aR borderWidth:(CGFloat)aB borderColor:(UIColor*)aColor{
    if (aR>0.) {
        aView.layer.cornerRadius = aR;
    }
    if (aB>0.) {
        aView.layer.borderWidth = aB;
        aView.layer.borderColor = aColor.CGColor;//
    }
    aView.clipsToBounds = YES;
}

+ (void)setNavBarBgUI:(UINavigationBar*)navBar{
    navBar.barTintColor = [Utils colorWithHexString:@"FFFFFF"];//F54E54
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[Utils colorWithHexString:@"333333"],[UIFont systemFontOfSize:16],nil]
                                                      forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    navBar.titleTextAttributes = dict;
    navBar.barStyle=UIBarStyleDefault;
    //[navBar setTranslucent:YES];
}

+ (void)setNavBarBgWhite:(UINavigationBar*)navBar{
    navBar.barTintColor = [Utils colorWithHexString:@"FFFFFF"];//F54E54
    NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[Utils colorWithHexString:@"000000"],[UIFont systemFontOfSize:16],nil]
                                                      forKeys:[NSArray arrayWithObjects:NSForegroundColorAttributeName,NSFontAttributeName, nil]];
    navBar.titleTextAttributes = dict;
    //navBar.barStyle=UIBarStyleDefault;
    //[navBar setTranslucent:YES];
}

+ (UIButton*)createButtonWith:(CustomButtonType)aType text:(NSString *)title{
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (aType == CustomButtonType_Back) {
        UIImage *img = [UIImage imageNamed:@"icon_back"];
        [aBtn setImage:img forState:UIControlStateNormal];
        [aBtn setImage:img forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0,  0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    }
    else if (aType == CustomButtonType_Back2) {
        aBtn.frame = CGRectMake(0, 0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        [aBtn setImage:[UIImage imageNamed:@"vps_actionbar_black_ic.png"] forState:UIControlStateNormal];
    }
    else if(aType == CustomButtonType_Text){
        [aBtn setTitle:title forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:14.]];
        //[aBtn setTitleColor:myColor02 forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0, 0, 50, 30);
         //aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
        aBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        //[Utils cornerView:aBtn withRadius:4 borderWidth:1 borderColor:[UIColor whiteColor]];
    }
    else if(aType == CustomButtonType_Text2){
        [aBtn setTitle:title forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
        [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0, 0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
        aBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        //[Utils cornerView:aBtn withRadius:4 borderWidth:1 borderColor:[UIColor whiteColor]];
    }
    else if(aType == CustomButtonType_long){
        [aBtn setTitle:title forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
        [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0, 0, 80, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
        aBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        //[Utils cornerView:aBtn withRadius:4 borderWidth:1 borderColor:[UIColor whiteColor]];
    }
    else if (aType == CustomButtonType_Delete){
        [aBtn setImage:[UIImage imageNamed:@"cyb_actionbar_delete_ic.png"] forState:UIControlStateNormal];
         aBtn.frame = CGRectMake(0, 0, 50, 30);
         aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
    }
    else if(aType == CustomButtonType_Share){
        [aBtn setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [aBtn setImage:[UIImage imageNamed:@"share_press.png"] forState:UIControlStateHighlighted];
        aBtn.frame = CGRectMake(0, 0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];

    
    }
    else if(aType == CustomButtonType_Collection){
        [aBtn setImage:[UIImage imageNamed:@"hotelinfo_button_collect_default.png"] forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0, 0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
        
        
    }
    else if(aType == CustomButtonType_Search){
        [aBtn setImage:[UIImage imageNamed:@"btn_search.png"] forState:UIControlStateNormal];
        [aBtn setImage:[UIImage imageNamed:@"btn_search_press.png"] forState:UIControlStateHighlighted];
        aBtn.frame = CGRectMake(0, 0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
    }
    else if(aType == CustomButtonType_Mine){
        [aBtn setImage:[UIImage imageNamed:@"nav_button_my.png"] forState:UIControlStateNormal];
        [aBtn setImage:[UIImage imageNamed:@"nav_button_my_selected.png"] forState:UIControlStateHighlighted];
        aBtn.frame = CGRectMake(0, 0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
    }
    else if(aType == CustomButtonType_More){
        [aBtn setImage:[UIImage imageNamed:@"icon_xiaoxi"] forState:UIControlStateNormal];
        [aBtn setImage:[UIImage imageNamed:@"icon_xiaoxi"] forState:UIControlStateHighlighted];
        aBtn.frame = CGRectMake(0, 0, 50, 30);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
    }
    else if(aType == CustomButtonType_UserCenter)
    {
        //[aBtn setImage:[UIImage imageNamed:@"h_User_press.png"] forState:UIControlStateNormal];
        //[aBtn setImage:[UIImage imageNamed:@"h_User_press.png"] forState:UIControlStateHighlighted];
        aBtn.frame = CGRectMake(0, 0, 24, 24);
        aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [aBtn setBackgroundColor:[UIColor whiteColor]];
        [Utils cornerView:aBtn withRadius:12 borderWidth:0 borderColor:[UIColor clearColor]];
    }
    else if(aType == CustomButtonType_leftlong){
        [aBtn setTitle:title forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
        [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0, 0, 70, 30);
        //aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
        aBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [aBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //[Utils cornerView:aBtn withRadius:4 borderWidth:1 borderColor:[UIColor whiteColor]];
    }
    else if(aType == CustomButtonType_rightlong){
        [aBtn setTitle:title forState:UIControlStateNormal];
        [aBtn.titleLabel setFont:[UIFont systemFontOfSize:13.]];
        [aBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        aBtn.frame = CGRectMake(0, 0, 60, 30);
        //aBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [aBtn setBackgroundColor:[UIColor clearColor]];
        aBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        //[Utils cornerView:aBtn withRadius:4 borderWidth:1 borderColor:[UIColor whiteColor]];
    }
   // [aBtn setBackgroundColor:[UIColor redColor]];
    return aBtn;
}

+(NSString *)ret32bitString{
    char data[32];
    for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}

//ADDED By HQL 2014/10/31
+ (NSString*)getTimeFromLongNumStrDate:(NSString*)aNumStr{
    if ([aNumStr longLongValue] == 0) {
        return @"";
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[aNumStr longLongValue]/1000];
    NSString * aTimeStr= [[Utils dateFormatterForDate]stringFromDate:confromTimesp];
    return aTimeStr;
}

+ (NSString*)getTimeFromLongNumStr:(NSString*)aNumStr{
    if ([aNumStr longLongValue] == 0) {
        return @"";
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[aNumStr longLongValue]/1000];
    NSString * aTimeStr= [[Utils dateFormatterForDateAndTime]stringFromDate:confromTimesp];
    return aTimeStr;
}
+ (NSString*)getDateFromLongNumStr:(NSString*)aNumStr{
    if ([aNumStr longLongValue] == 0) {
        return @"";
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[aNumStr longLongValue]/1000];
    NSString * aTimeStr= [[Utils dateFormatterForDate]stringFromDate:confromTimesp];
    return aTimeStr;
}

+ (long long)getLongNumFromDateAndTimeStr:(NSString *)aStr{
    NSDateFormatter *dateFormatter = [Utils dateFormatterForDateAndTime];
    NSDate *date = [dateFormatter dateFromString:aStr];
    long long num = [Utils getLongNumFromDate:date];//ms
   
    return num;
}
+ (long long)getLongNumFromDateStr:(NSString *)aStr{
    NSDateFormatter *dateFormatter = [Utils dateFormatterForDate];
    NSDate *date = [dateFormatter dateFromString:aStr];
    long long num = [Utils getLongNumFromDate:date];//ms
    
    return num;
}

+ (NSDate*)getDateFromStrHMS:(NSString*)aStr
{
    NSDateFormatter *dateForMatter = [Utils dateFormatterForDateAndTime];
    return [dateForMatter dateFromString:aStr];
}

+ (NSDate*)getDateFromStr:(NSString*)aStr
{
    NSDateFormatter *dateForMatter = [Utils dateFormatterForDate];
    return [dateForMatter dateFromString:aStr];
}

+ (NSDate*)getMonthDateFromStr:(NSString*)aStr
{
    NSDateFormatter *dateForMatter = [Utils monthDateFormatterForDate];
    return [dateForMatter dateFromString:aStr];
}

+ (NSString*)getStrFromDate:(NSDate*)date
{
    //NSDateFormatter *dateForMatter = [Utils dateFormatterForDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)getMonthStrFromDate:(NSDate*)date
{
    NSDateFormatter *dateForMatter = [Utils monthDateFormatterForDate];
    return [dateForMatter stringFromDate:date];
}

+ (NSDate *)nextDay:(NSDate *)date calender:(NSCalendar*)calen space:(int)inter type:(int)Type{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    if(Type == 1)
        [comps setDay:inter];
    else if(Type == 2)
        [comps setMonth:inter];
    NSDate* _date;
    _date = [calen dateByAddingComponents:comps toDate:date options:0];
    //[comps release];
    return _date;
}

+ (long long)getLongNumFromDate:(NSDate *)date{
    NSTimeInterval time = [date timeIntervalSince1970];
    // NSTimeInterval返回的是double类型，输出会显示为10位整数加小数点加一些其他值
    // 如果想转成int型，必须转成long long型才够大。
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue] ; // 将double转为long long型
    return dTime;
}
//ADDED By HQL 2014/10/31
+ (long long)getLLongNumFromDate:(NSDate *)date{
    NSTimeInterval time = [date timeIntervalSince1970];
    // NSTimeInterval返回的是double类型，输出会显示为10位整数加小数点加一些其他值
    // 如果想转成int型，必须转成long long型才够大。
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue] *1000; // 将double转为long long型
    return dTime;
}
//ADDED By HQL 2014/10/31
+ (NSDateFormatter *)dateFormatterForDateAndTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return dateFormatter;
}

+ (NSDateFormatter *)monthDateFormatterForDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return dateFormatter;
}
+ (NSDateFormatter *)dateFormatterForDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return dateFormatter;
}
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

+ (NSAttributedString*)getLabelAttributedWithString:(NSString *)aStr font:(UIFont *)aFont{
    MarkupParser *parser = [[MarkupParser alloc]init];
    parser.textFont = aFont;
    NSAttributedString *attString = [parser attrStringFromMarkup:aStr];
    return attString;
}

+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:YES];
}

+ (NSString *)getImagePathWithName:(NSString *)imgName{
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);//NSDocumentDirectory
    NSString *docDir = [paths objectAtIndex:0];
    NSString *filePath = [docDir stringByAppendingPathComponent:imgName];
     //UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    return filePath;
}


+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)aSize
{
    
    if (!image) {
        return image;
    }
    CGRect aFrame = CGRectMake(0, 0, aSize.width*2, aSize.height*2);
    UIImage *newImage = image;
    CGSize imgSize = image.size;
    if (imgSize.width < aSize.width*2 || imgSize.height < aSize.height*2) {
        if (imgSize.width < aSize.width*2) {
            CGFloat scale = aSize.width*2/imgSize.width;
            newImage = [self scaleImage:image toScale:scale];
            image = newImage;
        }
        if (imgSize.height < aSize.height*2) {
            CGFloat scale = aSize.height*2/imgSize.height;
            newImage = [self scaleImage:image toScale:scale];
            image = newImage;
        }
        
    }
    else
    {
        //相对于目标size比例，原图寛大于高
        if (imgSize.width/imgSize.height > aSize.width/aSize.height) {
            CGFloat scale = aSize.height*2/imgSize.height;
            newImage = [self scaleImage:image toScale:scale];
            image = newImage;
        }
        //相对于目标size比例，原图高大于寛
        else
        {
            CGFloat scale = aSize.width*2/imgSize.width;
            newImage = [self scaleImage:image toScale:scale];
            image = newImage;
        }
        
    }
    
    
    imgSize = image.size;
    aFrame.origin.x = (imgSize.width - aSize.width*2)/2.0;
    aFrame.origin.y = (imgSize.height - aSize.height*2)/2.0;
    aFrame.size.width = aSize.width*2;
    aFrame.size.height = aSize.height*2;

    UIImage *rimage = [Utils getSubImage:image mCGRect:aFrame centerBool:YES];//[Utils croppedPhotoWithCropRect:image toFrame:aFrame];
    
    return rimage;
    
}

+(BOOL)judgeUrlString:(NSString *)aStr
{

    BOOL isUrl = YES;
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:aStr options:0 range:NSMakeRange(0, [aStr length])];
        if (firstMatch) {
            isUrl = YES;
            
        }else {
            //DLog(@"no result");
            isUrl = NO;
            
        }
    }
    return isUrl;
    
}



//HQL
+ (CLLocationDistance)getTheDistance:(CLLocationCoordinate2D)oriLoc DisLoc:(CLLocationCoordinate2D)dicloc
{
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:oriLoc.latitude  longitude:oriLoc.longitude];
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:dicloc.latitude longitude:dicloc.longitude];
    
    CLLocationDistance kilometers=[orig distanceFromLocation:dist];
    ////DLog(@"距离:",kilometers);
    return kilometers;
}



//+ (CLLocationCoordinate2D)getThelocation
//{
//    CLLocationCoordinate2D location ;
//    location.latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_CLIENT_VO_LAT] floatValue];
//    location.longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_CLIENT_VO_LNG] floatValue];
//    return location;
//}

//+ (void)cashImage:(NSArray*)ary
//{
//    for (GiftVO* vo in ary) {
//        if([[NSUserDefaults standardUserDefaults] valueForKey:vo.giftPic])
//            continue;
//        else
//        {
//            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[PIC_HOST stringByAppendingString:vo.giftPic]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//                
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//                if(error) {
//                    //isSaveStartPage(NO);
//                }else if(image) {
//                    NSLog(@"%@",Gift_PATH(vo.giftPic));
//                    [UIImagePNGRepresentation(image) writeToFile:Gift_PATH(vo.giftPic) atomically:YES];
//                    [[NSUserDefaults standardUserDefaults] setValue:vo.giftPic forKey:vo.giftPic];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    //isSaveStartPage(YES);
//                }
//            }];
//        }
//    }
//}

+ (UIImage*)getCashImage:(NSString*)url
{
    NSLog(@"%@",Gift_PATH(url));
    UIImage* image = [UIImage imageWithContentsOfFile:Gift_PATH(url)];
    return image;
}

//存储、读取个人数据
+ (UserVO *)readUser{
    NSData *oldData = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
    if (!oldData) {
        return nil;
    }
    NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:oldData];
    UserVO *ary = [myKeyedUnarchiver decodeObject];
    [myKeyedUnarchiver finishDecoding];
    return ary;
}

+ (void)archiveUser:(UserVO *)aVOsAry{
    
    NSMutableData *newData = [[NSMutableData alloc] init];
    NSKeyedArchiver *newKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:newData];
    [newKeyedArchiver encodeObject:aVOsAry];
    [newKeyedArchiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:newData forKey:USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//存储、读取个人数据
//存储、读取城市数据
+ (NSArray *)readCityData
{
    NSData *oldData = [[NSUserDefaults standardUserDefaults] objectForKey:CITYDATA];
    if (!oldData) {
        return nil;
    }
    NSKeyedUnarchiver *myKeyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:oldData];
    NSArray *ary = [myKeyedUnarchiver decodeObject];
    [myKeyedUnarchiver finishDecoding];
    return ary;
}

+ (void)archiveCityData:(NSArray *)aVOsAry
{
    NSMutableData *newData = [[NSMutableData alloc] init];
    NSKeyedArchiver *newKeyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:newData];
    [newKeyedArchiver encodeObject:aVOsAry];
    [newKeyedArchiver finishEncoding];
    [[NSUserDefaults standardUserDefaults] setObject:newData forKey:CITYDATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//存储、读取城市
+ (NSString *)getCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:SINGLECITY];
    if (!city) {
        city = @"深圳市";
    }
    return city;
}
+ (void)archiveCity:(NSString *)city
{
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:SINGLECITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - ScaleImageSize
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize {
    if (image) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    return nil;
}
+ (UIImage *) croppedPhotoWithCropRect:(UIImage *)aImage toFrame:(CGRect)aFrame
{
    //框的坐标
    CGRect cropRect = aFrame;
    //根据范围剪切图片得到新图片
    CGImageRef imageRef = CGImageCreateWithImageInRect([aImage CGImage], cropRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return result;
}

/**
 * 截取部分图像
 *
 **/
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool
{
    
    /*如若centerBool为Yes则是由中心点取mCGRect范围的图片*/
    
    
    float imgwidth = image.size.width;
    float imgheight = image.size.height;
    float viewwidth = mCGRect.size.width;
    float viewheight = mCGRect.size.height;
    CGRect rect;
    if(centerBool)
        rect = CGRectMake((imgwidth-viewwidth)/2, (imgheight-viewheight)/2, viewwidth, viewheight);
    else{
        if (viewheight < viewwidth) {
            if (imgwidth <= imgheight) {
                rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
            }else {
                float width = viewwidth*imgheight/viewheight;
                float x = (imgwidth - width)/2 ;
                if (x > 0) {
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgwidth*viewheight/viewwidth);
                }
            }
        }else {
            if (imgwidth <= imgheight) {
                float height = viewheight*imgwidth/viewwidth;
                if (height < imgheight) {
                    rect = CGRectMake(0, 0, imgwidth, height);
                }else {
                    rect = CGRectMake(0, 0, viewwidth*imgheight/viewheight, imgheight);
                }
            }else {
                float width = viewwidth*imgheight/viewheight;
                if (width < imgwidth) {
                    float x = (imgwidth - width)/2 ;
                    rect = CGRectMake(x, 0, width, imgheight);
                }else {
                    rect = CGRectMake(0, 0, imgwidth, imgheight);
                }
            }
        }
    }
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}



+ (NSArray*)getAniGiftAryWithType:(GiftType)giftType
{
    NSArray* giftAry;
    if(giftType == Gift_Boat)
    {
        
    }
    else if(giftType == Gift_Kiss)
    {
        giftAry = @[@"qinqin01.png",@"qinqin02.png",@"qinqin03.png",@"qinqin04.png",@"qinqin05.png",@"qinqin06.png"];
    }
    else if(giftType == Gift_Lamborghini_1)
    {
        giftAry = @[@"labijini1_01.png",@"labijini1_02.png",@"labijini1_03.png",@"labijini1_04.png",@"labijini1_05.png",@"labijini1_06.png",@"labijini1_07.png"];
    }
    else if(giftType == Gift_Lamborghini_2)
    {
        giftAry = @[@"labijini2_01.png",@"labijini2_02.png",@"labijini2_03.png",@"labijini2_04.png",@"labijini2_05.png",@"labijini2_06.png",@"labijini2_07.png",@"labijini2_08.png",@"labijini2_09.png",@"labijini2_10.png",@"labijini2_11.png",@"labijini2_12.png",@"labijini2_13.png",@"labijini2_14.png"];
    }
    else if(giftType == Gift_Arrow)
    {
        giftAry = @[@"jian01.png",@"jian02.png",@"jian03.png",@"jian04.png",@"jian05.png",@"jian06.png",@"jian07.png"];
    }
    else if(giftType == Gift_Plane)
    {
        giftAry = @[@"feiji1_01.png",@"feiji1_02.png",@"feiji1_03.png",@"feiji1_04.png"];
    }
    else if(giftType == Gift_Ferrari)
    {
        giftAry = @[@"falali1_01.png",@"falali1_02.png",@"falali1_03.png",@"falali1_04.png",@"falali1_05.png",@"falali1_06.png",@"falali1_07.png",@"falali2_01.png",@"falali2_02.png",@"falali2_03.png",@"falali2_04.png",@"falali2_05.png",@"falali2_06.png",@"falali2_07.png"];
    }
    return giftAry;
}

#pragma mark - Cache
//lxf
+  (NSString* )pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}
//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName
{
    NSString *imageDir = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}



// 删除图片缓存
+ (BOOL) deleteDirInCache:(NSString *)dirName
{
    NSString *imageDir = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isDeleted = false;
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:imageDir error:nil];
    }
    
    return isDeleted;
}

// 图片本地缓存
+ (BOOL) saveImageToCacheDir:(NSString *)directoryPath image:(UIImage *)image imageName:(NSString *)imageName imageType:(NSString *)imageType
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = false;
    if ( isDir == YES && existed == YES )
    {
        if ([[imageType lowercaseString] isEqualToString:@"png"])
        {
            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
        }
        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
        {
            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
        }
        else
        {
            //DLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
        }
    }
    
    //NSError *error;
    //NSLog(@"图片本地缓存Documentsdirectory: %@",[fileManager contentsOfDirectoryAtPath:directoryPath error:&error]);
    
    return isSaved;
}
// 获取缓存图片
+ (NSData*) loadImageData:(NSString *)directoryPath imageName:( NSString *)imageName
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES )
    {
        NSString *imagePath = [directoryPath stringByAppendingString : [NSString stringWithFormat:@"/%@",imageName]];
        BOOL fileExisted = [fileManager fileExistsAtPath:imagePath];
        if (!fileExisted) {
            return NULL;
        }
        NSData *imageData = [NSData dataWithContentsOfFile : imagePath];
        return imageData;
    }
    else
    {
        return NULL;
    }
}
//lxf
+ (BOOL)deleteAllImageCache{
    // 删除所有图片缓存
    NSString *path = [self pathInCacheDirectory:CACHE_FOLDER_NAME];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    bool isDeleted = false;
    //NSError *error;
    //NSLog(@"111Documentsdirectory: %@",[fileManager contentsOfDirectoryAtPath:path error:&error]);
    
    if ( isDir == YES && existed == YES )
    {
        isDeleted = [fileManager removeItemAtPath:path error:nil];
    }
    
    //NSLog(@"222Documentsdirectory: %@",[fileManager contentsOfDirectoryAtPath:path error:&error]);
    
    return isDeleted;
}



+(NSString *)tenK:(NSString *)str
{
    NSInteger num = [str integerValue];
    NSString *resultStr;
    if (num > 1000000)
    {
        CGFloat floatNum = num/1000000.0;
        resultStr = [NSString stringWithFormat:@"%.2f百万",floatNum];
    }
    else if (num > 10000)
    {
        CGFloat floatNum = num/10000.0;
        resultStr = [NSString stringWithFormat:@"%.2f万",floatNum];
    }
    else
    {
        resultStr = str;
    }
    
    
    return resultStr;
}
@end
