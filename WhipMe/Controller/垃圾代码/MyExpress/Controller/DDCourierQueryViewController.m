//
//  CourierQueryViewController.m
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

/**
    快递查询视图
 */

/** 多个UITextField对应的tag值基数 */
#define KCourierQueryText 7777

#import "DDCourierQueryViewController.h"
#import "DDChooseCompanyViewController.h"
#import "DDThirdParcelViewController.h"
#import "DDZbarViewController.h"
#import "DDCQDetailViewController.h"

#import "DDCompanyModel.h"
#import "DDMyExpress.h"
#import "YYModel.h"
#import "DDGlobalVariables.h"
#import "CustomStringUtils.h"
#import "DDAlertView.h"

@interface DDCourierQueryViewController () <UITextFieldDelegate, DDChooseCompanyViewDelegate, DDZbarViewDelegate, DDInterfaceDelegate>
{
    BOOL _isQuerying;
    BOOL _toDetailControl;
}
@property (nonatomic, strong) UITextField *textNumbers;         /** 快递单号书写框 */
@property (nonatomic, strong) UITextField *textCourier;         /** 快递公司书写框 */
@property (nonatomic, strong) UIButton *btnSubmit;              /** 查询按钮 */

@property (nonatomic, strong) DDInterface *interfaceQuery;      /** 快递查询 */
@property (nonatomic, strong) DDInterface *interfaceMay;        /** 查询可能存在的快递公司 */
@property (nonatomic, strong) DDInterface *interfaceCompany;    /** 查询所有的快递公司 */
@property (nonatomic, strong) DDCompanyModel *companyModel;     /** 选择的快递公司 */

@end

@implementation DDCourierQueryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"快递查询" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self adaptFirstRightItemWithTitle:@"列表"];
    
    [self ddCreateForTextField];
    
    [self getCompany];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:false];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_toDetailControl) {
        _toDetailControl = false;
        [self.textCourier setText:@""];
        [self.textNumbers setText:@""];
    }
}

#pragma mark - 类的对象方法:初始化页面
/** 创建"请输入快递单号"和"请选择快递公司"的输入框视图 */
- (void)ddCreateForTextField
{
    //循环创建UITextField，根据下标判断“快递单号”和“快递公司”
    NSArray *arrayTitles = [NSArray arrayWithObjects:@"请输入快递单号",@"请选择快递公司", nil];
    for (int i=0; i<arrayTitles.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(0, kMargin*2.0f + i*44.0f + KNavHeight, self.view.width, 44.0f)];
        [itemButton setBackgroundColor:[UIColor whiteColor]];
        [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [self.view addSubview:itemButton];
        
        //初始化输入框
        UITextField *textItem = [[UITextField alloc] init];
        [textItem setFrame:CGRectMake(15.0f, 0, itemButton.width - 30.0f, itemButton.height)];
        [textItem setBackgroundColor:[UIColor clearColor]];
        [textItem setTextAlignment:NSTextAlignmentLeft];
        [textItem setTextColor:TITLE_COLOR];
        [textItem setFont:kTitleFont];
        [textItem setDelegate:self];
        [textItem setTag:KCourierQueryText + i];
        [textItem setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textItem setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textItem setPlaceholder:arrayTitles[i]];
        [textItem setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        [itemButton addSubview:textItem];
        
        //分界线
        UIView *lineView = [[UIView alloc] init];
        [lineView setFrame:CGRectMake(textItem.left, textItem.bottom - 1.0f, self.view.width - textItem.left, 0.5f)];
        [lineView setBackgroundColor:BORDER_COLOR];
        [itemButton addSubview:lineView];
        
        //输入框左边的图标icon
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setFrame:CGRectMake(0, 0, textItem.height, textItem.height)];
        [leftView setBackgroundColor:[UIColor clearColor]];
        [textItem setLeftView:leftView];
        [textItem setLeftViewMode:UITextFieldViewModeAlways];
        
        UIImageView *imgIcon = [[UIImageView alloc] init];
        [imgIcon setSize:CGSizeMake(19.0f, 19.0f)];
        [imgIcon setCenter:CGPointMake(leftView.centerx, leftView.centery)];
        [imgIcon setBackgroundColor:[UIColor clearColor]];
        [imgIcon setImage:[UIImage imageNamed:i==0?DDCouricerQuery_NumberIcon:DDCouricerQuery_CouricerIcon]];
        [leftView addSubview:imgIcon];
        
        //输入框右边的按钮选择事件，对应：条形码扫描和快递公司列表选择
        UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightView setFrame:CGRectMake(0, 0, textItem.height, textItem.height)];
        [rightView setBackgroundColor:[UIColor clearColor]];
        [rightView setAdjustsImageWhenHighlighted:false];
        [rightView setTag:KCourierQueryText + 10 + i];
        [textItem setRightView:rightView];
        [textItem setRightViewMode:UITextFieldViewModeAlways];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        [imgView setSize:i==0?CGSizeMake(26.0, 26.0f):CGSizeMake(13.0f, 13.0f)];
        [imgView setCenter:CGPointMake(rightView.centerx, rightView.centery)];
        [imgView setBackgroundColor:[UIColor clearColor]];
        [imgView setImage:[UIImage imageNamed:i==0?DDCouricerQuery_CodeGreen:DDArrowRight_Gray]];
        [rightView addSubview:imgView];
        
        if (i == 0) {
            [textItem setKeyboardType:UIKeyboardTypeNumberPad];
            [rightView addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
            self.textNumbers = textItem;
        } else {
            [textItem setUserInteractionEnabled:false];
            [itemButton addTarget:self action:@selector(clickWithCompany) forControlEvents:UIControlEventTouchUpInside];
            
            self.textCourier = textItem;
        }
    }
    
    [self ddCreateForButton];
}

/** 创建开始查询按钮 */
- (void)ddCreateForButton
{
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake( 15.0f, 202.f, self.view.width - 30.0f, 36.0f)];
    [btnSubmit setBackgroundColor:KPlaceholderColor];
    [btnSubmit setUserInteractionEnabled:false];
    [btnSubmit.layer setCornerRadius:btnSubmit.height/2.0f];
    [btnSubmit.layer setMasksToBounds:true];
    [btnSubmit.titleLabel setFont:kContentFont];
    [btnSubmit setTitle:@"开始查询" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit setAdjustsImageWhenHighlighted:false];
    [btnSubmit addTarget:self action:@selector(onClickWithSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    self.btnSubmit = btnSubmit;
}

#pragma mark - Action
/** 开始查询按钮的事件，查询成功好进入： 快递的查询结果视图，失败提示消息。 */
- (void)onClickWithSubmit
{
    if ([self clickWithSubmitButton]) {
        [self.btnSubmit setUserInteractionEnabled:false];
        [self queryLogisticWithRequest];
    }
}

/** 条形码扫描 */
- (void)onClickWithItem:(id)sender
{
    DDZbarViewController *controller = [[DDZbarViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:controller animated:true];
}

/** 快递公司列表 */
- (void)clickWithCompany
{
    DDChooseCompanyViewController *controller = [[DDChooseCompanyViewController alloc] initWithDelegate:self];
    [self.navigationController pushViewController:controller animated:true];
}

/** 判断数据是否完整，打开提交按钮 */
- (BOOL)clickWithSubmitButton
{
    if ([self.textNumbers.text length] > 8 && [[self.companyModel companyID] length] > 0) {
        [self.btnSubmit setBackgroundColor:DDGreen_Color];
        [self.btnSubmit setUserInteractionEnabled:true];
        return true;
    } else {
        [self.btnSubmit setBackgroundColor:KPlaceholderColor];
        [self.btnSubmit setUserInteractionEnabled:false];
        return false;
    }
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickFirstRightItem
{
    DDThirdParcelViewController *thirdParcelControl = [[DDThirdParcelViewController alloc] init];
    [self.navigationController pushViewController:thirdParcelControl animated:true];
}

#pragma mark - DDChooseCompanyViewDelegate
- (void)chooseCompanyViewWithCompany:(DDCompanyModel *)model
{
    if ([CustomStringUtils isBlankString:model.companyID] || [CustomStringUtils isBlankString:model.companyName]) {
        return;
    }
    self.companyModel = model;
    
    [self.textCourier setText:self.companyModel.companyName ?: @""];
    [self clickWithSubmitButton];
}

#pragma mark - DDZbarViewDelegate
- (void)zbarViewWithMachineReadableCodeObject:(NSString *)zbarData
{
    if ([CustomStringUtils isBlankString:zbarData] && ![self isValidateNumber:zbarData]) {
        return;
    }
    [self queryCompanyWithRequest:zbarData];
    
    [self.textNumbers setText:zbarData ?: @""];
    [self clickWithSubmitButton];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text_str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.textNumbers) {
        if([text_str length] > 24) {
            textField.text = [text_str substringToIndex:24];
            return false;
        }
    }
    [self clickWithSubmitButton];
    return true;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //如果单号输入框失去焦点，将访问所属快递公司的查询
    if (textField == self.textNumbers) {
        [self queryCompanyWithRequest:textField.text];
    }
    [self clickWithSubmitButton];
    return true;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:false];
}

- (DDCompanyModel *)companyModel
{
    if (!_companyModel) {
        _companyModel = [[DDCompanyModel alloc] init];
        _companyModel.companyID = @"";
    }
    return _companyModel;
}

/** 查询快递 */
- (void)queryLogisticWithRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[self.companyModel companyID] forKey:@"corId"];
    [param setValue:[self.textNumbers text] forKey:@"odd"];
    
    if (!self.interfaceQuery) {
        self.interfaceQuery = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceQuery interfaceWithType:INTERFACE_TYPE_LOGISTICS param:param];
}

/** 查询可能存在的快递公司 */
- (void)queryCompanyWithRequest:(NSString *)str_odd
{
    if (_isQuerying || [CustomStringUtils isBlankString:str_odd]) {
        return;
    }
    _isQuerying = true;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:str_odd forKey:@"odd"];
    
    if (!self.interfaceMay) {
        self.interfaceMay = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceMay interfaceWithType:INTERFACE_TYPE_MAY_COMPANY param:param];
}

/** 获取附件快递公司列表 */
- (void)getCompany
{
    if ([[DDGlobalVariables sharedInstance].arrayCourierCompany count] > 0) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (!self.interfaceCompany) {
        self.interfaceCompany = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceCompany interfaceWithType:INTERFACE_TYPE_TOTAL_COMPANY param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceQuery) {
        [self.btnSubmit setUserInteractionEnabled:true];
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            if (!result) {
                [self displayForErrorMsg:@"查无结果，请确定单号或快递公司是否正确！"];
                return;
            }
            
            DDMyExpress *model = [[DDMyExpress alloc] init];
            [model setDetailExpressResult:result];
            /** 快递公司icon更近id拼出url */
            model.companyId     = [self.companyModel companyID];
            model.companyName   = [self.companyModel companyName];
            model.companyLogo   = [self.companyModel companyLogo];
            model.expressNumber = [self.textNumbers text];
            
            model.companyPhone  = result[@"htel"] ?: @"";
            model.expressDate   = result[@"date"] ?: @"";
            model.expressStatus = result[@"status"] ? [result[@"status"] integerValue] : -1;
            
            if ([model.processList count] == 0) {
                [self displayForErrorMsg:@"抱歉，无法查询到该快递物流信息"];
                return;
            }
            _toDetailControl = true;
            DDCQDetailViewController *detailControl = [[DDCQDetailViewController alloc] initWithModel:model withStyle:DDCQDetailViewStyleQuery];
            [self.navigationController pushViewController:detailControl animated:true];
        }
    } else if (interface == self.interfaceMay) {
        _isQuerying = false;
        if (!error) {
            DDCompanyModel *company = [[DDCompanyModel alloc] init];
            [company setCompanyID:[CustomStringUtils isBlankString:result[@"corId"]] ? @"" : result[@"corId"]];
            [company setCompanyName:[CustomStringUtils isBlankString:result[@"name"]] ? @"" : result[@"name"]];
            self.companyModel = company;
            
            [self.textCourier setText:self.companyModel.companyName ?: @""];
            [self clickWithSubmitButton];
            
            if (![CustomStringUtils isBlankString:self.companyModel.companyName]) {
                [self onClickWithSubmit];
            }
        }
    } else if (interface == self.interfaceCompany) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            NSMutableArray *arrayContent = [NSMutableArray array];
            for (NSDictionary *dict in result[@"corList"]) {
                DDCompanyModel *company = [DDCompanyModel yy_modelWithDictionary:dict];
                company.companyLogo         = [DDInterfaceTool logoWithCompanyId:[CustomStringUtils isBlankString:company.companyID] ? @"" : company.companyID];
                company.companySelect       = false;
                company.companyModelType    = DDCompanyModelAll;
                [arrayContent addObject:company];
            }
            [[DDGlobalVariables sharedInstance] setArrayCourierCompany:[arrayContent mutableCopy]];
        }
    }
}

@end
