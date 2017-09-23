//
//  DDPrepareSendViewController.h
//  DuDu Courier
//
//  Created by yangg on 16/4/6.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import "DDRootViewController.h"
#import "DDAddressDetail.h"
@class DDCourierDetail;
@class DDSendInfo;


extern NSString *const NavigationItemTitle;


typedef NS_ENUM(NSInteger, DDTableViewSection) {
    DDTableViewSectionOne = 0,
    DDTableViewSectionTwo = 1,
    DDTableViewSectionThree = 2,
    DDTableViewSectionFour = 3,
};
typedef NS_ENUM(NSInteger, DDTableViewRow) {
    DDTableViewRowOne = 0,
    DDTableViewRowTwo = 1,
    DDTableViewRowThree = 2,
    DDTableViewRowFour = 3,
};

typedef NS_ENUM(NSInteger, DDPhotoButton) {
    DDTakePhotoFromCamera = 0,              /**  拍照  */
    DDTakePhotoFromPhotoLibrary = 1,        /**  相册  */
    DDTakePhotoCancel     = 2,              /**  取消  */
};

typedef NS_ENUM(NSInteger, DDPickViewSection) {
    DDDatePickerDay = 0,
    DDDatePickerHour = 1,
    DDDatePickerMinute = 2,
};



@class DDPrepareSendViewController;
@protocol DDPrepareSendViewDelegate <NSObject>
@optional
- (void)prepareSendView:(DDPrepareSendViewController *)prepareSendViewController popAnimationWithOrderId:(NSString *)orderId andOrderType:(NSInteger)flag;
- (void)prepareSendView:(DDPrepareSendViewController *)prepareSendViewController popWaitCourierGetWithOrderId:(NSString *)orderId;

@end

@interface DDPrepareSendViewController : DDRootViewController

- (instancetype)initWithDetailCourier:(DDCourierDetail *)courierDetail;

/** 判断是不是用户首次收件 */
@property (nonatomic, assign) BOOL  isFirstS;
/** 判断我要寄件进入还是追单进入  0:我要寄件 1:追单  2:再寄一件*/
@property (nonatomic, assign) NSInteger lastViewFlag;

@property (nonatomic, assign) id <DDPrepareSendViewDelegate> delegate;

@property (nonatomic, strong) DDAddressDetail *homeAddressDetail;

@property (nonatomic, assign) BOOL isFromHomePage;

@property (nonatomic, strong) NSMutableArray *expressCompanyArray;

@end
