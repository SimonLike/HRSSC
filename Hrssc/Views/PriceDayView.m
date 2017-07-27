//
//  PriceDayView.m
//  Hotel
//
//  Created by S on 15/10/14.
//  Copyright © 2015年 UU. All rights reserved.
//

#import "PriceDayView.h"

@implementation PriceDayView
static PriceDayView *tipInfoView = nil;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (PriceDayView*)getInstanceWithNib {
    if (!tipInfoView) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"PriceDayView" owner:nil options:nil];
        for(id obj in objs) {
            if([obj isKindOfClass:[PriceDayView class]]){
                tipInfoView = (PriceDayView *)obj;
                break;
            }
        }
    }
    //tipInfoView.bounds = CGRectMake(0, 0, 320, 454);
    return tipInfoView;
}

- (void)appearWithTitle:(NSInteger)title Delegate:(id)de
{
    //CGRect rct = [[UIScreen mainScreen] bounds];
    self.delegate = de;
    self.perPrice = @"";
    self.moneyQLabel.text = @"";
    self.moneyBLabel.text = @"";
    self.moneySLabel.text = @"";
    self.moneyGLabel.text = @"";
    self.currentRow = title;
    [Utils cornerView:self.commitBtn withRadius:3 borderWidth:0 borderColor:[UIColor clearColor]];
    self.frame = CGRectMake((SCREEN_WIDTH-300)/2, 200, 300, 180);
    [MyAppDelegate.window addSubview:self];
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.tag  = 1000;
    bgBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
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
    self.currentRow = 0;
    //[UIView commitAnimations];
    
    //[((UIViewController*)self.delegate).view addSubview:self];
}

- (void)appearWithTitle:(NSString*)title Tip:(NSString*)tip CommitTitle:(NSString*)commitTitle Delegate:(id)de Row:(NSInteger)row
{
    //CGRect rct = [[UIScreen mainScreen] bounds];
    self.delegate = de;
    self.perPrice = @"";
    self.moneyQLabel.text = @"";
    self.moneyBLabel.text = @"";
    self.moneySLabel.text = @"";
    self.moneyGLabel.text = @"";
    self.tipLabel.text = title;
    self.tipTitle.text = tip;
    [self.commitBtn setTitle:commitTitle forState:UIControlStateNormal];
    //self.currentRow = title;
    [Utils cornerView:self.commitBtn withRadius:3 borderWidth:0 borderColor:[UIColor clearColor]];
    self.frame = CGRectMake((SCREEN_WIDTH-300)/2, 200, 300, 180);
    [MyAppDelegate.window addSubview:self];
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.tag  = 1000;
    bgBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
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
    self.currentRow = row;
    //[UIView commitAnimations];
    
    //[((UIViewController*)self.delegate).view addSubview:self];
}



- (IBAction)actionCancel:(id)sender
{
    UIButton *bgBtn = (UIButton *)[self.superview viewWithTag:1000];
    self.alpha = 0;
    bgBtn.alpha = 0;
    [bgBtn removeFromSuperview];
    [self removeFromSuperview];
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


- (IBAction)OK:(id)sender
{
    [self actionCancel:nil];
    if(_delegate&&[_delegate respondsToSelector:@selector(OKDayPress: Row:)])
        [_delegate OKDayPress:self.perPrice Row:_currentRow];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //NSLog(@"%lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
    //NSLog(@"%@",string);
    if([@"0123456789" rangeOfString:string].length == 0&&![string isEqualToString:@""])
        return NO;
    
    if([self.perPrice isEqualToString:@""])
        self.perPrice = string;
    else
    {
        NSString* str = self.perPrice;
        if(range.length == 0)
        {
            str = [str stringByAppendingString:string];
            if(str.length <= 4)
                self.perPrice = str;
            else
            {
                textField.text = self.perPrice;
                return NO;
            }
        }
        else
        {
            if(range.location != 0)
            {
                NSMutableString* str = [NSMutableString stringWithString:self.perPrice];
                [str deleteCharactersInRange:range];
                self.perPrice = str;
            }
            else
            {
                self.perPrice = @"";
            }
        }
    }
    
    
    switch (self.perPrice.length) {
        case 0:
            self.moneyQLabel.text = @"";
            self.moneyBLabel.text = @"";
            self.moneySLabel.text = @"";
            self.moneyGLabel.text = @"";
            break;
        case 1:
            self.moneyQLabel.text = @"";
            self.moneyBLabel.text = @"";
            self.moneySLabel.text = @"";
            self.moneyGLabel.text = self.perPrice;
            break;
        case 2:
            self.moneyQLabel.text = @"";
            self.moneyBLabel.text = @"";
            self.moneySLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:0]];
            self.moneyGLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:1]];
            break;
        case 3:
            self.moneyQLabel.text = @"";
            self.moneyBLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:0]];
            self.moneySLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:1]];
            self.moneyGLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:2]];
            break;
        case 4:
            self.moneyQLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:0]];
            self.moneyBLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:1]];
            self.moneySLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:2]];
            self.moneyGLabel.text = [NSString stringWithFormat:@"%c",[self.perPrice characterAtIndex:3]];
            break;
        default:
            break;
    }
    return YES;

    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
