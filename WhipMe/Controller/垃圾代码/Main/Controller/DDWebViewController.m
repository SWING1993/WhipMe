//
//  DDWebViewController.m
//  DDWebViewController
//
//  Created by Steven.Liu on 15/6/24.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "DDWebViewController.h"
#import "CustomStringUtils.h"

#import "ShareMessageItem.h"
#import "ShareSDKUtils.h"

static const CGFloat bottomToolBarHeight = 49;

@interface DDWebViewController () <UIWebViewDelegate, UIActionSheetDelegate, ShareSDKViewDelegate>
{
    UIActivityIndicatorView *activityIndicator;
    
    UIBarButtonItem *backBarButtonItem;
    UIBarButtonItem *forwardBarButtonItem;
    UIBarButtonItem *refreshBarButtonItem;
    UIToolbar *toolBar;
    
    UIWebView *webView;
    NSString *shareUrl;
    
    NSString *needShareURL;
    NSString *shareSuccessedLoadURL;
}
@property (nonatomic, strong) UIView *shareBackView;
/**  底部分享视图  */
@property (nonatomic, strong) UIView *shareView;
/**  微信好友按钮  */
@property (nonatomic, strong) UIButton *wechatFriendsBtn;
/**  朋友圈按钮  */
@property (nonatomic, strong) UIButton *wechatCircleBtn;
/**  取消按钮  */
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIImageView *barcodeImageView;


@end

@implementation DDWebViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    NSString *showNavTitle = ![CustomStringUtils isBlankString:self.navTitle] ? self.navTitle : @"";
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:showNavTitle segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"back") highlightedImage:ImageNamed(@"back")];
    
    [self updateNavLeftSecondBarBtnWithNormalImage:ImageNamed(@"close") hightlightedImage:ImageNamed(@"close")];
    
    [self webViewInitialize];
    
    // 加载loading
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 32,32)];
    [activityIndicator setCenter:CGPointMake(MainScreenWidth / 2, 240)];
    [activityIndicator setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    
    [self.view addSubview:self.shareBackView];
    [self.shareBackView addSubview:self.shareView];
    [self.shareView addSubview:self.barcodeImageView];
    [self.shareView addSubview:self.wechatCircleBtn];
    [self.shareView addSubview:self.wechatFriendsBtn];
    [self.shareView addSubview:self.cancelBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self disableBackGesture];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)webViewInitialize
{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - 64)];
    [webView setDelegate:self];
//    webView.userInteractionEnabled = YES;
//    webView.scalesPageToFit = YES;
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:webView];
    
    if (![CustomStringUtils isBlankString:self.URLString]) {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    }
}

- (void)toolBarInitialize
{
    //调整baritem之间的位置的，可以自己设置宽度
    UIBarButtonItem *fixedSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace1.width = 100;
    
    UIBarButtonItem *fixedSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace2.width = 10;
    
    //调整baritem之间的位置，自动调整现有按钮使最大限度占据工具栏的所有空间。
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(webView.frame), MainScreenWidth, bottomToolBarHeight)];
    toolBar.tag = 3;
    UIImageView *toolBarShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, -3, MainScreenWidth, 3)];
    toolBarShadow.image = ImageNamed(@"sm_bottom_shadow.png");
    [toolBar addSubview:toolBarShadow];
    
    [toolBar setBackgroundImage:[self createImageFromColor:RGBCOLOR(30, 30, 30) width:MainScreenWidth height:bottomToolBarHeight] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIButton *backBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    [backBarButton addTarget:self action:@selector(goBackClicked) forControlEvents:UIControlEventTouchUpInside];
    backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBarButton];
    backBarButtonItem.style = UIBarButtonItemStylePlain;
    
    UIButton *forwardBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    [forwardBarButton addTarget:self action:@selector(goForwardClicked) forControlEvents:UIControlEventTouchUpInside];
    forwardBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardBarButton];
    forwardBarButtonItem.style = UIBarButtonItemStylePlain;
    
    UIButton *refreshBarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 49, 49)];
    [refreshBarButton addTarget:self action:@selector(reloadClicked) forControlEvents:UIControlEventTouchUpInside];
    refreshBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBarButton];
    refreshBarButtonItem.style = UIBarButtonItemStylePlain;
    
    NSArray *items;
    items = [NSArray arrayWithObjects:flexibleSpace, backBarButtonItem, fixedSpace2, forwardBarButtonItem, fixedSpace1, refreshBarButtonItem, flexibleSpace, nil];
    toolBar.items= items;
    
    [self.view addSubview:toolBar];
}

- (void)updateToolbarItems
{
    backBarButtonItem.enabled = webView.canGoBack;
    forwardBarButtonItem.enabled = webView.canGoForward;
    refreshBarButtonItem.enabled = !webView.isLoading;
}

#pragma mark - TargetAction

- (void)goBackClicked
{
    [webView goBack];
}

- (void)goForwardClicked
{
    [webView goForward];
}

- (void)reloadClicked
{
    [webView reload];
}

//自定义颜色
- (UIImage *)createImageFromColor:(UIColor *)color width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)onClickLeftItem
{
    if (webView.canGoBack) {
        
        [self goBackClicked];
        [self updateNavLeftSecondBarBtnShow:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onClickSecondLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator stopAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = request.URL.absoluteString;
    
    NSArray *components = [requestString componentsSeparatedByString:@"::"];
    
    if ([components count] > 0) {
        NSString *requestMethod = [components objectAtIndex:0];
        if ([requestMethod isEqualToString:@"share"]) {
            self.shareBackView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.shareBackView.backgroundColor = DDRGBAColor(0, 0, 0, 0.3);
                self.shareBackView.y -= 420;
            }];
        }
        
        if (components.count > 1) {
            needShareURL = [kURL_Pre_Test stringByAppendingString:[components objectAtIndex:1]];
        }
        
        if (components.count > 2) {
            shareSuccessedLoadURL = [kURL_Pre_Test stringByAppendingString:[components objectAtIndex:2]];
        }
    }
    
    NSLog(@"%@", requestString);
    return YES;
}


#pragma mark - ShareSDKDelegate
- (void)shareMessageSucceed
{
}


#pragma mark - Setter && Getter
- (UIView *)shareBackView
{
    if (_shareBackView == nil) {
        _shareBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 420)];
        _shareBackView.backgroundColor = DDRGBAColor(0, 0, 0, 0);
        _shareBackView.hidden = YES;
        _shareBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewCancelButtonClick)];
        [_shareBackView addGestureRecognizer:tapGesture];
    }
    return _shareBackView;
}


- (UIView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height, self.shareBackView.width, 420)];
        _shareView.backgroundColor = DDRGBAColor(255, 255, 255, 1);
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.shareView.height - 43, self.view.width, 0.5f)];
        lineView.backgroundColor = DDRGBColor(233, 233, 233);
        [_shareView addSubview:lineView];
        
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width/2-45, 250, 90, 15)];
        shareLabel.text = @"分享推荐";
        shareLabel.textColor = DDRGBAColor(153, 153, 153, 1);
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.font = [UIFont systemFontOfSize:14];
        [_shareView addSubview:shareLabel];
        
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(48, shareLabel.y + 7.5, self.view.width/2 - 48 - 45, 0.5)];
        leftLine.backgroundColor = DDRGBColor(233, 233, 233);
        [_shareView addSubview:leftLine];
        
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(shareLabel.right, shareLabel.y + 7.5, leftLine.width, 0.5)];
        rightLine.backgroundColor = DDRGBColor(233, 233, 233);
        [_shareView addSubview:rightLine];
    }
    return _shareView;
}


- (UIImageView *)barcodeImageView
{
    if (_barcodeImageView == nil) {
        _barcodeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.width - 155)/2, 35, 155, 155)];
        _barcodeImageView.image = [UIImage imageNamed:@"qr-code"];
        _barcodeImageView.contentMode = UIViewContentModeCenter;
        
        
        UILabel *underImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(_barcodeImageView.left, _barcodeImageView.bottom + 10, _barcodeImageView.width, 14)];
        underImageLabel.text = @"扫码推荐";
        underImageLabel.textAlignment = NSTextAlignmentCenter;
        underImageLabel.textColor = DDRGBColor(102, 102, 102);
        underImageLabel.font = [UIFont systemFontOfSize:14];
        [_shareView addSubview:underImageLabel];
        
    }
    return _barcodeImageView;
}
-(UIButton *)wechatFriendsBtn
{
    if (_wechatFriendsBtn == nil) {
        _wechatFriendsBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width / 2 - 100, 268, 100, 112)];
        [_wechatFriendsBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_wechatFriendsBtn addTarget:self action:@selector(wechatFriendsBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_wechatFriendsBtn setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 12, 0)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_wechatFriendsBtn.x, _wechatFriendsBtn.top + 77, _wechatFriendsBtn.width, 15)];
        label.text = @"微信好友";
        label.textColor = DDRGBColor(102, 102, 102);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.shareView addSubview:label];
    }
    return _wechatFriendsBtn;
}


- (UIButton *)wechatCircleBtn
{
    if (_wechatCircleBtn == nil) {
        _wechatCircleBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width / 2, 268, 100, 112)];
        [_wechatCircleBtn setImage:[UIImage imageNamed:@"friend-zone"] forState:UIControlStateNormal];
        [_wechatCircleBtn addTarget:self action:@selector(wechatCircleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_wechatCircleBtn setImageEdgeInsets:UIEdgeInsetsMake(-12, 0, 12, 0)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_wechatCircleBtn.x, _wechatCircleBtn.top + 77, _wechatCircleBtn.width, 15)];
        label.text = @"朋友圈";
        label.textColor = DDRGBColor(102, 102, 102);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [self.shareView addSubview:label];
    }
    return _wechatCircleBtn;
}

-(UIButton *)cancelBtn
{
    if (_cancelBtn == nil) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.shareView.height - 42, self.view.width, 42)];
        [_cancelBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:DDRGBColor(51, 51, 51) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_cancelBtn addTarget:self action:@selector(shareViewCancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (void)wechatFriendsBtnClick
{
    [self pushToPlatformFromPlatformType:SSDKPlatformSubTypeWechatSession];
}

- (void)wechatCircleBtnClick
{
    [self pushToPlatformFromPlatformType:SSDKPlatformSubTypeWechatTimeline];
}

- (void)pushToPlatformFromPlatformType:(SSDKPlatformType)type
{
    ShareMessageItem *item = [[ShareMessageItem alloc] init];
    item.title = @"新用户首单免费寄！7元优惠券限时领取";
    item.message = @"艾特小哥联合2万快递员欧巴，一起宠爱你";
    item.image = RecommendShareImageURL;
    
    if (![CustomStringUtils isBlankString:needShareURL]) {
        item.url = needShareURL;
    }
    [ShareSDKUtils shareInstance].shareSDKViewDelegate = self;
    [[ShareSDKUtils shareInstance] shareMessageWithPlatformType:type shareMessageItem:item];
}


- (void)shareViewCancelButtonClick
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareBackView.backgroundColor = DDRGBAColor(0, 0, 0, 0);
        self.shareBackView.y += 420;
    } completion:^(BOOL finished) {
        self.shareBackView.hidden = YES;
    }];
}

@end
