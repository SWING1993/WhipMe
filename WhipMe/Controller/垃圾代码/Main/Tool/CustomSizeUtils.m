//
//  CustomSizeUtils.m
//  YouShaQi
//
//  Created by 蔡三泽 on 15/8/19.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "CustomSizeUtils.h"

@implementation CustomSizeUtils

//简单版本计算文本大小
+ (CGSize)simpleSizeWithStr:(NSString *)str font:(UIFont *)font
{
    CGSize textSize = [str sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName]];
    return textSize;
}

//计算文本大小
+ (CGSize)customSizeWithStr:(NSString *)str font:(UIFont *)font size:(CGSize)size
{
    CGRect textRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName] context:nil];
    
    return textRect.size;
}


+ (CGRect)caculateTextViewFrame:(UITextView *)textView
{
    CGRect caculateFrame = textView.frame;
    caculateFrame.size.height = textView.contentSize.height;
    return caculateFrame;
}


//获取视图大小
+ (CGSize)getMainScreenSize
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    BOOL statusBarIsLandscape = UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
    if (statusBarIsLandscape) {
        return CGSizeMake(MAX(screenSize.width, screenSize.height), MIN(screenSize.width, screenSize.height));
    } else {
        return CGSizeMake(MIN(screenSize.width, screenSize.height), MAX(screenSize.width, screenSize.height));
    }
}

@end
