//
//  AppDelegate.m
//  Hrssc
//
//  Created by admin on 17/4/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "AppDelegate.h"
#import "HRHomeVC.h"
#import "HRScoreVC.h"
#import "HRServiceVC.h"
#import "HRCenterVC.h"
#import "RDVTabBarItem.h"
#import "EMMSecurity.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

BMKMapManager* _mapManager;

@interface AppDelegate ()<RDVTabBarControllerDelegate,BMKGeneralDelegate,UIAlertViewDelegate,EMMSecurityVerifyDelegate>

@end

@implementation AppDelegate

- (void)setUpIM
{
    HOptions *option = [[HOptions alloc] init];
    option.appkey = @"1189170508115271#kefuchannelapp41119"; // 必填项，appkey获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
    option.tenantId = @"41119";// 必填项，tenantId获取地址：kefu.easemob.com，“管理员模式 > 设置 > 企业信息”页面的“租户ID”
    //推送证书名字
    //option.apnsCertName = @"your apnsCerName";//(集成离线推送必填)
    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
    HError *initError = [[HChatClient sharedClient] initializeSDKWithOptions:option];
    if (initError) { // 初始化错误
    }
}

- (void)imLogin
{
    HError *error = [[HChatClient sharedClient] registerWithUsername:@"SS" password:@"123"];
    if(error)
    {
        NSLog(@"%i",error.code);
    }
    else
    {
        NSLog(@"注册成功");
    }
    HChatClient *client = [HChatClient sharedClient];
    if (client.isLoggedInBefore != YES) {
        HError *error = [client loginWithUsername:@"SS" password:@"123"];
        if (!error) { //登录成功
        } else { //登录失败
            return;
        }
    }
}

- (void)switchLoginStatue:(BOOL)statue
{
    if(statue)
    {
        self.window.rootViewController = [self setupViewControllers];
        [self.window makeKeyAndVisible];
    }
    else
    {
        self.loginViewController = [[HRLoginVC alloc] initWithNibName:@"HRLoginVC" bundle:nil];
        NALNavigationController *navVC1 = [[NALNavigationController alloc]initWithRootViewController:self.loginViewController];
        [Utils setNavBarBgUI:navVC1.navigationBar];
        self.window.rootViewController = navVC1;
        [self.window makeKeyAndVisible];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //单点登录
    /* 
     * 报错不能运行时 查看Third/HRSinglePoint
     * 我只提示下，被坑了半个小时。。。
     * 下位接手者你也欣赏下啊  A00262
     */
    [[EMMSecurity share] applicationLaunchingWithAppId:@"A00262"];
    [EMMSecurity share].delegate = self;
    
    [self setUpIM];//初始化IM
    [self imLogin];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        DLog(@"经纬度类型设置成功");
    } else {
        DLog(@"经纬度类型设置失败");
    }
    
    BOOL ret = [_mapManager start:@"1hT8FEEjBiGyYQBj9q7ldQgi8KdL0AAz" generalDelegate:self];
//    BOOL ret = [_mapManager start:@"dFbQeUKh7PjuTtDyeOzBImtQp4QsRaF0" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    if(![Utils readUser].token)
    {
        self.loginViewController = [[HRLoginVC alloc] initWithNibName:@"HRLoginVC" bundle:nil];
        NALNavigationController *navVC1 = [[NALNavigationController alloc]initWithRootViewController:self.loginViewController];
        [Utils setNavBarBgUI:navVC1.navigationBar];
        _RootViewVC = navVC1;
        self.window.rootViewController = navVC1;
        [self.window makeKeyAndVisible];
    }else{
        [self switchLoginStatue:YES];
    }
    
    //异步处理版本更新
    dispatch_async(dispatch_get_main_queue(), ^{
        [Net Version:1 CallBack:^(BOOL isSucc, NSDictionary *info) {
            if (isSucc) {
                NSDictionary *dict = info[@"data"][@"version"];
                NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                
                NSString *ser_Version = [[dict valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"." withString:@""];
                NSString *sys_Version = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
                float ser_VersionF = [ser_Version floatValue];
                float sys_VersionF = [sys_Version floatValue];
                
                if (ser_VersionF > sys_VersionF) {//有版本要更新
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示更新" message:[dict valueForKey:@"comment"]  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认更新", nil];
                    [alert show];
                }
                
            }
        } FailBack:^(NSError *error) {
            
        }];
    });
    
    return YES;
}

#pragma mark - Methods

- (RDVTabBarController*)setupViewControllers {
    UIViewController *firstViewController = [HRHomeVC new];
    UINavigationController *firstNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:firstViewController];
    
    UIViewController *secondViewController = [HRScoreVC new];
    UINavigationController *secondNavigationController = [[UINavigationController alloc]
                                                           initWithRootViewController:secondViewController];
    
    UIViewController *thirdViewController = [HRServiceVC new];
    UINavigationController *thirdNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:thirdViewController];
    
    UIViewController *forthViewController = [HRCenterVC new];
    UINavigationController *forthNavigationController = [[UINavigationController alloc]
                                                          initWithRootViewController:forthViewController];
    
    
    [Utils setNavBarBgUI:firstNavigationController.navigationBar];
    [Utils setNavBarBgUI:secondNavigationController.navigationBar];
    [Utils setNavBarBgUI:thirdNavigationController.navigationBar];
    [Utils setNavBarBgUI:forthNavigationController.navigationBar];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    //if(!NET.isVIP)
    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
                                           thirdNavigationController,forthNavigationController]];
    [self customizeTabBarForController:tabBarController];
    tabBarController.delegate = self;
    
//    tabBarController.preferredStatusBarStyle= UIStatusBarStyleLightContent;
    
    return tabBarController;
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    tabBarController.view.backgroundColor = [UIColor blackColor];
    NSArray *tabBarItemImages = @[@"icon_home",@"icon_duihuan",@"icon_kefu", @"icon_wode"];
    NSArray *tabBarItemTitle = @[@"首页", @"积分兑换",@"客服", @"我的"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_h",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:tabBarItemTitle[index]];
        [item setSelectedTitleAttributes:@{
                                           NSFontAttributeName : [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName : [Utils colorWithHexString:@"1978CA"],
                                           }];
        [item setUnselectedTitleAttributes:@{
                                             NSFontAttributeName : [UIFont systemFontOfSize:12],
                                             NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                             }];
        index++;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[EMMSecurity share] applicationHandleOpenURL:url];
}
#pragma mark -- alertDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {//版本更新跳转App Store地址
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps ://"]];
    }
}
//- (void)goToLoginPage
//{
////    LoginViewController *loginControl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
////    self.window.rootViewController = loginControl;
////    [self.window makeKeyAndVisible];
//}

#pragma mark SecurityVerifyDelegate

/**
 *  安全认证失败
 *
 *  @param errorCode 错误码
 *
 *  TokenNotFound = 0   没有读取到token 如果是MOA需要跳转到登录界面，如果是其他程序自动跳转到MOA去登录
 *  TokenInvalidate     读取到token 校验后token失效
 *  EncryptionError     加密串校验失败
 *  PasswordError       用户名密码校验失败
 *
 *  @param errorMsg  错误提示语
 */
- (void)securityVerifyFailureWithCode:(NSInteger)errorCode errorMsg:(NSString *)errorMsg
{
//    if (errorCode == 0) {
//        [[EMMSecurity share] goToLoginPage];
//    }
    NSLog(@"securityVerifyFailure,errorCode =%ld,errorMsg = %@",(long)errorCode,errorMsg);
    
}

/**
 *  安全验证成功
 *
 *  @param verifyType (TokenVerify = 0,EncryptionVerify,PasswordVerify,SSOVerify)
 */
- (void)securityVerifySuccess:(NSInteger)verifyType
{
    NSLog(@"securityVerifySuccess verifyType = %ld",(long)verifyType);
    
//    UIAlertView *arl = [[UIAlertView alloc] initWithTitle: [EMMSecurity share].userId message:[EMMSecurity share].token delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
//    [arl show];
    if (verifyType == TokenVerify || verifyType == EncryptionVerify ||verifyType == SSOVerify) {


    }
}


@end
