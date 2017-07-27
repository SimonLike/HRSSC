//
//  XQDateTimeView.m
//  XQCarmateClub
//
//  Created by xf.lai on 14/12/31.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//

#import "XQDateTimeView.h"
//#import "EditHouseVC.h"
#define currentMonth [currentMonthString integerValue]

@implementation XQDateTimeView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
+ (XQDateTimeView*)getInstanceWithNibWithBlock:(ClickDoneBlock)aBlock{
    XQDateTimeView *view = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"XQDateTimeView" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[XQDateTimeView class]]){
            view = (XQDateTimeView *)obj;
            break;
        }
    }
    view.clickDoneBlock = aBlock;
    
    return view;
}
- (void)setUI{
    //    self.backgroundColor = [Utils colorWithHexString:@"ebebeb"];
    [_doneButton setTitleColor:[Utils colorWithHexString:@"00c8e0"]forState:UIControlStateNormal];
    //[Utils cornerView:_doneButton withRadius:2 borderWidth:1 borderColor:[Utils colorWithHexString:@"00c8e0"]];
    
    
    firstTimeLoad = YES;
    // self.customPicker.hidden = YES;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%d",[[formatter stringFromDate:date]intValue]];
    int num = [currentMonthString intValue];
    if(num<10)
        currentMonthString = [NSString stringWithFormat:@"%02d",num];
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    num = [currentDateString intValue];
    if(num<10)
        currentDateString = [NSString stringWithFormat:@"%02d",num];
    
    // Get Current  Hour
    //  [formatter setDateFormat:@"hh"];
    //  NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Minutes
    //  [formatter setDateFormat:@"mm"];
    //  NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  AM PM
    
    //   [formatter setDateFormat:@"a"];
    //   NSString *currentTimeAMPMString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //    if ([currentTimeAMPMString isEqualToString:@"下午"]) {
    //     num = [currentHourString intValue];
    //     currentHourString = [NSString stringWithFormat:@"%i",num];
    //   }
    
    // PickerView - Default Selection as per current Date
    
    [self.customPicker selectRow:[self.yearArray indexOfObject:currentyearString] inComponent:0 animated:NO];
    
    [self.customPicker selectRow:[self.monthArray indexOfObject:currentMonthString] inComponent:1 animated:NO];
    
    [self.customPicker selectRow:[self.DaysArray indexOfObject:currentDateString] inComponent:2 animated:NO];
    
    //    [self.customPicker selectRow:[self.hoursArray indexOfObject:currentHourString] inComponent:3 animated:NO];
    //
    //    [self.customPicker selectRow:[self.minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:NO];
    
}

- (void)setDataArray:(NSMutableArray*)array
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
        [_dataArray addObjectsFromArray:array];
    }
    else
    {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:array];
    }
}

- (void)setYearAry:(NSMutableArray*)array
{
    if (!_yearArray) {
        _yearArray = [[NSMutableArray alloc]init];
        [_yearArray addObjectsFromArray:array];
    }
    else
    {
        [_yearArray removeAllObjects];
        [_yearArray addObjectsFromArray:array];
    }
}

- (void)setMonthAry:(NSMutableArray*)array
{
    if (!_monthArray) {
        _monthArray = [[NSMutableArray alloc]init];
        [_monthArray addObjectsFromArray:array];
    }
    else
    {
        [_monthArray removeAllObjects];
        [_monthArray addObjectsFromArray:array];
    }
}

- (void)appear{
    //[self setUI];
    //时间选择器
    
    [_doneButton setTitleColor:[Utils colorWithHexString:@"535353"]forState:UIControlStateNormal];
    //[Utils cornerView:_doneButton withRadius:2 borderWidth:1 borderColor:[Utils colorWithHexString:@"535353"]];
    firstTimeLoad = YES;
    //自定义内容选择器
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.tag  = 1000;
    bgBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    bgBtn.frame = self.superview.bounds;
    [bgBtn addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.superview insertSubview:bgBtn belowSubview:self];
    //[self.superview addSubview:bgBtn];
    //
    
    //
    
    CGRect pFrame = self.frame;
    pFrame.origin.y = CGRectGetHeight(self.superview.bounds) - CGRectGetHeight(pFrame);
    [UIView animateWithDuration:.3 animations:^{
        self.frame = pFrame;
    }];
}

- (void)hide{
    UIButton *bgBtn = (UIButton *)[self.superview viewWithTag:1000];
    if (bgBtn) {
        [bgBtn removeFromSuperview];
    }
    
    CGRect pFrame = self.frame;
    pFrame.origin.y = CGRectGetHeight(self.superview.bounds);
    [UIView animateWithDuration:.3 animations:^{
        self.frame = pFrame;
    }];
}


- (IBAction)actionCancel:(id)sender
{
    [self hide];
    
}

- (IBAction)actionDone:(id)sender
{
    
    //NSString *str =[NSString stringWithFormat:@"%@-%@-%@",[self.yearArray objectAtIndex:[self.customPicker selectedRowInComponent:0]],[self.monthArray objectAtIndex:[self.customPicker selectedRowInComponent:1]],[self.DaysArray objectAtIndex:[self.customPicker selectedRowInComponent:2]]];
    NSString *str = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:[self.customPicker selectedRowInComponent:0]]];
    if (_clickDoneBlock) {
        _clickDoneBlock(str);
    }
    [self hide];
}


#pragma mark - getter
- (NSMutableArray *)yearArray{
    if (!_yearArray) {
        _yearArray = [[NSMutableArray alloc]init];
        //因为是预约，故从当前年份开始
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy"];
        int currentYear = [[formatter stringFromDate:[NSDate date]] intValue];
        
        for (int i = currentYear; i <= currentYear+50 ; i++)
        {
            [_yearArray addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
    }
    return _yearArray;
}
- (NSArray *)monthArray{
    if (!_monthArray) {
        _monthArray = [[NSMutableArray alloc]init];
        
        for (int i = 1; i <= 12; i++)
        {
            [_monthArray addObject:[NSString stringWithFormat:@"%02d",i]];
            
        }
    }
    return _monthArray;
}
- (NSMutableArray *)DaysArray{
    if (!_DaysArray) {
        _DaysArray = [[NSMutableArray alloc]init];
        
        for (int i = 1; i <= 31; i++)
        {
            [_DaysArray addObject:[NSString stringWithFormat:@"%02d",i]];
            
        }
    }
    return _DaysArray;
}

//- (NSMutableArray *)hoursArray{
//    if (!_hoursArray) {
//        _hoursArray = [[NSMutableArray alloc]init];
//
//        for (int i = 0; i < 24; i++)
//        {
//           [_hoursArray addObject:[NSString stringWithFormat:@"%02d",i]];
//        }
//
//    }
//    return _hoursArray;
//}
//- (NSMutableArray *)minutesArray{
//    if (!_minutesArray) {
//        _minutesArray = [[NSMutableArray alloc]init];
//
//        for (int i = 0; i < 60; i++)
//        {
//
//            [_minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
//
//        }
//
//    }
//    return _minutesArray;
//}

#pragma mark - UIPickerViewDelegate


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [self.customPicker reloadAllComponents];
    //    if (component == 0)
    //    {
    //        selectedYearRow = row;
    //        [self.customPicker reloadAllComponents];
    //    }
    //    else if (component == 1)
    //    {
    //        selectedMonthRow = row;
    //        [self.customPicker reloadAllComponents];
    //    }
    //    else if (component == 2)
    //    {
    //        selectedDayRow = row;
    //
    //        [self.customPicker reloadAllComponents];
    //
    //    }
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 300, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:20.0f]];
    }
    
    pickerLabel.text = [self.dataArray objectAtIndex:row];//
    //    if (component == 0)
    //    {
    //        pickerLabel.text =  [self.yearArray objectAtIndex:row]; // Year
    //    }
    //    else if (component == 1)
    //    {
    //        pickerLabel.text =  [self.monthArray objectAtIndex:row];  // Month
    //    }
    //    else if (component == 2)
    //    {
    //        pickerLabel.text =  [self.DaysArray objectAtIndex:row]; // Date
    //
    //    }
    //    else if (component == 3)
    //    {
    //        pickerLabel.text =  [self.hoursArray objectAtIndex:row]; // Hours
    //    }
    //    else if (component == 4)
    //    {
    //        pickerLabel.text =  [self.minutesArray objectAtIndex:row]; // Mins
    //    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    //    if (component == 0)
    //    {
    //        return [self.yearArray count];
    //
    //    }
    //    else if (component == 1)
    //    {
    //        return [self.monthArray count];
    //    }
    //    else if (component == 2)
    //    { // day
    //
    //        if (firstTimeLoad)
    //        {
    //            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
    //            {
    //                return 31;
    //            }
    //            else if (currentMonth == 2)
    //            {
    //                int yearint = [[self.yearArray objectAtIndex:selectedYearRow]intValue ];
    //
    //                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
    //
    //                    return 29;
    //                }
    //                else
    //                {
    //                    return 28; // or return 29
    //                }
    //
    //            }
    //            else
    //            {
    //                return 30;
    //            }
    //
    //        }
    //        else
    //        {
    //
    //            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
    //            {
    //                return 31;
    //            }
    //            else if (selectedMonthRow == 1)
    //            {
    //                int yearint = [[self.yearArray objectAtIndex:selectedYearRow]intValue ];
    //
    //                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
    //                    return 29;
    //                }
    //                else
    //                {
    //                    return 28; // or return 29
    //                }
    //
    //                
    //                
    //            }
    //            else
    //            {
    //                return 30;
    //            }
    //            
    //        }
    //        
    //        
    //    }
    //    else if (component == 3)
    //    { // hour
    //        
    //        return 24;
    //        
    //    }
    //    else if (component == 4)
    //    { // min
    //        return 60;
    //    }
    return [self.dataArray count];
    
}



@end
