//
//  HRBankTemplateVC.h
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BankTemplateBlock)(NSString *tpl_form);

@interface HRBankTemplateVC : BaseViewController
@property (nonatomic, strong)NSString *tpStr;
@property (nonatomic, copy)BankTemplateBlock btBlock;

@end
