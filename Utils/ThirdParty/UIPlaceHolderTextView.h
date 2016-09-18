//
//  UIPlaceHolderTextView.h
//  BlackCard
//
//  Created by Song on 16/6/7.
//  Copyright © 2016年 冒险元素. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
