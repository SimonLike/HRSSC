//
//  AddCell.h
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCellDelegate <NSObject>
- (void)setDefault:(UITableViewCell*)cell;
- (void)edit:(UITableViewCell*)cell;
- (void)del:(UITableViewCell*)cell;
@end
@interface AddCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UILabel* tel;
@property (nonatomic, strong) IBOutlet UILabel* address;
@property (nonatomic, strong) IBOutlet UIButton* defaultBtn;
@property (nonatomic, strong) id<AddCellDelegate>delegate;
+ (AddCell*)getInstanceWithNib;
- (void)setUI:(HRAddVO*)aVO;
- (void)setDefault:(BOOL)isDefault;
@end
