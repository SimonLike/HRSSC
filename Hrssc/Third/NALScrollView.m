//
//  NALScrollView.m
//  NorthAmericanLive
//
//  Created by Yang on 16/1/21.
//  Copyright © 2016年 NorthAmericanLive. All rights reserved.
//

#import "NALScrollView.h"

@implementation NALScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounces = NO;
        [self.panGestureRecognizer addTarget:self action:@selector(handlePanGesture:)];
    }
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)pangesture
{
    if (self.contentOffset.x <= 0) {
        if (self.leftSlideDelegate && [_leftSlideDelegate respondsToSelector:@selector(paningGestureReceive:)]) {
            [self.leftSlideDelegate paningGestureReceive:self.panGestureRecognizer];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (_isVideoScroll) {
        [super touchesBegan:touches withEvent:event];
//        POST_NOTIFICATION(@"VideoScrollViewDidTouched", nil);
    }
}

@end
