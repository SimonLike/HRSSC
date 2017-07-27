//
//  AddressDetialVC.h
//  Beautiful
//
//  Created by S on 16/1/26.
//  Copyright © 2016年 B. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressDetialVC : UIViewController
@property (nonatomic, strong) IBOutlet UIButton* saveBtn;
@property (nonatomic, strong) IBOutlet UITextField* name;
@property (nonatomic, strong) IBOutlet UITextField* tel;
@property (nonatomic, strong) IBOutlet UITextField* detial;
@property (nonatomic, strong) IBOutlet UILabel* areaLabel;
@property (nonatomic, assign) int adType;//1.新建 2.编辑
@property (nonatomic, strong) HRAddVO* currentVO;
@property (nonatomic, assign) int aId;
@end
