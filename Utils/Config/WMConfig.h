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

static NSString * const st_chatViewControllerTittle = @"会话";
static const NSInteger st_chatTabTag = 10;

static NSString * const st_contactsTabTitle = @"通讯录";
static NSInteger const st_contactsTabTag = 11;

static NSString * const st_settingTabTitle = @"我";
static NSInteger const st_settingTag = 12;
static NSInteger const st_toolBarTextSize = 17;

static NSString * const st_receiveUnknowMessageDes = @"收到新消息类型无法解析的数据，请升级查看";
static NSString * const st_receiveErrorMessageDes = @"接收消息错误";

#define kDeleteAllMessage  @"deleteAllMessage"
#define kAlertToSendImage @"AlertToSendImage"
#define kDeleteMessage @"DeleteMessage"

#define upLoadImgWidth            720

#define JCHATMAINTHREAD(block) dispatch_async(dispatch_get_main_queue(), block)

#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue]

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
