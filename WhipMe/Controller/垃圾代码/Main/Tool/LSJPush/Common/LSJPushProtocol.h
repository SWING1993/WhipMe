//
//  LSJPushProtocol.h
//  LSJPush
//
//  Created by Steven.Liu on 15/9/17.
//  Copyright (c) 2015年 Steven.Liu. All rights reserved.
//

@protocol LSJPushProtocol <NSObject>

@required
-(void)didReceiveRemoteNotification:(NSDictionary *)userInfo;


@end