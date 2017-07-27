//
//  NALNavigationController.h
//  NorthAmericanLive
//
//  Created by Yang on 16/1/21.
//  Copyright © 2016年 NorthAmericanLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NALScrollView.h"

@interface NALNavigationController : UINavigationController<NALSlideScrollDelegate>

@property (nonatomic, assign) BOOL canDragBack;

@end
