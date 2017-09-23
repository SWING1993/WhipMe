//
//  ShareSDKUtils.m
//  DDExpressClient
//
//  Created by JC_CP3 on 16/4/19.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "ShareSDKUtils.h"

@implementation ShareSDKUtils

+ (instancetype)shareInstance
{
    static ShareSDKUtils *shareSDKUtils = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareSDKUtils = [[ShareSDKUtils alloc] init];
    });
    
    return shareSDKUtils;
}

- (void)shareMessageWithPlatformType:(SSDKPlatformType)type shareMessageItem:(ShareMessageItem *)item
{
    id image;
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if (item.image) {
        
        image = item.image;
        if (type == SSDKPlatformTypeSinaWeibo) {
            image = [UIImage imageWithContentsOfFile:image];
            image = UIImageJPEGRepresentation(image, 1.0);
        }
    } else {
        
        NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
        NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
        image = [UIImage imageNamed:icon];
//        image = UIImageJPEGRepresentation(image, 1.0);
    }
    
    [shareParams SSDKSetupShareParamsByText:item.message
                                     images:image
                                        url:[NSURL URLWithString:item.url]
                                      title:item.title
                                       type:SSDKContentTypeAuto];
    
    [ShareSDK share:type
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         NSString *shareStatusMsg;
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 if ([self.shareSDKViewDelegate respondsToSelector:@selector(shareMessageSucceed)]) {
                     [self.shareSDKViewDelegate shareMessageSucceed];
                 }
                 shareStatusMsg = @"分享成功";
                 
                 break;
             }
             case SSDKResponseStateFail:
             {
                 shareStatusMsg = @"分享失败";
                 
                 NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error description], [error description]);
                 break;
             }
//             case SSDKResponseStateCancel:
//             {
//                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                     message:nil
//                                                                    delegate:nil
//                                                           cancelButtonTitle:@"确定"
//                                                           otherButtonTitles:nil];
//                 [alertView show];
//                 break;
//             }
             default:
                 break;
         }
     }];

}

@end
