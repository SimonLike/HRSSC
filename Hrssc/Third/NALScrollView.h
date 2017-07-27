//
//  NALScrollView.h
//  NorthAmericanLive
//
//  Created by Yang on 16/1/21.
//  Copyright © 2016年 NorthAmericanLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NALSlideScrollDelegate <NSObject>
@optional
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer;

@end

@interface NALScrollView : UIScrollView

@property (assign, nonatomic)   BOOL    isVideoScroll;
@property (nonatomic, assign) id<NALSlideScrollDelegate> leftSlideDelegate;

@end
