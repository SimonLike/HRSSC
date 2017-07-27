//
//  NSString+Regex.h
//  MXapp
//
//  Created by congyang on 16/6/16.
//  Copyright © 2016年 zeb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Regex)

@property (nonatomic, assign, readonly)  BOOL isTelNumber;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
- (CGSize)computeSizeWithFont:(CGFloat)font maxW:(CGFloat)maxW;
- (NSString *)StringFromLongTime;
- (NSString *)timeWithString;
-(BOOL)isValidateEmail:(NSString *)email;

@end
