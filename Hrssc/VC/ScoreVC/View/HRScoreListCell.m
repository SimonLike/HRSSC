//
//  HRScoreListCell.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRScoreListCell.h"

@implementation HRScoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (HRScoreListCell*)getInstanceWithNib
{
    HRScoreListCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRScoreListCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRScoreListCell class]]){
            cell = (HRScoreListCell *)obj;
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(OrderListVO*)vo
{
    [Utils cornerView:_img withRadius:0 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
    //_icon.image = PNG_FROM_NAME(coverPic);
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,vo.img_url]] placeholderImage:DEFAULTIMG completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //self.icon.transform = CGAffineTransformMakeScale(0.1, 0.1);
        //[self.view addSubview:_deleteFoodView.view];
        [UIView animateWithDuration:.5 animations:^{
            //self.icon.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            //self.icon.transform = CGAffineTransformIdentity;
        }];
    }];
    _title.text = vo.pname;
    _score.text = [NSString stringWithFormat:@"%@积分",vo.points];
    _num.text = [NSString stringWithFormat:@"x %@",vo.count];
    _time.text = vo.create_time;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
