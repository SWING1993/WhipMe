//
//  DDTargetAddressEditView.m
//  DDExpressClient
//
//  Created by SongGang on 2/25/16.
//  Copyright © 2016 NS. All rights reserved.
//
#define KAddressEdit_Txt 7777

#import "DDTargetAddressEditView.h"
#import "Constant.h"
#import "DDAddressDetail.h"
#import "CustomStringUtils.h"

@interface DDTargetAddressEditView() <UITextFieldDelegate>

/** 名字 */
@property (nonatomic, strong) UITextField *textUserName;
/** 联系方式 */
@property (nonatomic, strong) UITextField *textUserPhone;
/** 第一个地址 */
@property (nonatomic, strong) UITextField *textFirstAddr;

@end

@implementation DDTargetAddressEditView
@synthesize addressDetail = _addressDetail;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


/** 初始化界面 */
- (void)setup
{
    NSArray  *arrayLabelTitle = [NSArray arrayWithObjects:@"收件人",@"手机号码",@"所在区域",@"详细地址", nil];
    NSString *item_str = [arrayLabelTitle objectAtIndex:1];
    CGSize   size_item = [item_str sizeWithAttributes:@{NSFontAttributeName:kTitleFont}];
    CGFloat  origin_x = floorf(size_item.width+1) + 40.0f;
    
    for (int i=0; i<arrayLabelTitle.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(0, i*44.0f, DDSCreenBounds.size.width, 44.0f)];
        [itemButton setBackgroundColor:[UIColor whiteColor]];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake((itemButton.height - floorf(size_item.height+1))/2.0f, 15.0f, 0, 0)];
        [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton setTitle:arrayLabelTitle[i] forState:UIControlStateNormal];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton addTarget:self action:@selector(clickWithTapGr) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:itemButton];
        
        if (i < arrayLabelTitle.count - 1) {
            UIView *lineView = [[UIView alloc] init];
            [lineView setFrame:CGRectMake(15.0f, itemButton.height - 0.5f, itemButton.width - 15.0f, 0.5f)];
            [lineView setBackgroundColor:BORDER_COLOR];
            [itemButton addSubview:lineView];
        }
        
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
            if (i == 0) {
                [textItem setPlaceholder:@"请输入收件人姓名"];
                self.textUserName = textItem;
                
                //输入框右边的按钮选择事件
                UIButton *rightButon = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightButon setFrame:CGRectMake(0, 0, textItem.height, textItem.height)];
                [rightButon setBackgroundColor:[UIColor clearColor]];
                [rightButon setAdjustsImageWhenHighlighted:false];
                [rightButon setImage:[UIImage imageNamed:@"addressbook"] forState:UIControlStateNormal];
                [rightButon addTarget:self action:@selector(addcontacts) forControlEvents:UIControlEventTouchUpInside];
                [textItem setRightView:rightButon];
                [textItem setRightViewMode:UITextFieldViewModeAlways];
            } else if (i == 1) {
                [textItem setPlaceholder:@"请输入电话"];
                [textItem setKeyboardType:UIKeyboardTypeNumberPad];
                self.textUserPhone = textItem;
            } else {
                [textItem setPlaceholder:@"请选择地址"];
                [textItem setUserInteractionEnabled:false];
                self.textFirstAddr = textItem;
                [itemButton addTarget:self action:@selector(popAreaView) forControlEvents:UIControlEventTouchUpInside];
                
                //输入框右边的按钮选择事件
                UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
                [rightView setFrame:CGRectMake(0, 0, textItem.height, textItem.height)];
                [rightView setBackgroundColor:[UIColor clearColor]];
                [rightView setAdjustsImageWhenHighlighted:false];
                [rightView setImage:[UIImage imageNamed:DDArrowRight_Gray] forState:UIControlStateNormal];
                [textItem setRightView:rightView];
                [textItem setRightViewMode:UITextFieldViewModeAlways];
            }
        } else if (i == 3) {
            [self createWithTextDetailAddr:CGRectMake(origin_x - 10.0f, 5.0f, itemButton.width - origin_x, itemButton.height)];
            [self.textSecondAddr setPlaceholder:@"请详细到门牌号"];
//            [self.textSecondAddr setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
            [self.textSecondAddr setTextColor:TITLE_COLOR];
            [self.textSecondAddr setFont:kTitleFont];
            [itemButton addSubview:self.textSecondAddr];
            self.btnSecondAddr = itemButton;
        }
    }
}

/** 因懒加载不好控制rect，所以只能抽取方法 */
- (void)createWithTextDetailAddr:(CGRect)rect
{
    if (self.textSecondAddr) {
        return;
    }
    self.textSecondAddr = [[HPGrowingTextView alloc] initWithFrame:rect];
    self.textSecondAddr.backgroundColor = [UIColor clearColor];
    self.textSecondAddr.minNumberOfLines = 1;
    self.textSecondAddr.maxNumberOfLines = 5;
    self.textSecondAddr.isScrollable = NO;
    self.textSecondAddr.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textSecondAddr.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textSecondAddr.placeholderColor = KPlaceholderColor;
    self.textSecondAddr.font = kTitleFont;
    self.textSecondAddr.textColor = TITLE_COLOR;
    self.textSecondAddr.keyboardType = UIKeyboardTypeDefault;
    self.textSecondAddr.returnKeyType = UIReturnKeyDefault;
    self.textSecondAddr.enablesReturnKeyAutomatically = YES;
}

/** addressDetail赋值 */
- (void)setAddressDetail:(DDAddressDetail *)addressDetail
{
    _addressDetail = addressDetail;
    
    if ((addressDetail.provinceName.length > 0 && addressDetail.cityName.length > 0 && addressDetail.districtName.length > 0) || (addressDetail.provinceName.length > 0 && addressDetail.cityName.length > 0)) {
        if (![CustomStringUtils isBlankString:addressDetail.districtName]) {
            self.textFirstAddr.text = [NSString stringWithFormat:@"%@ %@ %@",addressDetail.provinceName,addressDetail.cityName,addressDetail.districtName];
        } else {
            self.textFirstAddr.text = [NSString stringWithFormat:@"%@ %@",addressDetail.provinceName,addressDetail.cityName];
        }

    } else if (addressDetail.addressName > 0) {
        self.textFirstAddr.text = [NSString stringWithFormat:@"%@",addressDetail.addressName];
    } else {
        self.textFirstAddr.text= @"";
    }
    
    if (addressDetail.supplementAddress.length > 0) {
        self.textSecondAddr.text = addressDetail.supplementAddress;
    }
   
    if (addressDetail.nick.length > 0 ) {
        self.textUserName.text = addressDetail.nick;
    }
    
    if (addressDetail.phone.length > 0) {
        self.textUserPhone.text = addressDetail.phone;
    }
}

- (void)clickWithTapGr
{
    [self endEditing:false];
}

/** 获取addressDetail值 */
- (DDAddressDetail *) addressDetail
{
    if (!_addressDetail) {
        _addressDetail = [[DDAddressDetail alloc] init];
    }
    
    _addressDetail.addressName = @"";
    _addressDetail.localDetailAddress = @"";
    
    _addressDetail.supplementAddress = self.textSecondAddr.text;
    
    NSString *str = @"";
    if (![CustomStringUtils isBlankString:_addressDetail.cityName] && ![CustomStringUtils isBlankString:_addressDetail.districtName]) {
        str = [NSString stringWithFormat:@"%@%@%@",_addressDetail.provinceName,_addressDetail.cityName,_addressDetail.districtName];
    } else if (![CustomStringUtils isBlankString:_addressDetail.cityName] && ![CustomStringUtils isBlankString:_addressDetail.provinceName]) {
        str = [NSString stringWithFormat:@"%@%@%@",_addressDetail.provinceName,_addressDetail.provinceName,_addressDetail.cityName];
    }
    
    _addressDetail.contentAddress = str;
    _addressDetail.nick = self.textUserName.text;
    _addressDetail.phone = self.textUserPhone.text;
    return _addressDetail;
}

/** 添加通讯录 */
- (void)addcontacts
{
    [self clickWithTapGr];
    if ([_delegate respondsToSelector:@selector(addToAddressBook)]) {
        [_delegate addToAddressBook];
    }
}

/** 弹出所在区域选择器 */
- (void)popAreaView
{
    [self clickWithTapGr];
    if ([_delegate respondsToSelector:@selector(createDistrictSelectPickerViewWithTitle:)]) {
        [_delegate createDistrictSelectPickerViewWithTitle:@"请选择地址"];
    }
}

#pragma mark - UITextFieldDelegate
/** 限制输入字符长度 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str_text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.textUserName == textField) {
        //截取字符串，10个字符以内
        if ([self lenghtWithString:str_text] > 10) {
            textField.text = [self subToStirng:str_text length:10];
            return false;
        }
    }else if (textField == self.textUserPhone) {
        //截取字符串，11个字符以内
        if ([self lenghtWithString:str_text] > 11) {
            textField.text = [self subToStirng:str_text length:11];
            return false;
        }
    }
    return YES;
}

/** 计算转换后字符的个数*/
- (NSUInteger)lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    
    NSString *pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
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

@end
