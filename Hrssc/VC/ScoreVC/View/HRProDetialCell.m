//
//  HRProDetialCell.m
//  Hrssc
//
//  Created by admin on 17/5/2.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRProDetialCell.h"

@implementation HRProDetialCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (HRProDetialCell*)getInstanceWithNib
{
    HRProDetialCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRProDetialCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRProDetialCell class]]){
            cell = (HRProDetialCell *)obj;
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(HRProDetialVO*)vo
{
    _title.text = vo.product.name;
    _score.text = [NSString stringWithFormat:@"%@积分",vo.product.price];
    _detial.text = [NSString stringWithFormat:@"数量：%@  价值：%.2f",vo.product.lefts,vo.product.worth.floatValue/100];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
