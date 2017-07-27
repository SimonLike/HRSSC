//
//  HRCenterHeadCell.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRCenterHeadCell.h"

@implementation HRCenterHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (HRCenterHeadCell*)getInstanceWithNib{
    HRCenterHeadCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRCenterHeadCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRCenterHeadCell class]]){
            cell = (HRCenterHeadCell *)obj;
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(HRUserInfoVO*)vo
{
    self.backgroundColor = [UIColor clearColor];
    [Utils cornerView:_icon withRadius:42 borderWidth:0 borderColor:nil];
    //_icon.image = PNG_FROM_NAME(coverPic);
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",PIC_HOST,vo.head]] placeholderImage:HEADTIMG completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //self.icon.transform = CGAffineTransfo rmMakeScale(0.1, 0.1);
        //[self.view addSubview:_deleteFoodView.view];
        [UIView animateWithDuration:.5 animations:^{
            //self.icon.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            //self.icon.transform = CGAffineTransformIdentity;
        }];
    }];
    _name.text = vo.name;
    _uId.text = [NSString stringWithFormat:@"工号：%@",vo.uin];
    [Utils cornerView:_signBtn withRadius:5 borderWidth:0 borderColor:nil];
}

- (IBAction)signNow:(id)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(signNow:)])
        [_delegate signNow:self];
}

- (void)setSign:(BOOL)state
{
    if(state)
    {
        [_signBtn setBackgroundColor:RGBCOLOR16(0x999999)];
        [_signBtn setTitle:@"今日已签" forState:0];
    }
    else
    {
        [_signBtn setBackgroundColor:RGBCOLOR16(0x00A9F3)];
        [_signBtn setTitle:@"签到" forState:0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
