//
//  XQUploadHelper.h
//  XQExpressCourier
//
//  Created by xf.lai on 14/8/27.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//

/**
 *
 * 上传
 *
 */

#import <Foundation/Foundation.h>


// 异步请求要传的block
typedef void (^AsynchronousBlock)(NSData *obj,id error);


@interface XQUploadHelper : NSObject

// 用来保存服务器返回的数据
@property (nonatomic,strong) NSMutableData *receiveData;
@property (nonatomic,copy) AsynchronousBlock asynchronousBlock;

+(void)startSendImageName:(NSString *)name image:(UIImage *)image parameters:(NSDictionary *)parameters block:(AsynchronousBlock)block;


@end
