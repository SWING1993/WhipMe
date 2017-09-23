//
//  UITableView+DefaultPage.h
//  DDExpressCourier
//
//  Created by Steven.Liu on 16/4/20.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (DefaultPage)

@property (nonatomic, strong, readonly) UIView *defaultPageView;

-(void)addDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title;

-(void)addDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle;

-(void)addDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action;

-(void)addDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action withTarget:(id)target;

- (void)setDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action;

- (void)setDefaultPageWithImageName:(NSString *)imageName andTitle:(NSString *)title andSubTitle:(NSString *)subTitle andBtnImage:(NSString *)btnImageName andbtnTitle:(NSString *)btnTitle andBtnAction:(SEL)action withTarget:(id)target;
@end
