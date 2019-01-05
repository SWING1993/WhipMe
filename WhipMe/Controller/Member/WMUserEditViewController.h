//
//  WMUserEditViewController.h
//  WhipMe
//
//  Created by anve on 16/11/30.
//  Copyright © 2016年 -. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EditControlType) {
    EditControlNickname = 0,//用户昵称
    EditControlSign,//用户签名
    EditControlAvatar,//用户头像
    EditControlSex,//用户性别
    EditControlBirthday,//用户生日
};

@protocol WMUserEditViewControllerDelegate;

@interface WMUserEditViewController : UIViewController

@property (nonatomic, strong) UITextField *txtField;
@property (nonatomic, strong) UITextView *txtView;

@property (nonatomic, weak  ) id<WMUserEditViewControllerDelegate> delegate;

@property (nonatomic, assign) EditControlType editControl;
@property (nonatomic, copy  ) NSString *strPlaceholder;

- (instancetype)initWithPlaceholder:(NSString *)string delegate:(id<WMUserEditViewControllerDelegate>)delegate;

@end

@protocol WMUserEditViewControllerDelegate <NSObject>
@optional
- (void)userEditView:(NSString *)strEdited editConterol:(EditControlType)type;

@end
