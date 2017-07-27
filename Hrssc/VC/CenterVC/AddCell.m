//
//  AddCell.m
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "AddCell.h"

@implementation AddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (AddCell*)getInstanceWithNib
{
    AddCell *cell = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"AddCell" owner:nil options:nil];
    for(id obj in objs) {
        if([obj isKindOfClass:[AddCell class]]){
            cell = (AddCell *)obj;
            break;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setUI:(HRAddVO*)aVO
{
    self.backgroundColor = [UIColor clearColor];
    self.name.text = aVO.name;
    self.tel.text = aVO.phone;
    self.address.text = [NSString stringWithFormat:@"%@%@%@%@",aVO.prov,aVO.city,aVO.area,aVO.addr];
    [self setDefault:[aVO.is_default isEqualToString:@"0"]?NO:YES];
}

- (void)setDefault:(BOOL)isDefault
{
    if(isDefault)
    {
        [self.defaultBtn setImage:PNG_FROM_NAME(@"icon_xuanze") forState:UIControlStateNormal];
        [self.defaultBtn setTitleColor:[UIColor redColor] forState:0];
    }
    else
    {
        [self.defaultBtn setImage:PNG_FROM_NAME(@"icon_weixuanze") forState:UIControlStateNormal];
        [self.defaultBtn setTitleColor:[Utils colorWithHexString:@"535353"] forState:0];
    }
}

- (IBAction)setDefaultNow:(id)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(setDefault:)])
        [_delegate setDefault:self];
}

- (IBAction)edit:(id)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(edit:)])
        [_delegate edit:self];
}

- (IBAction)dele:(id)sender
{
    if(_delegate&&[_delegate respondsToSelector:@selector(del:)])
        [_delegate del:self];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
