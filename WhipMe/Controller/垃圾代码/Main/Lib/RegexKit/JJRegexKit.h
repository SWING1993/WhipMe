//
//  JJRegexKit.h
//  coretext
//
//  Created by KimBox on 15/5/26.
//  Copyright (c) 2015年 KimBox. All rights reserved.
//
// /^[\@A-Za-z0-9\!\#\$\%\^\&\*\.\~]{6,16}$/
#import <Foundation/Foundation.h>
//#import "JJTextPart.h"
@interface JJTextPart : NSObject

/** NSRange*/
@property(nonatomic,assign)NSRange range;

/** NSString*/
@property(nonatomic,copy)NSString *text;

/** NSInteger*/
@property(nonatomic,assign)NSInteger index;

/**被正则规则出来的单词吗?*/
@property(nonatomic,assign)BOOL isRegular;

@end

@interface JJRegexKit : NSObject

/**返回匹配正则规则的文字片段*/
+(void)stringsMatchedByText:(NSString *)text pattern:(NSString *)pattern  TextPart:(void (^)(JJTextPart  *textPart))textPart;


/**返回不匹配正则规则的文字片段*/
+(void)stringsSeparatedByText:(NSString *)text pattern:(NSString *)pattern  TextPart:(void (^)(JJTextPart  *textPart))textPart;

/**返回全部文字片段,用正则规则分段*/
+(void)stringsAllPartByText:(NSString *)text pattern:(NSString *)pattern  TextPart:(void (^)(JJTextPart  *textPart))textPart;


@end
