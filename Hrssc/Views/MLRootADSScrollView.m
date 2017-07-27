//
//  MLRootADSScrollView.m
//  RemoteControl
//
//  Created by S on 14-10-19.
//  Copyright (c) 2014年 ChangHong. All rights reserved.
//

#import "MLRootADSScrollView.h"

@implementation MLRootADSScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
    }
    return self;
}

- (void)awakeFromNib{
    self.pagingEnabled = YES;
}
- (void)setUp:(int)page
{
    adsPage = page;
    currentPage = 0;
}

@end
