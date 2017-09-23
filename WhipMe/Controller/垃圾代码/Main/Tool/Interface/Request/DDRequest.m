//
//  DDRequest.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRequest.h"
#import "DDNetInstance.h"
#import "DDCenterCoordinate.h"

/**
 *  请求类型
 */
typedef NS_ENUM(NSInteger, REQUEST_TYPE) {
    REQUEST_TYPE_HTTP                               = 0x00,                                                             /**< HTTP请求 */
    REQUEST_TYPE_SOCKET                             = 0x01,                                                             /**< SOCKET请求 */
};

NSString *const DDRequestTimeKey                            = @"time";                                                  /**< 时间戳Key */
NSString *const DDRequestSignKey                            = @"sign";                                                  /**< 签名Key */
NSString *const DDRequestLongitudeKey                       = @"lon";                                                   /**< 经度Key */
NSString *const DDRequestLatitudeKey                        = @"lat";                                                   /**< 纬度Key */

@interface DDRequest ()

@property (nonatomic, weak) Pomelo                                          *pomelo;                                    /**< pomelo实例 */
@property (nonatomic, weak) AFHTTPSessionManager                            *requestManager;                            /**< AFNetworking Manager */

@property (nonatomic, strong)   NSTimer                                     *outTimer;                                  /**< 超时定时器 */

@end

@implementation DDRequest

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    [self setOutTimer:nil];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        DDNetInstance *netInstance  = [DDNetInstance netInstance];
        self.pomelo                 = netInstance.pomelo;
        self.requestManager         = netInstance.requestManager;
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (instancetype)initWithDelegate:(id<DDRequestDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate  = delegate;
    }
    
    return self;
}

- (void)httpRequestWithType:(HTTP_REQUEST_TYPE)type param:(NSDictionary *)param {
    NSString        *host               = [self httpHostWithType:type];
    NSDictionary    *requestParam       = [self requestDicWithParam:param type:REQUEST_TYPE_HTTP];
    
    __weak typeof(self) weakSelf = self;
    [self.requestManager POST:host parameters:requestParam progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf sendResult:responseObject error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *resultError = [NSError errorWithDomain:@"网络错误" code:ErrorNetWorkError userInfo:nil];
        [weakSelf sendResult:nil error:resultError];
    }];
}

- (void)socketRequstWithType:(SOCKET_REQUEST_TYPE)type param:(NSDictionary *)param {
    if (!self.pomelo.connected) {
        NSError *error = [NSError errorWithDomain:@"服务器没有连接" code:ErrorHostDisConnect userInfo:nil];
        [self sendResult:nil error:error];
        return;
    }
    
    NSString            *authString     = [self socketAuthStringWithType:type];
    NSDictionary        *requestParam   = [self requestDicWithParam:param type:REQUEST_TYPE_SOCKET];
    
    [self startTimer];
    __weak typeof(self) weakSelf = self;
    [self.pomelo requestWithRoute:authString andParams:requestParam andCallback:^(id callback) {
        if ([weakSelf.outTimer isValid]) {
            [weakSelf.outTimer invalidate];
            [weakSelf setOutTimer:nil];
            
            if ([callback isKindOfClass:[NSDictionary class]]) {
                [weakSelf sendResult:(NSDictionary *)callback error:nil];
            } else {
                NSError *error = [NSError errorWithDomain:@"网络错误" code:ErrorNetWorkError userInfo:nil];
                [weakSelf sendResult:nil error:error];
            }
        }
    }];
}

- (void)sockeNotifytWithType:(SOCKET_REQUEST_TYPE)type param:(NSDictionary *)param {
    NSString            *authString     = [self socketAuthStringWithType:type];
    NSDictionary        *requestParam   = [self requestDicWithParam:param type:REQUEST_TYPE_SOCKET];
    
    [self.pomelo notifyWithRoute:authString andParams:requestParam];
}

- (void)socketBindWithType:(BIND_TYPE)type on:(BOOL)on {
    NSString *routeString   = [self bindRouteStringWith:type];
    
    if (!on) {
        [self.pomelo offRoute:routeString];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.pomelo onRoute:routeString withCallback:^(id callback) {
        if ([callback isKindOfClass:[NSDictionary class]]) {
            NSString        *route = [(NSDictionary *)callback ddObjectForKey:@"route" classType:CLASS_TYPE_NSSTRING];
            NSDictionary    *body  = [(NSDictionary *)callback ddObjectForKey:@"body" classType:CLASS_TYPE_NSDICTIONARY];
            
            if ([routeString isEqualToString:route]) {
                NSMutableDictionary *bodyDic = [NSMutableDictionary dictionaryWithDictionary:body];
                [bodyDic setObject:@200 forKey:CodeKey];
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(request:result:error:)]) {
                    [weakSelf.delegate request:weakSelf result:bodyDic error:nil];
                }
            } else {
                NSError *error      = [NSError errorWithDomain:@"网络错误" code:ErrorNetWorkError userInfo:nil];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(request:result:error:)]) {
                    [weakSelf.delegate request:weakSelf result:nil error:error];
                }
            }
        } else {
            NSError *error          = [NSError errorWithDomain:@"网络错误" code:ErrorNetWorkError userInfo:nil];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(request:result:error:)]) {
                [weakSelf.delegate request:weakSelf result:nil error:error];
            }
        }
    }];
}

#pragma mark -
#pragma mark Private Methods

#pragma mark sign

/**
 *  回调前面结果
 *
 *  @param result 结果字典
 *  @param error  错误信息
 */
- (void)sendResult:(NSDictionary *)result error:(NSError *)error {
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(request:result:error:)]) {
            [self.delegate request:self result:nil error:error];
        }
        return;
    }
    
    NSInteger code = [[result ddObjectForKey:CodeKey classType:CLASS_TYPE_NSNUMBER] integerValue];
    if (code != SuccessCode) {
        NSString *message = [result ddObjectForKey:MessageKey classType:CLASS_TYPE_NSSTRING];
        if ([message isEqualToString:@""]) message = @"服务器错误";
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:result];
        [resultDic setObject:message forKey:MessageKey];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(request:result:error:)]) {
            [self.delegate request:self result:resultDic error:nil];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(request:result:error:)]) {
        [self.delegate request:self result:result error:nil];
    }
}

/**
 *  得到请求字典(加签名)
 *
 *  @param param 参数字典
 *  @param type  请求类型
 *
 *  @return 请求字典
 */
- (NSDictionary *)requestDicWithParam:(NSDictionary *)param type:(REQUEST_TYPE)type {
    NSString *time                  = [self currentTimeInterval];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:param];
    [requestDic setValue:time forKey:DDRequestTimeKey];
    
    if (REQUEST_TYPE_SOCKET == type) {
        CLLocationCoordinate2D location     = [DDCenterCoordinate getCenterCoordinate];
        NSNumber *longitude                 = [NSNumber numberWithDouble:location.longitude];
        NSNumber *latitude                  = [NSNumber numberWithDouble:location.latitude];
        [requestDic setObject:longitude forKey:DDRequestLongitudeKey];
        [requestDic setObject:latitude forKey:DDRequestLatitudeKey];
    }
    
    NSString *sign  = [self signWithRequsetDic:requestDic];
    [requestDic setValue:sign forKey:DDRequestSignKey];
    
    return requestDic;
}

/**
 *  获取当前时间戳
 *
 *  @return 当前时间戳
 */
- (NSString *)currentTimeInterval {
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"hhmmssSSS"];
    NSString *dateString =  [formatter stringFromDate:[NSDate date]];
    return dateString;
}

/**
 *  获得MD5所用userKey
 *
 *  @return MD5所用userKey
 */
- (NSString *)getUserKey {
    if ([DDInterfaceTool getLoginSucced]) {
        NSString *userKey   = [DDInterfaceTool getUserkey];
        return [DDEncryption stringWithMD5EncryptionString:userKey];
    }
    return Md5Key;
}

/**
 *  签名
 *
 *  @param dictionary 请求字典
 *
 *  @return 签名字符串
 */
- (NSString *)signWithRequsetDic:(NSDictionary *)dictionary {
    NSString *unString  = @"";
    
    NSArray *sortKeys   = [[dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = (NSString *)obj1;
        NSString *string2 = (NSString *)obj2;
        return (NSComparisonResult)[string1 compare:string2];
    }];
    
    for (NSString *key in sortKeys) {
        NSString *valueString = [self valueStringWithObj:[dictionary objectForKey:key]];
        if (![[dictionary objectForKey:key] isKindOfClass:[NSArray class]]) {
            unString = [unString stringByAppendingFormat:@"%@=%@&", key, valueString];
        } else {
            unString = [unString stringByAppendingFormat:@"%@&", valueString];
        }
    }
    
    NSString *userKey   = [self getUserKey];
    unString = [[unString stringByAppendingFormat:@"userKey=%@", userKey] lowercaseString];
    NSLog(@"签名前字符串:%@", unString);
    
    NSString *sign      = [DDEncryption stringWithMD5EncryptionString:unString];
    NSLog(@"签名:%@", sign);
    return sign;
}

/**
 *  获取对象中字符串
 *
 *  @param obj 对象
 *
 *  @return 对象中字符串
 */
- (NSString *)valueStringWithObj:(id)obj {
    if ([obj isKindOfClass:[NSString class]]) return (NSString *)obj;
    if ([obj isKindOfClass:[NSNumber class]]) return [(NSNumber *)obj stringValue];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSString *arrayString = @"";
        for (id object in (NSArray *)obj) arrayString = [arrayString stringByAppendingString:[self valueStringWithObj:object]];
        return arrayString;
    }
    
    return @"";
}

/**
 *  开始定时器
 */
- (void)startTimer {
    NSTimeInterval outTime = SOCKETTimeoutInterval;
    
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
    NSError *error = [NSError errorWithDomain:@"请求超时" code:ErrorNetWorkError userInfo:nil];
    [self sendResult:nil error:error];
}

#pragma mark Request

/**
 *  获取HTTP请求域名
 *
 *  @param type 请求类型
 *
 *  @return 域名
 */
- (NSString *)httpHostWithType:(HTTP_REQUEST_TYPE)type {
    NSString *address               = HTTPBaseAdress;
    
    switch (type) {
        case HTTP_REQUEST_TYPE_FIND_SERVER:
            address                 = [address stringByAppendingString:@"find_server"];
            break;
            
        case HTTP_REQUEST_TYPE_SEND_CAPTCHA:
            address                 = [address stringByAppendingString:@"send_captcha"];
            break;
            
        case HTTP_REQUEST_TYPE_AUTH_CAPTCHA:
            address                 = [address stringByAppendingString:@"auth_captcha"];
            break;
            
        case HTTP_REQUEST_TYPE_SIGN_UP:
            address                 = [address stringByAppendingString:@"register"];
            break;
            
        case HTTP_REQUEST_TYPE_FORGOT_PWD:
            address                 = [address stringByAppendingString:@"forgot"];
            break;
            
        case HTTP_REQUEST_TYPE_NEAR_COURIER:
            address                 = [address stringByAppendingString:@"find_courier"];
            break;
        
        case HTTP_REQUEST_TYPE_NEW_VERSION:
            address                 = [address stringByAppendingString:@"new_version"];
            break;
        
        default:
            break;
    }
    
    return address;
}

/**
 *  获取socket请求权限字符串
 *
 *  @param type 请求类型
 *
 *  @return 权限字符串
 */
- (NSString *)socketAuthStringWithType:(SOCKET_REQUEST_TYPE)type {
    NSString *authString    = @"c.h.r";
    switch (type) {
        case SOCKET_REQUEST_TYPE_NORMAL:
            authString      = @"c.h.r";
            break;
            
        case SOCKET_REQUEST_TYPE_LOGIN:
            authString      = @"c.h.login";
            break;
            
        case SOCKET_REQUEST_TYPE_AUTOLOGIN:
            authString      = @"c.h.auto_login";
            break;
            
        default:
            break;
    }
    
    return authString;
}

/**
 *  获得绑定监听权限字符串
 *
 *  @param type 监听类型
 *
 *  @return 监听权限字符串
 */
- (NSString *)bindRouteStringWith:(BIND_TYPE)type {
    NSString *routeString   = @"";
    switch (type) {
        case BIND_TYPE_WAIT_RUSH:
            routeString     = @"c.h.bind_courier";
            break;
            
        case BIND_TYPE_BIND_PAY:
            routeString     = @"c.h.bind_pay";
            break;
            
        case BIND_TYPE_BIND_POSITION:
            routeString     = @"c.h.bind_position";
            break;
            
        case BIND_TYPE_OTHER_LOGIN:
            routeString     = @"onKick";
            break;
            
        default:
            break;
    }
    
    return routeString;
}

@end

@implementation NSDictionary (Request)

- (id)ddObjectForKey:(id)aKey classType:(CLASS_TYPE)classType {
    id object   = [self objectForKey:aKey];
    if (![object isKindOfClass:[NSNull class]] && (nil != object)) return object;
    
    id rObject  = nil;
    switch (classType) {
        case CLASS_TYPE_NSSTRING:
            rObject                  = @"";
            break;
            
        case CLASS_TYPE_NSNUMBER:
            rObject                  = [NSNumber numberWithInteger:0];
            break;
            
        case CLASS_TYPE_NSARRAY:
            rObject                  = [NSArray array];
            break;
            
        case CLASS_TYPE_NSDICTIONARY:
            rObject                  = [NSDictionary dictionary];
            break;
            
        default:
            break;
    }
    return rObject;
}

@end