//
//  XQDateTimeView.h
//  XQCarmateClub
//
//  Created by xf.lai on 14/12/31.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickDoneBlock) (NSString *aStr);
@interface XQDateTimeView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
}

@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

//HQL
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) id superViewDelegate;

@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@property (strong, nonatomic) NSMutableArray *DaysArray;
@property (strong, nonatomic) NSMutableArray *hoursArray;
@property (strong, nonatomic) NSMutableArray *minutesArray;

@property(nonatomic, strong)ClickDoneBlock clickDoneBlock;

- (void)setDataArray:(NSMutableArray*)array;
- (void)setYearAry:(NSMutableArray*)array;
- (void)setMonthAry:(NSMutableArray*)array;
+ (XQDateTimeView*)getInstanceWithNibWithBlock:(ClickDoneBlock)aBlock;
- (void)hide;
- (void)appear;

@end
