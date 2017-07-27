//
//  HRCityVC.h
//  Hrssc
//
//  Created by admin on 17/4/24.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ CityBlock)(NSString* cityStr);

@interface HRCityVC : BaseViewController
@property (nonatomic, strong) CityBlock cBlock;
@end
