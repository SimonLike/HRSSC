//
//  HRScoreProVC.h
//  Hrssc
//
//  Created by admin on 17/4/26.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRScoreProVC : UIViewController
@property(nonatomic, strong) HRScoreProductVO* currentVO;
@property (nonatomic, assign) int pid;
@property (nonatomic, assign) int orderId;

@end
