//
//  UIImage+Orientation.h
//  FuErDai_01
//
//  Created by anve on 16/9/22.
//  Copyright © 2016年 Mr. Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Orientation)

+ (UIImage *)fixOrientation:(UIImage *)aImage;

+ (UIImage *)scaleImage:(UIImage *)image;

+ (NSData *)dataRepresentationImage:(UIImage *)image;

+ (UIImage *)fullToFilePath:(NSString *)imageName;

+ (NSString *)generateUuidString;

+ (UIImage *)convertViewToImage:(UIView *)v;

- (UIImage *)watermarkLogo:(UIView *)logo make:(CGRect)makeSize width:(CGFloat)kWidth heith:(CGFloat)kHeight;

@end
