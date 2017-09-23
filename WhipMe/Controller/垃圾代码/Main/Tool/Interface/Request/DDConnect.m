//
//  DDConnect.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDConnect.h"
#import "AFNetworkReachabilityManager.h"
#import "DDRequest.h"

NSString *const DDConnnectSocketStatusKVO       = @"socketStatus";                                                      /**< KVO网络状态 */

const NSInteger DDconnectHostIFCode             = 10000;                                                                /**< 请求服务器地址接口业务码 */
NSString *const DDconnectHostIFVersion          = @"1.0.0";                                                             /**< 请求服务器地址接口版本号 */

NSString *const DDConnectDeviceIdKey            = @"devId";                                                             /**< 设备标示Key */
NSString *const DDConnectHostKey                = @"host";                                                              /**< 服务器IPKey */
NSString *const DDConnectPortKey                = @"port";                                                              /**< 服务器端口Key */

@interface DDConnect ()<DDRequestDelegate>

@property (nonatomic, assign)   CONNECTING_STATUS                                connectingStatus;                      /**< 连接服务器时状态 */
@property (nonatomic, assign)   SOCKET_STATUS                                    socketStatus;                          /**< 长连接连接状态 */

@property (nonatomic, weak)     DDNetInstance                                   *netInstance;                           /**< 网络单例实例 */
@property (nonatomic, weak)     Pomelo                                          *pomelo;                                /**< 长连接实例 */

@property (nonatomic, strong)   DDRequest                                       *hostRequset;                           /**< 服务器地址请求实例 */
@property (nonatomic, assign)   NSInteger                                        requsetHostNum;                        /**< 获取服务器地址次数 */

@property (nonatomic, strong)   NSTimer                                         *outTimer;                              /**< 超时定时器 */

@end

@implementation DDConnect

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    [self.netInstance removeObserver:self forKeyPath:DDConnnectSocketStatusKVO context:nil];
    [self setOutTimer:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.netInstance    = [DDNetInstance netInstance];
        self.socketStatus   = self.netInstance.socketStatus;
        self.pomelo         = self.netInstance.pomelo;
        
        [self.netInstance addObserver:self forKeyPath:DDConnnectSocketStatusKVO options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    return self;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:DDConnnectSocketStatusKVO] && [object isEqual:self.netInstance]) {
        self.socketStatus   = self.netInstance.socketStatus;
        if ([self.outTimer isValid]) {
            [self.outTimer invalidate];
            [self setOutTimer:nil];
        } else {
            if (self.socketStatus == SOCKET_STATUS_CONNECTED) return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(connect:connnetStatus:)]) {
            [self.delegate connect:self connnetStatus:self.socketStatus];
        }
    }
}

#pragma mark -
#pragma mark Public Methods

- (instancetype)initWithDelegate:(id<DDConnectDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate   = delegate;
    }
    
    return self;
}

- (void)connect {
    if ([self.pomelo connected]) {
        self.connectingStatus = CONNECTING_STATUS_CONNECTING;
        [self sendConnecingStatus];
        return;
    }
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (AFNetworkReachabilityStatusNotReachable != manager.networkReachabilityStatus) {
        self.requsetHostNum = 0;
        [self requstHost];
    } else {
        self.connectingStatus = CONNECTING_STATUS_NOREACHABLE;
        [self sendConnecingStatus];
    }
}

- (void)disConnnect {
    [self.pomelo disconnect];
}

#pragma mark -
#pragma mark Private Methods

/**
 *  请求服务器IP和PORT
 */
- (void)requstHost {
    self.requsetHostNum++;
    
    self.hostRequset        = [[DDRequest alloc] initWithDelegate:self];
    NSNumber    *code       = [NSNumber numberWithInteger:DDconnectHostIFCode];
    NSString    *version    = DDconnectHostIFVersion;
    NSString    *deviceID   = [DDInterfaceTool getUUIDString];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           code,        CodeKey,
                           version,     VersionKey,
                           deviceID,    DDConnectDeviceIdKey,
                           nil];
    [self.hostRequset httpRequestWithType:HTTP_REQUEST_TYPE_FIND_SERVER param:param];
}

/**
 *  发送连接服务器中状态
 *
 *  @param status 连接服务器中状态
 */
- (void)sendConnecingStatus {
    if (self.delegate && [self.delegate respondsToSelector:@selector(connect:connnetingStatus:)]) {
        [self.delegate connect:self connnetingStatus:self.connectingStatus];
    }
}

/**
 *  开始定时器
 */
- (void)startTimer {
    NSTimeInterval outTime = 5.0f;
    
    if ([self.outTimer isValid]) {
        [self.outTimer invalidate];
        [self setOutTimer:nil];
    }
    self.outTimer   = [NSTimer timerWithTimeInterval:outTime target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.outTimer forMode:NSRunLoopCommonModes];
}

/**
 *  定时器触发
 */
- (void)timerFire:(NSTimer *)timer {
    self.connectingStatus = CONNECTING_STATUS_TIMEOUT;
    [self sendConnecingStatus];
}

#pragma mark -
#pragma mark DDRequestDelegate

- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error {
    if (![request isEqual:self.hostRequset]) return;
    
    if ((!error) && ([[result objectForKey:CodeKey] integerValue] == SuccessCode)) {
        NSString    *host       = [result objectForKey:DDConnectHostKey];
        NSInteger    port       = [[result objectForKey:DDConnectPortKey] integerValue];
        [self.pomelo connectToHost:host onPort:port];
        [self startTimer];
        
        return;
    }
    
    if (self.requsetHostNum < 2 ) [self requstHost];
    else {
        self.connectingStatus = CONNECTING_STATUS_NOHOST;
        [self sendConnecingStatus];
    }
}

@end
