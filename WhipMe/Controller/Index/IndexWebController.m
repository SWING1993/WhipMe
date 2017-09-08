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
    NSDictionary *params = @{@"card":card,@"datas":[datas mj_JSONString]};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.kayouxiang.com"]];
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer   = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    [manager POST:@"/submits" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        id data = [result mj_JSONObject];
        DebugLog(@"success:%@",data);
        [Tool showHUDTipWithTipStr:@"上传成功"];
        [self.webController.webViewWM loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kayouxiang.com/mobile/myRz.htm"]]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        DebugLog(@"error:%@",error);
        [Tool showHUDTipWithTipStr:@"上传失败"];
        [self.webController.webViewWM loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.kayouxiang.com/mobile/myRz.htm"]]];
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
}

- (void)startLoad {
    if (self.webViewWM.isLoading) {
        return;
    }
    NSURL *url = [NSURL URLWithString:@"http://www.kayouxiang.com/mobile/index.htm"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
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
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if([error code] == NSURLErrorCancelled) {
        return;
    }
}

@end
