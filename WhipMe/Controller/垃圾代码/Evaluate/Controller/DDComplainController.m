//
//  DDComplainController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
#define KComplainItem 7777

#import "DDComplainController.h"
#import "HPGrowingTextView.h"
#import "DDInterface.h"

@interface DDComplainController () <HPGrowingTextViewDelegate, DDInterfaceDelegate>

@property (nonatomic, strong) UIScrollView *detailScroll;                                                               /** 本视图的整体滚动视图 */
@property (nonatomic, strong) HPGrowingTextView *textQuestion;                                                          /** 文本框（还有什么问题） */
@property (nonatomic, strong) UILabel *lblTextCount;                                                                    /** 文本框限量计数 */
@property (nonatomic, strong) UIView *lineText;                                                                         /** 边框线 */
@property (nonatomic, strong) UIButton *btnSubmit;                                                                      /** 提交按钮 */
@property (nonatomic, strong) UIButton *btnPhone;                                                                       /** 联系客服 */
@property (nonatomic, strong) NSMutableArray *arrayComplainBtn;                                                            /** 存储投诉意见按钮空间 */
/** 投诉内容字符串数组 */
@property (nonatomic, strong) NSMutableArray *complainTextArray;
/**
 *  网络请求
 */
@property (nonatomic, strong) DDInterface *interComplain;
@end

@implementation DDComplainController
@synthesize detailScroll;
@synthesize btnSubmit;

@synthesize lblTextCount;
@synthesize textQuestion;
@synthesize lineText;
@synthesize btnPhone;
@synthesize arrayComplainBtn;

#pragma mark - 初始化生成临时数据
- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSMutableArray *)complainTextArray
{
    if (_complainTextArray == nil) {
        _complainTextArray = [NSMutableArray array];
    }
    return _complainTextArray;
}

/** 实时显示当前文本框的字符数 */
- (void)setLabelTextCount:(NSString *)str_count
{
    NSRange range_count = [str_count rangeOfString:@"/100"];
    NSMutableAttributedString *att_count = [[NSMutableAttributedString alloc] initWithString:str_count];
    [att_count addAttribute:NSForegroundColorAttributeName value:DDGreen_Color range:NSMakeRange(0, str_count.length)];
    [att_count addAttribute:NSFontAttributeName value:kTimeFont range:NSMakeRange(0, str_count.length)];
    [att_count addAttribute:NSForegroundColorAttributeName value:KPlaceholderColor range:range_count];
    [lblTextCount setAttributedText:att_count];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interComplain)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark -- 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"投诉" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //初始化界面的控件
    [self ddCreateForViewControl];
    
    [self setLabelTextCount:@"0/100"];
}

/**
 初始化界面的控件
 */
- (void)ddCreateForViewControl
{
    //创建滚动视图，作为界面的所有内容父视图
    detailScroll = [[UIScrollView alloc] init];
    [detailScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
    [detailScroll setBackgroundColor:[UIColor whiteColor]];
    [detailScroll setShowsHorizontalScrollIndicator:false];
    [detailScroll setShowsVerticalScrollIndicator:false];
    [self.view addSubview:detailScroll];

    //取消键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickWithTap)];
    [detailScroll addGestureRecognizer:tapGr];
    
    /** 
     循环创建投诉意见按钮
     KComplainItem  按钮下标
     
     */
    arrayComplainBtn = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"额外收取不合理费用",@"未在规定时间内取件",@"快递员服务态度恶劣",@"不是该快递公司快递员",@"取件速度特别慢", nil];
    for (NSInteger i=0; i<arrayTitle.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setSize:CGSizeMake(290.0f, 32.0f)];
        [itemButton setOrigin:CGPointMake(floorf(detailScroll.width - itemButton.width)/2.0f, 30.0f + i*52.0f)];
        [itemButton.layer setCornerRadius:4.0f];
        [itemButton.layer setMasksToBounds:true];
        [itemButton.layer setBorderWidth:1.0f];
        [itemButton.layer setBorderColor:BORDER_COLOR.CGColor];
        [itemButton setBackgroundColor:[UIColor clearColor]];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton setTitle:arrayTitle[i] forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [itemButton setTitleColor:TITLE_COLOR forState:UIControlStateSelected];
        [itemButton setTag:KComplainItem + i];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [detailScroll addSubview:itemButton];
        [arrayComplainBtn addObject:itemButton];
    }
    
    //还有什么问题文本框
    textQuestion = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15.0f, 52.0f*arrayTitle.count + 40.0f, detailScroll.width - 30.0f, 42.0f)];
    textQuestion.backgroundColor = [UIColor clearColor];
    textQuestion.minNumberOfLines = 1;
    textQuestion.maxNumberOfLines = 5;
    textQuestion.isScrollable = NO;
    textQuestion.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    textQuestion.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    
    textQuestion.placeholder = @"还有什么问题";
    textQuestion.placeholderColor = KPlaceholderColor;
    textQuestion.font = kTitleFont;
    textQuestion.textColor = TITLE_COLOR;
    textQuestion.delegate = self;
    textQuestion.returnKeyType = UIReturnKeyDone;
    textQuestion.enablesReturnKeyAutomatically = YES;
    [detailScroll addSubview:textQuestion];
    
    //边框线
    lineText = [[UIView alloc] init];
    [lineText setFrame:CGRectMake(15.0f, textQuestion.bottom - 2.0f, detailScroll.width - 30.0f, 0.5f)];
    [lineText setBackgroundColor:BORDER_COLOR];
    [detailScroll insertSubview:lineText belowSubview:textQuestion];
    
    //文本框文字计数
    lblTextCount = [[UILabel alloc] init];
    [lblTextCount setFrame:CGRectMake(textQuestion.right - 80.0f, lineText.bottom, 80.0f, textQuestion.height)];
    [lblTextCount setBackgroundColor:[UIColor clearColor]];
    [lblTextCount setTextAlignment:NSTextAlignmentRight];
    [lblTextCount setFont:kTimeFont];
    [lblTextCount setTextColor:KPlaceholderColor];
    [detailScroll addSubview:lblTextCount];
    
    //提交按钮
    btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake( lineText.left, lineText.bottom + 54.0f, lineText.width, 40.0f)];
    [btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:BORDER_COLOR withSize:btnSubmit.bounds] forState:UIControlStateNormal];
    [btnSubmit.layer setCornerRadius:btnSubmit.height/2.0f];
    [btnSubmit.layer setMasksToBounds:true];
    [btnSubmit setAdjustsImageWhenHighlighted:false];
    [btnSubmit.titleLabel setFont:kButtonFont];
    [btnSubmit setUserInteractionEnabled:false];
    [btnSubmit setTitle:@"提   交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:TIME_COLOR forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(onClickWithSubmit:) forControlEvents:UIControlEventTouchUpInside];
    [detailScroll addSubview:btnSubmit];
    
    //联系客服
    btnPhone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhone setBackgroundColor:[UIColor clearColor]];
    [btnPhone setAdjustsImageWhenHighlighted:false];
    [btnPhone.titleLabel setFont:kTimeFont];
    [btnPhone setTitleColor:DDGreen_Color forState:UIControlStateNormal];
    [btnPhone addTarget:self action:@selector(onClickWithPhone) forControlEvents:UIControlEventTouchUpInside];
    [detailScroll addSubview:btnPhone];
    
    NSString *phoneStr = @"联系客服";
    CGSize phoneSize = [phoneStr sizeWithAttributes:@{NSFontAttributeName : kTimeFont}];
    [btnPhone setSize:CGSizeMake(floorf(phoneSize.width)+1.0f, floorf(phoneSize.height)+1.0f)];
    [btnPhone setCenter:CGPointMake(btnSubmit.centerX, btnSubmit.bottom + 28.0f)];
    [btnPhone setTitle:phoneStr forState:UIControlStateNormal];
    [detailScroll setContentSize:CGSizeMake(detailScroll.width, MAX(detailScroll.height, btnPhone.bottom + 22.0f))];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action
/** 投诉选项按钮的事件 */
- (void)onClickWithItem:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [btn.layer setBorderColor:DDGreen_Color.CGColor];
        [self.complainTextArray addObject:btn.titleLabel.text];
    } else {
        [btn.layer setBorderColor:BORDER_COLOR.CGColor];
        [self.complainTextArray removeObject:btn.titleLabel.text];
    }
//    for (UIButton *itemButton in arrayComplain)
//    {
//        if (itemButton.tag == btn.tag) {
//            _indexChoose = [arrayComplain indexOfObject:itemButton];
//            //如果是当前选择按钮，改变颜色和边框
//            [itemButton.layer setBorderColor:DDGreen_Color.CGColor];
//            [itemButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
//        } else {
//            //其他，还原默认值
//            [itemButton.layer setBorderColor:BORDER_COLOR.CGColor];
//            [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
//        }
//    }
    [self setSubmitButtonState:self.complainTextArray.count > 0 ? true : false];
}

/**  拨打电话 */
- (void)onClickWithPhone
{
    if (self.servicePhone.length == 0) {
        self.servicePhone = @"4008228089";
    }
    [self callCustomerService:self.servicePhone];
}

/**
 *  拨打电话
 */
- (void)callCustomerService:(NSString *)phone
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];
}

/** 设置提交按钮状态 */
- (void)setSubmitButtonState:(BOOL)flag
{
    if (flag) {
        [btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:DDGreen_Color withSize:btnSubmit.bounds] forState:UIControlStateNormal];
        [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSubmit setUserInteractionEnabled:YES];
    } else {
        [btnSubmit setBackgroundImage:[UIImage imageWithDrawColor:BORDER_COLOR withSize:btnSubmit.bounds] forState:UIControlStateNormal];
        [btnSubmit setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [btnSubmit setUserInteractionEnabled:false];
    }
}

/** 提交按钮触发事件 */
- (void)onClickWithSubmit:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil
                                                     message:@"感谢您的反馈，你提交的信息我们会第一时间处理并给您答复的，再次感谢"
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
    [alert show];
    
    if (self.textQuestion.text.length > 0) {
        [self.complainTextArray addObject:self.textQuestion.text];
        NSLog(@"%@",self.complainTextArray);
    }
    
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //订单 ID
    [param setObject:self.orderId forKey:@"orderId"];
    
    //数组中装投诉字符串
    [param setObject:self.complainTextArray forKey:@"content"];
    
    //初始化连接
    DDInterface *interface = [[DDInterface alloc] initWithDelegate:self];
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [interface interfaceWithType:INTERFACE_TYPE_SUBMIT_COMPLAIN param:param];
    
    self.interComplain = interface;
}




#pragma mark growing textview delegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //计算文本框根据字符串得到的高度差
    float diff = (height - growingTextView.height);
    
    //以文本框新增的高度差，来调整文本框坐标小面空间的位置
    [lineText setOrigin:CGPointMake(lineText.left, lineText.top+diff)];
    [lblTextCount setOrigin:CGPointMake(lblTextCount.left, lblTextCount.top+diff)];
    
    [btnSubmit setOrigin:CGPointMake(btnSubmit.left, btnSubmit.top+diff)];
    [btnPhone setOrigin:CGPointMake(btnPhone.left, btnPhone.top+diff)];
    
    //调整滚动视图显示的位置
    [detailScroll setContentOffset:CGPointMake(detailScroll.contentOffset.x, detailScroll.contentOffset.y+diff)];
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //获取当前文本框的所有字符
    NSString *text_str = [growingTextView.text stringByReplacingCharactersInRange:range withString:text];
    //限制文本框字符长度
    if (text_str.length > 100) {
        [self setLabelTextCount:@"100/100"];
        growingTextView.text = [text_str substringToIndex:100];
        return false;
    }
    [self setLabelTextCount:[NSString stringWithFormat:@"%ld/100",(long)text_str.length]];
    return true;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    //限制文本框字符长度
    if (growingTextView.text.length > 100) {
        [self setLabelTextCount:@"100/100"];
        growingTextView.text = [growingTextView.text substringToIndex:100];
    }
    [self setLabelTextCount:[NSString stringWithFormat:@"%ld/100",(long)growingTextView.text.length]];
}

/** 取消键盘编辑 */
- (void)onClickWithTap
{
    [self.view endEditing:false];
}

#pragma mark - 键盘隐藏和显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    DDAddNotification(@selector(keyBoardWillShow:), UIKeyboardWillShowNotification);
    DDAddNotification(@selector(keyBoardWillHide:), UIKeyboardWillHideNotification);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DDRemoveNotificationObserver();
}

/** 键盘显示所触发的事件 */
- (void)keyBoardWillShow:(NSNotification *)note
{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height + lblTextCount.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [detailScroll setContentOffset:CGPointMake(detailScroll.contentOffset.x, MAX(textQuestion.bottom + kMargin - (detailScroll.height - ty), 0))];
    } completion:^(BOOL finish) {
        if (detailScroll.contentSize.height - textQuestion.top + 7.0f > detailScroll.height - textQuestion.top + 7.0f) {
            [detailScroll setContentSize:CGSizeMake(detailScroll.width, MAX(DDSCreenBounds.size.height - KNavHeight, btnPhone.bottom + 22.0f) + ty)];
        }
    }];
}

/** 键盘隐藏所触发的事件 */
- (void)keyBoardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [detailScroll setContentOffset:CGPointMake(detailScroll.contentOffset.x, 0)];
    } completion:^(BOOL finish) {
        [detailScroll setContentSize:CGSizeMake(detailScroll.width, MAX(detailScroll.height, btnPhone.bottom + 22.0f))];
        //判断文本框是否有字符串，提交按钮是否可点击
        [self setSubmitButtonState:textQuestion.text>0 ? true : false];
    }];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
