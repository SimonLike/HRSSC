//
//  UIImage+Extend.m
//  LY
//
//  Created by ly1992 on 15/4/22.
//  Copyright (c) 2015年 ly1992. All rights reserved.
//

#import "UIImage+Extend.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation UIImage (Extend)

//按固定的width等比例缩放（UIImage),返回CGSize
+ (CGSize)sizeWithImage:(UIImage *)sourceImage scaledToWidth:(float)width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    CGSize size = CGSizeMake(newWidth, newHeight);
    return size;
}
//按固定的i_height等比例缩放（UIImage）,返回CGSize
+ (CGSize)sizeWithHeightImage:(UIImage *)sourceImage scaledToWidth:(float)height
{
    float oldHeight = sourceImage.size.height;
    float scaleFactor = height / oldHeight;
    
    float newWight = sourceImage.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
    CGSize size = CGSizeMake(newWight, newHeight);
    return size;
}
//按固定的width等比例缩放（sourceSize）
+ (CGSize)sizeWithSize:(CGSize)sourceSize scaledToWidth:(float)width
{
    float oldWidth = sourceSize.width;
    float scaleFactor = width / oldWidth;
    float newHeight = sourceSize.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    CGSize size = CGSizeMake(newWidth, newHeight);
    return size;
}
//按固定的height等比例缩放（sourceSize）
+ (CGSize)sizeWithHeightSize:(CGSize)sourceSize scaledToHeight:(float)height
{
    float oldHeight = sourceSize.height;
    float scaleFactor = height / oldHeight;
    float newWidth = sourceSize.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    CGSize size = CGSizeMake(newWidth,newHeight);
    return size;
}
//按固定的width等比例缩放（UIImage）, 返回图片
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth - 2, newHeight - 2));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//图片中间等比例 拉伸
+ (UIImage *)middleStretchableImageWithKey:(NSString *)key;
{
    UIImage *image = [UIImage imageNamed:key];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
/**
 *  图片压缩
 *  是 “压” 文件体积变小，但是像素数不变，长宽尺寸不变，那么质量可能下降，
 UIImageJPEGRepresentation(image, 0.0)
 *  是 “缩” 文件的尺寸变小，也就是像素数减少。长宽尺寸变小，文件体积同样会减小。
 [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)]
 */
+ (NSData *)imagewithCompressImage:(UIImage *)sourceImage scaledToWidth:(float)width scaledCompress:(float)compress
{
    //
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth - 2, newHeight - 2));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = nil;
    if (compress) {
        imageData = UIImageJPEGRepresentation(newImage, compress);
    } else {
        imageData = UIImageJPEGRepresentation(newImage, 0.5);
    }
    
    return imageData;
}
//将图片切成圆角
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}
@end
