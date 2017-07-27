//
//  HRCheckResultObj.h
//  Hrssc
//
//  Created by Simon on 2017/5/17.
//  Copyright © 2017年 HRSSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRCheckResultObj : NSObject
/*
 "uid": 2,
 "result": "测试1",
 "create_time": "2017-05-06 17:10:14",
 "images": "[\"/uploadFiles/uploadImgs/20170517/11/8eadab2e25d040f6b7f846c059a9fc3e.jpg\"]"

 */
@property (nonatomic) int uid;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *images;

@end
