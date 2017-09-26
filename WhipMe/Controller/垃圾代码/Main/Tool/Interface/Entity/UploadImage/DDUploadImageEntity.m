//
//  DDUploadImageEntity.m
//  DDExpressCourier
//
//  Created by Sxx on 16/4/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDUploadImageEntity.h"
#import "DDInterfaceTool.h"
#import "DDEncryption.h"
#import "DDRequest.h"
#import "AFHTTPSessionManager.h"

//传入参数的组织方式为@{@"infoList":@[@{@"image":NSData, @"name":ImageName}, @{@"image":NSData, @"name":ImageName}]} 是数组套字典的方式
NSString *const DDUploadImageInfoListMQ                                 = @"infoList";                                  /**< 图片信息数组 */
NSString *const DDUploadImageImageMQ                                    = @"image";                                     /**< UIImage */
NSString *const DDUploadImageNameMQ                                     = @"name";                                      /**< 图片名字 */

NSString *const DDUploadFilenamesFQ                                     = @"filenames";                                 /**< 图片名字 */
NSString *const DDUploadSignFQ                                          = @"sign";                                      /**< 签名 */

@interface DDUploadImageEntity ()

@property (nonatomic, strong)   AFHTTPSessionManager                        *requestManager;                            /**< AFNetworking Manager */
@property (nonatomic, strong)   NSArray<NSDictionary *>                     *infoArray;                                 /**< 图片信息数组 */


@end

@implementation DDUploadImageEntity

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestManager                     = [AFHTTPSessionManager manager];
        self.requestManager.requestSerializer   = [AFHTTPRequestSerializer serializer];
        self.requestManager.responseSerializer  = [AFJSONResponseSerializer serializer];
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
    NSArray<NSDictionary *> *infoArray  = [param objectForKey:DDUploadImageInfoListMQ];
    self.infoArray = infoArray;
    
    [self configHttpHeader];
    [self uploadImage];
}

#pragma mark -
#pragma mark Private Methods

/**
 *  设置请求头
 */
- (void)configHttpHeader {
    NSString *filenames = nil;
    for (NSDictionary *info in self.infoArray) {
        NSString *name  = [info objectForKey:DDUploadImageNameMQ];
        if (filenames) filenames = [[filenames stringByAppendingString:@";"] stringByAppendingString:name];
        else filenames = name;
    }
    
    NSString *unString  = [[NSString stringWithFormat:@"%@%@", filenames, Md5Key] lowercaseString];
    NSLog(@"签名前字符串:%@", unString);
    NSString *sign      = [DDEncryption stringWithMD5EncryptionString:unString];
    NSLog(@"签名:%@", sign);
    
    [self.requestManager.requestSerializer setValue:filenames forHTTPHeaderField:DDUploadFilenamesFQ];
    [self.requestManager.requestSerializer setValue:sign forHTTPHeaderField:DDUploadSignFQ];
}

/**
 *  上传图片
 */
- (void)uploadImage {
    NSString *address   = [NSString stringWithFormat:@"%@service/upload",OtherServerAddress];
    
    __weak typeof(self) weakSelf = self;
    [self.requestManager POST:address parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSDictionary *info in weakSelf.infoArray) {
            NSData      *imageData  = [info objectForKey:DDUploadImageImageMQ];
            NSString    *name       = [info objectForKey:DDUploadImageNameMQ];
//            NSData      *imageData  = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:imageData name:@"image" fileName:name mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf sendResult:responseObject error:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSError *resultError = [NSError errorWithDomain:@"网络错误" code:ErrorNetWorkError userInfo:nil];
        [weakSelf sendResult:nil error:resultError];
    }];
}

/**
 *  回调前面结果
 *
 *  @param result 结果字典
 *  @param error  错误信息
 */
- (void)sendResult:(NSDictionary *)result error:(NSError *)error {
    if (error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) {
            [self.delegate entity:self result:result error:error];
        }
        return;
    }
    
    NSInteger code = [[result ddObjectForKey:CodeKey classType:CLASS_TYPE_NSNUMBER] integerValue];
    if (code != SuccessCode) {
        NSString *message = [result ddObjectForKey:MessageKey classType:CLASS_TYPE_NSSTRING];
        if ([message isEqualToString:@""]) message = @"服务器错误";
        NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:result];
        [resultDic setObject:message forKey:MessageKey];
        
        NSError *resultError = [NSError errorWithDomain:message code:code userInfo:nil];
        if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) {
            [self.delegate entity:self result:result error:resultError];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) {
        [self.delegate entity:self result:result error:error];
    }
}

@end
