//
//  TipInfoView.m
//  XQInstgClient
//
//  Created by iObitLXF on 5/31/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import "XQTipInfoView.h"

static XQTipInfoView *tipInfoView = nil;

@implementation XQTipInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+ (XQTipInfoView*)getInstanceWithNib {
    if (!tipInfoView) {
        NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"XQTipInfoView" owner:nil options:nil];
        for(id obj in objs) {
            if([obj isKindOfClass:[XQTipInfoView class]]){
                tipInfoView = (XQTipInfoView *)obj;
                break;
            }
        }
    }
    tipInfoView.bounds = CGRectMake(0, 0, 180, 70);
    return tipInfoView;
}

- (void)appear:(NSString*)strText {
    @synchronized(self) {
        NSInteger strLength = strText.length*15;
        if (strLength < 120) {
            strLength = 120;
        }
        if(strLength >220)
            strLength = 220;
        long rowNum = strLength/220 + 1;
        self.frame = CGRectMake((SCREEN_WIDTH-strLength)/2, 350, strLength, 35*rowNum);
        [Utils cornerView:self withRadius:4 borderWidth:0 borderColor:[UIColor clearColor]];
        infoLabel.text = strText;
        infoLabel.textColor =[UIColor whiteColor];//modify text color
        infoLabel.font = [UIFont boldSystemFontOfSize:14];
        infoLabel.frame = CGRectMake(0, 0, strLength, 35*rowNum);
        infoImageView.frame = CGRectMake(0, 0, 236, 56 + [Utils heightOfText:infoLabel.text theWidth:206 theFont:infoLabel.font]);
        UIImage *image = [UIImage imageNamed:@"errow-bg.png"];
        [infoImageView setImage:[image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2]];
        infoImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];//modify background color
        [Utils cornerView:infoImageView withRadius:2 borderWidth:0 borderColor:nil];
        
        if (!bIsAppear) {
            [MyAppDelegate.window addSubview:self];
            bIsAppear = YES;
        }
    }
    self.alpha = 0;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    self.alpha = 1;
    [UIView commitAnimations];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(disAppear) object:nil];
    [self performSelector:@selector(disAppear) withObject:nil afterDelay:3];
}

- (void)disAppear {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hidden)];
	
	self.alpha = 0;
	
	[UIView commitAnimations];
}

- (void)hidden {
    if (self.alpha > 0) {
        return;
    }
    @synchronized(self) {
        [self removeFromSuperview];
        bIsAppear = NO;
    }
}

@end
