//
//  HRSignWebViewVC.m
//  Hrssc
//
//  Created by Simon on 2017/6/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRSignWebViewVC.h"

@interface HRSignWebViewVC ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *sign_webView;

@end

@implementation HRSignWebViewVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sign_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height )];
    self.sign_webView.delegate = self;
    self.sign_webView.scalesPageToFit = YES;
    [self.view addSubview: self.sign_webView];
    
    NSURL *url = [NSURL URLWithString:[self.signUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.sign_webView loadRequest:request];

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSString *urlstr = request.URL.absoluteString;
        
        if ([urlstr isEqualToString:@"hrssc://appBack"]) {
            [self backAction];
        }
        DLog(@"urlstr-->%@",urlstr);
        return NO;
    }
    return YES;
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    DLog(@"---------开始加载--------");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    DLog(@"---------加载完成--------");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    DLog(@"---------加载失败--------");
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
