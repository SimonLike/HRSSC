
//
//  HRCommonWebVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/11.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRCommonWebVC.h"

@interface HRCommonWebVC ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *comWebView;

@end

@implementation HRCommonWebVC

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (self.link) {
        [self.comWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.link]]];
    }else{
        
        [Net HelpDetial:[Utils readUser].token Qid:self.qid CallBack:^(BOOL isSucc, NSDictionary *info) {
            if (isSucc) {
                [self.comWebView loadHTMLString:info[@"data"][@"question"][@"content"] baseURL:nil];
                self.title = info[@"data"][@"question"][@"title"];
            }
        } FailBack:^(NSError *error) {
            
        }];
    }
    // Do any additional setup after loading the view.
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [SVProgressHUD show];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
