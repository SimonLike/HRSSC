//
//  HREvaluationVC.h
//  Hrssc
//
//  Created by Simon on 2017/5/23.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^EvaSuccessBlock)();

@interface HREvaluationVC : BaseViewController
@property (nonatomic, assign) int aid;
@property (nonatomic, strong) NSString *work_order;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, copy) EvaSuccessBlock successBlock;
@end
