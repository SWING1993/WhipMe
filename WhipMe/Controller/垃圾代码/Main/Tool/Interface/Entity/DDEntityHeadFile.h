//
//  EntityHeader.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/3/15.
//  Copyright © 2016年 NS. All rights reserved.
//
// .h文件
#define DDEntityHeadH \
@property (nonatomic, weak) id<DDEntityDelegate> delegate; \
- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate;

// .m文件
#define DDEntityHeadM(name) \
\
- (void)dealloc { } \
\
- (instancetype)init { \
    self = [super init]; \
    if (self) { \
    } \
    return self; \
} \
\
- (instancetype)initWithDelegate:(id<DDEntityDelegate>)delegate { \
    self = [self init]; \
    if (self) { \
        self.delegate = delegate; \
    } \
    return self; \
} \
\
- (void)sendResult:(NSDictionary *)result error:(NSError *)error { \
    if (self.delegate && [self.delegate respondsToSelector:@selector(entity:result:error:)]) { \
        [self.delegate entity:self result:result error:error]; \
    } \
} \
\
- (void)request:(DDRequest *)request result:(NSDictionary *)result error:(NSError *)error { \
    if (![request isEqual:(name)]) return; \
    if (error) { \
        [self sendResult:nil error:error]; \
        return; \
    } \
    NSInteger    code       = [[result objectForKey:CodeKey] integerValue]; \
    NSString    *message    = [result objectForKey:MessageKey]; \
    if (code != SuccessCode) { \
        NSError *error = [NSError errorWithDomain:message code:code userInfo:nil]; \
        [self sendResult:nil error:error]; \
        return; \
    } \
    [self sendResult:result error:nil]; \
} 
