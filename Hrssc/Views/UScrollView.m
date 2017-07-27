//
//  UScrollView.m
//  User
//
//  Created by S on 15/8/14.
//  Copyright (c) 2015年 UU. All rights reserved.
//

#import "UScrollView.h"

@implementation UScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.superview touchesBegan:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
