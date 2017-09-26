//
//  DDInputAddressController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//



/**
    区分是建议地址还是旧地址
 */
typedef enum {
    DDStyleoldAddress = 0,          //旧地址
    DDStyleSuggestionAddress = 1,   //建议地址

} DDInputAddressStyle;
/**
    区分是否存在文字
 */
typedef enum {
    DDNoTextInTextField = 0,
    DDHaveTextInTextField = 1,
} DDInputTextExist;



#import "DDRootViewController.h"
#import "DDAddressDetail.h"
@class DDInputAddressController;
@protocol DDInputAddressControllerDelegate <NSObject>
@optional
/** 将选择的地址回传 */
- (void)passInputAddress:(DDInputAddressController *)InputAddressController withSuggestionAddress:(DDAddressDetail *)addressDetail;

@end

@interface DDInputAddressController : DDRootViewController

/** 百度地图背景图片 */
@property (nonatomic, strong) UIImage *backgroundMapImage;
/** 传地址代理*/
@property (nonatomic, assign) id<DDInputAddressControllerDelegate> delegate;

@property (assign, nonatomic) BOOL isBackToHome;

@end
