//
//  AddsImageView.m
//  PZWToGetHer
//
//  Created by S on 15-2-9.
//
//

#import "AddsImageView.h"
//#import "RecommendViewController.h"
@implementation AddsImageView

- (void)addTap
{
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self addGestureRecognizer:singleRecognizer];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.frame;
    [btn addTarget:self action:@selector(adds:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)adds:(id)sender
{
    
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer*)recognizer
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
