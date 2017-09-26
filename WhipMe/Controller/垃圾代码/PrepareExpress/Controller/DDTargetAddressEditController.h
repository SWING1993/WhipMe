//
//  DDTargetAddressEditController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
/*
    收件人新增编辑地址
 **/
#import <UIKit/UIKit.h>
#import "DDTargetAddressEditView.h"
#import "DDAddressDetail.h"
#import "DDRootViewController.h"

@protocol DDTargetAddressEditDelegate <NSObject>
@optional
//- (void)editTargetAddressDetail:(DDAddressDetail *)person;
- (void)addTargetAddressDetail:(DDAddressDetail *)person;

@end

@interface DDTargetAddressEditController : DDRootViewController <DDTargetAddressEditViewDelegate>

/** 个人地址信息 */
@property (nonatomic, strong) DDAddressDetail *addressDetail;
/** 用来判断是添加寄件地址，还是编辑寄件地址 */
@property (nonatomic, assign) int isEdit;

@property (nonatomic, assign) id<DDTargetAddressEditDelegate> delegate;

@property (nonatomic, strong) DDAddressDetail *editAddressDetail;

@end
