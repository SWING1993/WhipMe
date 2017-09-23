//
//  UIPlaceHolderTextView.h
//  FuErDai_01
//
//  Created by ASN on 15/3/14.
//  Copyright (c) 2015年 Mr. Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, strong) UILabel *placeHolderLabel;

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;

- (void)textChanged:(NSNotification *)notification;



@end
