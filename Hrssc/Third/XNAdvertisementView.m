//
//  XNAdvertisementView.m
//  NeighBour
//
//  Created by S on 15/09/29.
//  Copyright © 2015年 S. All rights reserved.
//

#import "XNAdvertisementView.h"

#define     Advertisement_IMG_URL               @"startPageUrl"
#define     Advertisement_ACTION_URL            @"startPageAction"
#define     Advertisement_PATH                  [NSString stringWithFormat:@"%@/Documents/start_page.jpg", NSHomeDirectory()]
#define     Adv_TimeInterval                    3
@interface XNAdvertisementView() {
    NSString *actionUrl;
    NSString *imageUrl;
    UIImage  *image;
}
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIButton    *skipBtn;
@property (nonatomic, retain) NSTimer     *mTimer;
//@property (nonatomic, retain) NSString    *advertisementUrl;
@end

@implementation XNAdvertisementView

#pragma mark - XNAdvertisementView (传入Image和advertisementUrl,5秒后自动消失)
+ (void)showLoadingView {
    if([XNAdvertisementView isExistsAdvertisementData]) {
        XNAdvertisementView *loadingView = [[XNAdvertisementView alloc] init];
        [[UIApplication sharedApplication].delegate.window addSubview:loadingView];
    }
}

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, 0, XNSCREEN_WIDTH, XNSCREEN_HEIGHT)];
    if(self) [self initThisView];
    return self;
}

- (void)initThisView {
    //加载数据
    imageUrl  = [[NSUserDefaults standardUserDefaults] valueForKey:Advertisement_IMG_URL];
    actionUrl = [[NSUserDefaults standardUserDefaults] valueForKey:Advertisement_ACTION_URL];
    image = [UIImage imageWithContentsOfFile:Advertisement_PATH];
    
    //image = [UIImage imageNamed:@"2.jpg"];
    //测试数据
    
    //ImageView
    //UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoWebView)];
    self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imgView.image = image;
    self.imgView.userInteractionEnabled = YES;
    //[self.imgView addGestureRecognizer:touch];
    [self addSubview:self.imgView];
    
    //SkipButton
    self.skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(XNSCREEN_WIDTH-70, 25, 45, 26)];
    self.skipBtn.backgroundColor = [UIColor clearColor];
    [self.skipBtn addTarget:self action:@selector(dismissLoadingView) forControlEvents:(UIControlEventTouchUpInside)];
    [Utils cornerView:self.skipBtn withRadius:7 borderWidth:1 borderColor:[UIColor whiteColor]];
    [self.skipBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [self.skipBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
    [self addSubview:self.skipBtn];
    [self setupTimer];
}

- (void)setupTimer {
    self.mTimer = [NSTimer scheduledTimerWithTimeInterval:Adv_TimeInterval
                                                   target:self
                                                 selector:@selector(dismissLoadingView)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)stopTimer {
    if(self.mTimer) {
        [self.mTimer invalidate];
        self.mTimer = nil;
    }
}

- (void)dismissLoadingView {
    [self stopTimer];
    [UIView animateWithDuration:0.6f animations:^{
        self.alpha = 0.f;
        [self setTransform:CGAffineTransformMakeScale(1.5, 1.5)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)gotoWebView {
    [self stopTimer];
    //点击加入跳转
    
//    XNWebViewViewController *webVC = [[XNWebViewViewController alloc] init];
//    webVC.titleText = @"网页";
//    webVC.url = actionUrl;
//    [[self getCurrentVC] presentViewController:webVC animated:YES completion:^{
//        [self removeFromSuperview];
//        
//    }];
    
}

- (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}

//存储广告图片和图片链接
+ (void)saveAdvertisementImageAndActionUrl:(UIImage *)image  imageUrl:(NSString *)imageUrl advertisementUrl:(NSString *)advertisementUrl {
    if(!image || !advertisementUrl) return;
    [UIImagePNGRepresentation(image) writeToFile:Advertisement_PATH atomically:YES];
    [[NSUserDefaults standardUserDefaults] setValue:imageUrl forKey:Advertisement_IMG_URL];
    [[NSUserDefaults standardUserDefaults] setValue:advertisementUrl forKey:Advertisement_ACTION_URL];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//判断是否存在广告数据
+ (BOOL)isExistsAdvertisementData {
    NSString *lastStartImgUrl = [[NSUserDefaults standardUserDefaults] valueForKey:Advertisement_IMG_URL];
    NSString *lastStartImgAction = [[NSUserDefaults standardUserDefaults] valueForKey:Advertisement_ACTION_URL];
    BOOL isExistsimgFile = [[NSFileManager defaultManager] fileExistsAtPath:Advertisement_PATH];
    if(lastStartImgUrl && lastStartImgAction && isExistsimgFile) {
        return YES;
    }
    return NO;
    //return YES;//暂时每次都显示测试图片
}
//判断本次图片地址地址的跳转地址和上次是否一致
+ (BOOL)isSametoLastData:(NSString *)imageUrl actionUrl:(NSString *)actionUrl {
    NSString *lastStartImgUrl = [[NSUserDefaults standardUserDefaults] valueForKey:Advertisement_IMG_URL];
    NSString *lastStartImgAction = [[NSUserDefaults standardUserDefaults] valueForKey:Advertisement_ACTION_URL];
    if(lastStartImgUrl && lastStartImgAction &&
       [imageUrl isEqualToString:lastStartImgUrl] && [actionUrl isEqualToString:lastStartImgAction]) {
        return YES;
    }
    return NO;
}

+ (void)deleteAdvertisementData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Advertisement_IMG_URL];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:Advertisement_ACTION_URL];
    BOOL isExistsimgFile = [[NSFileManager defaultManager] fileExistsAtPath:Advertisement_PATH];
    if(isExistsimgFile) {
        NSFileManager * fileManager = [[NSFileManager alloc] init];
        [fileManager removeItemAtPath:Advertisement_PATH error:nil];
    }
}
@end

#pragma mark - XNWebViewViewController (点击广告图片后跳转到这里)
//@interface XNWebViewViewController() <UIWebViewDelegate>
//@property (nonatomic, assign) BOOL isLoadWebContentSucceeded;
//@end
//
//
//@implementation XNWebViewViewController
//
//- (void)viewDidLoad {
//    self.customNavigationBar = YES;
//    [super viewDidLoad];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//
//- (void)initSubViews {
//    [self setNavBackground:MCOLOR_STATUS];
//    [self.view setBackgroundColor:MCOLOR_BACKGROUND_F2F2F2];
//    [self setNaviTitle:self.titleText];
//    [self addNavigationBarBackButton:nil normal:IMAGENAME(DEFAULT_IMAGE_BACK_N) selected:IMAGENAME(DEFAULT_IMAGE_BACK_S)];
//    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, XNSCREEN_WIDTH, XNSCREEN_HEIGHT-64)];
//    _webView.delegate = self;
//    [self.view addSubview:_webView];
//    NSURL *nsurl = [NSURL URLWithString:_url] ;
//    NSURLRequest *request =[NSURLRequest requestWithURL:nsurl];
//    [_webView loadRequest:request];
//    [self showHUD];
//}
//
//- (void)ActionForBackButton:(UIButton *)button {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//#pragma - UIWebView Delegate
////当网页视图已经开始加载一个请求后，得到通知。
//-(void)webViewDidStartLoad:(UIWebView*)webView {
//    _isLoadWebContentSucceeded = YES;
//}
//
////当网页视图结束加载一个请求之后，得到通知。
//-(void)webViewDidFinishLoad:(UIWebView*)webView {
//    _isLoadWebContentSucceeded = YES;
//    [self hideHUD];
//}
//
////当在请求加载中发生错误时
//-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error {
//    _isLoadWebContentSucceeded = YES;
//    [self hideHUD];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self hideHUD];
//}
//
//@end
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


