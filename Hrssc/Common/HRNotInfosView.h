//
//  HRNotInfosView.h
//  Hrssc
//
//  Created by Simon on 2017/5/18.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRNotInfosView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *cz_image;
@property (weak, nonatomic) IBOutlet UILabel *cz_label1;
@property (weak, nonatomic) IBOutlet UILabel *cz_label2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerTop;

+(instancetype) initNotInfosView;

@end
