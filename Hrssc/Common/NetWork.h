//
//  NetWork.h
//  Hotel
//
//  Created by S on 15-7-7.
//  Copyright (c) 2015年 UU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWork : NSObject
{
    MBProgressHUD* p_progressHUD;
}

+ (NetWork*)shareInstance;
- (void)showHud;
- (void)disMisHud;


#pragma mark - HR基础接口
//版本更新
- (void)Version:(int)type CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//登录
- (void)Login:(int)type Account:(NSString*)account Password:(NSString*)password Mac:(NSString*)mac Version:(NSString*)version Login_way:(NSString*)login_way CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

- (void)moaLogin:(NSString*)account Name:(NSString*)name Mac:(NSString*)mac Version:(NSString*)version Login_way:(NSString*)login_way CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//登出
- (void)LoginOut:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//发送短信
- (void)sendAuthPhone:(NSString*)phone CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//修改密码
- (void)ModifyPSW:(NSString*)token OldPassword:(NSString*)oldPassword NewPassword:(NSString*)newPassword CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//忘记密码第一步
- (void)ForgetPSW1:(NSString*)account Phone:(NSString*)phone CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//忘记密码第二步
- (void)ForgetPSW2:(NSString*)account Phone:(NSString*)phone Code:(NSString*)code NewPassword:(NSString*)newPassword CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark-banner
- (void)GetBanner:(NSString*)token Location:(int)location CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark-首页
//获取城市信息
- (void)CityInfo:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取首页信息
- (void)HomeInfo:(NSString*)token City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//待我办理（即合同签订）status：0-待签署  1-待盖章  2-已撤销  3-已完成
- (void)WaitingDeal:(NSString*)token Status:(int)status Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查询合同详情
- (void)ContractInfo:(NSString*)token Id:(int)id CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//选择签署合同方式
- (void)ContractWay:(NSString*)token Id:(int)id Sign_way:(int)sign_way CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;



//获取咨询分类
- (void)NewsClass:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//分类咨询列表
- (void)NewsClassList:(NSString*)token Cid:(int)cid City:(NSString*)city Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取资讯详情
- (void)NewsById:(NSString*)token Nid:(int)nid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark-业务办理
//获取全部一级业务
- (void)Category1:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取全部二级业务
- (void)Category2:(NSString*)token Cid:(int)cid City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取某个二级业务的全部模板(适用证明类表单)
- (void)Templates:(NSString*)token Cid2:(int)cid2 City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//提交申请（适用证明类、学位证明、工卡照片、预约入职）
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
           CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取某个二级业务的基础信息（官方网站，体检、报到地址，联系人，联系方式）
- (void)GetWebsite:(NSString*)token Cid:(int)cid Cid2:(int)cid2 City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取某个二级业务的办理说明（适用学位证明、工卡照片、预约入职）
- (void)GetLink:(NSString*)token Cid2:(int)cid2 City:(NSString*)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark--社保公积金
//首次加载个人社保
- (void)SocialSecurityFirst:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//根据时间查询个人社保
- (void)SocialSecurityByDate:(NSString*)token QryDate:(NSString*)qryDate CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取个人公积金缴交列表
- (void)GetPublicFunds:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//获取个人最新公积金
- (void)PublicFundFirst:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查看社保历史记录
- (void)SocialSecurityDate:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查询体检结果
- (void)HealthCheck:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark-我的申请
//我的申请列表接口
- (void)GetApplys:(NSString*)token Status:(int)status Search:(NSString*)search Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//确认领取
- (void)Gain:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//删除业务
- (void)DeleteBusines:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//批量删除业务
- (void)BatchDeleteBusiness:(NSString*)token Aids:(NSString *)aids CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查询业务详情
- (void)FindApplyDetail:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

// 查询某个城市的某个二级业务的全部模板
- (void)ApplyTemplates:(NSString*)token Cid2:(int)cid2 City:(NSString *)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查询某个城市的自取地址列表
- (void)SelfHelpAddress:(NSString*)token City:(NSString *)city CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark-评价
//获取评价标签接口
- (void)EvaluateTags:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//提交评价接口
- (void)EvaluateApply:(NSString*)token
                  Aid:(int)aid
                Star1:(int)star1
                Star2:(int)star2
             Comment1:(NSString *)comment1
             Comment2:(NSString *)comment2
                  Tag:(NSString *)tag
             CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark-积分商城
//积分商城商品
- (void)ScoreProducts:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查询商品详情
- (void)productDetial:(NSString*)token Pid:(int)pid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//OrderList
- (void)OrderList:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//OrderDetial
- (void)OrderDetial:(NSString*)token OrderId:(int)orderId  CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//兑换商品
- (void)ScoreToProduct:(NSString*)token Count:(int)count Pid:(int)pid Aid:(int)aid  CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

#pragma mark-个人中心
//个人基本信息
- (void)UserInfo:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//个人详细信息
- (void)UserDetialInfo:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//快捷服务列表
- (void)ServiceList:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//帮助中心
- (void)HelpCenter:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//根据分类/关键词  获取问题列表
- (void)HelpList:(NSString*)token Search:(NSString*)search Cid:(int)cid Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//根据id查询问题详情
- (void)HelpDetial:(NSString*)token Qid:(int)qid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//登录日志
- (void)Log:(NSString*)token StartTime:(NSString*)startTime EndTime:(NSString*)endTime Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//意见反馈
- (void)Feedback:(NSString*)token Title:(NSString*)title Content:(NSString*)content CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//添加收件地址
- (void)AddressAdd:(NSString*)token Name:(NSString*)name Phone:(NSString*)phone Prov:(NSString*)prov City:(NSString*)city Area:(NSString*)area Addr:(NSString*)addr CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//编辑收件地址
- (void)AddressEdit:(NSString*)token Aid:(int)aid Name:(NSString*)name Phone:(NSString*)phone Prov:(NSString*)prov City:(NSString*)city Area:(NSString*)area Addr:(NSString*)addr CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//设置默认收件地址
- (void)AddressSet:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;
//删除收件地址
- (void)AddressDel:(NSString*)token Aid:(int)aid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查询收件地址
- (void)AddressGet:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;
//消息列表
- (void)InfoList:(NSString*)token Page:(int)page Rows:(int)rows CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//消息详情
- (void)InfoDetial:(NSString*)token Mid:(int)mid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//删除消息
- (void)InfoDel:(NSString*)token Mid:(int)mid CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查询未读消息数量
- (void)GetMessageCount:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//签到
- (void)Sign:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

//查看是否签到
- (void)SignOrNot:(NSString*)token CallBack:(void(^)(BOOL isSucc, NSDictionary* info))callBlock FailBack:(void(^)(NSError* error))failBlock;

@end
