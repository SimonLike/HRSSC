//
//  HRInputVC.h
//  Hrssc
//
//  Created by Simon on 2017/5/6.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^InputBlock)(NSString *describe);//block

@interface HRInputVC : BaseViewController
@property(nonatomic,copy) InputBlock inputBlock;

@end
