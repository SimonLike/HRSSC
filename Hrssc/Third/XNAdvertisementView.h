//
//  XNAdvertisementView.h
//  NeighBour
//
//  Created by S on 15/09/29.
//  Copyright © 2015年 S. All rights reserved.
//
//
//
//
//
//                                <-- XNAdvertisementView -->
//  1.可通过[XNAdvertisementView isExistsAdvertisementData]检测沙盒中是否存在广告数据,存在则进行第2步
//  1.直接调用[XNAdvertisementView showLoadingView],自动检测是否存在广告数据,如果存在则显示到Window上
//  2.在外部下载图片,然后调用saveAdvertisementImageAndActionUrl存储数据,下载前先通过isSametoLastData检测本次数据是否和上次相同




#import <UIKit/UIKit.h>
//#import "XNViewController.h"

@interface XNAdvertisementView : UIView
+ (BOOL)isExistsAdvertisementData;
+ (BOOL)isSametoLastData:(NSString *)imageUrl actionUrl:(NSString *)actionUrl;
+ (void)saveAdvertisementImageAndActionUrl:(UIImage *)image  imageUrl:(NSString *)imageUrl advertisementUrl:(NSString *)advertisementUrl;
+ (void)deleteAdvertisementData;
+ (void)showLoadingView;
@end

//@interface XNWebViewViewController : XNViewController
//@property (retain, nonatomic) UIWebView *webView;
//@property (retain, nonatomic) NSString *titleText;
//@property (retain, nonatomic) NSString *url;
//@end
