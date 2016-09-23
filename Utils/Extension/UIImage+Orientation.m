//
//  UIImage+Orientation.m
//  FuErDai_01
//
//  Created by anve on 16/9/22.
//  Copyright © 2016年 Mr. Yang. All rights reserved.
//

#import "UIImage+Orientation.h"

@implementation UIImage (Orientation)


+ (UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)scaleImage:(UIImage *)image
{
    
    if (MAX(image.size.height, image.size.width) < 1280.0f)
    {
        return image;
    }
    
    CGSize newImageS = CGSizeZero;
    if (image.size.height > image.size.width) {
        newImageS.height = 1280.0f;
        float ratio = 1280.0f / image.size.height;
        newImageS.width = image.size.width * ratio;
    } else {
        newImageS.width = 1280.0f;
        float ratio = 1280.0f / image.size.width;
        newImageS.height = image.size.height * ratio;
    }
    
    UIGraphicsBeginImageContext(newImageS);
    [image drawInRect:CGRectMake(0, 0, newImageS.width, newImageS.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}
/** 压缩图片内存大小 */
+ (NSData *)dataRepresentationImage:(UIImage *)image
{
    if (!image) {
        return [NSData data];
    }
    float ratioValue = 1.0;
    NSData *imageData = UIImageJPEGRepresentation(image, ratioValue);
    while (imageData.length > 200 * 1024 && ratioValue >= 0.1) {
        ratioValue = ratioValue - 0.4;
        imageData = UIImageJPEGRepresentation(image, ratioValue);
    }
    return imageData;
}


+ (UIImage *)fullToFilePath:(NSString *)imageName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingFormat:@"/%@", imageName];
    
    if (![fileManager fileExistsAtPath:path])
    {
        NSAssert(path != nil, @"%@", path);
        path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Documents"] stringByAppendingFormat:@"/%@", imageName];
        if (![fileManager fileExistsAtPath:path])
        {
            NSAssert(path != nil, @"%@", path);
            return nil;
        }
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}


@end
