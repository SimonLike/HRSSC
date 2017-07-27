//
//  HRBackAlertView.h
//  Hrssc
//
//  Created by Simon on 2017/5/11.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BackBlock)(NSInteger tag);

@interface HRBackAlertView : UIView
@property (weak, nonatomic) IBOutlet UIButton *bbcBtn;
@property (weak, nonatomic) IBOutlet UIButton *bcBtn;

@property (nonatomic, copy) BackBlock backBlock;

+(instancetype) initBackAlertView;
@end
