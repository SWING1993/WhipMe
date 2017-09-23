//
//  DDTextAlertView.m
//  DuDu Courier
//
//  Created by yangg on 16/3/11.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import "DDTextAlertView.h"
#import "Constant.h"
#import "HPGrowingTextView.h"

@interface DDTextAlertView () <HPGrowingTextViewDelegate>
{
    /** 避免调用显示和隐藏的属性 */
    BOOL _isShowing;
    /** 标题字符串 */
    NSString *_isTitle;
    /** 取消按钮标题 */
    NSString *_isCancelTitle;
    /** 确认按钮标题 */
    NSString *_isNextTitle;
    /** 根控制器 */
    UIWindow *_window;
}

/** 白色的中心视图 */
@property (nonatomic, strong) UIView        *viewCurrent;
/** 灰色的背景视图 */
@property (nonatomic, strong) UIButton      *buttonBlack;
/** 文本框（备注） */
@property (nonatomic, strong) HPGrowingTextView *textQuestion;
/** 边框线 */
@property (nonatomic, strong) UIView *lineText;
/** 标题 */
@property (nonatomic, strong) UILabel       *lblTitle;
/** 取消和确认按钮的父视图 */
@property (nonatomic, strong) UIView        *viewBottom;
/** 取消按钮 */
@property (nonatomic, strong) UIButton      *btnBack;
/** 确认按钮 */
@property (nonatomic, strong) UIButton      *btnNext;
/** 协议 */
@property (nonatomic, weak) id<DDTextAlertViewDelegate> delegate;

@end

@implementation DDTextAlertView
@synthesize buttonBlack;
@synthesize viewCurrent;

@synthesize lineText;
@synthesize textQuestion;
@synthesize lblTitle;
@synthesize viewBottom;
@synthesize btnBack;
@synthesize btnNext;

- (instancetype)initWithTitle:(NSString *)objTitle delegate:(id<DDTextAlertViewDelegate>)objDelegate cancelTitle:(NSString *)objCancel nextTitle:(NSString *)objNext
{
    self = [super init];
    if (self)
    {
        _delegate = objDelegate;
        _isTitle = objTitle;
        _isCancelTitle = objCancel;
        _isNextTitle = objNext;
        
        _window = [UIApplication sharedApplication].keyWindow;
        self.frame = CGRectMake(0, 0, CGRectGetWidth(_window.bounds), CGRectGetHeight(_window.bounds));
        
        [self setup];
    }
    return self;
}

/**
 初始化自定义控件
 */
- (void)setup
{
    /** 灰色的背景 */
    buttonBlack = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonBlack setFrame:CGRectMake(0, 0, self.width, self.height)];
    [buttonBlack setBackgroundColor:[UIColor blackColor]];
    [buttonBlack setAlpha:0.3f];
    [self addSubview:buttonBlack];
    
    viewCurrent = [[UIView alloc] init];
    [viewCurrent setSize:CGSizeMake(self.width - 30.0f, 200.0f)];
    [viewCurrent setCenter:CGPointMake(self.centerx, self.centery - viewCurrent.centery)];
    [viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [viewCurrent.layer setCornerRadius:4.0f];
    [viewCurrent.layer setMasksToBounds:true];
    [self addSubview:viewCurrent];
    
    lblTitle = [[UILabel alloc] init];
    [lblTitle setFrame:CGRectMake(20.0f, 20.0f, viewCurrent.width - 40.0f, 20.0f)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:TITLE_COLOR];
    [lblTitle setFont:kButtonFont];
    [lblTitle setText:!_isTitle?@"提示":_isTitle];
    [viewCurrent addSubview:lblTitle];
    
    //还有什么问题文本框
    textQuestion = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15.0f, lblTitle.bottom + 40.0f, viewCurrent.width - 30.0f, 42.0f)];
    textQuestion.backgroundColor = [UIColor clearColor];
    textQuestion.minNumberOfLines = 1;
    textQuestion.maxNumberOfLines = 5;
    textQuestion.isScrollable = NO;
    textQuestion.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textQuestion.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    
    textQuestion.placeholder = @"备注";
    textQuestion.placeholderColor = KPlaceholderColor;
    textQuestion.font = kContentFont;
    textQuestion.textColor = TITLE_COLOR;
    textQuestion.delegate = self;
    textQuestion.keyboardType = UIKeyboardTypeDefault;
    textQuestion.returnKeyType = UIReturnKeyDefault;
    textQuestion.enablesReturnKeyAutomatically = YES;
    [viewCurrent addSubview:textQuestion];
    
    //边框线
    lineText = [[UIView alloc] init];
    [lineText setFrame:CGRectMake(lblTitle.left, textQuestion.bottom - 2.0f, lblTitle.width, 1.0f)];
    [lineText setBackgroundColor:DDGreen_Color];
    [viewCurrent insertSubview:lineText belowSubview:textQuestion];
    
    viewBottom = [[UIView alloc] init];
    [viewBottom setFrame:CGRectMake(0, textQuestion.bottom + 40.0f, viewCurrent.width, 44.0f)];
    [viewBottom setBackgroundColor:[UIColor whiteColor]];
    [viewCurrent addSubview:viewBottom];
    [viewCurrent setSize:CGSizeMake(viewCurrent.width, viewBottom.bottom)];
    
    btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 0, floorf(viewBottom.width/2.0f), viewBottom.height)];
    [btnBack setBackgroundImage:[UIImage imageWithDrawColor:[UIColor whiteColor] withSize:btnBack.bounds] forState:UIControlStateNormal];
    [btnBack setBackgroundImage:[UIImage imageWithDrawColor:KPlaceholderColor withSize:btnBack.bounds] forState:UIControlStateHighlighted];
    
    [btnBack.titleLabel setFont:kButtonFont];
    [btnBack setTitle:!_isCancelTitle?@"取消":_isCancelTitle forState:UIControlStateNormal];
    [btnBack setTitleColor:TIME_COLOR forState:UIControlStateNormal];
    [btnBack setTitleColor:CONTENT_COLOR forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(onClickWithClear) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnBack];
    
    btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext setFrame:CGRectMake(btnBack.right, btnBack.top, viewBottom.width - btnBack.width, btnBack.height)];
    [btnNext setBackgroundImage:[UIImage imageWithDrawColor:[UIColor whiteColor] withSize:btnNext.bounds] forState:UIControlStateNormal];
    [btnNext setBackgroundImage:[UIImage imageWithDrawColor:DDGreen_Color withSize:btnNext.bounds] forState:UIControlStateHighlighted];
    
    [btnNext.titleLabel setFont:kButtonFont];
    [btnNext setTitle:!_isNextTitle?@"确定":_isNextTitle forState:UIControlStateNormal];
    [btnNext setTitleColor:DDGreen_Color forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnNext addTarget:self action:@selector(onClickWithNext) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:btnNext];
    
    UIView *lineCol = [[UIView alloc] init];
    [lineCol setFrame:CGRectMake(0, 0, viewBottom.width, 0.5f)];
    [lineCol setBackgroundColor:BORDER_COLOR];
    [viewBottom addSubview:lineCol];
    
    UIView *lineRow = [[UIView alloc] init];
    [lineRow setFrame:CGRectMake(floorf(viewBottom.width/2.0f), 0, 0.5f, viewBottom.height)];
    [lineRow setBackgroundColor:BORDER_COLOR];
    [viewBottom addSubview:lineRow];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    textQuestion.placeholder = placeholder ?: @"";
}

- (void)setKeyboardTypeNumber:(NSInteger)keyboardTypeNumber
{
    textQuestion.keyboardType = UIKeyboardTypeNumberPad;
}

- (NSInteger)contentCount
{
    if (_contentCount < 1) {
        _contentCount = 60;
    }
    return _contentCount;
}

#pragma mark - Action
- (void)onClickWithClear
{
    [self dismissAlert];
    if (_delegate && [_delegate respondsToSelector:@selector(textAlertView:withText:withFlag:)]) {
        [_delegate textAlertView:self withText:textQuestion.text withFlag:false];
    }
}

- (void)onClickWithNext
{
    [self dismissAlert];
    if (_delegate && [_delegate respondsToSelector:@selector(textAlertView:withText:withFlag:)]) {
        [_delegate textAlertView:self withText:textQuestion.text withFlag:true];
        [textQuestion setText:@""];
    }
}

#pragma mark - 视图的显示和隐藏
- (void)show
{
    if (_isShowing) {
        return;
    }
    [_window addSubview:self];
    
    [self setAlpha:0];
    [UIView animateWithDuration:0.35f animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        _isShowing = true;
        [textQuestion becomeFirstResponder];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }];
}

- (void)dismissAlert
{
    if (!_isShowing) {
        return;
    }
    [textQuestion resignFirstResponder];
    
    [UIView animateWithDuration:0.35f animations:^(void) {
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        _isShowing = false;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        [self removeFromSuperview];
        [super removeFromSuperview];
    }];
}

#pragma mark - 键盘隐藏和显示
- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [viewCurrent setCenter:CGPointMake(viewCurrent.centerX, floorf(self.height-ty)/2.0f)];
    }];
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [viewCurrent setCenter:CGPointMake(self.centerx, self.centery - viewCurrent.centery)];
    }];
}

#pragma mark growing textview delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //计算文本框根据字符串得到的高度差
    float diff = (height - growingTextView.height);
    
    [lineText setOrigin:CGPointMake(lineText.left, lineText.top+diff)];
    [viewBottom setOrigin:CGPointMake(viewBottom.left, viewBottom.top+diff)];
    
    //以文本框新增的高度差，来调整位置
    CGRect r = viewCurrent.frame;
    r.size.height += diff;
    r.origin.y -= diff;
    viewCurrent.frame = r;
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *text_str = [growingTextView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger length_Max = MIN(self.contentCount, 60);
    
    if (text_str.length > length_Max) {
        growingTextView.text = [text_str substringToIndex:length_Max];
        return false;
    }
    return true;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    NSInteger length_Max = MIN(self.contentCount, 60);
    if (growingTextView.text.length > length_Max) {
        growingTextView.text = [growingTextView.text substringToIndex:length_Max];
    }
}

@end
