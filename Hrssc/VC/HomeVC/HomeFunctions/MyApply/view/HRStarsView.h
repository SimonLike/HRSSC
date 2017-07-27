//
//  HRStarsView.h
//  Hrssc
//
//  Created by Simon on 2017/5/23.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StarsBlock)(int star);

@interface HRStarsView : UIView
@property (nonatomic, copy) StarsBlock starsBlock;

@end
