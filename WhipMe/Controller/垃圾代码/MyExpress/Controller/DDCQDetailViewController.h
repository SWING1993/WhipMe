//
//  CQDetailViewController.h
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//
/**
    快递的查询结果视图
 */

typedef enum {
    DDCQDetailViewStyleQuery = 0,
    DDCQDetailViewStyleList
} DDCQDetailViewStyle;

#import "DDRootViewController.h"

@class DDMyExpress;
@interface DDCQDetailViewController : DDRootViewController

- (instancetype)initWithModel:(DDMyExpress *)model withStyle:(DDCQDetailViewStyle)style;

@end
