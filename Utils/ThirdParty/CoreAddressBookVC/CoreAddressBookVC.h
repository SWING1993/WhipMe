//
//  BlackCard-PrefixHeader.pch
//  BlackCard
//
//  Created by Mr.song on 16/5/24.
//  Copyright © 2016年 冒险元素. All rights reserved.

#import <UIKit/UIKit.h>
#import "JXPersonInfo.h"


@protocol CoreAddressBookVCDelegate;

@interface CoreAddressBookVC : UIViewController

@property (nonatomic, weak) id<CoreAddressBookVCDelegate> delegate;

- (instancetype)initWithDelegate:(id<CoreAddressBookVCDelegate>)delegate;

@end

@protocol CoreAddressBookVCDelegate <NSObject>
@optional
- (void)addressBookVCSelectedContact:(JXPersonInfo *)personInfo;

@end
