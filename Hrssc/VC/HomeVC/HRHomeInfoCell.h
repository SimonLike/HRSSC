//
//  HRHomeInfoCell.h
//  Hrssc
//
//  Created by admin on 17/4/22.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HRHomeInfoCellDelegate <NSObject>

- (void)objAction:(NSInteger)actionTag;

@end

@interface HRHomeInfoCell : UITableViewCell
@property (nonatomic, strong) id<HRHomeInfoCellDelegate>delegate;
+ (HRHomeInfoCell*)getInstanceWithNib;
- (void)setUI:(NSString*)cover;
@end
