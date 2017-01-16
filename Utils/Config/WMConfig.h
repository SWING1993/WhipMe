//
//  WMConfig.h
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//

#ifndef WMConfig_h
#define WMConfig_h


#endif /* WMConfig_h */

static NSString *const KQueryAccountWalletNotification = @"queryAccountWalletNotification";
static NSString *const kAllConversationsNotification = @"getAllConversationListNotification";

#pragma mark - 通知处理
#define DDAddNotification(_selector,_name)\
([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:nil])

#define DDRemoveNotificationWithName(_name)\
([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])

#define DDRemoveNotificationObserver() ([[NSNotificationCenter defaultCenter] removeObserver:self])

#define DDPostNotification(_name)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:nil])

#define DDPostNotificationWithObj(_name,_obj)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:nil])

#define DDPostNotificationWithInfos(_name,_obj,_infos)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:_infos])
