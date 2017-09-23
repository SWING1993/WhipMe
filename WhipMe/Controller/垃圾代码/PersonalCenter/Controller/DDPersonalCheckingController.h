//
//  DDPersonalCheckingController.h
//  DDExpressClient
//
//  Created by yoga on 16/4/12.
//  Copyright © 2016年 NS. All rights reserved.
//


/**
 *  身份   认证中/已认证 页面
 */
#import "DDRootViewController.h"
#import "DDSelfInfomation.h"

@interface DDPersonalCheckingController : DDRootViewController
///**  姓名  */
//@property (nonatomic, strong) NSString *name;
///**  身份证号  */
//@property (nonatomic, strong) NSString *idNumber;


@property (nonatomic, strong) DDSelfInfomation *selfInfo;

- (instancetype)initWithCheckingType:(NSInteger)type;
@end
