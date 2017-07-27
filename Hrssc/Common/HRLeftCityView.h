//
//  HRLeftCityView.h
//  Hrssc
//
//  Created by Simon on 2017/5/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftCityBlock)();

@interface HRLeftCityView : UIView
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *upIma;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (nonatomic, copy) LeftCityBlock leftBlock;
+(instancetype) initLeftCityView;

@end
