//
//  HRSPFooterCell.h
//  Hrssc
//
//  Created by Simon on 2017/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FooterBlock)(NSInteger tag);//block

@interface HRSPFooterCell : UITableViewCell
@property (nonatomic,copy)FooterBlock block;//定义一个Block属性

@end
