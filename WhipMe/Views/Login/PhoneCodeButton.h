//
//  PhoneCodeButton.h
//  BlackCard
//
//  Created by Mr.song on 16/5/24.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kShow @"isShow"

@interface PhoneCodeButton : UIButton

@property (nonatomic, assign) BOOL isShow;

- (void)startUpTimer;
- (void)invalidateTimer;

@end
