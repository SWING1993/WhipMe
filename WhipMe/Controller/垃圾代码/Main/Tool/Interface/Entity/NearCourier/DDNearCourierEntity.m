//
//  DDNearCourierEntity.m
//  DDExpressClient
//
//  Created by EWPSxx on 3/9/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDNearCourierEntity.h"
#import "DDInterfaceTool.h"
#import "DDRequest.h"
#import "DDCenterCoordinate.h"

#pragma mark Model Key

NSString *const DDNearCourierCorIdListM                                 = @"companyIdList";                             /**< 快递公司列表(不传表示所有快递公司) */

NSString *const DDNearCourierCouListM                                  = @"courierList";                                /**< 快递员信息列表 */
NSString *const DDNearCourierPosListM                                  = @"positionList";                               /**< 位置数组列表 */
NSString *const DDNearCourierCouIdM                                    = @"courierID";                                  /**< 快递员ID */
NSString *const DDNearCouriercorIdM                                    = @"companyID";                                  /**< 快递公司ID */
NSString *const DDNearCourierLogoM                                     = @"companyLogo";                                /**< 快递公司LOGO */

#pragma mark Interface Key

const NSInteger DDNearCourierHttpIFCode                                 = 10005;                                        /**< http获取附近快递员业务码 */
NSString *const DDNearCourierHttpIFVersion                              = @"1.0.0";                                     /**< http获取附近快递员版本号 */

const NSInteger DDNearCourierSocketIFCode                               = 1001;                                         /**< socket获取附近快递员业务码 */
NSString *const DDNearCourierSocketIFVersion                            = @"1.0.0";                                     /**< socket获取附近快递员版本号 */

NSString *const DDNearCourierCorIdListIF                                = @"corIdList";                                 /**< 快递公司列表(不传表示所有快递公司) */

NSString *const DDNearCourierCouListIF                                  = @"couList";                                   /**< 快递员信息列表 */
NSString *const DDNearCourierPosListIF                                  = @"posList";                                   /**< 位置数组列表 */
NSString *const DDNearCourierCouIdIF                                    = @"couId";                                     /**< 快递员ID */
NSString *const DDNearCouriercorIdIF                                    = @"corId";                                     /**< 快递公司ID */


@interface DDNearCourierEntity ()<DDRequestDelegate>

@property (nonatomic, strong)   DDRequest                               *httpNearRequest;                               /**< http获取附近快递员 */
@property (nonatomic, strong)   DDRequest                               *socketNearRequest;                             /**< socket获取附近快递员 */

@end

@implementation DDNearCourierEntity

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
//    NSArray<NSString *> *corIdArray = [param objectForKey:DDNearCourierCorIdListM];
    NSMutableDictionary *paramDic   = [[NSMutableDictionary alloc] initWithDictionary:param];
//    if (corIdArray) [paramDic setObject:corIdArray forKey:DDNearCourierCorIdListIF];
    
    if ([DDInterfaceTool getLoginSucced]) {
        NSNumber *code      = [NSNumber numberWithInteger:DDNearCourierSocketIFCode];
        NSString *version   = DDNearCourierSocketIFVersion;
        [paramDic setObject:code forKey:CodeKey];
        [paramDic setObject:version forKey:VersionKey];
        
        self.socketNearRequest = [[DDRequest alloc] initWithDelegate:self];
        [self.socketNearRequest socketRequstWithType:SOCKET_REQUEST_TYPE_NORMAL param:paramDic];
    } else {
        NSNumber *code      = [NSNumber numberWithInteger:DDNearCourierHttpIFCode];
        NSString *version   = DDNearCourierHttpIFVersion;
        [paramDic setObject:code forKey:CodeKey];
        [paramDic setObject:version forKey:VersionKey];
        
        CLLocationCoordinate2D location     = [DDCenterCoordinate getCenterCoordinate];
        NSNumber *longitude                 = [NSNumber numberWithDouble:location.longitude];
        NSNumber *latitude                  = [NSNumber numberWithDouble:location.latitude];
        [paramDic setObject:longitude forKey:@"lon"];
        [paramDic setObject:latitude forKey:@"lat"];
        
        self.httpNearRequest = [[DDRequest alloc] initWithDelegate:self];
        [self.httpNearRequest httpRequestWithType:HTTP_REQUEST_TYPE_NEAR_COURIER param:paramDic];
    }
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

/**
 *  获得Model所用字典
 *
 *  @param result 结果字典
 *
 *  @return model所用字典
 */
- (NSDictionary *)modleWithResult:(NSDictionary *)result {
    NSArray<NSDictionary *>         *couArray       = [result ddObjectForKey:DDNearCourierCouListIF classType:CLASS_TYPE_NSARRAY];
    NSMutableArray<NSDictionary *>  *courierArray   = [NSMutableArray arrayWithCapacity:[couArray count]];
    
    for (NSDictionary *couDic in couArray) {
        NSArray<NSArray *>  *positionArray  = [couDic ddObjectForKey:DDNearCourierPosListIF classType:CLASS_TYPE_NSARRAY];
        NSString            *courierId      = [couDic ddObjectForKey:DDNearCourierCouIdIF classType:CLASS_TYPE_NSSTRING];
        NSString            *companyId      = [couDic ddObjectForKey:DDNearCouriercorIdIF classType:CLASS_TYPE_NSSTRING];
        NSString            *companyLogo    = [DDInterfaceTool logoWithCompanyId:companyId];
        
        NSDictionary        *resultDic      = [NSDictionary dictionaryWithObjectsAndKeys:
                                               positionArray,           DDNearCourierPosListM,
                                               courierId,               DDNearCourierCouIdM,
                                               companyId,               DDNearCouriercorIdM,
                                               companyLogo,             DDNearCourierLogoM,
                                               nil];
        [courierArray addObject:resultDic];
    }
    
    NSDictionary    *modelDic       = [NSDictionary dictionaryWithObjectsAndKeys:
                                       courierArray,          DDNearCourierCouListM,
                                       nil];
    return modelDic;
}

#pragma mark -
#pragma mark DDRequestDelegate

- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error {
    if ((![request isEqual:self.httpNearRequest]) && (![request isEqual:self.socketNearRequest])) return;
    
    if (error) {
        [self sendResult:nil error:error];
        return;
    }
    
    NSInteger    code       = [[result objectForKey:CodeKey] integerValue];
    NSString    *message    = [result objectForKey:MessageKey];
    if (code != SuccessCode) {
        NSError *error = [NSError errorWithDomain:message code:code userInfo:nil];
        [self sendResult:nil error:error];
        return;
    }
    
    [self sendResult:[self modleWithResult:result] error:nil];
}

@end
