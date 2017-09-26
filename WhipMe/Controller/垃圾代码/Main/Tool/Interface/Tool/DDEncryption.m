//
//  DDEncryption.m
//  e-treasure
//
//  Created by xu on 15/7/31.
//  Copyright (c) 2015年 xu. All rights reserved.
//

#import "DDEncryption.h"
#import <CommonCrypto/CommonCrypto.h>

NSString *const Des3Key         = @"Gang!(*(si)$na)$1@3$5^7*";
NSString *const Des3Iv          = @"GSN)#04a";

@interface DDEncryption ()

#pragma mark Private Base64

/**
 *  获取一个base64加密的string
 *
 *  @param data 要加密的data
 *
 *  @return 加密的字符串
 */
+ (NSString *)stringWithBase64EncryptionData:(NSData *)data;

/**
 *  获取一个base64解密的data
 *
 *  @param string 需要解密的字符串
 *
 *  @return 解密的data
 */
+ (NSData *)dataWithBase64DecryptionString:(NSString *)string;

@end

@implementation DDEncryption

#pragma mark -
#pragma mark  Public Base64

/**
 *  获得一个base64加密的字符串
 *
 *  @param string 需要加密的字符串
 *
 *  @return 加密的字符串 nil 加密失败
 */
+ (NSString *)stringWithBase64EncryptionString:(NSString *)string {
    if (!string || [string isEqual:@""]) return nil;
    
    NSData *nData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString *yString = [nData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return yString;
}

/**
 *  获得base64解密的字符串
 *
 *  @param string 需要解密的字符串
 *
 *  @return 解密字符串 nil 解密失败
 */
+ (NSString *)stringWithBase64DecryptionString:(NSString *)string {
    if (!string || [string isEqual:@""]) return nil;
    
    NSData *nData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *nString = [[NSString alloc] initWithData:nData encoding:NSUTF8StringEncoding];
    return nString;
}

#pragma mark -
#pragma mark Private Base64

/**
 *  获取一个base64加密的string
 *
 *  @param data 要加密的data
 *
 *  @return 加密的字符串
 */
+ (NSString *)stringWithBase64EncryptionData:(NSData *)data {
    if (!data) return nil;
    
    NSString *yString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return yString;
}

/**
 *  获取一个base64解密的data
 *
 *  @param string 需要解密的字符串
 *
 *  @return 解密的data
 */
+ (NSData *)dataWithBase64DecryptionString:(NSString *)string {
    if (!string || [string isEqual:@""]) return nil;
    
    NSData *nData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return nData;
}

#pragma mark -
#pragma mark Public 3DES

/**
 *  获得一个3DES+Base64加密的字符串
 *
 *  @param string 要加密的字符串
 *
 *  @return 加密的字符串
 */
+ (NSString *)stringWithDesEncryptionString:(NSString*)string {
    if (!string || [string isEqual:@""]) return nil;
    
    NSData* data = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [Des3Key UTF8String];
    const void *vinitVec = (const void *) [Des3Iv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [DDEncryption stringWithBase64EncryptionData:myData];
    return result;
}

/**
 *  获得一个Base64+3DES解密的字符串
 *
 *  @param string 要解密的字符串
 *
 *  @return 解密的字符串
 */
+ (NSString *)stringWithDesDecryptionString:(NSString*)string {
    if (!string || [string isEqual:@""]) return nil;
    
    NSData *encryptData = [DDEncryption dataWithBase64DecryptionString:string];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *) [Des3Iv UTF8String];
    const void *vinitVec = (const void *) [Des3Iv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark -
#pragma mark Public MD5

/**
 *  获得一个MD5加密字符串
 *
 *  @param string 要加密的字符串
 *
 *  @return 加密的字符串
 */
+ (NSString *)stringWithMD5EncryptionString:(NSString*)string {
    if (!string || [string isEqual:@""]) return nil;
    
    const char *original_str = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) [hash appendFormat:@"%02X", result[i]];
    NSString *yString = [hash lowercaseString];
    
    return yString;
}

@end
