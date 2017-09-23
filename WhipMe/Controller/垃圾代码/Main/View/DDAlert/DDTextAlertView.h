//
//  DDTextAlertView.h
//  DuDu Courier
//
//  Created by yangg on 16/3/11.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDTextAlertView;
@protocol DDTextAlertViewDelegate <NSObject>
@optional
- (void)textAlertView:(DDTextAlertView *)textView withText:(NSString *)text withFlag:(BOOL)flag;

@end

@interface DDTextAlertView : UIView

@property (nonatomic, strong) NSString *placeholder;

@property (nonatomic, assign) NSInteger keyboardTypeNumber;

/** 限制输入框最大长度 */
@property (nonatomic, assign) NSInteger contentCount;

/**
 自定义View
 */
- (instancetype)initWithTitle:(NSString *)objTitle
                     delegate:(id<DDTextAlertViewDelegate>)objDelegate
                  cancelTitle:(NSString *)objCancel
                    nextTitle:(NSString *)objNext;

- (void)show;


@end
