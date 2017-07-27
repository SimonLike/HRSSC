
//
//  HRWebViewVC.m
//  Hrssc
//
//  Created by Simon on 2017/5/9.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRWebViewVC.h"
#import "HRBankTemplateVC.h"
#import <QuickLook/QuickLook.h>


@interface HRWebViewVC ()<UIWebViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property (strong, nonatomic) UIWebView *hr_webView;

@end

@implementation HRWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.templatesObj.name) {
        self.title = self.templatesObj.name;
    }
    self.view.backgroundColor = RGBCOLOR(60, 60, 60);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navBtnRight.hidden = NO;
    self.navBtnRight.frame = CGRectMake(SCREEN_WIDTH - SCREEN_NAVIGATION_HEIGHT - 13, SCREEN_STATUS, SCREEN_NAVIGATION_HEIGHT + 10, SCREEN_NAVIGATION_HEIGHT);
    [self.navBtnRight setTitle:@"下一步" forState:UIControlStateNormal];

    self.hr_webView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 80, self.view.width - 40, self.view.height - 40 - SCREEN_STATUS_NAVIGATION)];
    self.hr_webView.delegate = self;
    self.hr_webView.scalesPageToFit = YES;
    [self.view addSubview: self.hr_webView];
    
    if ([self.typeUrl isEqualToString:@"showHetong"]) {//合同预览
        self.attachStr = [self.attachStr stringByReplacingOccurrencesOfString:@"doc" withString:@"html"];
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@",PIC_HOST,self.attachStr]  stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        [self.hr_webView loadRequest:request];

        self.navBtnRight.hidden = YES;
        
    }else if ([self.typeUrl isEqualToString:@"attach"]) {//附件显示
        NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@",PIC_HOST,self.attachStr]  stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.hr_webView loadRequest:request];
        [self.navBtnRight setTitle:@"打印" forState:UIControlStateNormal];
        
        //        QLPreviewController *previewController = [[QLPreviewController alloc] init];
        //        previewController.dataSource = self;
        //        previewController.delegate = self;
        //        previewController.currentPreviewItemIndex = 0;
        //
        //        [self presentViewController:previewController animated:YES completion:nil];
        
    }else if ([self.typeUrl isEqualToString:@"showNotR"]) {//显示内容
        self.navBtnRight.hidden = YES;
        [self.hr_webView loadHTMLString:self.templatesObj.template baseURL:nil];
    }else if ([self.typeUrl isEqualToString:@"signature"]) {//电子签章
        [self.navBtnRight setTitle:@"签名" forState:UIControlStateNormal];
        NSURL *url = [NSURL URLWithString:[self.signUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.hr_webView loadRequest:request];
//        [self.hr_webView loadHTMLString:self.templatesObj.template baseURL:nil];
    }else{//模板可填写
        [self.hr_webView loadHTMLString:self.templatesObj.template baseURL:nil];
    }
}

-(void)rightAction{
    
    if ([self.typeUrl isEqualToString:@"attach"]) {//附件显示  打印
        
    }else if ([self.typeUrl isEqualToString:@"signature"]) {//电子签章  签章
        
    }else{//模板可填写
        HRBankTemplateVC *vc = [[UIStoryboard storyboardWithName:@"HomeFunctions" bundle:nil] instantiateViewControllerWithIdentifier:@"HRBankTemplate"];
        vc.tpStr = self.templatesObj.form;
        vc.btBlock = ^(NSString *tpl_form) {
            if (self.tpBlock) {
                self.tpBlock(tpl_form);
            }
        };
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark - QLPreviewControllerDelegate
-(CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view
{
    //提供变焦的开始rect，扩展到全屏
    return CGRectMake(60, 200, 200, 200);
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}

- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx{
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@",PIC_HOST,self.attachStr] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    return url;
    
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
