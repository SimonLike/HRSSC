//
//  HRMailingAddressVC.h
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRAddVO.h"

typedef void(^MailingBlock)(HRAddVO *rAddObj);
@interface HRMailingAddressVC : BaseViewController

@property (nonatomic, strong) MailingBlock mailingBlock;
@end
