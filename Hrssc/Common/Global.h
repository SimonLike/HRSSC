//
//  Global.h
//  XQExpressCourier
//
//  Created by xf.lai on 14/8/11.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//



#if	1
#define DLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define DLog(format, ...)
#endif


#define XNSCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define XNSCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)


#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

#define IS_IOS7_Later ([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0f)

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

#define IS_IOS8_0_2 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.2f && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

#define IS_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)





// 测试相关
#pragma mark-测试相关
#define USERNICKNSME @"我的昵称" // 我的昵称
#define OTHERNICKNAME @"别人的昵称" // 别人的昵称
#define ICOURL @"http://image27.360doc.com/DownloadImg/2011/04/2015/11077777_5.png" // 头像url

/**
 *
 * APP TYPE
 *
 */
//IM
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IMACCOUNT @"IMACCOUNT"
#define IMPASSWORD @"IMPASSWORD"

//IM
#define APP_TYPE @"APP_TYPE"//Courier--快递端，User--用户端

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

#define FontColor [UIColor colorWithRed:76/255.0 green:176/255.0 blue:52/255.0 alpha:1.0]
#define NAVCOLOR [Utils colorWithHexString:@"6081C8"]
#define PNG_FROM_NAME(_PNGFILE)  ([UIImage imageNamed:_PNGFILE])

#define     Gift_PATH(_giftPic)                  [NSString stringWithFormat:@"%@/Documents%@", NSHomeDirectory(),_giftPic]

#define DEFAULTIMG [UIImage imageNamed:@"empty_photo.png"]
#define HEADTIMG [UIImage imageNamed:@"icon_moren"]

/**
 *
 * API相关
 *
 */
//本地服务器，测试服务器，正式服务器 打包必看
//正式服务器
#define HTTPType @"https" // @"http"
#define API_HOST @"hrssctest.wenhua407.top"
#define NEWAPI_HOST @"app.ccvzb.cn:8081/CCSC"

//测试服务器
//#define HTTPType @"http"
//#define API_HOST @"112.74.202.86:8080/CCVZB"

//上传图片前缀
#define PIC_UPDATE @"hrsscadmin.wenhua407.top"
//图片Url前缀
#define PIC_HOST  @"http://hrsscadmin.wenhua407.top/"//@"http://192.168.1.183:8081/"

#define POST_KEY_METHOD      @"POST"
#define INT_REQUEST_TIMEOUT 30
#define SAVERITEMS @"SAVERITEMS"
#define BACKPLAY_URL(id) [NSString stringWithFormat:@"http://beautycircle2016.ufile.ucloud.cn/%@.m3u8",id]// 拼接回放地址

#define HOST_PIC(url) [NSString stringWithFormat:@"%@%@",PIC_HOST,url]

#define isFirst @"isFirst"

//HR
#define Net [NetWork shareInstance]
#define CITYDATA @"CITYDATA"
#define SINGLECITY @"SINGLECITY"
// NSUserDefaults
#pragma mark-NSUserDefaults
#define GET_NSUSERDEFAULTS(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define SET_NSUSERDEFAULTS(key,value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define USERINFO @"USERINFO"
#define CACHE_FOLDER_NAME @"CACHE_FOLDER_NAME"
//HR


/**
 *
 * 支付相关
 *
 */
#define weChatKey @"wxe1ad5d72081a4e91"

#define AppScheme @"User"

#define PHONENUM @"PHONENUM"

//MJRefresh HIHT TEXT
#define     MJREFRESH_DOWN_Title1                   @"下拉刷新"
#define     MJREFRESH_DOWN_Title2                   @"释放刷新"
#define     MJREFRESH_DOWN_Title3                   @"正在刷新"

#define     MJREFRESH_UP_Title1                     @"上滑加载更多"
#define     MJREFRESH_UP_Title2                     @"释放刷新"
#define     MJREFRESH_UP_Title3                     @"正在加载"
#define     MJREFRESH_UP_Title4                     @"没有更多了"


/**
 * ***************************颜色相关*********************************
 */
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBCOLOR16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBACOLOR16(rgbValue) [UIColor colorWithRed:((float)(((rgbValue & 0xFF000000) >> 16) >>8))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00)>>8))/255.0 alpha:(float)(rgbValue & 0xFF)/255.0]
#define colorFrom16RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define DEFAULTCOLOR [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]
#define HKTITLECOLOR [UIColor colorWithRed:34/255.0 green:170/255.0 blue:238/255.0 alpha:1.0]
#define PINK [UIColor colorWithRed:242/255.0 green:72/255.0 blue:135/255.0 alpha:1]
#define PURPLE [UIColor colorWithRed:234/255.0 green:58/255.0 blue:242/255.0 alpha:1]
#define YELLOW [UIColor colorWithRed:242/255.0 green:136/255.0 blue:59/255.0 alpha:1]



/**
 * AppDelegate
 */
#define MyAppDelegate	 [UIApplication sharedApplication].delegate
#define kTabBarHeight 50.0f//tabbar高度
//屏幕状态栏高
#define SCREEN_STATUS  20
//屏幕导航条高
#define SCREEN_NAVIGATION_HEIGHT 44
#define SCREEN_STATUS_NAVIGATION 64



#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define IOS7_SDK_AVAILABLE 1
#endif
