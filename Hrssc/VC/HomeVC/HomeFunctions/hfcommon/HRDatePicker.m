
//
//  HRDatePicker.m
//  Hrssc
//
//  Created by Simon on 2017/5/12.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRDatePicker.h"

@implementation HRDatePicker

+(instancetype) initDatePicker{
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRDatePicker" owner:nil options:nil];
    return [objs firstObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    self.datePicker.minimumDate = [NSDate date];
}
- (IBAction)dp_click:(UIButton *)sender {
    if (self.dateBlock) {
        self.dateBlock(sender.tag,self.selectTime);
    }
    [self removeFromSuperview];
}

-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    /*添加你自己响应代码*/
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    self.selectTime = [dateFormatter stringFromDate:_date];
}
@end
