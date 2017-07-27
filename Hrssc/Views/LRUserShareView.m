//
//  LRUserShareView.m
//  LRVideo
//
//  Created by S on 16/5/31.
//  Copyright © 2016年 S. All rights reserved.
//

#import "LRUserShareView.h"

@implementation LRUserShareView

static LRUserShareView *CammerView = nil;

+ (LRUserShareView*)getInstanceWithNib {
    if (!CammerView) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"LRUserShareView" owner:nil options:nil];
        for(id obj in objs) {
            if([obj isKindOfClass:[LRUserShareView class]]){
                CammerView = (LRUserShareView *)obj;
                break;
            }
        }
    }
    return CammerView;
}

- (void)appear:(UIView*)hostView
{
    //    CGPoint carmeraCenter = [hostView convertPoint:hostView.center toView:MyAppDelegate.window];
    //    //CGPoint carmeraCenter = _cammeraBtn.center;
    //    carmeraCenter.y = carmeraCenter.y - 60 - 20;
    //    self.center = carmeraCenter;
    //CGRect rct = [[UIScreen mainScreen] bounds];
    self.frame = CGRectMake(SCREEN_WIDTH-118-37-8, SCREEN_HEIGHT-14-37-2-182, 85, 182);
    //self.center = hostView.center;
    [MyAppDelegate.window addSubview:self];
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.tag  = 1000;
    bgBtn.backgroundColor = [UIColor clearColor];
    bgBtn.frame = self.superview.bounds;
    [bgBtn addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.superview insertSubview:bgBtn belowSubview:self];
    [Utils cornerView:self withRadius:5 borderWidth:1 borderColor:[UIColor clearColor]];
    //self.alpha = 0;
    //bgBtn.alpha = 0;
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.1];
    self.alpha = 1;
    bgBtn.alpha = 1;
    //[UIView commitAnimations];
    
    //[((UIViewController*)self.delegate).view addSubview:self];
    self.transform = CGAffineTransformMakeScale(0., 0.);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1., 1.);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)actionCancel:(id)sender
{
    self.transform = CGAffineTransformMakeScale(1., 1.);
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0., 0.);
    } completion:^(BOOL finished) {
        
        UIButton *bgBtn = (UIButton *)[self.superview viewWithTag:1000];
        //self.alpha = 0;
        //bgBtn.alpha = 0;
        self.transform = CGAffineTransformMakeScale(1., 1.);
        [bgBtn removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (IBAction)share:(id)sender
{
    [self actionCancel:nil];
    UIButton* btn = sender;
    if(_delegate&&[_delegate respondsToSelector:@selector(shareType:)])
        [_delegate shareType:btn.tag - 100];
}

- (void)disMis
{
    UIButton *bgBtn = (UIButton *)[self.superview viewWithTag:1000];
    if (bgBtn) {
        [bgBtn removeFromSuperview];
    }
    @synchronized(self) {
        [self removeFromSuperview];
    }
}

@end
