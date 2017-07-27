//
//  HRLanguageAlert.h
//  Hrssc
//
//  Created by Simon on 2017/5/9.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^LanguageAlertBlock)(NSString *language ,NSInteger tag);//block

@interface HRLanguageAlert : UIView
+(instancetype) initLanguageAlert;
@property(nonatomic,copy) LanguageAlertBlock languageBlock;
@end
