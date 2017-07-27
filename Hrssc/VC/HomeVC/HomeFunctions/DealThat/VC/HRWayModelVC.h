//
//  HRWayModelVC.h
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplatesObj.h"
#import "HRAddVO.h"

//选取方式
typedef void(^WayModelBlock)(int tag,NSString *str);
//选取领取地址
typedef void(^ObjBlock)(AddressObj *obj);
//选取邮寄地址
typedef void(^AddBlock)(HRAddVO *vobj);
//选取的模板
typedef void(^TemplateBlock)(TemplatesObj *obj);

//选取的模板 填写的信息拼接
typedef void(^WayTpBlock)(NSString *tpl_form);

@interface HRWayModelVC : BaseViewController

@property(nonatomic,strong)NSString *fromVC;
@property(nonatomic, copy)WayModelBlock wmBlock;
@property(nonatomic, copy)ObjBlock objBlock;
@property(nonatomic, copy)AddBlock addBlock;
@property(nonatomic, copy)TemplateBlock templateBlock;
@property(nonatomic, copy)WayTpBlock wtpBlock;

@property (nonatomic, strong)NSArray *templateArr;
@property (nonatomic, strong)NSArray *addresArr;

@end
