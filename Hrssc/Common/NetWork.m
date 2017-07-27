 //
//  NetWork.m
//  Hotel
//
//  Created by S on 15-7-7.
//  Copyright (c) 2015年 UU. All rights reserved.
//

#import "NetWork.h"
#import "AppDelegate.h"

#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

@implementation NetWork
+ (NetWork*)shareInstance{
    static NetWork *__singletion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __singletion=[[NetWork alloc]init];
    });
    return __singletion;
}



- (void)showHud
{
    p_progressHUD.hidden = YES;
    [p_progressHUD removeFromSuperview];
    p_progressHUD = nil;
    p_progressHUD  = [[MBProgressHUD alloc] initWithView:MyAppDelegate.window];
    p_progressHUD.mode = MBProgressHUDModeIndeterminate;
    [MyAppDelegate.window addSubview:p_progressHUD];
    [p_progressHUD show:YES];
}

- (void)disMisHud
{
    p_progressHUD.hidden = YES;
    [p_progressHUD removeFromSuperview];
    p_progressHUD = nil;
}

- (BOOL)tokenOutDate:(NSDictionary*)infoDic Error:(NSError*)error
{
    if(!error&&[Utils TokenOutDate:infoDic])
    {
        //这里调用token失效跳转重新登录界面
        UserVO* uVO = [Utils readUser];
        uVO.token = @"";
        [Utils archiveUser:uVO];
        [(AppDelegate*)MyAppDelegate switchLoginStatue:NO];
        return YES;
    }
    else
        return NO;
}

- (void)HRNetStar:(NSString*)path Params:(NSMutableDictionary*)params CallBack:(void(^)(BOOL, NSDictionary*))callBlock FailBack:(void(^)(NSError*))failBlock
{
    MKNetworkHost *engine = [[MKNetworkHost alloc] initWithHostName:API_HOST Path:path];
    MKNetworkRequest *operation = [engine requestWithPath:nil params:params httpMethod:@"POST"];
    // 添加网络请求完成处理逻辑
    [operation addCompletionHandler:^(MKNetworkRequest *completedRequest) {
        if(completedRequest.state == MKNKRequestStateCompleted)
        {
            NSError *error;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[completedRequest responseData] options:NSJSONReadingMutableLeaves error:&error];
            if([self tokenOutDate:dic Error:error])
                return;
            if (!error&&[Utils NetStatus:dic])
                callBlock(YES,dic);
            else
            {
                if(dic[@"msg"])
                    [Utils showMSG:dic[@"msg"]];
                else
                    [Utils showMSG:@"网络错误"];
                callBlock(NO,nil);
            }
            //[self disMisHud];
        }
        else if(completedRequest.state == MKNKRequestStateError)
        {
            failBlock(completedRequest.error);
            [Utils showMSG:@"网络错误"];
            //[self disMisHud];
        }
        
    }];
    // 发送网络请求
    [engine startRequest:operation];
}

#pragma mark-HR基础接口

//版本更新
- (void)Version:(int)type CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBasicController/getVersion"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(type) forKey:@"type"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//登录
- (void)Login:(int)type Account:(NSString*)account Password:(NSString*)password Mac:(NSString*)mac Version:(NSString*)version Login_way:(NSString*)login_way CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscLoginController/userLogin"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:account forKey:@"account"];
    [params setObject:password forKey:@"password"];
    [params setObject:@"" forKey:@"mac"];
    [params setObject:@"1.0.0" forKey:@"version"];
    [params setObject:@"ios" forKey:@"login_way"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
- (void)moaLogin:(NSString*)account Name:(NSString*)name Mac:(NSString*)mac Version:(NSString*)version Login_way:(NSString*)login_way CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscLoginController/userLoginMOA"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:account forKey:@"account"];
    [params setObject:name forKey:@"name"];
    [params setObject:@"" forKey:@"mac"];
    [params setObject:@"1.0.0" forKey:@"version"];
    [params setObject:@"ios" forKey:@"login_way"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//登出
- (void)LoginOut:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscLoginController/userLoginOut"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
//发送短信/
- (void)sendAuthPhone:(NSString*)phone CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscBasicController/sendAuthCode"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//修改密码
- (void)ModifyPSW:(NSString*)token OldPassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscLoginController/updatePassword"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:newPassword forKey:@"newPassword"];
    [params setObject:oldPassword forKey:@"oldPassword"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//忘记密码第一步
- (void)ForgetPSW1:(NSString*)account Phone:(NSString*)phone CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscLoginController/forgetPassword1"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    [params setObject:account forKey:@"account"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//忘记密码第二步
- (void)ForgetPSW2:(NSString*)account Phone:(NSString*)phone Code:(NSString*)code NewPassword:(NSString*)newPassword CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscLoginController/forgetPassword2"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:phone forKey:@"phone"];
    [params setObject:account forKey:@"account"];
    [params setObject:code forKey:@"code"];
    [params setObject:newPassword forKey:@"newPassword"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//忘记密码第二步
- (void)MassageGet:(NSString*)token Phone:(NSString*)phone CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscBasicController/sendAuthCode"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [params setObject:phone forKey:@"phone"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark-banner
- (void)GetBanner:(NSString*)token Location:(int)location CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscHomePageController/getBanner"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(location) forKey:@"location"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark-首页
//获取城市信息
- (void)CityInfo:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscBasicController/getCitys"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:token forKey:@"token"];
    [params setObject:@(rows) forKey:@"rows"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//获取首页信息
- (void)HomeInfo:(NSString*)token City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscHomePageController/getBannerAndNews"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:city forKey:@"city"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//待我办理（即合同签订）
- (void)WaitingDeal:(NSString*)token Status:(int)status Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscContractController/findMyContract"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(status) forKey:@"status"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
    //数据接口反馈HRDealVO对象
}

//查询合同详情
- (void)ContractInfo:(NSString*)token Id:(int)id CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscContractController/findContractFlowById"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(id) forKey:@"id"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
    //数据接口反馈HRDealVO对象
}

//选择签署合同方式
- (void)ContractWay:(NSString*)token Id:(int)id Sign_way:(int)sign_way CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscContractController/signContractFlow"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(id) forKey:@"id"];
    [params setObject:@(sign_way) forKey:@"sign_way"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}



//获取咨询分类
- (void)NewsClass:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscNewsController/getNewClass"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//分类咨询列表
- (void)NewsClassList:(NSString*)token Cid:(int)cid City:(NSString*)city Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscNewsController/getNewsByClass"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cid) forKey:@"cid"];
    [params setObject:city forKey:@"city"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//获取资讯详情
- (void)NewsById:(NSString*)token Nid:(int)nid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscNewsController/getNewsById"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(nid) forKey:@"nid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark-业务办理
//获取全部一级业务
- (void)Category1:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getCategory1"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//获取全部二级业务
- (void)Category2:(NSString*)token Cid:(int)cid City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getCategory2"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cid) forKey:@"cid"];
    [params setObject:city forKey:@"city"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
//获取某个二级业务的全部模板(适用证明类表单)
- (void)Templates:(NSString*)token Cid2:(int)cid2 City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getTemplates"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cid2) forKey:@"cid2"];
    [params setObject:city forKey:@"city"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//提交申请（适用证明类、学位证明、工卡照片、预约入职）
/*
 token	String	Y	token
 type	int	Y	0-保存草稿  1-提交申请
 city	String	Y	城市名称
 cid2	int	Y	二级业务id
 get_way	int	N	文档领取方式（0-自取 1-邮寄 2-打印）
 address	String	N	自取地址名称
 address_info	String	N	自取地址详情
 recipient	String	N	邮寄地址
 tpl_tid	Integet	N	模板id
 tpl_form	String	N	填写的模板表单
 brief	String	N	描述
 comment	String	N	备注
 language	Integer	N	0-中文  1-英文
 images	String	N	图片，最多10张图片
 attachs	Stirng	N	附件，最多10个附件

 */
- (void)SubmitApply:(NSString*)token
               Type:(int)type
               City:(NSString*)city
               Cid2:(int)cid2
                Aid:(int)aid
            Get_way:(int)get_way
            Address:(NSString*)address
       Address_info:(NSString*)address_info
          Recipient:(NSString*)recipient
            Tpl_tid:(NSInteger)tpl_tid
           Tpl_form:(NSString*)tpl_form
              Brief:(NSString*)brief
            Comment:(NSString*)comment
           Language:(NSInteger)language
             Images:(NSString*)images
            Attachs:(NSString*)attachs
           CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/submitApply"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [params setObject:@(type) forKey:@"type"];
    [params setObject:city forKey:@"city"];
    [params setObject:@(cid2) forKey:@"cid2"];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:@(get_way) forKey:@"get_way"];
    [params setObject:address forKey:@"address"];
    [params setObject:address_info forKey:@"address_info"];
    [params setObject:recipient forKey:@"recipient"];
    [params setObject:@(tpl_tid) forKey:@"tpl_tid"];
    [params setObject:tpl_form forKey:@"tpl_form"];
    [params setObject:brief forKey:@"brief"];
    [params setObject:comment forKey:@"comment"];
    [params setObject:@(language) forKey:@"language"];
    [params setObject:images forKey:@"images"];
    [params setObject:attachs forKey:@"attachs"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

// 获取某个二级业务的基础信息（官方网站，体检、报到地址，联系人，联系方式）
- (void)GetWebsite:(NSString*)token Cid:(int)cid Cid2:(int)cid2 City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getWebsite"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cid) forKey:@"cid"];
    [params setObject:@(cid2) forKey:@"cid2"];
    [params setObject:city forKey:@"city"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
//获取某个二级业务的办理说明（适用学位证明、工卡照片、预约入职）
- (void)GetLink:(NSString*)token Cid2:(int)cid2 City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getLink"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cid2) forKey:@"cid2"];
    [params setObject:city forKey:@"city"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark--社保公积金
//首次加载个人社保
- (void)SocialSecurityFirst:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscSocialSecurityController/getSocialSecurityFirst"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//根据时间查询个人社保
- (void)SocialSecurityByDate:(NSString*)token QryDate:(NSString*)qryDate CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscSocialSecurityController/getSocialSecurityByDate"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:qryDate forKey:@"qryDate"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//获取个人公积金缴交列表
- (void)GetPublicFunds:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscSocialSecurityController/getPublicFunds"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//获取个人最新公积金
- (void)PublicFundFirst:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscSocialSecurityController/getPublicFundFirst"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查看社保历史记录
- (void)SocialSecurityDate:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscSocialSecurityController/getSocialSecurityDateWithTotalList"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查询体检结果
- (void)HealthCheck:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getHealthCheck"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark-我的申请
//我的申请列表接口
- (void)GetApplys:(NSString*)token Status:(int)status Search:(NSString*)search Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getApplys"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(status) forKey:@"status"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:search forKey:@"search"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
//确认领取
- (void)Gain:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/gain"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//删除单个业务
- (void)DeleteBusines:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/deleteBusiness"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
//批量删除业务
- (void)BatchDeleteBusiness:(NSString*)token Aids:(NSString *)aids CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/batchDeleteBusiness"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:aids forKey:@"aids"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查询业务详情
- (void)FindApplyDetail:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/findApplyDetail"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
// 查询某个城市的某个二级业务的全部模板
- (void)ApplyTemplates:(NSString*)token Cid2:(int)cid2 City:(NSString *)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getApplyTemplates"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(cid2) forKey:@"cid2"];
    [params setObject:city forKey:@"city"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查询某个城市的自取地址列表
- (void)SelfHelpAddress:(NSString*)token City:(NSString *)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getSelfHelpAddress"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:city forKey:@"city"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark-评价
//获取评价标签接口
- (void)EvaluateTags:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/getEvaluateTags"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//提交评价接口
- (void)EvaluateApply:(NSString*)token
                  Aid:(int)aid
                Star1:(int)star1
                Star2:(int)star2
             Comment1:(NSString *)comment1
             Comment2:(NSString *)comment2
                  Tag:(NSString *)tag
             CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscBusinessController/evaluateApply"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:@(star1) forKey:@"star1"];
    [params setObject:@(star2) forKey:@"star2"];
    [params setObject:comment1 forKey:@"comment1"];
    [params setObject:comment2 forKey:@"comment2"];
    [params setObject:tag forKey:@"tag"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark-积分商城
//积分商城商品
- (void)ScoreProducts:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscProductController/getProducts"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:token forKey:@"token"];
    [params setObject:@(rows) forKey:@"rows"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查询商品详情
- (void)productDetial:(NSString*)token Pid:(int)pid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscProductController/getProductById"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(pid) forKey:@"pid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//OrderList
- (void)OrderList:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    //[self showHud];
    NSString *path = [NSString stringWithFormat:@"hrsscProductController/getMyProductOrder"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}


//OrderDetial
- (void)OrderDetial:(NSString*)token OrderId:(int)orderId  CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscProductController/getOrderDetail"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(orderId) forKey:@"orderId"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//兑换商品
- (void)ScoreToProduct:(NSString*)token Count:(int)count Pid:(int)pid Aid:(int)aid  CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscProductController/exchangeProduct"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(count) forKey:@"count"];
    [params setObject:@(pid) forKey:@"pid"];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

#pragma mark-个人中心
//个人信息
- (void)UserInfo:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscUserController/getUserByToken"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//个人详细信息
- (void)UserDetialInfo:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscUserController/getMyInfo"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//快捷服务列表
- (void)ServiceList:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscInfoController/getAllServices"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//帮助中心
- (void)HelpCenter:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscHelpController/getHelpClass"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//根据分类/关键词  获取问题列表
- (void)HelpList:(NSString*)token Search:(NSString*)search Cid:(int)cid Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscHelpController/getQuestions"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(cid) forKey:@"cid"];
    [params setObject:search forKey:@"search"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//根据id查询问题详情
- (void)HelpDetial:(NSString*)token Qid:(int)qid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscHelpController/getQuestionDetail"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(qid) forKey:@"qid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//登录日志
- (void)Log:(NSString*)token StartTime:(NSString*)startTime EndTime:(NSString*)endTime Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscLoginController/getLoginLog"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:endTime forKey:@"endTime"];
    [params setObject:startTime forKey:@"startTime"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//意见反馈
- (void)Feedback:(NSString*)token Title:(NSString*)title Content:(NSString*)content CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscInfoController/feedback"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:title forKey:@"title"];
    [params setObject:content forKey:@"content"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//添加收件地址
- (void)AddressAdd:(NSString*)token Name:(NSString*)name Phone:(NSString*)phone Prov:(NSString*)prov City:(NSString*)city Area:(NSString*)area Addr:(NSString*)addr CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscInfoController/addAddress"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:token forKey:@"token"];
    [params setObject:prov forKey:@"prov"];
    [params setObject:city forKey:@"city"];
    [params setObject:area forKey:@"area"];
    [params setObject:addr forKey:@"addr"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//编辑收件地址
- (void)AddressEdit:(NSString*)token Aid:(int)aid Name:(NSString*)name Phone:(NSString*)phone Prov:(NSString*)prov City:(NSString*)city Area:(NSString*)area Addr:(NSString*)addr CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscInfoController/editAddress"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:name forKey:@"name"];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:token forKey:@"token"];
    [params setObject:prov forKey:@"prov"];
    [params setObject:city forKey:@"city"];
    [params setObject:area forKey:@"area"];
    [params setObject:addr forKey:@"addr"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//设置默认收件地址
- (void)AddressSet:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscInfoController/setDefaultAddress"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//删除收件地址
- (void)AddressDel:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscInfoController/deleteAddress"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(aid) forKey:@"aid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查询收件地址
- (void)AddressGet:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscInfoController/getMyAddress"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//消息列表
- (void)InfoList:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscMessageController/getMessages"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(rows) forKey:@"rows"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//消息详情
- (void)InfoDetial:(NSString*)token Mid:(int)mid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscMessageController/getMessageDetail"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(mid) forKey:@"mid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//删除消息
- (void)InfoDel:(NSString*)token Mid:(int)mid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscMessageController/deleteMessage"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@(mid) forKey:@"mid"];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查询未读消息数量
- (void)GetMessageCount:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscMessageController/getMessageCount"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//签到
- (void)Sign:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscUserController/sign"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}

//查看是否签到
- (void)SignOrNot:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock
{
    NSString *path = [NSString stringWithFormat:@"hrsscUserController/signOrNot"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:token forKey:@"token"];
    [self HRNetStar:path Params:params CallBack:callBlock FailBack:failBlock];
}
@end
