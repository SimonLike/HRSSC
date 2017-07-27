//
//  HRWebViewVC.h
//  Hrssc
//
//  Created by Simon on 2017/5/9.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "BaseViewController.h"
#import "TemplatesObj.h"
typedef void(^BankTpBlock)(NSString *tpl_form);

@interface HRWebViewVC : BaseViewController
@property(nonatomic,strong)NSString *attachStr;
@property(nonatomic,strong)TemplatesObj *templatesObj;
@property (nonatomic, copy)BankTpBlock tpBlock;
@property(nonatomic,strong)NSString *signUrl;
@property (nonatomic, strong) NSString *typeUrl;// showHetong 预览合同   showNotR 展示内容不可操作  attach 附件展示  signature 电子签章   其他默认为模板展示有下一步操作

@end
