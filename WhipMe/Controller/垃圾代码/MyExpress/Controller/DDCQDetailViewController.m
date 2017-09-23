//
//  CQDetailViewController.m
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

/**
    快递的查询结果视图
 */

#import "DDCQDetailViewController.h"
#import "DDLogisticsViewCell.h"
#import "DDTextAlertView.h"
#import "DDMyExpress.h"
#import "CustomStringUtils.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "YYModel.h"

@interface DDCQDetailViewController () <
DDTextAlertViewDelegate,
DDInterfaceDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    /** TableView高度 */
    CGFloat _tableHeight;
    //备注的图片
    NSAttributedString *_remarksIcon;
}
//本视图的整体滚动视图
@property (nonatomic, strong) UIScrollView *detailScroll;
/** 快递的图片 */
@property (nonatomic, strong) UIImageView *imageIcon;
/** 快递的标题 */
@property (nonatomic, strong) UIButton *btnTitle;
/** 快递单号 */
@property (nonatomic, strong) UILabel *lblNumber;
/** 物流电话 */
@property (nonatomic, strong) UILabel *lblCall;
/** 快递的签收状态 */
@property (nonatomic, strong) UILabel *lblState;
/** 备注 */
@property (nonatomic, strong) NSString *strRemarks;
/** 物流信息列表 */
@property (nonatomic, strong) UITableView *logisticTableView;
/** 物流信息数组 */
@property (nonatomic, strong) NSMutableArray *arrayLogistics;
/** 枚举，用于判断是入口（快递查询／快递列表），快递查询是不可修改备注 */
@property (nonatomic, assign) DDCQDetailViewStyle detailViewStyle;
/** 包裹详情 */
@property (nonatomic, strong) DDInterface *interfaceDetail;
/** 修改备注 */
@property (nonatomic, strong) DDInterface *interfaceComment;
/** 快递信息 */
@property (nonatomic, strong) DDMyExpress *modelExpress;

@end

@implementation DDCQDetailViewController
@synthesize detailScroll;
@synthesize imageIcon;
@synthesize lblCall, btnTitle, lblNumber, lblState;
@synthesize logisticTableView;
@synthesize arrayLogistics;

#pragma mark - 初始化

- (instancetype)initWithModel:(DDMyExpress *)model withStyle:(DDCQDetailViewStyle)style
{
    self = [super init];
    if (self) {
        self.modelExpress = model;
        self.detailViewStyle = style;
    }
    return self;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"快递信息详情" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self ddCreateForScrollView];
    
    if (self.detailViewStyle == DDCQDetailViewStyleList) {
        [self myParcelsWithRequest];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadWithViewLoad];
}

/** 刷新视图  */
- (void)reloadWithViewLoad
{
    NSString *img_url = [CustomStringUtils isBlankString:self.modelExpress.companyLogo] ? @"" : self.modelExpress.companyLogo;
    [imageIcon sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:KClientIcon48]];
    
    //主标题
    NSString *title_str = @"";
    if ([self.modelExpress.expressComment length] > 0) {
        title_str = [self.modelExpress.expressComment stringByAppendingString:@"  "];
    } else {
        title_str = [NSString stringWithFormat:@"%@的包裹  ",self.modelExpress.companyName];
    }
    
    [btnTitle setUserInteractionEnabled:false];
    NSDictionary *attribute_Title = @{NSFontAttributeName:kTitleFont, NSForegroundColorAttributeName:TITLE_COLOR};
    NSMutableAttributedString *attArrow = [[NSMutableAttributedString alloc] initWithString:title_str attributes:attribute_Title];
    [btnTitle setAttributedTitle:attArrow forState:UIControlStateNormal];
    
    CGSize size_title = [attArrow.string sizeWithAttributes:@{NSFontAttributeName:btnTitle.titleLabel.font}];
    [btnTitle setSize:CGSizeMake(MAX(50.0f, floorf(size_title.width)+14.0f), btnTitle.height)];

    /** 客服热线 */
    NSTextAttachment *item_call = [[NSTextAttachment alloc] init];
    [item_call setImage:[UIImage imageNamed:DDCallArrow]];
    [item_call setBounds:CGRectMake(0, 1, 7.0f, 7.0f)];
    NSAttributedString *icon_call = [NSAttributedString attributedStringWithAttachment:item_call];
    
    NSString *str_call = [NSString stringWithFormat:@"客服热线：%@  ",self.modelExpress.companyPhone];
    NSDictionary *attribute = @{NSFontAttributeName:kTimeFont, NSForegroundColorAttributeName:TIME_COLOR};
    NSMutableAttributedString *att_str_call = [[NSMutableAttributedString alloc] initWithString:str_call attributes:attribute];
    [att_str_call insertAttributedString:icon_call atIndex:[str_call length]];
    [lblCall setAttributedText:att_str_call];
    
    //快递单号
    [lblNumber setText:[NSString stringWithFormat:@"%@：%@",self.modelExpress.companyName, self.modelExpress.expressNumber]];
    
    //快递状态
    [lblState setText:[DDMyExpress expressForStatu:self.modelExpress.expressStatus]];
    [lblState setHidden:self.modelExpress.expressStatus == -1 ? YES : NO];
    
    if ([lblState.text isEqualToString:@"已签收"]) {
        [lblState setTextColor:TIME_COLOR];
        [lblState.layer setBorderColor:TIME_COLOR.CGColor];
    } else {
        [lblState setTextColor:DDGreen_Color];
        [lblState.layer setBorderColor:DDGreen_Color.CGColor];
    }
    
    CGSize size_state = [lblState.text sizeWithAttributes:@{NSFontAttributeName:lblState.font}];
    [lblState setSize:CGSizeMake(floorf(size_state.width) + 14.0f, lblState.height)];
    [lblState setOrigin:CGPointMake(detailScroll.width - lblState.width - 15.0f, lblState.top)];
    
    arrayLogistics = [self.modelExpress.processList mutableCopy];
    if (arrayLogistics.count > 0) {
        _tableHeight = 30.0f;
        [logisticTableView setHidden:false];
        [logisticTableView reloadData];
        [logisticTableView setSize:CGSizeMake(logisticTableView.width, _tableHeight)];
    } else {
        _tableHeight = 30.0f;
        arrayLogistics = [[NSMutableArray alloc] initWithCapacity:0];
        [logisticTableView reloadData];
        [logisticTableView setHidden:true];
    }
    [detailScroll setContentSize:CGSizeMake(detailScroll.width, MAX(logisticTableView.top + _tableHeight, detailScroll.height))];
}

#pragma mark - 类的对象方法:初始化页面
/** 初始化界面的控件 创建本界面的整体滚动视图，作为所有显示空间的父视图 */
- (void)ddCreateForScrollView
{
    detailScroll = [[UIScrollView alloc] init];
    [detailScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, MainScreenHeight - KNavHeight)];
    [detailScroll setBackgroundColor:[UIColor whiteColor]];
    [detailScroll setShowsHorizontalScrollIndicator:false];
    [detailScroll setShowsVerticalScrollIndicator:false];
//    [detailScroll setBounces:false];
    [self.view addSubview:detailScroll];
    
    [self ddCreateForViewTop];
    
    [self ddCreateForTableView];
}

/** 添加内容，包含Icon，标题，物流订单号等 */
- (void)ddCreateForViewTop
{
    /** 快递的图片 */
    imageIcon = [[UIImageView alloc] init];
    [imageIcon setFrame:CGRectMake(15.0f, 15.0f, 24.0f, 24.0f)];
    [imageIcon setBackgroundColor:HIGHLIGHT_COLOR];
    [imageIcon.layer setCornerRadius:imageIcon.height/2.0f];
    [imageIcon.layer setMasksToBounds:true];
    [detailScroll addSubview:imageIcon];
    
    /** 标题 */
    btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTitle setFrame:CGRectMake(imageIcon.right + kMargin, imageIcon.top + 3.0f, detailScroll.width - imageIcon.right*2.0f - kMargin*2.0f, 16.0f)];
    [btnTitle setBackgroundColor:[UIColor clearColor]];
    [btnTitle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnTitle.titleLabel setFont:kContentFont];
    [btnTitle setAdjustsImageWhenHighlighted:false];
    [btnTitle addTarget:self action:@selector(onClickWithRemarks:) forControlEvents:UIControlEventTouchUpInside];
    [detailScroll addSubview:btnTitle];
    
    /** 类别 */
    lblState = [[UILabel alloc] init];
    [lblState setFrame:CGRectMake(btnTitle.right, btnTitle.top, 44.0f, 14.0f)];
    [lblState setBackgroundColor:[UIColor clearColor]];
    [lblState.layer setCornerRadius:lblState.height/2.0f];
    [lblState.layer setMasksToBounds:true];
    [lblState.layer setBorderWidth:0.5f];
    [lblState.layer setBorderColor:TIME_COLOR.CGColor];
    [lblState setTextAlignment:NSTextAlignmentCenter];
    [lblState setTextColor:TIME_COLOR];
    [lblState setFont:KCountFont];
    [lblState setHidden:true];
    [detailScroll addSubview:lblState];
    
    /** 快递单号 */
    lblNumber = [[UILabel alloc] init];
    [lblNumber setFrame:CGRectMake(btnTitle.left, btnTitle.bottom + 10.0f, detailScroll.width - imageIcon.right - 25.0f, 14.0f)];
    [lblNumber setBackgroundColor:[UIColor clearColor]];
    [lblNumber setTextAlignment:NSTextAlignmentLeft];
    [lblNumber setTextColor:TIME_COLOR];
    [lblNumber setFont:kTitleFont];
    [detailScroll addSubview:lblNumber];
    
    /** 物流电话 */
    lblCall = [[UILabel alloc] init];
    [lblCall setFrame:CGRectMake(lblNumber.left, lblNumber.bottom + 7.0f, lblNumber.width, lblNumber.height)];
    [lblCall setBackgroundColor:[UIColor clearColor]];
    [lblCall setTextAlignment:NSTextAlignmentLeft];
    [lblCall setTextColor:TIME_COLOR];
    [lblCall setFont:kTitleFont];
    [lblCall setUserInteractionEnabled:true];
    [detailScroll addSubview:lblCall];
    
    UITapGestureRecognizer *tapCall = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickWithCall)];
    [lblCall addGestureRecognizer:tapCall];
}

/** 创建物流信息流程列表 */
- (void)ddCreateForTableView
{
    /** 物流信息列表 */
    logisticTableView = [[UITableView alloc] init];
    [logisticTableView setFrame:CGRectMake(0, lblCall.bottom + 15.0f, detailScroll.width, detailScroll.height - lblCall.bottom - 15.0f)];
    [logisticTableView setBackgroundColor:[UIColor whiteColor]];
    [logisticTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [logisticTableView setDelegate:self];
    [logisticTableView setDataSource:self];
    [logisticTableView setBounces:false];
    [detailScroll addSubview:logisticTableView];
    
    //物流信息的标题
    UIButton *logisticTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [logisticTitle setFrame:CGRectMake(0, 0, detailScroll.width, 30.0f)];
    [logisticTitle setBackgroundColor:KBackground_COLOR];
    [logisticTitle setUserInteractionEnabled:false];
    [logisticTitle.titleLabel setFont:kTimeFont];
    [logisticTitle setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
    [logisticTitle setTitle:@"物流信息" forState:UIControlStateNormal];
    [logisticTableView setTableHeaderView:logisticTitle];
    
    [detailScroll setContentSize:CGSizeMake(detailScroll.width, MAX(logisticTableView.bottom, detailScroll.height))];
}

#pragma mark - Action
/** 显示备注消息窗 */
- (void)onClickWithRemarks:(id)sender
{
    DDTextAlertView *alertView = [[DDTextAlertView alloc] initWithTitle:@"备注" delegate:self cancelTitle:@"取消" nextTitle:@"确定"];
    [alertView show];
}

- (void)onClickWithCall
{
    UIWebView *callWebView = [[UIWebView alloc] init];
    
    NSString *strTel = [NSString stringWithFormat:@"tel:%@",self.modelExpress.companyPhone];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strTel]]];
    [self.view addSubview:callWebView];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DDTextAlertViewDelegate
- (void)textAlertView:(DDTextAlertView *)textView withText:(NSString *)text withFlag:(BOOL)flag
{
    if (!flag || text.length == 0) {
        return;
    }
    
    self.strRemarks = [NSString stringWithFormat:@"%@  ",text];
    
    [self updateExpressComment:self.strRemarks];
}

#pragma mark - tableView 数据源及代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    _tableHeight = 30.0f;
    return [arrayLogistics count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDLogisticsViewCell *cell = (DDLogisticsViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    CGFloat _cellHeight = [cell LogisticsCellHeight];
    
    _tableHeight += _cellHeight;
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"parcelTableViewCell";
    DDLogisticsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDLogisticsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [cell setCellForLogistics:arrayLogistics[indexPath.row] withIndexPath:indexPath];
    
    [cell.lineRow setHidden:arrayLogistics.count-1 == indexPath.row ? true : false];
    return cell;
}

- (DDMyExpress *)modelExpress
{
    if (!_modelExpress) {
        _modelExpress = [[DDMyExpress alloc] init];
    }
    return _modelExpress;
}

/** 查询快递的物流信息 */
- (void)myParcelsWithRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.modelExpress.companyId forKey:@"corId"];
    [param setValue:self.modelExpress.expressNumber forKey:@"odd"];
    
    if (!self.interfaceDetail) {
        self.interfaceDetail = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceDetail interfaceWithType:INTERFACE_TYPE_LOGISTICS param:param];
}

/** 修改包裹备注 */
- (void)updateExpressComment:(NSString *)comment
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.modelExpress.companyId forKey:@"corId"];
    [param setValue:self.modelExpress.expressNumber forKey:@"expNum"];
    [param setValue:comment forKey:@"comment"];
    
    if (!self.interfaceComment) {
        self.interfaceComment = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceComment interfaceWithType:INTERFACE_TYPE_MODIFY_COMMENT param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceDetail) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            DDMyExpress *model = [DDMyExpress yy_modelWithDictionary:result];
            model.companyLogo = [DDInterfaceTool logoWithCompanyId:model.companyId];
            model.expressStatus = model.expressStatus ?: -1;
            model.expressType   = 0;
            
            self.modelExpress.processList   = model.processList ?: [NSMutableArray array];
            self.modelExpress.companyPhone  = model.htelPhone ?: @"";
            self.modelExpress.expressDate   = model.expressDate ?: @"";
            
            [self reloadWithViewLoad];
        }
    }  else if (interface == self.interfaceComment) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            //创建可编辑字符串
            NSDictionary *attribute = @{NSFontAttributeName:kTitleFont, NSForegroundColorAttributeName:DDGreen_Color};
            NSMutableAttributedString *attArrow = [[NSMutableAttributedString alloc] initWithString:self.strRemarks attributes:attribute];
            [attArrow insertAttributedString:_remarksIcon atIndex:[attArrow.string length]];
            [btnTitle setAttributedTitle:attArrow forState:UIControlStateNormal];
            
            CGSize size_title = [self.strRemarks sizeWithAttributes:@{NSFontAttributeName:btnTitle.titleLabel.font}];
            [btnTitle setSize:CGSizeMake(MAX(50.0f, floorf(size_title.width)+14.0f), btnTitle.height)];
        }
    }
}



@end
