//
//  CityPickerView.h
//  PlistDemo
//
//  Created by Wei Wang on 11/6/13.
//  Copyright (c) 2013 weiwang. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol updateLabel <NSObject>
- (void) updateLabel;
@end
@interface CityPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *proviceDictionary;
@property (nonatomic, weak) id<updateLabel> delegate;
- (void)dataInit;
@end
