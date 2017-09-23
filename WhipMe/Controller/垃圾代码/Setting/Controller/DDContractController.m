//
//  DDContractController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDContractController.h"
#import "Constant.h"

@interface DDContractController ()

/** 合同文本 */
@property (nonatomic, weak) UITextView *textView;

@end

@implementation DDContractController

#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"服务条款" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
//    [self setContractTextView];
}

#pragma mark - 类的对象方法
- (void)setContractTextView
{
    //初始化合同文本
    UITextView *textView = [[UITextView alloc] init];
    [textView setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];

    [textView setText:@"Description it is  a test font, and don't become angry for which i use to do here.Now here is a very nice party from american or not!"];
    self.textView = textView;
    [self.view addSubview:textView];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"服务条款"];
}


- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
