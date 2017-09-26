//
//  ChildPageViewController.h
//  YouShaQi
//
//  Created by JC_CP3 on 14-4-8.
//  Copyright (c) 2014年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"

@protocol ChildPageViewDelegate <NSObject>

@optional
- (void)authBtnClicked:(NSInteger)btnIndex;
- (void)enterBtnClicked;

@end

@interface ChildPageViewController : UIViewController

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, weak) id<ChildPageViewDelegate> childPageViewDelegate;
@end
