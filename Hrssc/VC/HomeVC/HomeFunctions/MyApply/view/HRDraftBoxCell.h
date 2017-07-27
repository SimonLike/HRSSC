//
//  HRDraftBoxCell.h
//  Hrssc
//
//  Created by Simon on 2017/5/20.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRDraftBoxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@end
