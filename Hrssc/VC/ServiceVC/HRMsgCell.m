//
//  HRMsgCell.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRMsgCell.h"

@implementation HRMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (HRMsgCell*)getInstanceWithNib
{
    HRMsgCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRMsgCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRMsgCell class]]){
            cell = (HRMsgCell *)obj;
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(HRMsgVO*)vo
{
    self.backgroundColor = [UIColor clearColor];
    [Utils cornerView:_bgView withRadius:5 borderWidth:.5 borderColor:[UIColor lightGrayColor]];
    _time.text = vo.create_time;
    _title.text = vo.title;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
