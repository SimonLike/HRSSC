//
//  BGHelper.h
//  BeautyCircle
//
//  Created by 冉彬 on 16/5/23.
//  Copyright © 2016年 成都伟航创达科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserModel.h"

//#define USERINFO @"userInfor"

typedef enum ShareType
{
    ShareTypeWeibo = 0,          // 微博
    ShareTypeWeChart,            // 微信
    ShareTypeWechatTimeline,     // 朋友圈
    ShareTypeQQ,                 // qq
    ShareTypeQzone,              // qq空间
}ShareType;


typedef void (^shareBlock)(BOOL isSeccress);



@interface BGHelper : NSObject
// 设置圆角边框
+ (void)cornerView:(UIView *)aView withRadius:(CGFloat)aR borderWidth:(CGFloat)aB borderColor:(UIColor*)aColor;
//图片拉伸
+ (UIImage *)stretchableImage:(UIImage *)oriImg;

// 计算labelsize
+(CGSize)getSizeWithLabelFont:(UIFont *)font maxWidth:(CGFloat)width maxHigth:(CGFloat)higth text:(NSString *)text;


#pragma mark -数据转换

/*!
 * @brief 把字典转化为JSON格式的字符串
 * @param dic 字典
 * @return 返回JSON格式的字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// 32b随机名
+(NSString *)random32bitString;

//// 保存个人信息到本地
//+(void)setMine:(UserModel *)user;
//// 获取本地个人信息
//+ (UserModel *)getMine;

+ (void)setNavBarBgUI:(UINavigationBar*)navBar;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;

//获得设备型号
+ (NSString *)getCurrentDeviceModel;

@end
