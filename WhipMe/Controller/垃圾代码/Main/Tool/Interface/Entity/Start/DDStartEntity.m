//
//  DDStartEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDStartEntity.h"
#import "DDInterfaceTool.h"
#import "AFNetworkReachabilityManager.h"
#import "DDConnect.h"
#import "DDRequest.h"


#pragma mark Model Key

NSString *const DDStartStartMQ                                  = @"start";                                             /**< 是否是开始 0 不是 1是 */

NSString *const DDStartAutoLoginM                               = @"autoLogin";                                         /**< 是否是自动登录 Key */
NSString *const DDStartUserInfoM                                = @"userInfo";                                          /**< 用户信息 Key */
NSString *const DDStartUserIDM                                  = @"selfId";                                            /**< 用户IDKey */
NSString *const DDStartAvatarM                                  = @"headIcon";                                          /**< 头像Key */
NSString *const DDStartNameM                                    = @"name";                                              /**< 名字Key */
NSString *const DDStartNickM                                    = @"nickName";                                          /**< 昵称Key */
NSString *const DDStartEmailM                                   = @"emailAddress";                                      /**< 邮件Key */
NSString *const DDStartBrithdayM                                = @"birthDay";                                          /**< 生日Key */
NSString *const DDStartSexM                                     = @"sex";                                               /**< 性别Key */
NSString *const DDStartJobM                                     = @"job";                                               /**< 工作Key */
NSString *const DDStartAuthM                                    = @"idetify";                                           /**< 认证Key */
NSString *const DDStartPhoneM                                   = @"phoneNumber";                                       /**< 手机号Key */

#pragma mark Interface Key

const NSInteger DDStartAutoLoginIFCode                          = 1006;                                                 /**< 自动登录接口业务码 */
NSString *const DDStartAutoLoginIFVersion                       = @"1.0.0";                                             /**< 自动登录接口版本号 */

NSString *const DDStartUserKeyIF                                = @"userKey";                                           /**< UserKey Key */
NSString *const DDStartUserIdIF                                 = @"userId";                                            /**< UserID Key */
NSString *const DDStartDeviceIdIF                               = @"devId";                                             /**< 设备标示ID Key */

NSString *const DDStartAvatarIF                                 = @"avatar";                                            /**< 头像Key */
NSString *const DDStartNameIF                                   = @"name";                                              /**< 名字Key */
NSString *const DDStartNickIF                                   = @"nick";                                              /**< 昵称Key */
NSString *const DDStartEmailIF                                  = @"email";                                             /**< 邮件Key */
NSString *const DDStartBrithdayIF                               = @"birthday";                                          /**< 生日Key */
NSString *const DDStartSexIF                                    = @"sex";                                               /**< 性别Key */
NSString *const DDStartJobIF                                    = @"job";                                               /**< 工作Key */
NSString *const DDStartAuthIF                                   = @"auth";                                              /**< 认证Key */

@interface DDStartEntity ()<DDRequestDelegate, DDConnectDelegate>

@property (nonatomic, strong)   DDRequest                                       *aLoginRequset;                         /**< 自动登录请求实例 */
@property (nonatomic, strong)   DDConnect                                       *connect;                               /**< 连接实例 */
@property (nonatomic, strong)   NSTimer                                         *connectTimer;                          /**< 重连定时器 */

@end

@implementation DDStartEntity

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    self.connectTimer = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self reachability];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

+ (instancetype)instanceWithDelegate:(id<DDEntityDelegate>)delegate {
    static DDStartEntity                  *instance   = nil;
    static dispatch_once_t           predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[DDStartEntity alloc] init];
        instance.delegate = delegate;
    });
    
    return instance;
}

- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)entityWithParam:(NSDictionary *)param {
    [DDInterfaceTool configLoginSucced:NO];
    [DDInterfaceTool configStop:NO];
    
    self.connect    = [[DDConnect alloc] initWithDelegate:self];
    NSInteger start = [[param objectForKey:DDStartStartMQ] integerValue];
    if (0 == start) {//不是开始时 直接重连
        [self.connect connect];
        return;
    }
    
    NSString *userKey = [DDInterfaceTool getUserkey];
    if (userKey) {
        //连接服务器,自动登录
        [self.connect connect];
    } else {
        //手动登录
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],DDStartAutoLoginM, nil];
        [self sendResult:result error:nil];
    }
}

#pragma mark -
#pragma mark Private Methodss

/**
 *  回调前面结果
 *
 *  @param result 结果字典
 *  @param error  错误信息
 */
- (void)sendResult:(NSDictionary *)result error:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) {
        [self.delegate entity:self result:result error:error];
    }
}

/**
 *  网络情况
 */
- (void)reachability {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [DDInterfaceTool configLoginSucced:NO];
        
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSError *error = [NSError errorWithDomain:@"网络不可用" code:ErrorNoReachable userInfo:nil];
            [weakSelf sendResult:nil error:error];
        } else {
            //连接服务器(在已经登录过的情况下)
            if ([DDInterfaceTool getUserkey]) {
                self.connect = [[DDConnect alloc] initWithDelegate:self];
                [self.connect connect];
            }
        }
     }];
}

/**
 *  自动登录
 */
- (void)autoLogin {
    self.aLoginRequset  = [[DDRequest alloc] initWithDelegate:self];
    
    NSNumber *code      = [NSNumber numberWithInteger:DDStartAutoLoginIFCode];
    NSString *version   = DDStartAutoLoginIFVersion;
    NSString *userKey   = [DDInterfaceTool getUserkey];
    NSNumber *userID    = [NSNumber numberWithInteger:[DDInterfaceTool getUserID]];
    NSString *deviceID  = [DDInterfaceTool getUUIDString];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           code,                        CodeKey,
                           version,                     VersionKey,
                           userKey,                     DDStartUserKeyIF,
                           userID,                      DDStartUserIdIF,
                           deviceID,                    DDStartDeviceIdIF,
                           nil];
    
    [self.aLoginRequset socketRequstWithType:SOCKET_REQUEST_TYPE_AUTOLOGIN param:param];
}

/**
 *  获得Model所用字典
 *
 *  @param result 结果字典
 *
 *  @return model所用字典
 */
- (NSDictionary *)modleWithResult:(NSDictionary *)result {
    NSNumber        *autoLogin      = [NSNumber numberWithInteger:1];
    NSDictionary    *modelDic       = [NSDictionary dictionaryWithObjectsAndKeys:
                                       autoLogin,       DDStartAutoLoginM,
                                       nil];
    return modelDic;
}

/**
 *  开始定时器
 */
- (void)startTimer {
    NSTimeInterval outTime = 3.0f;
    
    if ([self.connectTimer isValid]) {
        [self.connectTimer invalidate];
        [self setConnectTimer:nil];
    }
    self.connectTimer   = [NSTimer timerWithTimeInterval:outTime target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
}

/**
 *  定时器触发
 */
- (void)timerFire:(NSTimer *)timer {
    NSLog(@"定时重连服务器");
    AFNetworkReachabilityManager    *manager = [AFNetworkReachabilityManager sharedManager];
    NSString                        *userKey = [DDInterfaceTool getUserkey];
    if ((AFNetworkReachabilityStatusNotReachable != manager.networkReachabilityStatus) && userKey) {
        self.connect = [[DDConnect alloc] initWithDelegate:self];
        [self.connect connect];
    }
}

#pragma mark -
#pragma mark DDRequestDelegate

- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error {
    if (![request isEqual:self.aLoginRequset]) return;
    
    if (error) {
        [self sendResult:nil error:error];
        return;
    }
    
    NSInteger code = [[result ddObjectForKey:CodeKey classType:CLASS_TYPE_NSNUMBER] integerValue];
    if (code != SuccessCode) {//出现错误转手动登录
        [DDInterfaceTool configUserkey:@""];
        [DDInterfaceTool configUserID:0];
        [DDInterfaceTool configPhoneNumber:@""];
        
        NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:0],DDStartAutoLoginM, nil];
        [self sendResult:result error:nil];
        return;
    }
    
    [DDInterfaceTool configLoginSucced:YES];
    [self sendResult:[self modleWithResult:result] error:nil];
}

#pragma mark -
#pragma mark DDConnectDelegate

- (void)connect:(DDConnect *)connect connnetStatus:(SOCKET_STATUS)status {
    if (![connect isEqual:self.connect]) return;
    
    if (SOCKET_STATUS_CONNECTED == status) {
        NSLog(@"连接成功，自动登录");
        [self autoLogin];
        return;
    }
    
    NSLog(@"服务器断开连接");
    
    if (![DDInterfaceTool getLoginSucced]) return;
    [DDInterfaceTool configLoginSucced:NO];
    
    NSError *error = [NSError errorWithDomain:@"服务器断开连接" code:ErrorHostDisConnect userInfo:nil];
    [self sendResult:nil error:error];
    
    AFNetworkReachabilityManager    *manager = [AFNetworkReachabilityManager sharedManager];
    NSString                        *userKey = [DDInterfaceTool getUserkey];
    BOOL                             stop    = [DDInterfaceTool getStop];
    NSLog(@"断开连接判断自动重连::<userKey>:<%@>;;<stop>:<%i>;;<reach>:<%li>;;", userKey, stop,(long)manager.networkReachabilityStatus);
    if ((AFNetworkReachabilityStatusNotReachable != manager.networkReachabilityStatus) && userKey && !stop) {
        NSLog(@"断开连接，自动重连");
        self.connect = [[DDConnect alloc] initWithDelegate:self];
        [self.connect connect];
    }
}

- (void)connect:(DDConnect *)connect connnetingStatus:(CONNECTING_STATUS)status {
    if (status == CONNECTING_STATUS_CONNECTING) {
        NSLog(@"连接建立中，自动登录");
        [self autoLogin];
    } else if (status == CONNECTING_STATUS_NOREACHABLE) {
        NSError *error = [NSError errorWithDomain:@"网络不可用" code:ErrorNoReachable userInfo:nil];
        [self sendResult:nil error:error];
    } else if (status == CONNECTING_STATUS_NOHOST) {
        [self startTimer];//开启重连定时器
//不提示错误
//        NSError *error = [NSError errorWithDomain:@"网络错误" code:ErrorNetWorkError userInfo:nil];
//        [self sendResult:nil error:error];
    } else if (status == CONNECTING_STATUS_TIMEOUT) {
        //连接超时直接重连
        self.connect = [[DDConnect alloc] initWithDelegate:self];
        [self.connect connect];
//不提示错误
//        NSError *error = [NSError errorWithDomain:@"连接超时" code:ErrorNetWorkError userInfo:nil];
//        [self sendResult:nil error:error];
    }
}

@end
