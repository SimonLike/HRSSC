//
//  HRMsgVO.h
//  Hrssc
//
//  Created by admin on 17/5/3.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRMsgVO : NSObject
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* create_time;
@property (nonatomic, strong) NSString* id;
@property (nonatomic, strong) NSString* sender;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* title;
@end
//content = "";
//"create_time" = "2017-04-24 19:26:36";
//id = 25;
//sender = "";
//status = 1;
//title = "\U60a8\U6709\U4e00\U6761\U65b0\U7684\U5f85\U529e\Uff1a\U201c \U6df1\U5733\U5168\U65e5\U5236\U901a\U7528\U5408\U540c\U6a21\U677f1\Uff08\U4e2d\U6587\Uff09 \U201d\U3002";
