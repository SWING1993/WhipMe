//
//  DDFeedbackController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDFeedbackController.h"
#import "MBProgressHUD+MJ.h"
#import "HPGrowingTextView.h"

@interface DDFeedbackController () <HPGrowingTextViewDelegate, DDInterfaceDelegate>

/** 自定义TextView，可设置Placeholder提示消息 */
@property (nonatomic, strong) HPGrowingTextView *textQuestion;
/** 边框线 */
@property (nonatomic, strong) UIView *lineText;
/** 下一步操作的按钮 */
@property (nonatomic, strong) UIButton *btnSubmit;

/** 网络请求 */
@property (strong, nonatomic) DDInterface *interfaceFeedBack;
@end

@implementation DDFeedbackController
#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"意见反馈" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self.view addSubview:self.textQuestion];
    [self.view insertSubview:self.lineText belowSubview:self.textQuestion];
    [self.view addSubview:self.btnSubmit];
}

#pragma mark - Event Method
- (void)onClickWithSubmit:(id)sender
{
    [self.textQuestion resignFirstResponder];
    if ([self.textQuestion.text length] > 0) {
        [self feedBackDetailWithRequest];
    }
}
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:false];
}

#pragma mark - Growing Textview Delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //计算文本框根据字符串得到的高度差
    float diff = (height - growingTextView.height);
    
    [self.lineText setOrigin:CGPointMake(self.lineText.left, self.lineText.top+diff)];
    [self.btnSubmit setOrigin:CGPointMake(self.btnSubmit.left, self.btnSubmit.top+diff)];
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //判断字符串的最大长度位160
    NSString *text_str = [growingTextView.text stringByReplacingCharactersInRange:range withString:text];
    if (text_str.length > 0) {
        [self.btnSubmit setUserInteractionEnabled:true];
        [self.btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:DDGreen_Color withSize:self.btnSubmit.bounds] forState:UIControlStateNormal];
    } else {
        [self.btnSubmit setUserInteractionEnabled:false];
        [self.btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:KPlaceholderColor withSize:self.btnSubmit.bounds] forState:UIControlStateNormal];
    }
    if (text_str.length >= 160) {
        [growingTextView setText:[text_str substringToIndex:160]];
    }
    return true;
}
#pragma mark - Network Request

- (void)feedBackDetailWithRequest
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //意见
    [param setObject:[NSString stringWithFormat:@"%@",self.textQuestion.text] forKey:@"feed"];
    
    //初始化连接
    if (!self.interfaceFeedBack) {
        self.interfaceFeedBack = [[DDInterface alloc] initWithDelegate:self];
    }
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [self.interfaceFeedBack interfaceWithType:INTERFACE_TYPE_FEED_BACK param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceFeedBack)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [MBProgressHUD showSuccess:@"感谢您的反馈，我们会在第一时间核实您提交的信息" withFontSzie:25];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }
}
#pragma mark - Setter && Getter
- (HPGrowingTextView *)textQuestion
{
    if (_textQuestion == nil) {
        _textQuestion = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(kMargin, 40.0f + KNavHeight, self.view.width - kMargin*2.0f, 42.0f)];
        _textQuestion.backgroundColor = [UIColor clearColor];
        _textQuestion.minNumberOfLines = 1;
        _textQuestion.maxNumberOfLines = 5;
        _textQuestion.isScrollable = NO;
        _textQuestion.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _textQuestion.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        _textQuestion.placeholder = @"请输入您的意见和建议吧";
        _textQuestion.placeholderColor = KPlaceholderColor;
        _textQuestion.font = kContentFont;
        _textQuestion.textColor = TITLE_COLOR;
        _textQuestion.delegate = self;
        _textQuestion.returnKeyType = UIReturnKeyDone;
        _textQuestion.enablesReturnKeyAutomatically = YES;
    }
    return _textQuestion;
}

- (UIView *)lineText
{
    if (_lineText == nil) {
        _lineText = [[UIView alloc] init];
        [_lineText setFrame:CGRectMake(15.0f, self.textQuestion.bottom - 2.0f, self.view.width - 30.0f, 0.5f)];
        [_lineText setBackgroundColor:BORDER_COLOR];
    }
    return _lineText;
}

- (UIButton *)btnSubmit
{
    if (_btnSubmit == nil) {
        _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSubmit setFrame:CGRectMake( 15.0f, self.textQuestion.bottom + 20.0f, self.view.width - 30.0f, 40.0f)];
        [_btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:KPlaceholderColor withSize:_btnSubmit.bounds] forState:UIControlStateNormal];
        [_btnSubmit setAdjustsImageWhenHighlighted:false];
        [_btnSubmit.layer setCornerRadius:_btnSubmit.height/2.0f];
        [_btnSubmit.layer setMasksToBounds:true];
        [_btnSubmit setUserInteractionEnabled:false];
        [_btnSubmit.titleLabel setFont:kButtonFont];
        [_btnSubmit setTitle:@"提交反馈" forState:UIControlStateNormal];
        [_btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnSubmit addTarget:self action:@selector(onClickWithSubmit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnSubmit;
}



@end
