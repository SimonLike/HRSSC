//
//  HRSPHerderCell.h
//  Hrssc
//
//  Created by Simon on 2017/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HerderBlock)(NSInteger tag);//block

@interface HRSPHerderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *btnView;
@property (weak, nonatomic) IBOutlet UIView *roundView;
@property (weak, nonatomic) IBOutlet UIButton *unitBtn;
@property (weak, nonatomic) IBOutlet UIButton *personalBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (nonatomic,copy) HerderBlock block;//定义一个Block属性

@end
