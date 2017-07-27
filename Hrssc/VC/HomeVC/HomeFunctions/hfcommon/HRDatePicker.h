//
//  HRDatePicker.h
//  Hrssc
//
//  Created by Simon on 2017/5/12.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DateBlock)(NSInteger tag,NSString *time);

@interface HRDatePicker : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, copy) DateBlock  dateBlock;

@property (nonatomic, strong) NSString *selectTime;
+(instancetype) initDatePicker;
@end
