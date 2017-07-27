

//
//  HRProgressCell.m
//  Hrssc
//
//  Created by Simon on 2017/5/15.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import "HRProgressCell.h"
#import "BoderButton.h"

@implementation HRProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.grayView.layer.borderColor = RGBCOLOR16(0xdddddd).CGColor;
    self.grayView.layer.borderWidth = 1;
}
//图片
-(void)pics:(NSArray *)array{
    self.picView.picTypeTnt = 1;
    self.picView.picspathArr = array;
    
    if (array.count%3 == 0) {
        self.picHeightCont.constant = array.count/3 * ((self.picView.width - 30)/3 + 10) - 10;
    }else{
        self.picHeightCont.constant = (array.count/3 + 1) * ((self.picView.width - 30)/3 + 10) -10;
    }
    CGRect frame = self.picView.pic_collection.frame;
    frame.size.height = self.picHeightCont.constant;
    self.picView.pic_collection.frame = frame;
    
    [self.picView.pic_collection reloadData];
}

//附件
-(void)attachs:(NSArray *)array{
    [self.attachView setAttachpathArr:array];
    self.attachHeightCont.constant = 32 * array.count;
}

-(void)layoutIfNeeded{
    [super layoutIfNeeded];
    CGRect frame = self.frame;
    frame.size.height = self.grayView.height + 15;
    self.frame = frame;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
