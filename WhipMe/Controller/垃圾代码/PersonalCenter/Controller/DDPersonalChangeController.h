//
//  DDPersonalChangeController.h
//  DDExpressClient
//
//  Created by yangg on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    编辑用户姓名、用户邮箱、用户职业的界面
 */

typedef enum {
    DDPCEditUserNickname = 0, //编辑用户姓名
    DDPCEditUserMail = 1,     //编辑用户邮箱
    DDPCEditUserWork          //编辑用户职业
} DDPersonalChangeStyle;

#import "DDRootViewController.h"
#import "DDSelfInfomation.h"

@protocol DDPersonalChangeDelegate <NSObject>

- (void) changeEmail : (NSString * )email;
- (void) changeProfessional: (NSString *)professional;
- (void) changeNick : (NSString *)nick;
@end

@interface DDPersonalChangeController : DDRootViewController

- (instancetype)initWithChange:(DDPersonalChangeStyle)changeStyle;
@property (nonatomic,weak) id <DDPersonalChangeDelegate> delegate;

@end
