//
//  AppDelegate.h
//  Hrssc
//
//  Created by admin on 17/4/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRLoginVC.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) HRLoginVC* loginViewController;
@property (strong, nonatomic) id RootViewVC;
- (void)switchLoginStatue:(BOOL)statue;
@end

