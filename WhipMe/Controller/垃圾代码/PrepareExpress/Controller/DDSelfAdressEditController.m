//
//  DDSelfAdressEditController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
#define KAddressEdit_Txt 7777

#import "DDSelfAdressEditController.h"
#import "DDInputAddressController.h"
#import "HPGrowingTextView.h"
#import "DDLabelLists.h"
#import "DDSelfAddressListController.h"

#import "DDAddressDetail.h"
#import "DDProvinceList.h"
#import "DDCityList.h"
#import "DDAreaList.h"
#import "YYModel.h"
#import "DDLocalUserInfoUtils.h"

#import "Constant.h"
#import "DDLocalUserInfoUtils.h"
#import "CustomStringUtils.h"
#import "DDCenterCoordinate.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

typedef NS_ENUM(NSInteger, selfAddressInfoStyle) {
    selfAddressInfoName = 0,            /**  姓名  */
    selfAddressInfoPhoneNumber = 1,     /**  手机号  */
    selfAddressInfoLocAddress = 2,      /**  定位地址  */
    selfAddressInfoDetailAddress = 3,   /**  详细地址  */
    selfAddressInfoLabel = 4,           /**  标签  */
};

@interface DDSelfAdressEditController () <
DDInterfaceDelegate,
DDLabelListsDelegate,
HPGrowingTextViewDelegate,
DDInputAddressControllerDelegate,
UITextFieldDelegate>
{
    UIView *_tempView;
    BOOL _isshowed;
}
@property (strong, nonatomic) UIScrollView *backScroll;
/** 寄件人 */
@property (strong, nonatomic) UITextField *nameTextField;
/** 手机号 */
@property (strong, nonatomic) UITextField *phoneTextField;
/** 定位地址 */
@property (strong, nonatomic) UITextField *locAddressTextField;
/** 详细地址 */
@property (strong, nonatomic) HPGrowingTextView *detailAddressTextField;
@property (strong, nonatomic) UIButton *btnDetailAddr;
@property (strong, nonatomic) UIView *detailAddressUnderLine;

/** 标签 */
@property (nonatomic, strong) NSArray *arrayLabels;
@property (strong, nonatomic) UITextField  *textAddressLabel;
@property (strong, nonatomic) DDLabelLists *labelItems;
@property (strong, nonatomic) UIButton *btnLabelItems;


@property (strong, nonatomic) DDAddressDetail *addressDetail;

@property (strong, nonatomic) DDInterface *interfaceEdit;

@property (nonatomic, strong) UIButton *selfAddressListButton;
/**  判断是否是从选择定位地址中返回的  */
@property (nonatomic, assign) BOOL isInputBack;

@end

@implementation DDSelfAdressEditController

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *titleString = self.isEdit ? @"编辑寄件地址" : @"添加寄件地址";
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:titleString segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self adaptFirstRightItemWithTitle:@"保存"];
    [self.view addSubview:self.backScroll];
    [self createViewLoad];
    [self.view addSubview:self.selfAddressListButton];
    
    if (self.isEdit) {
        self.addressDetail = self.editAddressDetail;
    } else {
        [self copyHomePageAddress];
    }
}




- (void)copyHomePageAddress
{
    self.addressDetail.provinceName = self.homeAddressDetail.provinceName;
    self.addressDetail.cityName = self.homeAddressDetail.cityName;
    self.addressDetail.districtName = self.homeAddressDetail.districtName;
    self.addressDetail.contentAddress = self.homeAddressDetail.contentAddress;
    self.addressDetail.supplementAddress = self.homeAddressDetail.supplementAddress;
    self.addressDetail.localDetailAddress = self.homeAddressDetail.localDetailAddress;
    self.addressDetail.addressName = self.homeAddressDetail.addressName;
    self.addressDetail.latitude = self.homeAddressDetail.latitude;
    self.addressDetail.longitude = self.homeAddressDetail.longitude;
    self.addressDetail.nick = [LocalUserInfo objectForKey:@"nick"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setInitialValue];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DDAddNotification(@selector(keyBoardWillShow:), UIKeyboardWillShowNotification);
    DDAddNotification(@selector(keyBoardWillHide:), UIKeyboardWillHideNotification);
    [self.textAddressLabel addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextField  addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:false];
    DDRemoveNotificationObserver();
}

#pragma mark - 初始化视图
/** 初始化界面视图UI */
- (void)createViewLoad
{
    NSArray  *arrayLabelTitle = [NSArray arrayWithObjects:@"寄件人",@"联系方式",@"定位地址",@"详细地址",@"标签", nil];
    NSString *item_str = [arrayLabelTitle objectAtIndex:1];
    CGSize   size_item = [item_str sizeWithAttributes:@{NSFontAttributeName:kTitleFont}];
    CGFloat  origin_x = floorf(size_item.width+1) + 40.0f;
    for (int i=0; i<arrayLabelTitle.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(0, i*44.0f, self.backScroll.width, 44.0f)];
        [itemButton setBackgroundColor:[UIColor whiteColor]];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake((itemButton.height - floorf(size_item.height+1))/2.0f, 15.0f, 0, 0)];
        [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton setTitle:arrayLabelTitle[i] forState:UIControlStateNormal];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton addTarget:self action:@selector(clickWithTapGesture) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backScroll addSubview:itemButton];
        
        UIView *lineView = [[UIView alloc] init];
        [lineView setFrame:CGRectMake(15.0f, itemButton.height - 0.5f, itemButton.width - 15.0f, 0.5f)];
        [lineView setBackgroundColor:BORDER_COLOR];
        [itemButton addSubview:lineView];
        
        if (i < 3) {
            //初始化输入框
            UITextField *textItem = [[UITextField alloc] init];
            [textItem setFrame:CGRectMake(origin_x, 0, itemButton.width - origin_x, itemButton.height)];
            [textItem setBackgroundColor:[UIColor clearColor]];
            [textItem setTextAlignment:NSTextAlignmentLeft];
            [textItem setTextColor:TITLE_COLOR];
            [textItem setFont:kTitleFont];
            [textItem setDelegate:self];
            [textItem setTag:KAddressEdit_Txt + i];
            [textItem setClearButtonMode:UITextFieldViewModeWhileEditing];
            [textItem setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textItem setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
            [itemButton addSubview:textItem];
            
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            switch (i) {
                case selfAddressInfoName:
                    [textItem setPlaceholder:@"请输入寄件人姓名"];
                    self.nameTextField = textItem;
                    break;
                case selfAddressInfoPhoneNumber:
                    [textItem setPlaceholder:@"请输入电话"];
                    [textItem setUserInteractionEnabled:false];
                    [textItem setTextColor:KPlaceholderColor];
                    self.phoneTextField = textItem;
                    break;
                case selfAddressInfoLocAddress:
                    [textItem setPlaceholder:@"请选择定位地址"];
                    [textItem setUserInteractionEnabled:false];
                    self.locAddressTextField = textItem;
                    [itemButton addTarget:self action:@selector(locationAddressBtnClick) forControlEvents:UIControlEventTouchUpInside];
                    [rightView setFrame:CGRectMake(0, 0, textItem.height, textItem.height)];
                    [rightView setBackgroundColor:[UIColor clearColor]];
                    [rightView setAdjustsImageWhenHighlighted:false];
                    [rightView setImage:[UIImage imageNamed:DDInputAddressMap] forState:UIControlStateNormal];
                    [textItem setRightView:rightView];
                    [textItem setRightViewMode:UITextFieldViewModeAlways];
                    break;
                default:
                    break;
            }
        } else if (i == 3) {
            [self createAddressDetailTextFieldWithFrame:CGRectMake(origin_x - 10.0f, 5.0f, itemButton.width - origin_x, itemButton.height)];
            [self.detailAddressTextField setPlaceholder:@"补充详细地址，如X栋X单元X号"];
            [itemButton addSubview:self.detailAddressTextField];
            self.btnDetailAddr = itemButton;
            self.detailAddressUnderLine = lineView;
        } else {
            //创建标签按钮
            [self.labelItems setFrame:CGRectMake(origin_x, (itemButton.height - floorf(size_item.height+1))/2.0f, itemButton.width - origin_x - 15.0f, 20.0f)];
            [self.labelItems setDetailTags:(NSMutableArray *)self.arrayLabels];
            [itemButton addSubview:self.labelItems];
            [self.labelItems setSize:CGSizeMake([self.labelItems fittedSize].width, self.labelItems.height)];
            //创建标签输入框
            [self.textAddressLabel setFrame:CGRectMake(origin_x, self.labelItems.bottom, self.labelItems.width, 40.0f)];
            [self.textAddressLabel setTag:KAddressEdit_Txt + i];
            [self.textAddressLabel setPlaceholder:@"其他"];
            [itemButton addSubview:self.textAddressLabel];
            [itemButton setSize:CGSizeMake(itemButton.width, self.textAddressLabel.bottom)];
            self.btnLabelItems = itemButton;
            
            [lineView setFrame:CGRectMake(origin_x, self.textAddressLabel.bottom - 10.0f, self.textAddressLabel.width, 0.5f)];
        }
    }
}


#pragma mark - Private Method
-(void)textFieldValueChange:(UITextField *)textField{
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if (textField == self.textAddressLabel) {
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position && toBeString.length > 4) {
                textField.text = [toBeString substringToIndex:4];
            }
        }else{
            if (toBeString.length > 4) {
                textField.text = [toBeString substringToIndex:4];
            }
        }
    }else if (textField == self.nameTextField) {
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            if (!position && toBeString.length > 10) {
                textField.text = [toBeString substringToIndex:10];
            }
        }
        else{
            if (toBeString.length > 10) {
                textField.text = [toBeString substringToIndex:10];
            }
        }
    }
}


- (void)setInitialValue
{
    if (self.isInputBack == NO) {
        self.addressDetail.nick = [LocalUserInfo objectForKey:@"nick"];
        self.nameTextField.text = self.addressDetail.nick;
        NSString *str_label = self.addressDetail.sign ?: @"";
        /** 数组是否包含已有的标签字符 */
        if ([self.arrayLabels containsObject:str_label]) {
            NSInteger index = [self.arrayLabels indexOfObject:str_label];
            [self.labelItems selectedWithIndexItems:index];
        } else {
            self.textAddressLabel.text = str_label;
        }
    }else {
        self.isInputBack = NO;
    }
    
    
    self.detailAddressTextField.text = self.addressDetail.supplementAddress ?: @"";
    if ([CustomStringUtils isBlankString:self.addressDetail.addressName]) {
        if ([self.addressDetail.contentAddress rangeOfString:@"/"].length > 0) {
            
            NSRange range = [self.addressDetail.contentAddress rangeOfString:@"/"];
            
            NSString *addressName = [self.addressDetail.contentAddress substringWithRange:NSMakeRange(range.location+1, self.addressDetail.contentAddress.length - range.location - 1)];
            [self.locAddressTextField setText:addressName];
            
            self.addressDetail.localDetailAddress = [self.addressDetail.contentAddress substringToIndex:range.location];
            self.addressDetail.addressName = addressName;
        }
    } else {
        [self.locAddressTextField setText:self.addressDetail.addressName];
    }
    
    self.addressDetail.phone = [DDInterfaceTool getPhoneNumber] ?: [DDLocalUserInfoUtils getUserPhone];
    
    
    
    self.phoneTextField.text = self.addressDetail.phone;
    
    

}

- (void)savePersonDetailInfoToLocal
{
    /**  保存名字  */
    self.addressDetail.nick = self.nameTextField.text;
    self.addressDetail.supplementAddress = self.detailAddressTextField.text;
    self.addressDetail.contentAddress = [NSString stringWithFormat:@"%@/%@",self.addressDetail.localDetailAddress,self.addressDetail.addressName];
    self.addressDetail.addressType = 1;
    if ([self.textAddressLabel.text length] > 0) {
        self.addressDetail.sign = self.textAddressLabel.text;
    }
}

/** 判断必填项是否填写 */
- (BOOL)isAllInfoCompleted
{
    NSString *nick = self.nameTextField.text;
    NSString *location = self.locAddressTextField.text;
    NSString *content = self.detailAddressTextField.text;
    if (nick.length == 0 || location.length == 0 || content.length == 0) {
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - Event Method
/* 定位地址按钮点击事件 */
- (void)locationAddressBtnClick
{
    DDInputAddressController *controller = [[DDInputAddressController alloc] init];
    controller.delegate = self;
    controller.isBackToHome = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickWithTapGesture
{
    [self.view endEditing:false];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickFirstRightItem
{
    if ([self isAllInfoCompleted] ==  NO) {
        [self displayForErrorMsg:@"姓名，地址都不能为空"];
        return ;
    }
    
    CGFloat betweenMeters = [self getMetersWithCourierLocation:CLLocationCoordinate2DMake(self.addressDetail.latitude, self.addressDetail.longitude)];
    if (betweenMeters / 1000 > 20) {
        [MBProgressHUD showError:@"寄件地址不能超过20km"];
    } else {
        /** 保存数据 */
        [self savePersonDetailInfoToLocal];
        //回传
        if (self.delegate && [self.delegate respondsToSelector:@selector(getValueWhenSaveInSelfAdressEdit:withChangedAddressDetail:)]) {
            [self.delegate getValueWhenSaveInSelfAdressEdit:self withChangedAddressDetail:self.addressDetail];
        }
        if (self.isEdit == NO) {
            [DDLocalUserInfoUtils updateUserNickName:self.addressDetail.nick];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self changeAddressRequest];
        }
    }
}

- (void)onClickSelfAddressListButton
{
    DDSelfAddressListController *controller = [[DDSelfAddressListController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Delegate
- (void)passInputAddress:(DDInputAddressController *)InputAddressController withSuggestionAddress:(DDAddressDetail *)addressDetail
{
    self.isInputBack = YES;
    self.addressDetail.provinceName = addressDetail.provinceName;
    self.addressDetail.cityName = addressDetail.cityName;
    self.addressDetail.districtName = addressDetail.districtName;
    self.addressDetail.contentAddress = addressDetail.contentAddress;
    self.addressDetail.localDetailAddress = addressDetail.localDetailAddress;
    self.addressDetail.addressName = addressDetail.addressName;
    self.addressDetail.latitude = addressDetail.latitude;
    self.addressDetail.longitude = addressDetail.longitude;
}



#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    if (textField == self.textAddressLabel) {
        _tempView = self.btnLabelItems;
        [self.labelItems selectedWithAllItems:false];
        self.addressDetail.sign = @"";
    } else {
        _tempView = nil;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str_text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.phoneTextField) {
        if (str_text.length > 11) {
            textField.text = [str_text substringToIndex:11];
            return false;
        }
    }
    return true;
}

- (NSString *)subToStirng:(NSString *)str_text length:(NSInteger)length
{
    NSString *subStirng = @"";
    for (NSInteger i=1; i<[str_text length]; i++) {
        NSString *item_str = [str_text substringToIndex:i];
        if ([self lenghtWithString:item_str] > length) {
            break;
        }
        subStirng = item_str;
    }
    return subStirng;
}

#pragma mark HPGrowingTextViewDelegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    _tempView = self.btnDetailAddr;
    return true;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //计算文本框根据字符串得到的高度差
    float diff = (height - growingTextView.height);
    [self.detailAddressUnderLine setOrigin:CGPointMake(self.detailAddressUnderLine.left, MAX(self.detailAddressUnderLine.top+diff, 44.0f - 0.5f))];
    [self.btnLabelItems setOrigin:CGPointMake(self.btnLabelItems.left, MAX(self.btnLabelItems.top+diff, 176.0f))];
    [self.btnDetailAddr setSize:CGSizeMake(self.btnDetailAddr.width, MAX(44.0f, self.btnDetailAddr.height + diff))];
    
    if (_isshowed) {
        CGFloat offset_Y = MAX(self.backScroll.contentOffset.y+diff, 0);
        [self.backScroll setContentOffset:CGPointMake(self.backScroll.contentOffset.x, offset_Y)];
        [self.backScroll setContentSize:CGSizeMake(self.backScroll.width, self.backScroll.height+offset_Y)];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [growingTextView resignFirstResponder];
        return false;
    }
    NSString *str_text = [growingTextView.text stringByReplacingCharactersInRange:range withString:text];
    if ([self lenghtWithString:str_text] > 120) {
        growingTextView.text = [self subToStirng:str_text length:120];
        return false;
    }
    return true;
}

#pragma mark - DDLabelListsDelegate
- (void)ddLabelLists:(DDLabelLists *)labelList index:(NSInteger)buttonIndex withSelect:(BOOL)isSelect
{
    if (isSelect) {
        if ([self.arrayLabels count] > buttonIndex) {
            [self.textAddressLabel setText:@""];
            [self.textAddressLabel resignFirstResponder];
            self.addressDetail.sign = [self.arrayLabels objectAtIndex:buttonIndex];
        }
    } else {
        self.addressDetail.sign = @"";
    }
}

#pragma mark - 对象方法:监听键盘
- (void)keyBoardWillShow:(NSNotification *)note
{
    _isshowed = true;
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    CGFloat offset_Y = MAX(_tempView.bottom+kMargin+ty - self.backScroll.height, 0);
   
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.backScroll setContentOffset:CGPointMake(self.backScroll.contentOffset.x, offset_Y)];
    } completion:^(BOOL finish) {
        [self.backScroll setContentSize:CGSizeMake(self.backScroll.width, self.backScroll.height+offset_Y)];
    }];
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    _isshowed = false;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.backScroll setContentOffset:CGPointMake(self.backScroll.contentOffset.x, 0)];
    } completion:^(BOOL finish) {
        [self.backScroll setContentSize:CGSizeMake(self.backScroll.width, self.backScroll.height)];
    }];
}


#pragma mark - Setter && Getter
- (UIScrollView *)backScroll
{
    if (!_backScroll) {
        _backScroll = [[UIScrollView alloc] init];
        [_backScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
        [_backScroll setBackgroundColor:KBackground_COLOR];
        [_backScroll setShowsHorizontalScrollIndicator:false];
        [_backScroll setShowsVerticalScrollIndicator:false];
        [_backScroll setScrollEnabled:NO];
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWithTapGesture)];
        [_backScroll addGestureRecognizer:tapGr];
    }
    return _backScroll;
}

/** 因懒加载不好控制rect，所以只能抽取方法 */
- (void)createAddressDetailTextFieldWithFrame:(CGRect)rect
{
    if (self.detailAddressTextField) {
        return;
    }
    self.detailAddressTextField = [[HPGrowingTextView alloc] initWithFrame:rect];
    self.detailAddressTextField.backgroundColor = [UIColor clearColor];
    self.detailAddressTextField.minNumberOfLines = 1;
    self.detailAddressTextField.maxNumberOfLines = 5;
    self.detailAddressTextField.isScrollable = NO;
    self.detailAddressTextField.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.detailAddressTextField.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.detailAddressTextField.placeholderColor = KPlaceholderColor;
    self.detailAddressTextField.font = kTitleFont;
    self.detailAddressTextField.textColor = TITLE_COLOR;
    self.detailAddressTextField.delegate = self;
    self.detailAddressTextField.keyboardType = UIKeyboardTypeDefault;
    self.detailAddressTextField.returnKeyType = UIReturnKeyDefault;
    self.detailAddressTextField.enablesReturnKeyAutomatically = YES;
}

- (DDAddressDetail *)addressDetail
{
    if (!_addressDetail) {
        _addressDetail = [[DDAddressDetail alloc]init];
    }
    return _addressDetail;
}

- (DDLabelLists *)labelItems
{
    if (!_labelItems) {
        _labelItems = [[DDLabelLists alloc] initWithFrame:CGRectZero];
        [_labelItems setBackgroundColor:[UIColor clearColor]];
        [_labelItems setLabelBackgroundColor:[UIColor clearColor]];
        [_labelItems setLabelBorderColor:false];
        [_labelItems setDelegate:self];
    }
    return _labelItems;
}

- (UITextField *)textAddressLabel
{
    if (!_textAddressLabel) {
        _textAddressLabel = [[UITextField alloc] init];
        [_textAddressLabel setBackgroundColor:[UIColor clearColor]];
        [_textAddressLabel setTextAlignment:NSTextAlignmentLeft];
        [_textAddressLabel setTextColor:TITLE_COLOR];
        [_textAddressLabel setFont:kTitleFont];
        [_textAddressLabel setDelegate:self];
        [_textAddressLabel setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_textAddressLabel setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_textAddressLabel setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _textAddressLabel;
}

- (NSArray *)arrayLabels
{
    if (!_arrayLabels) {
        _arrayLabels = [NSArray arrayWithObjects:@"学校",@"公司",@"家", nil];
    }
    return _arrayLabels;
}



- (UIButton *)selfAddressListButton
{
    if (_selfAddressListButton == nil) {
        UIButton *addressListButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.width - 145)/2, self.view.height - 50, 145, 30)];
        [addressListButton setBackgroundColor:DDRGBColor(32, 198, 122)];
        [addressListButton setTitle:@"常用寄件地址" forState:UIControlStateNormal];
        [addressListButton setTitleColor:DDRGBColor(255, 255, 255) forState:UIControlStateNormal];
        addressListButton.titleLabel.font = [UIFont systemFontOfSize:16];
        addressListButton.layer.cornerRadius = addressListButton.height/2;
        addressListButton.layer.masksToBounds = YES;
        [addressListButton addTarget:self action:@selector(onClickSelfAddressListButton) forControlEvents:UIControlEventTouchUpInside];
        _selfAddressListButton = addressListButton;
    }
    return _selfAddressListButton;
}


#pragma mark - Network Request
- (void)changeAddressRequest
{
    //传参数字典(对应模型DDAddressDetail)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //地址ID
    [param setObject:self.addressDetail.addressID ?: @"" forKey:@"addrId"];
    
    //地址经度
    [param setObject:@(self.addressDetail.longitude) forKey:@"addrLon"];
    
    //地址纬度
    [param setObject:@(self.addressDetail.latitude) forKey:@"addrLat"];
    
    //主地址
    [param setObject:self.addressDetail.contentAddress ?: @"" forKey:@"main"];
    
    //详细地址
    [param setObject:self.addressDetail.supplementAddress ?: @"" forKey:@"detail"];
    
    //标签信息
    [param setObject:self.addressDetail.sign ?: @"" forKey:@"tag"];
    
    //名字
    [param setObject:self.addressDetail.nick ?: @"" forKey:@"name"];
    
    //手机号
    [param setObject:self.addressDetail.phone ?: @"" forKey:@"phone"];
    
    //省ID
    [param setObject:self.addressDetail.provinceId? : @"" forKey:@"provId"];
    
    //市id
    [param setObject:self.addressDetail.cityId? : @"" forKey:@"townId"];
    
    //区id
    [param setObject:@"" forKey:@"areaId"];
    
    //信息类型(1寄件 2 收件)
    [param setObject:@1 forKey:@"type"];
    
    if (!self.interfaceEdit) {
        self.interfaceEdit = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceEdit interfaceWithType:INTERFACE_TYPE_MODIFY_ADDRESS param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceEdit)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }else {
            [DDLocalUserInfoUtils updateUserNickName:self.addressDetail.nick];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (CGFloat)getMetersWithCourierLocation:(CLLocationCoordinate2D)coordinate2D
{
    BMKMapPoint courierPoint = BMKMapPointForCoordinate(coordinate2D);
    BMKMapPoint clientMapPoint = BMKMapPointForCoordinate([DDCenterCoordinate getUserLocationCoordinate]);
    CGFloat betweenMeters = BMKMetersBetweenMapPoints(clientMapPoint, courierPoint);
    
    return betweenMeters;
}

@end
