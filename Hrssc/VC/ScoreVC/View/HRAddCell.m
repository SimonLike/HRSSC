//
//  HRAddCell.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRAddCell.h"

@implementation HRAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (HRAddCell*)getInstanceWithNib
{
    HRAddCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRAddCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRAddCell class]]){
            cell = (HRAddCell *)obj;
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(HRAddVO*)vo
{
    if(vo)
    {
        _addView.hidden = NO;
        _seView.hidden = YES;
        _name.text = vo.name;
        _phone.text = vo.phone;
        _address.text = vo.addr;
    }
    else
    {
        _addView.hidden = YES;
        _seView.hidden = NO;
    }
}

- (IBAction)seAction:(id)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(seAdd)])
        [_delegate seAdd];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
