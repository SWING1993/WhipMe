//
//  DDMyExpressDetailViewController.h
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

/**
    快递列表详情查看
 */

#import "DDRootViewController.h"

@class DDMyExpress;
@interface DDMyExpressDetailViewController : DDRootViewController

- (instancetype)initWithModel:(DDMyExpress *)model;

@end
