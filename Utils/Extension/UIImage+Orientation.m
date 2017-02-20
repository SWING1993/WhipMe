//
//  UIImage+Orientation.m
//  FuErDai_01
//
//  Created by anve on 16/9/22.
//  Copyright © 2016年 Mr. Yang. All rights reserved.
//

#import "UIImage+Orientation.h"

#define k_scale_wh 800.0

@implementation UIImage (Orientation)

+ (UIImage *)fixOrientation:(UIImage *)aImage {
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

+ (UIImage *)scaleImage:(UIImage *)image {
    if (MAX(image.size.height, image.size.width) < k_scale_wh) {
        return image;
    }
    
    CGSize newImageS = CGSizeZero;
    if (image.size.height > image.size.width) {
        newImageS.height = k_scale_wh;
        float ratio = k_scale_wh / image.size.height;
        newImageS.width = image.size.width * ratio;
    } else {
        newImageS.width = k_scale_wh;
        float ratio = k_scale_wh / image.size.width;
        newImageS.height = image.size.height * ratio;
    }
    
    UIGraphicsBeginImageContext(newImageS);
    [image drawInRect:CGRectMake(0, 0, newImageS.width, newImageS.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaleImage;
}
/** 压缩图片内存大小 */
+ (NSData *)dataRepresentationImage:(UIImage *)image {
    if (!image) {
        return [NSData data];
    }
    float ratioValue = 0.3;
    NSData *imageData = UIImageJPEGRepresentation(image, ratioValue);
    while (imageData.length > 100 * 1024 && ratioValue >= 0.03) {
        ratioValue = ratioValue - 0.07;
        imageData = UIImageJPEGRepresentation(image, ratioValue);
    }
    return imageData;
}

+ (UIImage *)fullToFilePath:(NSString *)imageName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingFormat:@"/%@", imageName];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSAssert(path != nil, @"%@", path);
        path = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Documents"] stringByAppendingFormat:@"/%@", imageName];
        if (![fileManager fileExistsAtPath:path]) {
            NSAssert(path != nil, @"%@", path);
            return nil;
        }
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (NSString *)generateUuidString {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);

    return uuidString;
}

- (UIImage *)watermarkLogo:(UIView *)logo make:(CGRect)makeSize width:(CGFloat)kWidth heith:(CGFloat)kHeight {
    
    UIImage *img = [UIImage convertViewToImage:logo];
    CGFloat ratioA = CGRectGetWidth(makeSize)/kWidth;
    CGFloat ratioB = CGRectGetHeight(makeSize)/CGRectGetWidth(makeSize);
    CGFloat ratioC = 130.0/kHeight;
    CGFloat widthA = ratioA*self.size.width;
    CGFloat heightA = ratioB*widthA;
    CGFloat originY = self.size.height - heightA - ratioC*self.size.height;
    CGFloat originX = (self.size.width - widthA)/2.0;
    CGRect  rect_A = CGRectMake(floorf(originX), floorf(originY), floorf(widthA), floorf(heightA));
    
    UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [img drawInRect:rect_A];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

+ (UIImage *)convertViewToImage:(UIView *)v {
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
