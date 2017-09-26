//
//  NetInstance.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNetInstance.h"

@interface DDNetInstance ()<PomeloDelegate>

@property (nonatomic, strong) Pomelo                                        *pomelo;                                    /**< pomelo实例 */
@property (nonatomic, strong) AFHTTPSessionManager                          *requestManager;                            /**< AFNetworking Manager */
@property (nonatomic, assign) SOCKET_STATUS                                  socketStatus;                              /**< 长连接连接状态 */

@end

@implementation DDNetInstance

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initPomelo];
        [self initRequestManager];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

+ (instancetype)netInstance {
    static DDNetInstance              *instance   = nil;
    static dispatch_once_t           predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[DDNetInstance alloc] init];
    });
    
    return instance;
}

#pragma mark -
#pragma mark Private Methods

/**
 *  初始化pomelo
 */
- (void)initPomelo {
    self.pomelo         = [[Pomelo alloc] initWithDelegate:self];
    self.socketStatus   = SOCKET_STATUS_DISCONNECT;
}

/**
 *  初始化requestManager
 */
- (void)initRequestManager {
    self.requestManager                     = [AFHTTPSessionManager manager];
    self.requestManager.requestSerializer   = [AFJSONRequestSerializer serializer];
    self.requestManager.responseSerializer  = [AFJSONResponseSerializer serializer];
    [self.requestManager.requestSerializer setTimeoutInterval:HTTPTimeoutInterval];
}

#pragma mark -
#pragma mark PomeloDelegate

- (void)PomeloDidConnect:(Pomelo *)pomelo {
//    NSLog(@"服务器连接成功");
    self.socketStatus   = SOCKET_STATUS_CONNECTED;
}

- (void)PomeloDidDisconnect:(Pomelo *)pomelo withError:(NSError *)error {
    NSLog(@"服务器断开连接");
    self.socketStatus   = SOCKET_STATUS_DISCONNECT;
}

- (void)Pomelo:(Pomelo *)pomelo didReceiveMessage:(NSArray *)message {
    
}

@end
