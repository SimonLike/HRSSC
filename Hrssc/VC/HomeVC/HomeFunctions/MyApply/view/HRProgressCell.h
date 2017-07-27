//
//  HRProgressCell.h
//  Hrssc
//
//  Created by Simon on 2017/5/15.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRPicCollectionView.h"
#import "HRAttachsView.h"

@interface HRProgressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rleWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rleLeft;
@property (weak, nonatomic) IBOutlet UIImageView *rleIma;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dianWith;
@property (weak, nonatomic) IBOutlet UIView *grayView;
@property (weak, nonatomic) IBOutlet UILabel *tleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopCont;
@property (weak, nonatomic) IBOutlet HRPicCollectionView *picView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightCont;
@property (weak, nonatomic) IBOutlet HRAttachsView *attachView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachTopCont;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attachHeightCont;
-(void)pics:(NSArray *)array;
-(void)attachs:(NSArray *)array;

@end
