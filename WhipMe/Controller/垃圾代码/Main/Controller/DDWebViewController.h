//
//  DDWebViewController.h
//  DDWebViewController
//
//  Created by Steven.Liuon 15/6/24.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "DDRootViewController.h"

@interface DDWebViewController : DDRootViewController

/**
 *  网址
 */
@property (nonatomic, copy) NSString *URLString;

@property (nonatomic, strong) NSString *navTitle;

@end
