//
//  NSObject+CustomCategory.m
//  YouShaQi
//
//  Created by JC_CP3 on 15/1/7.
//  Copyright (c) 2015年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "NSObject+CustomCategory.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (JSONDeserializing)
- (id)objectFromJSONString
{
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
    return json;
}
@end

@implementation NSString (MD5)

- (NSString *)MD5
{
    const char * pointer = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [string appendFormat:@"%02x",md5Buffer[i]];
    
    return string;
}

@end

@implementation NSData (JSONDeserializing)
- (id)objectFromJSONData
{
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:NULL];
    return json;
}

@end