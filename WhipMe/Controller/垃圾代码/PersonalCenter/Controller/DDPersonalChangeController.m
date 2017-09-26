//
//  DDPersonalChangeController.m
//  DDExpressClient
//
//  Created by yangg on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

/**
    编辑用户姓名、用户邮箱、用户职业的界面
 */

#import "DDPersonalChangeController.h"
#import "CustomStringUtils.h"
#import "DDLocalUserInfoUtils.h"

@interface DDPersonalChangeController () <UITextFieldDelegate>
{
    /** 用户信息编辑枚举 */
    DDPersonalChangeStyle _ddChangeStyle;
}
/** 输入框的父视图 */
@property (nonatomic, strong) UIView *viewCurrent;
/** 文本输入框单行 */
@property (nonatomic, strong) UITextField *textfield;
/** 边框线 */
@property (nonatomic, strong) UIView *bottomLine;

@end
@implementation DDPersonalChangeController


#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        _ddChangeStyle = DDPCEditUserNickname;
    }
    return self;
}

- (instancetype)initWithChange:(DDPersonalChangeStyle)changeStyle
{
    self = [super init];
    if (self) {
        _ddChangeStyle = changeStyle;
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:DDRGBAColor(255, 255, 255, 1)];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:[self getCurrentNavTitleWithStyle:_ddChangeStyle] segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self adaptFirstRightItemWithTitle:@"完成"];
    
    [self.view addSubview:self.viewCurrent];
    [self.viewCurrent addSubview:self.textfield];
    [self.viewCurrent addSubview:self.bottomLine];
    
    //根据枚举值来判断显示哪个用户编写视图
    if (_ddChangeStyle == DDPCEditUserNickname) {
        [self createEditUserNicknameView];
    } else if (_ddChangeStyle == DDPCEditUserMail) {
        [self createEditUserMailView];
    } else if (_ddChangeStyle == DDPCEditUserWork) {
        [self createEditUserWorkView];
    }
    [self.textfield becomeFirstResponder];
}


/** 用户编辑"真实姓名"视图 */
- (void)createEditUserNicknameView
{
    [self.textfield setPlaceholder:@"请输入昵称"];
    if (![CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"nick"]]) {
        self.textfield.text = [LocalUserInfo objectForKey:@"nick"];
    }
}

/** 用户编辑"用户邮箱"视图 */
- (void)createEditUserMailView
{
    [self.textfield setKeyboardType:UIKeyboardTypeEmailAddress];
    [self.textfield setPlaceholder:@"请输入邮箱"];
    
    if (![CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"email"]]) {
        self.textfield.text = [LocalUserInfo objectForKey:@"email"];
    }
}

/** 用户编辑"用户职业"视图 */
- (void)createEditUserWorkView
{
    [self.textfield setPlaceholder:@"请输入职业"];
    
    if (![CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"job"]]) {
        self.textfield.text = [LocalUserInfo objectForKey:@"job"];
    }
}

/** 创建邮箱输入错误提示 */
- (void)ddCreateErrorLabel
{
    UILabel *errorLabel = (UILabel *)[self.view viewWithTag:10086];
    if (errorLabel) {
        [errorLabel removeFromSuperview];
    }
    
    UILabel * label = [[UILabel alloc] init];
    label.tag = 10086;
    label.x = 15.0f;
    label.y = self.bottomLine.bottom + 2 + KNavHeight;
    label.textColor = DDRed_Color;
    label.text = @"邮箱格式不正确，请输入正确的邮箱";
    label.font = kTimeFont;
    label.textAlignment = NSTextAlignmentLeft;
    CGSize size = [self sizeOfString:label.text withFont:label.font];
    label.width = size.width;
    label.height = size.height;
    [self.view addSubview:label];
}

#pragma mark - Event Method
/** 屏幕的触摸事件，用于取消键盘编辑 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:false];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickFirstRightItem
{
    if ([self.textfield.text length] > 0) {
        NSString *changeString = self.textfield.text;
        switch (_ddChangeStyle) {
            case DDPCEditUserNickname:
                if ([_delegate respondsToSelector:@selector(changeNick:)]) {
                    [_delegate changeNick:changeString];
                }
                [DDLocalUserInfoUtils updateUserNickName:changeString];
                break;
            case DDPCEditUserMail:
                if (![self isValidateEmail:self.textfield.text]) {
                    [self ddCreateErrorLabel];
                    return ;
                }
                if ([_delegate respondsToSelector:@selector(changeEmail:)]) {
                    [_delegate changeEmail:changeString];
                }
                break;
            case DDPCEditUserWork:
                if ([_delegate respondsToSelector:@selector(changeProfessional:)]) {
                    [_delegate changeProfessional:changeString];
                }
                break;
            default:
                break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate
/** 限制文本框输入长度，为40个字符 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (_ddChangeStyle == DDPCEditUserNickname) {
        if (text_str.length > 10) {
            [textField setText:[text_str substringToIndex:10]];
            return false;
        } 
    }else if (_ddChangeStyle == DDPCEditUserMail) {
        if (text_str.length > 40) {
            [textField setText:[text_str substringToIndex:40]];
            return false;
        }
    }else if (_ddChangeStyle == DDPCEditUserWork) {
        if (text_str.length > 40) {
            [textField setText:[text_str substringToIndex:40]];
            return false;
        }
    }
    return true;
}



#pragma mark - Private Method
/** 计算字符串的size */
- (CGSize)sizeOfString:(NSString *)string withFont:(UIFont *)fnt
{
    CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    return size;
}

- (NSString *)getCurrentNavTitleWithStyle:(DDPersonalChangeStyle)style
{
    if (_ddChangeStyle == DDPCEditUserMail) {
        return @"邮箱";
    } else if (_ddChangeStyle == DDPCEditUserWork) {
        return @"职位";
    } else if (_ddChangeStyle == DDPCEditUserNickname) {
        return @"昵称";
    }
    return @"";
}

-(UIView *)viewCurrent
{
    if (_viewCurrent == nil) {
        UIView *viewCurrent = [[UIView alloc] init];
        [viewCurrent setFrame:CGRectMake( 0, KNavHeight, self.view.width, 45.0f + 20)];
        [viewCurrent setBackgroundColor:DDRGBAColor(255, 255, 255, 1)];
        UIView *topLine = [[UIView alloc] init];
        [topLine setFrame:CGRectMake(0, 0, viewCurrent.width, 0.5f)];
        [topLine setBackgroundColor:BORDER_COLOR];
        [viewCurrent addSubview:topLine];
        _viewCurrent = viewCurrent;
    }
    return _viewCurrent;
}

- (UITextField *)textfield
{
    if (_textfield == nil) {
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(15.0f, 20.0f, self.viewCurrent.width-15.0f, 45.0f)];
        [textfield setBackgroundColor:[UIColor clearColor]];
        [textfield setTextAlignment:NSTextAlignmentLeft];
        [textfield setTextColor:TITLE_COLOR];
        [textfield setFont:kTitleFont];
        [textfield setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        [textfield setDelegate:self];
        _textfield = textfield;
    }
    return _textfield;
}

- (UIView *)bottomLine
{
    if (_bottomLine == nil) {
        //下边框线
        UIView *bottomLine = [[UIView alloc] init];
        [bottomLine setFrame:CGRectMake(self.textfield.left, self.textfield.bottom - 0.5f, self.textfield.width, 0.5f)];
        [bottomLine setBackgroundColor:BORDER_COLOR];
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}

@end
