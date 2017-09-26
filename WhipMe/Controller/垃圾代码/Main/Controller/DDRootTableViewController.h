//
//  DDRootTableViewController.h
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDInterface.h"

@interface DDRootTableViewController : UITableViewController

/** 抛出异常消息 */
- (void)showForErrorMsg:(NSError *)objMsg;

/** 获取随机的UUID字符串*/
- (NSString *)generateUuidString;

/** 降低图片的分辨率，以减少流量的传输*/
- (UIImage *)scaleImage:(UIImage *)image;

@end
