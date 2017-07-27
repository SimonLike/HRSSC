
//
//  BaseViewController.m
//  LRVideo
//
//  Created by Simon on 2017/1/19.
//  Copyright © 2017年 S. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏的leftButton
    //
    self.navBtnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navBtnleft.frame =  CGRectMake(-10,  SCREEN_STATUS, SCREEN_NAVIGATION_HEIGHT, SCREEN_NAVIGATION_HEIGHT);
    [self.navBtnleft setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [self.navBtnleft addTarget: self action: @selector(backAction) forControlEvents: UIControlEventTouchUpInside];
    self.navBtnleft.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:self.navBtnleft];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //左边返回按钮向左边框偏移位置
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -15.0f;
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space, leftItem, nil];
    
    self.navBtnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navBtnRight.frame = CGRectMake(SCREEN_WIDTH - SCREEN_NAVIGATION_HEIGHT - 3, SCREEN_STATUS, SCREEN_NAVIGATION_HEIGHT, SCREEN_NAVIGATION_HEIGHT);
    [self.navBtnRight setImage:[UIImage imageNamed:@"navshow"] forState:UIControlStateNormal];
    [self.navBtnRight addTarget: self action: @selector(rightAction) forControlEvents: UIControlEventTouchUpInside];
    self.navBtnRight.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navBtnRight setTitleColor:RGBCOLOR16(0x333333) forState:UIControlStateNormal];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.navBtnRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navBtnRight.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)backAction{
    // 在这里增加返回按钮的自定义动作
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightAction{
    
    
}
//添加键盘通知
-(void)addKeyboardNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}
//移除键盘通知
-(void)removeKeyboardNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//键盘上弹
-(void)openKeyboard:(NSNotification *)notification{
    CGRect keyboardFrame = [self keyboardFrame:notification];
    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];

    DLog(@"xxx-->%f",keyboardFrame.size.height);
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}
//恢复键盘
-(void)closeKeyboard:(NSNotification *)notification{
    
    NSTimeInterval duration = [self duration:notification];
    UIViewAnimationOptions option = [self option:notification];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
}
-(CGRect)keyboardFrame:(NSNotification *)notification{
    return [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
}
-(NSTimeInterval)duration:(NSNotification *)notification{
    return [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
}
-(UIViewAnimationOptions)option:(NSNotification *)notification{
    return [notification.userInfo [UIKeyboardAnimationCurveUserInfoKey]intValue];
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
