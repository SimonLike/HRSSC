//
//  MLRootADSScrollView.h
//  RemoteControl
//
//  Created by S on 14-10-19.
//  Copyright (c) 2014年 ChangHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLRootADSScrollView : UIScrollView
{
    int adsPage;
    int currentPage;
}
- (void)setUp:(int)page;


@end
