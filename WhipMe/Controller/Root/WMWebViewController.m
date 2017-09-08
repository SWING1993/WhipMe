//
//  WMWebViewController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMWebViewController.h"

@interface WMWebViewController ()

@end

@implementation WMWebViewController

- (instancetype)initWithUrlPath:(NSString *)ursString
{
    self = [super init];
    if (self) {
        _urlPath = ursString;
    }
    return self;
}

- (instancetype)initWithWebType:(WMWebViewType)type
{
    self = [super init];
    if (self) {
        _webType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    WEAK_SELF
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _webViewWM = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webViewWM.scalesPageToFit = YES;
    _webViewWM.delegate = self;
    [self.view addSubview:self.webViewWM];
    [self.webViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    if (self.isBounces) {
        [self.webViewWM.scrollView setBounces:NO];
    }
    if (self.webType == WMWebViewTypeLocal) {
        self.urlPath = @"http://www.superspv.com/help/contract.jsp";
    } else if (self.webType == WMWebViewTypeHelpCenter) {
        self.urlPath = @"http://www.superspv.com/help/question.jsp";
    }
    [self startLoad];
}

- (void)startLoad {
    if (self.webViewWM.request) {
        return;
    }
    if ([NSString isBlankString:self.urlPath]) {
        [self loadErrorHtml];
        return;
    }
    
    NSURL *url = [NSURL URLWithString:self.urlPath];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    [self.webViewWM loadRequest:request];
}

//- (void)loadLocalHtml {
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
//    
//    [self.navigationItem setTitle:@"用户协议"];
//    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"userAgreement" ofType:@"html"];
//    if (self.webType == WMWebViewTypeHelpCenter) {
//        [self.navigationItem setTitle:@"帮助中心"];
//        htmlPath = [[NSBundle mainBundle] pathForResource:@"HelpCenter" ofType:@"html"];
//    }
//    
//    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//    [self.webViewWM loadHTMLString:htmlCont baseURL:baseURL];
//}

- (void)loadErrorHtml {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    [self.webViewWM loadHTMLString:htmlCont baseURL:baseURL];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
   
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([NSString isBlankString:webTitle] == NO) {
        self.navigationItem.title = webTitle;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([error code] == NSURLErrorCancelled) {
        return;
    }
   
    
}


@end
