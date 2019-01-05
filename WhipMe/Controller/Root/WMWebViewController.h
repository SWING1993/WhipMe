//
//  WMWebViewController.h
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WMWebViewType) {
    WMWebViewTypeNetwork = 0,
    WMWebViewTypeLocal = 1,
    WMWebViewTypeHelpCenter = 2,
};

@interface WMWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, assign) WMWebViewType webType;
@property (nonatomic, copy  ) NSString *urlPath;
@property (nonatomic, assign) BOOL isBounces;

@property (nonatomic, strong) UIWebView *webViewWM;

- (instancetype)initWithWebType:(WMWebViewType)type;
- (instancetype)initWithUrlPath:(NSString *)ursString;

@end
