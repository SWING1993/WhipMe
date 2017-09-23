//
//  DDSelfAddressListController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
/*
    寄件人地址列表
 **/

#import <UIKit/UIKit.h>
#import "DDRootViewController.h"

@class DDAddressDetail;
@class DDSelfAddressListController;
@protocol DDSelfAddressListDelegate <NSObject>
@optional


@end

@interface DDSelfAddressListController : DDRootViewController

/** 地址列表的数据源 */
@property (nonatomic,strong) NSMutableArray *addressDetailArray;

@property (nonatomic,weak) id <DDSelfAddressListDelegate> delegate;

@property (nonatomic,copy) NSString * choosedId;
@end
