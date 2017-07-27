//
//  MBHud.m
//  Sexduoduo
//
//  Created by ly1992 on 15/6/2.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "MBHud.h"
#import "MBProgressHUD.h"

@implementation MBHud

//+ (id)showInView:(UIView *)aView withTitle:(NSString *)title
//{
//    [MBProgressHUD hideAllHUDsForView:aView animated:NO];
//    return [self showMessag:title toView:aView];
//}

+ (BOOL)removeFromView:(UIView *)aView
{
    [MBProgressHUD hideAllHUDsForView:aView animated:NO];
    __block BOOL flag = NO;
    [aView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[MBHud class]])
        {
            MBHud *hud = (MBHud *) obj;
            [hud removeFromSuperview];
            flag = YES;
            *stop = YES;
        }
    }];
    return flag;

}

+ (void)showMessag:(NSString *)message toView:(UIView *)view toBool:(BOOL)isResign{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
  
    hud.detailsLabelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    hud.mode = MBProgressHUDModeText;
    hud.opacity = 0.8;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [hud hide:YES];
        if (isResign) {
            
            [view endEditing:YES];
        }
    });
}


@end
