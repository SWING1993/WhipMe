//
//  ShareEngine.m
//  WhipMe
//
//  Created by anve on 16/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

#import "ShareEngine.h"
#import "NSString+Common.h"

static WMShareEngine *objShare = nil;
@implementation WMShareEngine

+ (WMShareEngine *)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objShare = [[WMShareEngine alloc] init];
    });
    return objShare;
}

- (void)registerApp {
    [WXApi registerApp:[Define appIDWeChat]];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    BOOL flag = NO;
    DebugLog(@"handle opern url : %@",url);
    if ([url.absoluteString hasPrefix:@"wx"]) {
        flag = [WXApi handleOpenURL:url delegate:self];
    }
    return flag;
}

//构造SendAuthReq结构体
- (void)sendAuthRequest:(id<WXApiEngineDelegate>)delegate {
    self.delegate = delegate;
    if ([WXApi isWXAppInstalled] == NO) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"没有安装微信" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertControl showViewController:(UIViewController *)self.delegate sender:nil];
    } else {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo,snsapi_base";
        req.state = @"whipme";
        //第三方向微信终端发送一个SendAuthReq消息结构
        BOOL flag = [WXApi sendReq:req];
        
        DebugLog(@"send is flag : %ld",(long)flag);
    }
}

- (void)sendWeChatPaymentInfo:(NSDictionary *)info
{
    if (!info) {
        return;
    }
    //调起微信支付 WX_PARTNER
    PayReq *req             = [[PayReq alloc] init];
    req.openID              = [NSString stringWithFormat:@"%@",info[@"appId"]];
    req.partnerId           = [NSString stringWithFormat:@"%@",info[@"partnerId"]];
    req.package             = [NSString stringWithFormat:@"%@",info[@"pkg"]];
    
    req.prepayId            = [NSString stringWithFormat:@"%@",info[@"prepayId"]];
    req.nonceStr            = [NSString stringWithFormat:@"%@",info[@"noncestr"]];
    req.timeStamp           = [info[@"timestamp"] intValue];
    req.sign                = [NSString stringWithFormat:@"%@",info[@"sign"]];
    
    [WXApi sendReq:req];
}

//创建package签名
- (NSString *)createMd5Sign:(NSMutableDictionary *)dict
{
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *contentString = [NSMutableString string];
    //拼接字符串
    for (NSString *categoryId in sortedArray)
    {
        if (![[dict objectForKey:categoryId] isEqualToString:@""] && ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"])
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    [contentString appendFormat:@"key=%@", @"LIHASDHAasdfasdfasfKLASDHGAkghas"];
    NSString *md5Sign = [contentString md5Str];
    
    return md5Sign;
}

#pragma mark - WXApiDelegate
- (void)onReq:(BaseReq *)req {
    DebugLog(@"on req is : %@", req);
}

- (void)onResp:(BaseResp *)resp {
    DebugLog(@"on resp is : %@",resp);
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if ([self.delegate respondsToSelector:@selector(shareEngineWXApi:)]) {
            [self.delegate shareEngineWXApi:authResp];
        }
    } else if ([resp isKindOfClass:[PayResp class]]) {
        if ([self.delegate respondsToSelector:@selector(shareEnginePayment:)]) {
            PayResp *authResp = (PayResp *)resp;
            [self.delegate shareEnginePayment:authResp];
        }
    }
}

@end
