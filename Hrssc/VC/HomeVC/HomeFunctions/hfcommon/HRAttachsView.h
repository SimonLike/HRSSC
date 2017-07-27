//
//  HRAttachsView.h
//  Hrssc
//
//  Created by Simon on 2017/5/16.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AttachsBlock)(NSString *str);

@interface HRAttachsView : UIView

@property (nonatomic, strong)NSArray *attachpathArr;
@property (nonatomic, strong)NSArray *attachArr;
@property (nonatomic, copy) AttachsBlock attachsBlock;

@end
