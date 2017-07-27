//
//  AreaPickView.h
//  Manage
//
//  Created by S on 15/12/22.
//  Copyright © 2015年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DoneBlock) (NSString *aStr);
typedef void (^DoneThirdBlock) (NSString *aStr,NSString *bStr,NSString *cStr);
@interface AreaPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *currentMonthString;
    
    NSInteger selectedYearRow;
    NSInteger selectedMonthRow;
    NSInteger selectedDayRow;
    
    BOOL firstTimeLoad;
    
}

@property (nonatomic, assign) PickType pickType;

@property (weak, nonatomic) IBOutlet UIPickerView *customPicker;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIView* bgView;
//HQL
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) id superViewDelegate;
@property (nonatomic, strong) NSMutableDictionary* areaDic;

@property (strong, nonatomic) NSMutableArray *yearArray;
@property (strong, nonatomic) NSMutableArray *monthArray;
@property (strong, nonatomic) NSMutableArray *DaysArray;
@property (strong, nonatomic) NSMutableArray *hoursArray;
@property (strong, nonatomic) NSMutableArray *minutesArray;

@property(nonatomic, strong)DoneBlock clickDoneBlock;
@property(nonatomic, strong)DoneThirdBlock clickDoneThirdBlock;
- (void)setDataArray:(NSMutableArray*)array;
- (void)setYearAry:(NSMutableArray*)array;
- (void)setMonthAry:(NSMutableArray*)array;
- (void)setAreaD:(NSMutableDictionary*)dic;
- (void)setCityD:(NSMutableDictionary*)dic;
+ (AreaPickView*)getInstanceWithNibWithBlock:(DoneBlock)aBlock;
+ (AreaPickView*)getInstanceWithThirdNibWithBlock:(DoneThirdBlock)aBlock;
- (void)hide;
- (void)appear;
@end