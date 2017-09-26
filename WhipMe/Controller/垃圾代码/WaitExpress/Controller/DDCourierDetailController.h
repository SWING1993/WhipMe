//
//  DDCourierDetailController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//




/**
 *  快递员详细信息
 */

#import "DDRootViewController.h"


@interface DDCourierDetailController : DDRootViewController

/** 实例方法，传快递员Id */
- (instancetype)initWithCourierId:(NSString *)courierId;


@end
