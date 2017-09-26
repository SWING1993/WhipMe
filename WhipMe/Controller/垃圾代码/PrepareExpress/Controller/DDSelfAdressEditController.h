//
//  DDSelfAdressEditController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
/*
    寄件人新增编辑地址
 **/

#import "DDRootViewController.h"
#import "DDAddressDetail.h"
@class DDSelfAdressEditController;
@protocol DDSelfAddressEditDelegate <NSObject>

- (void)getValueWhenSaveInSelfAdressEdit:(DDSelfAdressEditController *)selfAdressEdit withChangedAddressDetail:(DDAddressDetail *)addressDetail;

@end

@interface DDSelfAdressEditController : DDRootViewController
@property (nonatomic,weak) id<DDSelfAddressEditDelegate> delegate;

@property (nonatomic, strong) DDAddressDetail *homeAddressDetail;

@property (nonatomic, strong) DDAddressDetail *editAddressDetail;

@property (nonatomic, assign) BOOL isEdit;
@end
