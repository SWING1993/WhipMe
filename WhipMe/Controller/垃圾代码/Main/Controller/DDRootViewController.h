//
//  KRootViewController.h
//  DDExpressClient
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "DDInterface.h"
#import "DDInterfaceTool.h"
#import "MBProgressHUD+MJ.h"

typedef enum {
    CustomNavigationBarColorRed = 1,
    CustomNavigationBarColorWhite,
    CustomNavigationBarColorLightWhite,
    CustomNavigationBarColorBlack
} CustomNavigationBarColorTag;

@interface DDRootViewController : UIViewController

@property (nonatomic ,strong) UIView *shadowView;

- (void)adaptNavBarWithBgTag:(CustomNavigationBarColorTag)bgTag navTitle:(NSString *)title segmentArray:(NSArray *)array;

- (void)adaptLeftItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;
- (void)adaptLeftItemWithTitle:(NSString *)title backArrow:(BOOL)backArrow;

- (void)updateNavLeftSecondBarBtnWithNormalImage:(UIImage *)normalImage hightlightedImage:(UIImage *)highlightedImage;
- (void)updateNavLeftSecondBarBtnShow:(BOOL)show;

- (void)adaptFirstRightItemWithTitle:(NSString *)title;
- (void)adaptFirstRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;

- (void)adaptSecondRightItemWithTitle:(NSString *)title;
- (void)adaptSecondRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;
- (void)updateNavBarWithTitle:(NSString *)title;

- (void)onClickLeftItem;
- (void)onClickSecondLeftItem;
- (void)onClickFirstRightItem;
- (void)onClickSecondRightItem;
- (void)onClickSegment:(UISegmentedControl *)segmentControl;

- (NSInteger)getCurrentSelectedSegmentIndex;
- (void)updateSegmentControlWithIndex:(NSInteger)index;

- (void)disableBackGesture;
- (void)enableBackGesture;
- (void)adaptNavigationBarHidden:(BOOL)flag;


- (BOOL)isValidateMobile:(NSString *)mobile;
- (BOOL)isValidateNumber:(NSString *)number;
- (BOOL)isValidateEmail:(NSString *)email;
- (void)showForErrorMsg:(NSError *)objMsg;
- (void)displayForErrorMsg:(NSString *)objMsg;
- (NSString *)generateUuidString;
- (UIImage *)scaleImage:(UIImage *)image;
- (NSUInteger)lenghtWithString:(NSString *)string;
/** 筛选字符串中的数字 自区分字符和汉字，特殊字符没有限制*/
- (NSInteger)numberWithFiltrateString:(NSString *)string;
/** 根据日期字符串返回星座*/
- (NSString *)getWithDate:(NSString *)time;
/** 根据月、日返回星座*/
- (NSString *)getWithMonth:(NSInteger)m day:(NSInteger)d;
/** 根据日期字符串计算年龄*/
- (NSInteger)ageWithDateOfBirth:(NSString *)time;
/** 因有一定的时候图片获取为翻转、颠倒等，用户突破的位置矫正*/
- (UIImage *)fixOrientation:(UIImage *)aImage;

//友盟计数事件
- (void)uploadCountEventWithId:(NSString *)eventId label:(NSString *)eventLabel;
//友盟计算事件
- (void)uploadCaculateEventWithId:(NSString *)eventId attributes:(NSDictionary *)eventAttributes;
/**网络状态通知*/
- (BOOL)reachability;
@end
