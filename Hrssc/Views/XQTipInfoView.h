//
//  TipInfoView.h
//  XQInstgClient
//
//  Created by iObitLXF on 5/31/13.
//  Copyright (c) 2013 iObitLXF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface XQTipInfoView : UIView
{
    IBOutlet UILabel *infoLabel;
    IBOutlet UIImageView *infoImageView;
    BOOL bIsAppear;
}
+ (XQTipInfoView*)getInstanceWithNib;
- (void)appear:(NSString*)strText;

@end
