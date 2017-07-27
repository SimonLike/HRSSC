//
//  XQUploadHelper.m
//  XQExpressCourier
//
//  Created by xf.lai on 14/8/27.
//  Copyright (c) 2014年 xf.lai. All rights reserved.
//

#import "XQUploadHelper.h"

@implementation XQUploadHelper
+(void)startSendImageName:(NSString *)name image:(UIImage *)image parameters:(NSDictionary *)parameters block:(AsynchronousBlock)block
{
    NSMutableURLRequest *_request;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",PIC_UPDATE,@"hrsscBasicController/uploadPicture"]];
    
    DLog(@"url--->%@",url);
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    _request = [NSMutableURLRequest requestWithURL:url
                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                   timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 1);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameters allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:name])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
    }
    long long num = [Utils getLongNumFromDate:[NSDate date]];
    NSString* code = [Utils ret32bitString];
    NSString *fileName = [NSString stringWithFormat:@"%@-%lld-%@.png",[Utils readUser].token,num,code];//命名，必须唯一
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明name字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    
    
    
    //设置HTTPHeader
    [_request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [_request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [_request setHTTPBody:myRequestData];
    //http method
    [_request setHTTPMethod:@"POST"];
    
    XQUploadHelper *net = [[XQUploadHelper alloc] init];
    net.asynchronousBlock = block;
    [net start:_request];
    
}


+(void)startSendVideoName:(NSString *)name image:(UIImage *)image parameters:(NSDictionary *)parameters block:(AsynchronousBlock)block
{
    NSMutableURLRequest *_request;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@",PIC_UPDATE,@"hrsscBasicController/uploadPicture"]];
    
    DLog(@"url--->%@",url);
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    _request = [NSMutableURLRequest requestWithURL:url
                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                   timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data = UIImageJPEGRepresentation(image, 1);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [parameters allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        if(![key isEqualToString:name])
        {
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            //添加字段的值
            [body appendFormat:@"%@\r\n",[parameters objectForKey:key]];
        }
    }
    long long num = [Utils getLongNumFromDate:[NSDate date]];
    NSString* code = [Utils ret32bitString];
    NSString *fileName = [NSString stringWithFormat:@"%@-%lld-%@.png",[Utils readUser].token,num,code];//命名，必须唯一
    ////添加分界线，换行
    [body appendFormat:@"%@\r\n",MPboundary];
    //声明name字段，文件名为boris.png
    [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileName];
    //声明上传文件的格式
    [body appendFormat:@"Content-Type: image/jpeg\r\n\r\n"];
    
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    //将image的data加入
    [myRequestData appendData:data];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc] initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    
    
    
    //设置HTTPHeader
    [_request setValue:content forHTTPHeaderField:@"Content-Type"];
    //设置Content-Length
    [_request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [_request setHTTPBody:myRequestData];
    //http method
    [_request setHTTPMethod:@"POST"];
    
    XQUploadHelper *net = [[XQUploadHelper alloc] init];
    net.asynchronousBlock = block;
    [net start:_request];
    
}


-(void)start:(NSMutableURLRequest *)request
{
    NSURLConnection *urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    NSLog(urlConnection ? @"连接创建成功" : @"连接创建失败");
}

/*********************************
 异步网络请求 代理方法
 start
 *********************************/



//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    NSLog(@"连接成功啦");
    //打印获取到的一些信息
    NSLog(@"结果类型:%@",response.MIMEType);
    NSLog(@"请求的网址:%@",response.URL);
    NSLog(@"结果长度:%lld",response.expectedContentLength);
    // 初始化接收数据
    self.receiveData = [NSMutableData data];
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [self.receiveData appendData:data];
    
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection

 didFailWithError:(NSError *)error

{
    NSLog(@"哦嚯！请求出现错误：%@",[error localizedDescription]);
    self.asynchronousBlock(self.receiveData,[error localizedDescription]);
    
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    NSLog(@"数据传输完毕");
    self.asynchronousBlock(self.receiveData,nil);
    
}

/*********************************
 网络请求 代理方法
 end
 *********************************/



@end
