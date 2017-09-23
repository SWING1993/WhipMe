//
//  DDStopEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 16/3/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDStopEntity.h"
#import "DDInterfaceTool.h"
#import "DDConnect.h"

@interface DDStopEntity ()<DDConnectDelegate>

@property (nonatomic, strong)   DDConnect                                   *connect;                                   /**< 连接实例 */

@end

@implementation DDStopEntity

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)entityWithParam:(NSDictionary *)param {
    [DDInterfaceTool configLoginSucced:NO];
    [DDInterfaceTool configStop:YES];
    
    self.connect    = [[DDConnect alloc] initWithDelegate:self];
    [self.connect disConnnect];
    [self sendResult:[[NSDictionary alloc] init] error:nil];
}

#pragma mark -
#pragma mark Private Methods

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

#pragma mark -
#pragma mark DDConnectDelegate

- (void)connect:(DDConnect *)connect connnetStatus:(SOCKET_STATUS)status {
    
}

- (void)connect:(DDConnect *)connect connnetingStatus:(CONNECTING_STATUS)status {
    
}

@end
