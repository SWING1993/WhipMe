//
//  DDZbarViewController.h
//  DDExpressClient
//
//  Created by yangg on 16/3/12.
//  Copyright © 2016年 NS. All rights reserved.
//
/**
 二维码、条形码扫描界面
 */

#import "DDRootViewController.h"

/** 二维码扫描返回值 */
@protocol DDZbarViewDelegate <NSObject>
@optional
- (void)zbarViewWithMachineReadableCodeObject:(NSString *)zbarData;
@end

@interface DDZbarViewController : DDRootViewController

@property (nonatomic, assign) id<DDZbarViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<DDZbarViewDelegate>)delegate;

@end
