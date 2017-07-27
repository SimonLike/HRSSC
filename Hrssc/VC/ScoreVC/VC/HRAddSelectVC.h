//
//  HRAddSelectVC.h
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AddBlock)(HRAddVO* vo);
@interface HRAddSelectVC : UIViewController
@property (nonatomic, strong) AddBlock aBlock;
@end
