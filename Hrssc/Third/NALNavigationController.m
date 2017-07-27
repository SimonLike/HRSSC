//
//  NALNavigationController.m
//  NorthAmericanLive
//
//  Created by Yang on 16/1/21.
//  Copyright © 2016年 NorthAmericanLive. All rights reserved.
//

#import "NALNavigationController.h"

@interface NALNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *screenShotsList;

@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) BOOL isPushing;

@end

@implementation NALNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.screenShotsList = [[NSMutableArray alloc] init];
        self.canDragBack = YES;
        self.delegate = self;
        self.isPushing = NO;
    }
    return self;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.navigationBar.translucent = NO;
    //UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, SCREEN_WIDTH, 0.5)];
    //sepLine.backgroundColor =  [Utils colorWithHexString:@"e7e7e7"];// colorFromHex(0xe7e7e7);
    //[self.navigationBar addSubview:sepLine];
    
//    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftside_shadow"]];
//    shadowImageView.frame = CGRectMake(-10, 0, 10, SCREEN_HEIGHT);
//    [self.view addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isPushing = YES;
    UIImage *image = [self capture];
    [super pushViewController:viewController animated:animated];
    if (image) {
        [self.screenShotsList addObject:image];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *controller = [super popViewControllerAnimated:animated];
    if (_screenShotsList.count > 0) {
        [self.screenShotsList removeLastObject];
    }
    
    return controller;
}

- (nullable NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    NSArray *controllers = [super popToRootViewControllerAnimated:animated];
    if (_screenShotsList.count>0) {
        [_screenShotsList removeAllObjects];
    }
    return controllers;
}

//- (void)setCanDragBack:(BOOL)canDragBack{
//    _canDragBack = canDragBack;
//}

#pragma mark - Utility Methods

- (UIImage *)capture
{
    UIWindow *screenWindow = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(screenWindow.bounds.size, self.view.opaque, 0.0);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)moveViewWithX:(float)x
{
    CGFloat originX = x > SCREEN_WIDTH? SCREEN_WIDTH : x;
    originX = x < 20 ? 0 : x;
    
    CGRect backFrame = _backgroundView.frame;
    backFrame.origin.x = -SCREEN_WIDTH/3 + x/3;
    _backgroundView.frame = backFrame;
    
    CGRect frame = self.view.frame;
    frame.origin.x = originX;
    self.view.frame = frame;
    
    float alpha = 0.4 - (originX / 800);
    blackMask.alpha = alpha;
}

#pragma mark - Gesture Recognizer

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack || _isPushing) return;
    
    CGPoint touchPoint = [recoginzer locationInView:[UIApplication sharedApplication].keyWindow];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        _isMoving = YES;
        startTouch = touchPoint;
        
        CGRect frame = self.view.frame;
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(-frame.size.width/3, 0, frame.size.width, frame.size.height)];
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        
        blackMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        blackMask.backgroundColor = [UIColor blackColor];
        [self.backgroundView addSubview:blackMask];
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        lastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
    }else if (recoginzer.state == UIGestureRecognizerStateEnded) {
        if (touchPoint.x - startTouch.x > 50) {
            [UIView animateWithDuration:0.15 animations:^{
                [self moveViewWithX:SCREEN_WIDTH];
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }else {
            [UIView animateWithDuration:0.15 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
                [self.backgroundView removeFromSuperview];
                self.backgroundView = nil;
            }];
        }
        return;
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled) {
        [UIView animateWithDuration:0.15 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
            [self.backgroundView removeFromSuperview];
            self.backgroundView = nil;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return _canDragBack;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isPushing = NO;
}
@end
