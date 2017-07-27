//
//  UIView+Extend.h
//  ZJBDMIOS
//
//  Created by 转角街坊 on 16/1/26.
//  Copyright © 2016年 转角街坊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extend)

/**
 *常用属性参数
 **/
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat top;

@property (nonatomic) CGFloat right;

@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGFloat width;

@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;

@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;

@property (nonatomic) CGSize size;

- (id)initWithView:(UIView *)aView;

-(void)removeAllSubviews;
-(UIViewController*)viewController;

-(id)findViewParentWithClass:(Class)clazz;

- (void)debug;
- (void)debug:(BOOL)enable;

- (void)fuckBlur;

+ (id)loadFromXIB;
+ (id)loadFromXIBName:(NSString *)xibName;

+ (id)bolang;
+ (id)bolangForWindow;

@end
