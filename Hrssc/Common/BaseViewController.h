//
//  BaseViewController.h
//  LRVideo
//
//  Created by Simon on 2017/1/19.
//  Copyright © 2017年 S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property(nonatomic,strong)UIButton *navBtnleft;
@property(nonatomic,strong)UIButton *navBtnRight;

@property (nonatomic,strong) UIView *navView;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong)UIView *downLine;
- (void)backAction;
- (void)rightAction;


//添加键盘通知
-(void)addKeyboardNotification;
//移除键盘通知
-(void)removeKeyboardNotification;

//键盘上弹
-(void)openKeyboard:(NSNotification *)notification;
//恢复键盘
-(void)closeKeyboard:(NSNotification *)notification;

-(CGRect)keyboardFrame:(NSNotification *)notification;
-(NSTimeInterval)duration:(NSNotification *)notification;
-(UIViewAnimationOptions)option:(NSNotification *)notification;
@end
