//
//  XQDateTimeView.h
//  XQCarmateClub
//
//  Created by xf.lai on 14/12/31.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickTimeDoneBlock) (NSString *aStr);
@interface DateTimeView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
}

@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@property (strong, nonatomic) NSMutableArray *DaysArray;
@property (strong, nonatomic) NSMutableArray *hoursArray;
@property (strong, nonatomic) NSMutableArray *minutesArray;

@property(nonatomic, strong)ClickTimeDoneBlock clickDoneBlock;


+ (DateTimeView*)getInstanceWithNibWithBlock:(ClickTimeDoneBlock)aBlock;
- (void)hide;
- (void)appear;

@end
