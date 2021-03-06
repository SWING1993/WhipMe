//
//  IndexWebController.h
//  WhipMe
//
//  Created by Song on 2017/9/6.
//  Copyright © 2017年 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSObjcCDelegate <JSExport>

- (void)upLoadAddressBook:(NSString *)card;

@end


@interface IndexWebController : UIViewController

@property (nonatomic, strong) UIWebView *webViewWM;

@end


@interface JSObjectModel : NSObject<JSObjcCDelegate>

@property (nonatomic, weak) IndexWebController *webController;

@end
