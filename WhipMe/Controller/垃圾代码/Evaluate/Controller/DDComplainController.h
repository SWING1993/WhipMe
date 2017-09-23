//
//  DDComplainController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
/**
    投诉页面
 */
#import "DDRootViewController.h"

@interface DDComplainController : DDRootViewController

/** 需要投诉的订单号 */
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,copy) NSString *servicePhone;

@end
