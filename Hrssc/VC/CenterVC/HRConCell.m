//
//  HRConCell.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRConCell.h"

@implementation HRConCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.showBtn.layer.borderColor = RGBCOLOR(0, 157, 239).CGColor;
    self.showBtn.layer.masksToBounds = YES;
    self.showBtn.layer.borderWidth = 1;
    self.showBtn.layer.cornerRadius = 5;
}

+ (HRConCell*)getInstanceWithNib
{
    HRConCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRConCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRConCell class]]){
            cell = (HRConCell *)obj;
            break;
        }
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(HRSericeVO*)vo
{
    _title.text = vo.name;
    _detial.text = vo.brief;
//    [_icon sd_setImageWithURL:[NSURL URLWithString:vo.icon] placeholderImage:DEFAULTIMG completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //self.icon.transform = CGAffineTransformMakeScale(0.1, 0.1);
//        //[self.view addSubview:_deleteFoodView.view];
//        [UIView animateWithDuration:.5 animations:^{
//            //self.icon.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        } completion:^(BOOL finished) {
//            //self.icon.transform = CGAffineTransformIdentity;
//        }];
//    }];
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,vo.icon]] placeholderImage:DEFAULTIMG];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
