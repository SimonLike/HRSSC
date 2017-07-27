//
//  HRHomeInfoCell.m
//  Hrssc
//
//  Created by admin on 17/4/22.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRHomeInfoCell.h"

@implementation HRHomeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

+ (HRHomeInfoCell*)getInstanceWithNib
{
    HRHomeInfoCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"HRHomeInfoCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[HRHomeInfoCell class]]){
            cell = (HRHomeInfoCell *)obj;
            break;
        }
    }
    return cell;
}

- (void)setUI:(NSString*)cover
{
    
}

- (IBAction)objAction:(id)sender
{
    UIButton* btn = sender;
    if(_delegate&&[_delegate respondsToSelector:@selector(objAction:)])
        [_delegate objAction:btn.tag];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
