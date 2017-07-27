//
//  Utils.h
//  XQExpressCourier
//
//  Created by xf.lai on 14/8/11.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Global.h"
#import "MBProgressHUD.h"
#import "XQTipInfoView.h"
#import "UScrollView.h"
#import "MJRefresh.h"
//#import "NodataView.h"
//#import "Location.h"
//Model
#import "UserVO.h"
#import "HRCityVO.h"
#import "HRHomeInfoVO.h"
#import "HRScoreProductVO.h"
#import "HRDealVO.h"
#import "HRProdetialVO.h"
#import "OrderListVO.h"
#import "OrderDetialVO.h"
#import "HRSericeVO.h"
#import "HRUserInfoVO.h"
#import "HRAddVO.h"
#import "HRFQVO.h"
#import "HRSQVO.h"
#import "HRAddressVO.h"
#import "HRMsgVO.h"
//Model
#import "SDWebImageManager.h"
//#import "UIImageView+AFNetworking.h"
//#import "UIButton+AFNetworking.h"
#import "MKNetworkKit.h"
//#import "Location.h"
//NetWork
#import "RDVTabBarController.h"
#import "NetWork.h"
#import "XQUploadHelper.h"
#import "SJAvatarBrowser.h"
#import "MJExtension.h"
#import "JDStatusBarNotification.h"
//hql

typedef enum{
    Gift_Boat = -106,
    Gift_Kiss = -105,
    Gift_Lamborghini_1 = -104,
    Gift_Lamborghini_2 = -103,
    Gift_Arrow = -102,
    Gift_Plane = -101,
    Gift_Ferrari = -100,
} GiftType;

typedef enum{
    Video_Focus = 1,
    Video_Hot,
    Video_New,
    Video_Chan,
} VideoType;

typedef enum{
    Pick_Area,
    Pick_Item,
    Pick_Time,
    Pick_City,
} PickType;

typedef enum{
    Wait_NONE,
    Wait_WAIT,
    Wait_PRICE,
} Wait_Type;

typedef enum{
    Tab_1 = 0,
    Tab_2,
    Tab_3,
    Tab_4,
} Tab_type;

typedef enum{
    Staff_Edit,
    Staff_New,
} StaffType;

typedef enum{
    Pic_ALL = 1,
    Pic_OUT,
    Pic_INSIDE,
} PicType;

typedef enum{
    House_Online,
    House_Offline,
} House_Type;

typedef enum{
    Login_Mine,
    Login_Detial,
} Login_Type;

typedef enum{
    Comment_ALL = 1,
    Comment_GOOD,
    Comment_BAD,
} CommentType;


typedef enum{
    PayScreen_Normal,
    PayScreen_Order,
} PayScreen_Type;

typedef enum{
    Pay_All = 1,
    Pay_OnLine,
    Pay_OutLine,
} Pay_Type;

typedef enum{
    Date_First,
    Date_Second,
} Date_Type;

typedef enum{
    Order_Wait = 0,
    Order_Ing,
    Order_Over,
    Order_Finish,
} OrderType;

typedef enum{
    Friend_New,
    Friend_Edit,
} FriendType;

typedef enum{
    Sort_Star,
    Sort_Money,
    Sort_Area,
    Sort_Key,
} SortType;


typedef enum{
    NearBy_Normal,
    NearBy_Server,
    NearBy_Search,
} NearByType;

typedef enum{
    CustomButtonType_Back,
    CustomButtonType_Back2,
    CustomButtonType_Text,
    CustomButtonType_Text2,
    CustomButtonType_long,
    CustomButtonType_Delete,
    CustomButtonType_Share,
    CustomButtonType_Collection,
    CustomButtonType_Search,
    CustomButtonType_Mine,
    CustomButtonType_More,
    CustomButtonType_UserCenter,
    CustomButtonType_rightlong,
    CustomButtonType_leftlong,
} CustomButtonType;

typedef enum {
    UserInfoType_name = 100,
    UserInfoType_phoneNum,
    UserInfoType_sex,
    UserInfoType_birthday,
    UserInfoType_carInfo,
    UserInfoType_carNum,
    UserInfoType_pwd,
    
}UserInfoType;

typedef enum {
    NetworkType_NotReachable=0,
    NetworkType_WWAN,
    NetworkType_Wifi,
}NetworkType;

@interface Utils : NSObject

+ (UIImage*)createImageWithColor:(UIColor*) color;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (void)showMSG:(NSString*)msg;

+ (BOOL)NetStatus:(NSDictionary*)infoDic;

+ (BOOL)TokenOutDate:(NSDictionary*)infoDic;
+ (void)creatBackItemNIL:(UIViewController*)vc Selector:(SEL)selector;
+ (void)creatBackItem:(UIViewController*)vc Selector:(SEL)selector;

+(void)setupRefresh:(UIScrollView*)scrollView WithDelegate:(id)delegate HeaderSelector:(SEL)headSelector FooterSelector:(SEL)footSelector;
//HQL
+(NSString *)ret32bitString;
+ (NSAttributedString*)getLabelAttributedWithString:(NSString *)aStr font:(UIFont *)aFont;


+ (NSString*)getTimeCounter:(NSString*)exStr;

+ (NSString*)getStrFromArray:(NSMutableArray*)ary;

+ (Tab_type)getTabType;

//+ (UserVO*)getUserInfo;

+ (NSString*)getAccount;

+ (NSString*)getPsw;

+ (CLLocationDistance)getTheDistance:(CLLocationCoordinate2D)oriLoc DisLoc:(CLLocationCoordinate2D)dicloc;
+ (CLLocationCoordinate2D)getThelocation;
+ (NSString*)getCity;
+ (void)archiveCity:(NSString *)city;

+ (NSString*)getLat;
+ (NSString*)getLng;

+ (NSString*)getLoginStatue;
+ (NSString*)getMyToken;
+ (NSString*)getMyId;
+ (NSString*)getMyPhoneNum;
+(UIImage*)getSubImage:(UIImage *)image mCGRect:(CGRect)mCGRect centerBool:(BOOL)centerBool;
//+ (XQUserVO*)readUnarchiveUserVO;
//+ (void)archiveUserVO:(XQUserVO*)aVO;
+ (NetworkType)getCurrentNetworkType;
+ (BOOL)getBoolOfShowImgOnlyInWifi;

+ (CGFloat)heightOfText:(NSString *)text theWidth:(float)width theFont:(UIFont*)aFont;
+ (CGFloat)widthOfText:(NSString *)text theHeight:(float)height theFont:(UIFont*)aFont;
+ (void)showTipViewWhenFailed:(NSError *)error;
+ (BOOL)isIOSVersion7;
+ (UIImage *)stretchableImage:(UIImage *)oriImg;
+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *) colorWithHexStringWithAlpha: (NSString *) stringToConvert Alpha:(float)alpha;
+ (void)cornerView:(UIView *)aView withRadius:(CGFloat)aR borderWidth:(CGFloat)aB borderColor:(UIColor*)aColor;
+ (void)setNavBarBgUI:(UINavigationBar*)navBar;
+ (void)setNavBarBgWhite:(UINavigationBar*)navBar;
+ (UIButton*)createButtonWith:(CustomButtonType)aType text:(NSString *)title;
+ (NSDateFormatter *)dateFormatterForDate;
+ (NSDateFormatter *)dateFormatterForDateAndTime;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;
+ (long long)getLongNumFromDateStr:(NSString *)aStr;//1994-12-12 --- ms
//HQL
+ (NSDate*)getDateFromStrHMS:(NSString*)aStr;
+ (NSDate*)getDateFromStr:(NSString*)aStr;
+ (NSDate*)getMonthDateFromStr:(NSString*)aStr;
+ (NSString*)getStrFromDate:(NSDate*)date;
+ (NSString*)getMonthStrFromDate:(NSDate*)date;
+ (NSDate *)nextDay:(NSDate *)date calender:(NSCalendar*)calen space:(int)inter type:(int)Type;
//HQL
+ (long long)getLongNumFromDateAndTimeStr:(NSString *)aStr;//1994-12-12 12:00 --- ms
+ (long long)getLongNumFromDate:(NSDate *)date;
+ (long long)getLLongNumFromDate:(NSDate *)date;//ADDED By HQL 2014/10/31
+ (NSString*)getTimeFromLongNumStrDate:(NSString*)aNumStr;//ADDED By HQL 2014/10/31
+ (NSString*)getTimeFromLongNumStr:(NSString*)aNumStr;//ms --- 1994-12-12 12:00
+ (NSString*)getDateFromLongNumStr:(NSString*)aNumStr;//ms --- 1994-12-12
+ (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)aSize;
+ (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize ;
+ (UIImage *) croppedPhotoWithCropRect:(UIImage *)aImage toFrame:(CGRect)aFrame;
+ (NSString *)getImagePathWithName:(NSString *)imgName;
+ (BOOL)judgeUrlString:(NSString *)aStr;

+ (NSString *)getDicDataByKey:(NSDictionary *)dic key:(NSString *)strKey;

//存储、读取个人数据
+ (UserVO *)readUser;
+ (void)archiveUser:(UserVO *)aVOsAry;
//存储、读取城市数据
+ (NSArray *)readCityData;
+ (void)archiveCityData:(NSArray *)aVOsAry;


//+ (void)cashImage:(NSArray*)ary;
+ (UIImage*)getCashImage:(NSString*)url;

//获取缓存文件夹路径
+  (NSString* )pathInCacheDirectory:(NSString *)fileName;
//创建缓存文件夹
+ (BOOL) createDirInCache:(NSString *)dirName;
// 删除图片缓存
+ (BOOL) deleteDirInCache:(NSString *)dirName;
// 图片本地缓存
+ (BOOL) saveImageToCacheDir:(NSString *)directoryPath  image:(UIImage *)image imageName:(NSString *)imageName imageType:(NSString *)imageType;
// 获取缓存图片
+ (NSData*) loadImageData:(NSString *)directoryPath imageName:( NSString *)imageName;
// 删除所有图片缓存
+ (BOOL)deleteAllImageCache;
// 对数字字符串处理（万，百万）
+(NSString *)tenK:(NSString *)str;


@end
