//
//  DDGlobalVariables.m
//  DDExpressClient
//
//  Created by yangg on 16/3/22.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDGlobalVariables.h"
#import "DDSelfInfomation.h"
#import "DDAddressModel.h"

@implementation DDGlobalVariables
//@synthesize addressComponent;
@synthesize selfAddressDetail;
//@synthesize address;
//@synthesize locationCenter;
//@synthesize poiInfo;
@synthesize homeLocAddressDetail;
@synthesize targetAddressDetail;
@synthesize currentOrderId;
@synthesize autoLogin;

//@synthesize addressModel;

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (DDGlobalVariables *)sharedInstance
{
    static DDGlobalVariables *_globalVariable = nil;
    static dispatch_once_t _dispatch;
    dispatch_once(&_dispatch, ^{
        _globalVariable = [[DDGlobalVariables alloc] init];
    });
    return _globalVariable;
}


@end
