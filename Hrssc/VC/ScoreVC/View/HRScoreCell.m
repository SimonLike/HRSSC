//
//  HRScoreCell.m
//  Hrssc
//
//  Created by admin on 17/4/25.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRScoreCell.h"

@implementation HRScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (HRScoreCell*)getInstanceWithNib{
    HRScoreCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRScoreCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRScoreCell class]]){
            cell = (HRScoreCell *)obj;
            break;
        }
    }
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(HRScoreProductVO*)vo
{
    self.backgroundColor = [UIColor clearColor];
    [Utils cornerView:_bgView withRadius:0 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
    //_icon.image = PNG_FROM_NAME(coverPic);
//    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,vo.img_url]] placeholderImage:DEFAULTIMG completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //self.icon.transform = CGAffineTransformMakeScale(0.1, 0.1);
//        //[self.view addSubview:_deleteFoodView.view];
//        [UIView animateWithDuration:.5 animations:^{
//            //self.icon.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        } completion:^(BOOL finished) {
//            //self.icon.transform = CGAffineTransformIdentity;
//        }];
//    }];
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,vo.img_url]] placeholderImage:DEFAULTIMG];
    _title.text = vo.name;
    _score.text = [NSString stringWithFormat:@"%@积分",vo.price];
    
}

@end
