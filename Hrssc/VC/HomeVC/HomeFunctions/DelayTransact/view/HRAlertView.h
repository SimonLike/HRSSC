//
//  HRAlertView.h
//  Hrssc
//
//  Created by Simon on 2017/5/5.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBlock)(NSInteger tag);//block

@interface HRAlertView : UIView
+(instancetype) initAlertView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conTop;

@property (nonatomic,copy)AlertBlock alertBlock;

-(void)setContHidden:(BOOL)hidden;


@end
