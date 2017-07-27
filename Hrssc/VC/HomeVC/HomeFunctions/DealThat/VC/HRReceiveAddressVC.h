//
//  HRReceiveAddressVC.h
//  Hrssc
//
//  Created by Simon on 2017/4/28.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TemplatesObj.h"

typedef void(^ReceiveBlock)(AddressObj *obj);

@interface HRReceiveAddressVC : BaseViewController

@property(nonatomic,strong)NSArray *addresArr;
@property (nonatomic, copy)ReceiveBlock receiveBlock;

@end
