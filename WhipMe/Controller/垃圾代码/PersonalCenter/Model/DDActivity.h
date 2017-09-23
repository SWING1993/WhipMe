//
//  DDActivity.h
//  DDExpressCourier
//
//  Created by Steven.Liu on 16/4/14.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDActivity : NSObject

@property (nonatomic,copy) NSString *activityId;
@property (nonatomic,copy) NSString *activityImage;
@property (nonatomic,copy) NSString *activityUrl;
@property (nonatomic,copy) NSString *activityDescribe;
@property (nonatomic,copy) NSString *activityTime;

@end
