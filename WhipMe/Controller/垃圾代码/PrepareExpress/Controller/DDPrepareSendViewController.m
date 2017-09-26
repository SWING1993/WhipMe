//
//  DDPrepareSendViewController.m
//  DuDu Courier
//
//  Created by yangg on 16/4/6.
//  Copyright © 2016年 yangg. All rights reserved.
//
#define DDPrepareSendViewTag 7777

#define KSelfAddress_Text    @"点击添加寄件人信息"  /** 点击添加寄件人信息 */
#define KTargetAddress_Text  @"点击添加收件人信息"  /** 点击添加收件人信息 */
#define KAddressView_Height  68.0f
#define KAddressIcon_HW      31.0f

#define KItemView_Height     75.0f

#import "DDPrepareSendViewController.h"
#import "DDSelfAdressEditController.h"
#import "DDSelfAddressListController.h"
#import "DDTargetAddressEditController.h"
#import "DDTargetAddressListController.h"
#import "DDCourierCompanyViewController.h"
#import "DDBudgetController.h"
#import "DDProvinceList.h"
#import "DDAreaList.h"
#import "DDCityList.h"

#import "DDTipView.h"
#import "DDMessageView.h"
#import "DDTakeTimeView.h"
#import "DDItemTypeView.h"
#import "DDItemWeightView.h"
#import "DDPremiumView.h"

#import "DDSendInfo.h"
#import "DDCompanyModel.h"
#import "DDCourierDetail.h"

#import "DDInterface.h"
#import "DDGlobalVariables.h"
#import "UIImageView+WebCache.h"

#import "CustomStringUtils.h"
#import "DDCostDetailInfo.h"
#import "DDLocalUserInfoUtils.h"

#import "DDCenterCoordinate.h"

@interface DDPrepareSendViewController () <
                                            UIActionSheetDelegate,
                                            UIImagePickerControllerDelegate,
                                            UINavigationControllerDelegate,
                                            DDInterfaceDelegate,
                                            DDTargetAddressEditDelegate,
                                            DDTakeTimeViewDelegate,
                                            DDItemWeightViewDelegate,
                                            DDPremiumViewDelegate,
                                            DDTipViewDelegate,
                                            DDMessageViewDelegate,
                                            DDItemTypeViewDelegate,
                                            DDCourierCompanyViewDelegate,
                                            DDSelfAddressEditDelegate>
{

    /** 用来保存当前动画弹出的窗口*/
    UIView * animationView ;
    /** 黑色透明遮罩 */
    UIButton * animationButton;
    
    NSInteger minMoney;
    
    NSInteger maxMoney;
    
    NSString *showGetExpressTime;
    
    NSString *showGetExpressWeight;
    
    DDCostDetailInfo *currentCostDetailInfo;
    
    UIImageView *expressImageView;
    
    UILabel *addExpressImageLabel;
    
    BOOL _isUploadImage;
    
    NSString *expressTipString;
    
    NSString *needShowSelfAddress;
    
    NSString *currentOrderId;
    
    UIImagePickerController *imagePickerController;
}
@property (strong, nonatomic) NSMutableArray *provinceModelArr;
/** 滚动视图，本界面内容控件的父视图 */
@property (nonatomic, strong) UIScrollView *scrollContent;
/** 寄件人选项Button */
@property (nonatomic, strong) UIButton *btnSelfAddress;
/** 收件人选项Button */
@property (nonatomic, strong) UIButton *btnTargetAddress;
/** 地址描述副标题 */
@property (nonatomic, strong) UILabel *lblSelfAddress;
@property (nonatomic, strong) UILabel *lblTargetAddress;

/** 标题，寄件信息titles(@"快递公司",@"取件时间",@"物品重量",@"物品类型",@"所寄物品") */
@property (nonatomic, strong) NSArray *arrayItemTitels;
/** 快递公司 */
@property (nonatomic, strong) UILabel *lblItemCompany;
/** 取件时间 */
@property (nonatomic, strong) UILabel *lblItemDate;
/** 物品重量 */
@property (nonatomic, strong) UILabel *lblItemWeight;
/** 保费 */
@property (nonatomic, strong) UILabel *lblItemPrice;
/** 物品类型 */
@property (nonatomic, strong) UILabel *lblItemType;
/** 所寄物品 */
@property (nonatomic, strong) UIImageView *imagePhoto;
/** 确认订单View */
@property (nonatomic, strong) UIView *viewSubmit;
/** 确认订单按钮 */
@property (nonatomic, strong) UIButton *btnSubmit;
/** 预估费用 */
@property (nonatomic, strong) UIView *viewDeduction;
/** 预估费用明细查看 */
@property (nonatomic, strong) UIButton *btnDeduction;
/** 预估费用 */
@property (nonatomic, strong) UILabel *lblDeductionPrice;
/** 费用预估的抵扣卷icon */
@property (nonatomic, strong) NSAttributedString *price_str_Icon;
/** 抵扣卷标签 */
@property (nonatomic, strong) UIButton *voucherButton;
/** 小费按钮 */
@property (nonatomic, strong) UIButton *btnTipPrice;
/** 小费icon */
@property (nonatomic, strong) NSAttributedString *tipPrice_str_Icon;
/** 捎句话按钮 */
@property (nonatomic, strong) UIButton *btnTakeWords;
/** 捎句话icon */
@property (nonatomic, strong) NSAttributedString *takeWords_str_Icon;

/** 快递公司 */
@property (nonatomic, strong) NSMutableArray *companyName;
/** 物品类型 */
@property (nonatomic, strong) NSArray *itemTypeArray;
/** 寄件地址实体 */
@property (nonatomic, strong) DDAddressDetail *selfAddressDetail;

/** 寄件人信息 */
@property (nonatomic, strong) DDSendInfo * sendInfo;
/** 收件地址实体 */
@property (nonatomic, strong) DDAddressDetail *targetAddressDetail;

/** 确认订单，提交订单数据 */
@property (nonatomic, strong) DDInterface *interfaceSubmit;
@property (nonatomic, strong) DDInterface *interfaceSendInfo;
@property (nonatomic, strong) DDInterface *interfaceBudget;
@property (nonatomic, strong) DDInterface *interfaceWaitCourier;
@property (nonatomic, strong) DDInterface *interfaceItemType;
@property (nonatomic, strong) DDInterface *interfaceUploadData;
@property (nonatomic, strong) DDInterface *interfaceAddSelf;
@property (nonatomic, strong) DDInterface *interfaceAddTarget;
@property (nonatomic, strong) DDInterface *interfaceAdditinal;

/** 快递员信息, 追单使用的是同一个快递员 */
@property (strong, nonatomic) DDCourierDetail *detailCourier;


@end

@implementation DDPrepareSendViewController

- (void)dealloc
{
    
}

#pragma mark - 初始化控制器
- (instancetype)initWithDetailCourier:(DDCourierDetail *)courierDetail
{
    self = [super init];
    if (self) {
        self.lastViewFlag = 1;
        self.detailCourier = courierDetail;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:KBackground_COLOR];

    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"我要寄件" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self ddCreateWithScrollContent];
    /** 物品类型 */
    [self requestItemType];
    
    if (self.lastViewFlag == 0 || self.lastViewFlag == 2 ) {
        [self setCouriercompany:self.expressCompanyArray withLimit:NO];
        [self sendInfoInterface];
    } else {
        [self addAntherOrder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([DDGlobalVariables sharedInstance].targetAddressDetail) {
        [self getTargetAddressDetail];
        [DDGlobalVariables sharedInstance].targetAddressDetail = nil;
    }
    if ([DDGlobalVariables sharedInstance].selfAddressDetail) {
        [self getSelfAddressDetial];
        [DDGlobalVariables sharedInstance].selfAddressDetail = nil;
    }
    
    if (!_isUploadImage) {
        [self reloadWithViewLoad];
    }
}

/** 赋值，并刷新控件 */
- (void)reloadWithViewLoad
{
    if (self.selfAddressDetail.supplementAddress.length == 0) {
        /**  寄件地址无显示  */
        [self.btnSelfAddress setTitle:KSelfAddress_Text forState:UIControlStateNormal];
        [self.btnSelfAddress.titleLabel setFont:kTitleFont];
        [self.btnSelfAddress setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [self.btnSelfAddress setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.btnSelfAddress setContentEdgeInsets:UIEdgeInsetsMake(0, self.lblSelfAddress.left, 0, 0)];
        [self.lblSelfAddress setHidden:true];
    } else {
        /** 给寄件地址赋值 */
        NSString *strTitle = [NSString stringWithFormat:@"%@  %@",[LocalUserInfo objectForKey:@"nick"], [DDLocalUserInfoUtils getUserPhone]];
        [self.btnSelfAddress setTitle:strTitle forState:UIControlStateNormal];
        [self.btnSelfAddress.titleLabel setFont:kTimeFont];
        [self.btnSelfAddress setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        [self.btnSelfAddress setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [self.btnSelfAddress setContentEdgeInsets:UIEdgeInsetsMake((self.btnSelfAddress.height-KAddressIcon_HW)/2.0f-2, self.lblSelfAddress.left, 0, 0)];
       
        if (![CustomStringUtils isBlankString:self.selfAddressDetail.contentAddress] && ![CustomStringUtils isBlankString:self.selfAddressDetail.supplementAddress]) {
            
            if ([self.selfAddressDetail.contentAddress rangeOfString:@"/"].length > 0) {
                needShowSelfAddress = [self.selfAddressDetail.contentAddress stringByReplacingOccurrencesOfString:@"/" withString:@""];
            }
            [self.lblSelfAddress setText:[NSString stringWithFormat:@"%@%@", needShowSelfAddress, self.selfAddressDetail.supplementAddress]];
        }
        
        [self.lblSelfAddress setHidden:false];
    }
    
    
    if (self.targetAddressDetail.nick.length == 0) {
        /** 还原收件默认地址 */
        [self.btnTargetAddress setTitle:KTargetAddress_Text forState:UIControlStateNormal];
        [self.btnTargetAddress.titleLabel setFont:kTitleFont];
        [self.btnTargetAddress setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [self.btnTargetAddress setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [self.btnTargetAddress setContentEdgeInsets:UIEdgeInsetsMake(0, self.lblTargetAddress.left, 0, 0)];
        
        [self.lblTargetAddress setHidden:true];
        
    } else {
        /** 给收件地址赋值 */
        NSString *strTitle = [NSString stringWithFormat:@"%@  %@",[self.targetAddressDetail nick], [self.targetAddressDetail phone]];
        [self.btnTargetAddress setTitle:strTitle forState:UIControlStateNormal];
        
        [self.btnTargetAddress.titleLabel setFont:kTimeFont];
        [self.btnTargetAddress setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        [self.btnTargetAddress setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.btnTargetAddress setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [self.btnTargetAddress setContentEdgeInsets:UIEdgeInsetsMake((self.btnSelfAddress.height-KAddressIcon_HW)/2.0f-2, self.lblSelfAddress.left, 0, 0)];
        

        if (![CustomStringUtils isBlankString:self.targetAddressDetail.contentAddress] || ![CustomStringUtils isBlankString:self.targetAddressDetail.supplementAddress]) {
            
            [self.lblTargetAddress setText:[NSString stringWithFormat:@"%@%@", self.targetAddressDetail.contentAddress, self.targetAddressDetail.supplementAddress]];
        }
        [self.lblTargetAddress setHidden:NO];
    }
    
    [self reloadWithItemView];
}

/** 赋值，并刷新ItemView控件 */
- (void)reloadWithItemView
{
    NSString *currentMsg = [[NSString pathWithComponents:self.companyName] stringByReplacingOccurrencesOfString:@"/" withString:@" "];
    /** 快递公司 */
    if ([currentMsg length] > 0) {
        [self.lblItemCompany setText:currentMsg];
    } else {
        [self.lblItemCompany setText:@"不限"];
    }
    
    /** 取件时间 */
    [self.lblItemDate setTextColor:TITLE_COLOR];
    if (![CustomStringUtils isBlankString:showGetExpressTime]) {
        [self.lblItemDate setText:showGetExpressTime];
    } else {
        [self.lblItemDate setText:@"现在"];
    }
    
    
    /** 物品重量 */
    if ([self.sendInfo.itemWeight length] > 0)
    {
        [self.lblItemWeight setTextColor:TITLE_COLOR];
        [self.lblItemWeight setText:self.sendInfo.itemWeight];
    } else {
        [self.lblItemWeight setTextColor:TIME_COLOR];
        [self.lblItemWeight setText:@"请选择"];
    }
    
    /** 保费 */
    [self.lblItemPrice setTextColor:TITLE_COLOR];
    [self.lblItemPrice setText:[NSString stringWithFormat:@"%ld元",(long)self.sendInfo.itemInsure]];
    
    /** 物品类型 */
    if ([self.sendInfo.itemType length] > 0)
    {
        [self.lblItemType setTextColor:TITLE_COLOR];
        [self.lblItemType setText:self.sendInfo.itemType];
    } else {
        [self.lblItemType setTextColor:TIME_COLOR];
        [self.lblItemType setText:@"请选择"];
    }
    
    /** 所寄物品图片 */
    if (![CustomStringUtils isBlankString:self.sendInfo.itemImage]) {
        
        if (!expressImageView.image) {
            [addExpressImageLabel setHidden:YES];
            [self.imagePhoto setHidden:YES];
            [expressImageView setHidden:NO];
            [expressImageView sd_setImageWithURL:[NSURL URLWithString:self.sendInfo.itemImage]];
        }
        
    } else {
        
        if (!expressImageView.image) {
            [addExpressImageLabel setHidden:NO];
            [expressImageView setHidden:YES];
            [self.imagePhoto setHidden:NO];
        }

    }
    
    /** 判断是否所有项都已经选择，YES代表都已选择 */
    if ([self ifPopmoneyView]) {
        /** 预估费用 */
        [self budgetCostAction];
    }
}

/** 刷新预估费用view */
- (void)reloadWithDeductionView:(BOOL)flag
{
    NSInteger  firstMoney = minMoney;
    NSInteger  secondMoney = maxMoney;
    NSString *str_money = @"";
    NSString *str_Price = @"";
    
    //判断倒付状态
    if (self.sendInfo.targetPay == 1) {
        str_money = self.sendInfo.budgetCost;
        
        str_Price = [NSString stringWithFormat:@"预估费用：%@元",str_money];
        str_Price = [str_Price stringByAppendingString:@"  到付  "];/** 与箭头icon 的间距 */
    } else {
        if (firstMoney && secondMoney) {
            if (firstMoney == secondMoney) {
                str_money = [NSString stringWithFormat:@"%ld",(long)firstMoney];
            } else {
                str_money = [NSString stringWithFormat:@"%ld-%ld",(long)firstMoney, (long)secondMoney];
            }
        } else {
            str_money = self.sendInfo.budgetCost;
        }
        
        currentCostDetailInfo.finalCost = str_money;
        str_Price = [NSString stringWithFormat:@"预估费用：%@元",str_money];
        str_Price = [str_Price stringByAppendingString:@"  "];/** 与箭头icon 的间距 */
    }
    
    NSRange range_price = [str_Price rangeOfString:[str_money stringByAppendingString:@"元"]];
    NSRange range_number = [str_Price rangeOfString:str_money];
    NSDictionary *attribute_price = @{NSFontAttributeName:kTimeFont, NSForegroundColorAttributeName:TIME_COLOR};
    NSMutableAttributedString *att_str_price = [[NSMutableAttributedString alloc] initWithString:str_Price attributes:attribute_price];
    [att_str_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24.0f] range:range_number];
    [att_str_price addAttribute:NSForegroundColorAttributeName value:DDGreen_Color range:range_price];
    [att_str_price insertAttributedString:self.price_str_Icon atIndex:str_Price.length];
    [self.lblDeductionPrice setAttributedText:att_str_price];
    
    if (flag) {
        [self.lblDeductionPrice setOrigin:CGPointMake(self.lblDeductionPrice.left, 10.0f)];
        [self.voucherButton setHidden:false];
        [self.voucherButton setOrigin:CGPointMake(self.lblDeductionPrice.left, self.lblDeductionPrice.bottom)];
        [self.voucherButton setTitle:[NSString stringWithFormat:@"优惠券已扣除%@元", currentCostDetailInfo.couponCost] forState:UIControlStateNormal];

    } else {
        [self.lblDeductionPrice setCenter:CGPointMake(self.btnDeduction.centerx, self.btnDeduction.centery)];
        [self.voucherButton setHidden:true];
    }
}

/** 显示预估费用view */
- (void)showDidViewDeduction
{
    CGFloat scrollViewLastHeight = self.btnTargetAddress.bottom + 12.0f + 3*([self sizeItemWH].height+12.0f);
    CGFloat contentOffsetY = scrollViewLastHeight + CGRectGetHeight(self.viewDeduction.bounds) - CGRectGetHeight(self.scrollContent.bounds);
    
    [UIView animateWithDuration:0.35f animations:^{
        
        [self.viewDeduction setOrigin:CGPointMake(0, scrollViewLastHeight)];
        
        self.scrollContent.contentOffset = CGPointMake(0, contentOffsetY);
        self.scrollContent.contentSize = CGSizeMake(MainScreenWidth, scrollViewLastHeight + CGRectGetHeight(self.viewDeduction.bounds));
        
        
    } completion:^(BOOL finish) {
        [self reloadWithDeductionView:![CustomStringUtils isBlankString:currentCostDetailInfo.couponCost]];
    }];
}

/** 追单 */
- (void)addAntherOrder
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *ddSelfInfo = [defaults objectForKey:@"SelfPerson"];
    
    self.selfAddressDetail = [[DDAddressDetail alloc] init];
    self.selfAddressDetail.addressID = [ddSelfInfo valueForKey:@"addressID"];
    self.selfAddressDetail.addressName = [ddSelfInfo valueForKey:@"addressName"];
    self.selfAddressDetail.contentAddress = [ddSelfInfo valueForKey:@"contentAddress"];
    self.selfAddressDetail.supplementAddress = [ddSelfInfo valueForKey:@"supplementAddress"];
    self.selfAddressDetail.localDetailAddress = [ddSelfInfo valueForKey:@"localDetailAddress"];
    self.selfAddressDetail.nick = [ddSelfInfo valueForKey:@"name"];
    self.selfAddressDetail.phone = [ddSelfInfo valueForKey:@"phone"];
    self.selfAddressDetail.provinceId = [ddSelfInfo valueForKey:@"provinceId"];
    self.selfAddressDetail.cityId = [ddSelfInfo valueForKey:@"cityId"];
    self.selfAddressDetail.districtId = [ddSelfInfo valueForKey:@"districtId"];
    currentOrderId = [ddSelfInfo valueForKey:@"orderId"];
    NSDictionary *ddSendInfo = [defaults objectForKey:@"SendInfo"];
    self.sendInfo.selfAddressId = [ddSendInfo valueForKey:@"selfAddressId"];
    
    self.sendInfo.takeTime = @"现在";
    self.sendInfo.itemTip = 0;
    self.sendInfo.companyIds = [[NSArray alloc] initWithObjects:[self.detailCourier companyId], nil];
    
    NSString *couCompany = [self.detailCourier companyName];
    NSString *couWorker = [self.detailCourier courierName];
    NSString *resultString = [NSString stringWithFormat:@"%@(%@接单)",couCompany,couWorker];
    self.companyName = [[NSMutableArray alloc] initWithObjects:resultString, nil];
}

#pragma mark - 界面视图布局
/** 初始化界面视图控件 */
- (void)ddCreateWithScrollContent
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setFrame:CGRectMake(0, 64, self.view.width, MainScreenHeight - KNavHeight - 66)];
    [scrollView setBackgroundColor:KBackground_COLOR];
    [scrollView setShowsHorizontalScrollIndicator:false];
    [scrollView setShowsVerticalScrollIndicator:false];
    [scrollView setBounces:false];
    [self.view addSubview:scrollView];
    self.scrollContent = scrollView;
    
    /** 
     创建寄件人地址view和收件人地址view
     send recive
     */
    NSArray *array_address = [NSArray arrayWithObjects:KSelfAddress_Text, KTargetAddress_Text, nil];
    for (NSInteger i=0; i<array_address.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(0, i*KAddressView_Height, scrollView.width, KAddressView_Height)];
        [itemButton setBackgroundColor:[UIColor whiteColor]];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton setTag:DDPrepareSendViewTag+i];
        [scrollView addSubview:itemButton];
    
        UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KAddressIcon_HW, KAddressIcon_HW)];
        [imgIcon setCenter:CGPointMake(15.0f + imgIcon.centerx, itemButton.centery)];
        [imgIcon setBackgroundColor:[UIColor clearColor]];
        [imgIcon setImage:[UIImage imageNamed:i==0 ? KDDAddressSendIcon : KDDAddressReciveIcon]];
        [imgIcon setUserInteractionEnabled:false];
        [itemButton addSubview:imgIcon];
        
        //设置默认提示文本
        [itemButton setTitle:array_address[i] forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [itemButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [itemButton setContentEdgeInsets:UIEdgeInsetsMake(0, imgIcon.right + 12.0f, 0, 0)];
        
        /** 副标题，地址信息描述 */
        UILabel *itemLabel = [[UILabel alloc] init];
        [itemLabel setFrame:CGRectMake(imgIcon.right + 12.0f, imgIcon.bottom - 14.0f, itemButton.width - imgIcon.right - 50.0f, 14.0f)];
        [itemLabel setBackgroundColor:[UIColor clearColor]];
        [itemLabel setTextAlignment:NSTextAlignmentLeft];
        [itemLabel setTextColor:TIME_COLOR];
        [itemLabel setFont:kTimeFont];
        [itemLabel setHidden:true];
        [itemButton addSubview:itemLabel];
        
        //右边箭头icon
        UIImageView *imageArrow = [[UIImageView alloc] init];
        [imageArrow setSize:CGSizeMake(10, 12)];
        [imageArrow setCenter:CGPointMake(itemButton.width - 25.0f, itemButton.centery)];
        [imageArrow setImage:[UIImage imageNamed:KDDIconPDArraw]];
        [itemButton addSubview:imageArrow];
        
        if (i == 0) {
            UILabel *itemLine = [[UILabel alloc] init];
            [itemLine setFrame:CGRectMake(15.0f, itemButton.height - 0.5f, itemButton.width -15.0f, 0.5f)];
            [itemLine setBackgroundColor:BORDER_COLOR];
            [itemButton addSubview:itemLine];
            [itemButton addTarget:self action:@selector(onClickWithSelfAddress) forControlEvents:UIControlEventTouchUpInside];
            self.btnSelfAddress = itemButton;
            self.lblSelfAddress = itemLabel;
        } else {
            [itemButton addTarget:self action:@selector(onClickWithTargetAddress) forControlEvents:UIControlEventTouchUpInside];
            self.btnTargetAddress = itemButton;
            self.lblTargetAddress = itemLabel;
        }
    }
        
    /** 寄件Item选项(@"快递公司",@"取件时间",@"物品重量",@"物品类型",@"所寄物品",) */
    NSInteger column = 2;
    NSInteger tempIntdex = 0;
    CGFloat origin_y = 0.0f;
    
    //循环创建按钮
    for (NSInteger i = 0; i < 3; i++)
    {
        origin_y = self.btnTargetAddress.bottom + 12.0f + i*([self sizeItemWH].height+12.0f);
        for (NSInteger k=0; k<column; k++)
        {
            if (tempIntdex >= self.arrayItemTitels.count) {
                break;
            }
            CGFloat origin_x = k * [self sizeItemWH].width;
            
            //初始化对象
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [itemButton setFrame:CGRectMake(origin_x, origin_y, [self sizeItemWH].width, [self sizeItemWH].height)];
            [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
            [itemButton setBackgroundColor:[UIColor whiteColor]];
            [itemButton setAdjustsImageWhenHighlighted:false];
            [itemButton setTag:DDPrepareSendViewTag+array_address.count+tempIntdex];
            [itemButton addTarget:self action:@selector(onClickWithCheck:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:itemButton];
            
            //设置默认提示文本
            [itemButton setTitle:self.arrayItemTitels[tempIntdex] forState:UIControlStateNormal];
            [itemButton.titleLabel setFont:kTitleFont];
            [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
            [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [itemButton setContentEdgeInsets:UIEdgeInsetsMake(15.0f, 15.0f, 0, 0)];
            
            /** 副标题，地址信息描述 */
            UILabel *itemLabel = [[UILabel alloc] init];
            [itemLabel setBackgroundColor:[UIColor clearColor]];
            [itemLabel setTextAlignment:NSTextAlignmentLeft];
            [itemLabel setTextColor:TIME_COLOR];
            [itemLabel setFont:kContentFont];
            [itemLabel setFrame:CGRectMake(15.0f, itemButton.height - 30.0f, itemButton.width - 50.0f, 16.0f)];
            [itemButton addSubview:itemLabel];
            
            //右边箭头icon
            UIImageView *imageArrow = [[UIImageView alloc] init];
            [imageArrow setSize:CGSizeMake(10.0f, 12.0f)];
            [imageArrow setCenter:CGPointMake(itemButton.width - 25.0f, itemLabel.centerY)];
            [imageArrow setImage:[UIImage imageNamed:KDDIconPDArraw]];
            [itemButton addSubview:imageArrow];
            
            if (tempIntdex == 0) {
                [itemLabel setTextColor:TITLE_COLOR];
                [itemLabel setText:@"不限"];
                self.lblItemCompany = itemLabel;
            } else if (tempIntdex == 1) {
                [itemLabel setTextColor:TITLE_COLOR];
                [itemLabel setText:@"现在"];
                self.lblItemDate = itemLabel;
            } else if (tempIntdex == 2) {
                [itemLabel setTextColor:RGBCOLOR(188, 188, 188)];
                [itemLabel setText:@"请选择"];
                self.lblItemWeight = itemLabel;
            } else if (tempIntdex == 3) {
                [itemLabel setTextColor:RGBCOLOR(188, 188, 188)];
                [itemLabel setText:@"请选择"];
                self.lblItemType = itemLabel;
            } else if (tempIntdex == 4) {
                [itemLabel setTextColor:RGBCOLOR(188, 188, 188)];
                [itemLabel setText:@"添加图片"];
                
                [itemButton setFrame:CGRectMake(origin_x, origin_y, MainScreenWidth, [self sizeItemWH].height)];
                
                [imageArrow setSize:CGSizeMake(24.0f, 24.0f)];
                [imageArrow setCenter:CGPointMake(itemButton.width - 25.0f, itemLabel.centerY)];
                [imageArrow setImage:[UIImage imageNamed:@"photo"]];
                self.imagePhoto = imageArrow;
                self.imagePhoto.hidden = NO;
                
                [itemLabel setFrame:CGRectMake(CGRectGetMinX(imageArrow.frame) - 15 - 70, CGRectGetHeight(itemButton.bounds) / 2 - CGRectGetHeight(itemLabel.bounds) / 2, itemButton.width - 50.0f, 16.0f)];
                [imageArrow setCenter:CGPointMake(itemButton.width - 25.0f, itemLabel.centerY)];
                
                [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                [itemButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
                
                addExpressImageLabel = itemLabel;
                
                expressImageView = [[UIImageView alloc] init];
                [expressImageView setSize:CGSizeMake(40, 40)];
                [expressImageView setCenter:CGPointMake(itemButton.width - 20.0f - 40 / 2, itemLabel.centerY)];
                [itemButton addSubview:expressImageView];
                
                expressImageView.hidden = YES;
                
            }
            
            if (k == 0) {
                UILabel *lineColumn = [[UILabel alloc] init];
                [lineColumn setFrame:CGRectMake(itemButton.width - 0.5f, 0, 0.5f, itemButton.height)];
                [lineColumn setBackgroundColor:BORDER_COLOR];
                [itemButton addSubview:lineColumn];
            }
            tempIntdex++;
        }
    }
    
    /** 费用预估视图  */
    [self ddCreateWithDeductionView];
    
    /** 底部白色视图，确认订单 */
    UIView *viewSubmit = [[UIView alloc] init];
    [viewSubmit setFrame:CGRectMake(0, self.view.height - 66.0f, self.view.width, 66.0f)];
    [viewSubmit setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:viewSubmit];
    self.viewSubmit = viewSubmit;
    
    UILabel *lineTwo = [[UILabel alloc] init];
    [lineTwo setFrame:CGRectMake(0, 0, viewSubmit.width, 0.5f)];
    [lineTwo setBackgroundColor:BORDER_COLOR];
    [viewSubmit addSubview:lineTwo];
    
    UIButton *btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake(15.0f, 11.0f, viewSubmit.width - 30.0f, 44.0f)];
    [btnSubmit.layer setCornerRadius:btnSubmit.height/2];
    [btnSubmit.layer setMasksToBounds:true];
    [btnSubmit setBackgroundColor:KPlaceholderColor];
    [btnSubmit.titleLabel setFont:kButtonFont];
    [btnSubmit setTitle:@"确定订单" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(onClickWithCommit) forControlEvents:UIControlEventTouchUpInside];
    [btnSubmit setUserInteractionEnabled:NO];
    [viewSubmit addSubview:btnSubmit];
    self.btnSubmit = btnSubmit;
    
}

/**
 计算每一个方块的大小，按照一定的比例
 */
- (CGSize)sizeItemWH
{
    CGFloat imageW = self.view.width/2.0f;
    CGFloat imageR = 375.0f / imageW;
    CGFloat imageH = 170.0 / imageR;
    return CGSizeMake(imageW, imageH);
}

/** 费用预估视图 
 (self.view.height - self.navHeight - 66.0f)为底部确认订单视图的y值
 */
- (void)ddCreateWithDeductionView
{
    UIView *viewMoney = [[UIView alloc] init];
    [viewMoney setFrame:CGRectMake(0, MainScreenHeight - 64.f - 66.f, MainScreenWidth, 118.0f)];
    [viewMoney setBackgroundColor:[UIColor whiteColor]];
    [self.scrollContent addSubview:viewMoney];
    self.viewDeduction = viewMoney;
    
    UILabel *lineTwo = [[UILabel alloc] init];
    [lineTwo setFrame:CGRectMake(0, 0, viewMoney.width, 0.5f)];
    [lineTwo setBackgroundColor:BORDER_COLOR];
    [viewMoney addSubview:lineTwo];
    
    UIButton *btnDeduction = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDeduction setFrame:CGRectMake(0, 0, viewMoney.width, 74.0f)];
    [btnDeduction setBackgroundColor:[UIColor clearColor]];
    [btnDeduction setAdjustsImageWhenHighlighted:false];
    [btnDeduction addTarget:self action:@selector(onClickWithDeduction) forControlEvents:UIControlEventTouchUpInside];
    [viewMoney addSubview:btnDeduction];
    self.btnDeduction = btnDeduction;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFrame:CGRectMake(15.0f, 10.0f, viewMoney.width - 30.0f, 30.0f)];
    [priceLabel setBackgroundColor:[UIColor clearColor]];
    [priceLabel setTextAlignment:NSTextAlignmentCenter];
    [priceLabel setTextColor:TITLE_COLOR];
    [priceLabel setFont:kTimeFont];
    [viewMoney addSubview:priceLabel];
    self.lblDeductionPrice = priceLabel;
    
    NSTextAttachment *item_Icon = [[NSTextAttachment alloc] init];
    [item_Icon setImage:[UIImage imageNamed:DDCallArrow]];
    [item_Icon setBounds:CGRectMake(0, 0, 7.0f, 7.0f)];
    self.price_str_Icon = [NSAttributedString attributedStringWithAttachment:item_Icon];
    
    UIButton *voucherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [voucherButton setFrame:CGRectMake(priceLabel.left, priceLabel.bottom, priceLabel.width, 20.0f)];
    [voucherButton setBackgroundColor:[UIColor clearColor]];
    [voucherButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
    [voucherButton.titleLabel setFont:kTimeFont];
    [voucherButton setImage:[UIImage imageNamed:@"deduction"] forState:UIControlStateNormal];
    [voucherButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,10)];
    [viewMoney addSubview:voucherButton];
    self.voucherButton = voucherButton;
    
    UILabel *lineRow = [[UILabel alloc] init];
    [lineRow setFrame:CGRectMake(0, btnDeduction.height - 0.5f, viewMoney.width, 0.5f)];
    [lineRow setBackgroundColor:BORDER_COLOR];
    [btnDeduction addSubview:lineRow];
    
    /** 捎句话/小费 */
    NSArray *array_title;
    
    if (self.lastViewFlag == 1) {
        array_title = [NSArray arrayWithObjects:@"捎句话", nil];
    } else {
        array_title = [NSArray arrayWithObjects:@"小费",@"捎句话", nil];
    }
    
    for (NSInteger i = 0; i < array_title.count; i++) {
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (array_title.count == 1) {
            [itemButton setFrame:CGRectMake(0, lineRow.bottom, viewMoney.width, 44.0f)];
        } else {
            [itemButton setFrame:CGRectMake(i * (viewMoney.width / 2.0f), lineRow.bottom, viewMoney.width / 2.0f, 44.0f)];
        }
        
        [itemButton setBackgroundColor:[UIColor whiteColor]];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [viewMoney addSubview:itemButton];
        
        if (array_title.count == 1) {
            [itemButton setImage:[UIImage imageNamed:@"TakeWords"] forState:UIControlStateNormal];
        } else {
            [itemButton setImage:[UIImage imageNamed:i == 0 ? @"TipPrice" : @"TakeWords"] forState:UIControlStateNormal];
        }
        
        [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,10)];
        [itemButton setTitle:array_title[i] forState:UIControlStateNormal];
        
        if (array_title.count == 1) {
            [itemButton addTarget:self action:@selector(onClickWithTakeWords) forControlEvents:UIControlEventTouchUpInside];
            self.btnTakeWords = itemButton;
        } else {
            if (i == 0) {
                UILabel *lineColumn = [[UILabel alloc] init];
                [lineColumn setFrame:CGRectMake(itemButton.width - 0.5f, 0, 0.5f, itemButton.height)];
                [lineColumn setBackgroundColor:BORDER_COLOR];
                [itemButton addSubview:lineColumn];
                
                [itemButton addTarget:self action:@selector(onClickWithTipPrice) forControlEvents:UIControlEventTouchUpInside];
                self.btnTipPrice = itemButton;
            } else {
                [itemButton addTarget:self action:@selector(onClickWithTakeWords) forControlEvents:UIControlEventTouchUpInside];
                self.btnTakeWords = itemButton;
            }
        }
    }
}

#pragma mark - Private Method
- (void)getTargetAddressDetail
{
    self.targetAddressDetail = [[DDAddressDetail alloc] init];
    DDAddressDetail *addressDetail = [DDGlobalVariables sharedInstance].targetAddressDetail;
    self.targetAddressDetail.nick = addressDetail.nick;
    self.targetAddressDetail.contentAddress = addressDetail.contentAddress;
    self.targetAddressDetail.localDetailAddress = addressDetail.localDetailAddress;
    self.targetAddressDetail.supplementAddress = addressDetail.supplementAddress;
    self.targetAddressDetail.phone = addressDetail.phone;
    self.targetAddressDetail.addressName = addressDetail.addressName;
    self.targetAddressDetail.provinceId = addressDetail.provinceId;
    self.targetAddressDetail.provinceName = addressDetail.provinceName;
    self.targetAddressDetail.cityId = addressDetail.cityId;
    self.targetAddressDetail.cityName = addressDetail.cityName;
    self.targetAddressDetail.districtId = addressDetail.districtId;
    self.targetAddressDetail.districtName = addressDetail.districtName;
    self.targetAddressDetail.addressID = addressDetail.addressID;
    NSArray *arr = [NSArray array];
    if (addressDetail.provinceId.length > 0 && addressDetail.cityId.length > 0 && addressDetail.districtId.length > 0) {
        arr = [self getAddressNameFromProvinceId:addressDetail.provinceId andCityId:addressDetail.cityId andDistrictId:addressDetail.districtId];
        if (arr.count == 3) {
            self.targetAddressDetail.provinceName = arr[0];
            self.targetAddressDetail.cityName = arr[1];
            self.targetAddressDetail.districtName = arr[2];
        }
    }
}


- (NSArray *)getAddressNameFromProvinceId:(NSString *)pvId andCityId:(NSString *)ctId andDistrictId:(NSString *)dtId
{
    NSInteger provId = [pvId integerValue];
    NSInteger citId = [ctId integerValue];
    NSInteger dstId = [dtId integerValue];
    NSString *provName = [NSString string];
    NSString *citName = [NSString string];
    NSString *distName = [NSString string];
    NSMutableArray *arr = [NSMutableArray array];
    for (DDProvinceList *pvModel in self.provinceModelArr) {
        if (pvModel.provinceId == provId) {
            provName = pvModel.provinceName;
            for (NSDictionary *ctDic in pvModel.provinceSub) {
                DDCityList *ctModel = [DDCityList yy_modelWithDictionary:ctDic];
                if (ctModel.cityId == citId) {
                    citName = ctModel.cityName;
                    for (NSDictionary *dtDic in ctModel.citySub) {
                        DDAreaList *dtModel = [DDAreaList yy_modelWithDictionary:dtDic];
                        if (dtModel.areaId == dstId) {
                            distName = dtModel.areaName;
                            [arr addObject:provName];
                            [arr addObject:citName];
                            [arr addObject:distName];
                            return arr;
                        }
                    }
                }
            }
        }
    }
    
    return @[];
}


- (void)getSelfAddressDetial
{
    self.selfAddressDetail = [[DDAddressDetail alloc]init];
    DDAddressDetail *addressDetail = [DDGlobalVariables sharedInstance].selfAddressDetail;
    self.selfAddressDetail.name = [LocalUserInfo valueForKey:@"name"];
    self.selfAddressDetail.nick = addressDetail.nick;
    self.selfAddressDetail.contentAddress = addressDetail.contentAddress;
    self.selfAddressDetail.localDetailAddress = addressDetail.localDetailAddress;
    self.selfAddressDetail.supplementAddress = addressDetail.supplementAddress;
    self.selfAddressDetail.phone = addressDetail.phone;
    self.selfAddressDetail.addressName = addressDetail.addressName;
    self.selfAddressDetail.provinceId = addressDetail.provinceId;
    self.selfAddressDetail.provinceName = addressDetail.provinceName;
    self.selfAddressDetail.cityId = addressDetail.cityId;
    self.selfAddressDetail.cityName = addressDetail.cityName;
    self.selfAddressDetail.districtId = addressDetail.districtId;
    self.selfAddressDetail.districtName = addressDetail.districtName;
    self.selfAddressDetail.addressID = addressDetail.addressID;
    self.selfAddressDetail.latitude = addressDetail.latitude;
    self.selfAddressDetail.longitude = addressDetail.longitude;
}



#pragma mark - 按钮的方法事件 Action

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 确定订单按钮的点击事件 */
- (void)onClickWithCommit
{
    if (![CustomStringUtils isBlankString:self.selfAddressDetail.addressID] && ![CustomStringUtils isBlankString:self.targetAddressDetail.addressID]) {
        [self confirmOrderRequest];
    } else {
        if ([CustomStringUtils isBlankString:self.selfAddressDetail.addressID]) {
            [self addAddressRequestWithType:1];
        } else if ([CustomStringUtils isBlankString:self.targetAddressDetail.addressID]) {
            [self addAddressRequestWithType:2];
        }
    }
    
}

/** 寄件人地址信息  */
- (void)onClickWithSelfAddress
{
    if (self.lastViewFlag == 0 || self.lastViewFlag == 2) {
        DDSelfAdressEditController * selfAddressController = [[DDSelfAdressEditController alloc] init];
        selfAddressController.isEdit = NO;
        selfAddressController.delegate = self;
        selfAddressController.homeAddressDetail = self.homeAddressDetail;
        self.isFromHomePage = NO;
        [self.navigationController pushViewController:selfAddressController animated:YES];
    }
}

/** 收件人地址信息  */
- (void)onClickWithTargetAddress
{
    DDTargetAddressEditController * targetAddressController = [[DDTargetAddressEditController alloc] init];
    targetAddressController.delegate = self;
    targetAddressController.isEdit = NO;
    [self.navigationController pushViewController:targetAddressController animated:YES];
}

/** @"快递公司",@"取件时间",@"物品重量",@"物品类型",@"所寄物品",对应的选项事件 */
- (void)onClickWithCheck:(UIButton *)sender
{
    NSInteger index = sender.tag % DDPrepareSendViewTag;
    
    if (index == 2) {
        //快递公司
        [self pushCourierCompany];
    } else if (index == 3) {
        //取件时间
        [self popTakeTimeView];
    } else if (index == 4) {
        //物品重量
        [self popItemWeightView];
    } else if (index == 5) {
        //物品类型
        [self popItemTypeView];
    } else if (index == 6) {
        //所寄物品
        [self popEnclosedItemsView];
    }
}

/** 跳转到快递公司界面 */
- (void)pushCourierCompany
{
    if (self.lastViewFlag == 0 || self.lastViewFlag == 2)
    {
        DDCourierCompanyViewController *controller = [[DDCourierCompanyViewController alloc] init];
        controller.delegate = self;
        controller.idArray = self.sendInfo.companyIds;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

/** 动画弹出收取时间窗口 */
- (void)popTakeTimeView
{
    if (self.lastViewFlag == 0 || self.lastViewFlag == 2) {
        DDTakeTimeView  *view =  [[DDTakeTimeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 236.5 )];
        view.backgroundColor = WHITE_COLOR;
        view.delegate = self;
        [self setView:view animationHeight:view.height];
        
        if (![CustomStringUtils isBlankString:showGetExpressTime]) {
            [view showCurrentTime:showGetExpressTime];
        }
    }
}

/** 动画弹出物品重量窗口 */
- (void)popItemWeightView
{
    DDItemWeightView * view = [[DDItemWeightView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 236.5)];
    view.backgroundColor = WHITE_COLOR;
    view.delegate = self;
    [self setView:view animationHeight:view.height];
    
    if (![CustomStringUtils isBlankString:self.sendInfo.itemWeight]) {
        [view showCurrentWeight:self.sendInfo.itemWeight];
    }
}

/** 动画弹出保费窗口 */
- (void)popPremiumView
{
    DDPremiumView * view = [[DDPremiumView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 236.5 )];
    view.backgroundColor = WHITE_COLOR;
    view.delegate = self;
    [self setView:view animationHeight:view.height];
}

/** 弹出物品类型窗口 */
- (void)popItemTypeView
{
    DDItemTypeView  * view =  [[DDItemTypeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 236.5 )];
    view.backgroundColor = WHITE_COLOR;
    view.delegate = self;
    view.itemTypeArray = self.itemTypeArray;
    if (![CustomStringUtils isBlankString:self.sendInfo.itemType]) {
        [view showSelectedType:self.sendInfo.itemType];
    }
    [self setView:view animationHeight:view.height];
    
}

/** 动画弹出所寄物品窗口 */
- (void)popEnclosedItemsView
{
    UIActionSheet *sheet;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    } else {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
    }
    [sheet showInView:self.view];
}

/** 预估费用明细查看 */
- (void)onClickWithDeduction
{
    DDBudgetController *budgetController = [[DDBudgetController alloc] init];
    budgetController.detailInfo = currentCostDetailInfo;
    [self.navigationController pushViewController:budgetController animated:YES];
}

/** 小费按钮  动画弹出小费窗口 */
- (void)onClickWithTipPrice
{
    DDTipView *tipView =  [[DDTipView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 236.5 )];
    tipView.backgroundColor = WHITE_COLOR;
    tipView.delegate = self;
    [self setView:tipView animationHeight:tipView.height];
    
    if (![CustomStringUtils isBlankString:expressTipString]) {
        [tipView showSelectedTip:expressTipString];
    }
}

/** 捎句话按钮  动画弹出捎句话窗口*/
- (void)onClickWithTakeWords
{
    DDMessageView  *msgView =  [[DDMessageView alloc] init];
    msgView.backgroundColor = BORDER_COLOR;
    msgView.delegate = self;
    msgView.messageString = self.sendInfo.itemTag;
    [self setView:msgView animationHeight:msgView.height];
}

/** 设置从底部弹出的动画效果 */
- (void)setView:(UIView *)view animationHeight:(double)height
{
    animationView = view;
    animationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    animationButton.x = 0 ;
    animationButton.y = 0 ;
    animationButton.width = self.view.width;
    animationButton.height = self.view.height;
    [animationButton addTarget:self action:@selector(removeAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animationButton];
    
    [view setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, height)];
    [view setOpaque:NO];
    [self.view addSubview:view];
    
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.4];
    [view setFrame:CGRectMake(0, MainScreenHeight - height, MainScreenWidth, height)];
    animationButton.backgroundColor = DDRGBAColor(0, 0, 0, 0.15);
    [UIView commitAnimations];
}

/** 去掉动画弹窗 */
- (void)removeAnimation
{
    if (animationView != nil  && animationButton != nil) {
        
        [UIView animateWithDuration:0.4 animations:^{
            animationView.y = MainScreenHeight;
            animationButton.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [animationView removeFromSuperview];
            [animationButton removeFromSuperview];
            animationView = nil;
        }];
    }
}

#pragma mark - UIActionSheetDelegate
/** 实现相应的Action Sheet的选项的事件 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex) {
            case DDTakePhotoFromCamera:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case DDTakePhotoFromPhotoLibrary:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case DDTakePhotoCancel:
                return;
        }
    } else {
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            return;
        }
    }
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - UIImagePickerControllerDelegate
/** 获得已拍摄或者选择的图片，最后调用写好的upload方法将图片上传 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _isUploadImage = YES;
    [addExpressImageLabel setHidden:YES];
    [self.imagePhoto setHidden:YES];
    [expressImageView setHidden:NO];

    [expressImageView setImage:editedImage];
    
    UIImage *newImage = [self scaleImage:editedImage];
    [self saveImage:newImage WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpeg"]];
    
    if ([self ifPopmoneyView]) {
        /** 预估费用 */
        [self budgetCostAction];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    _isUploadImage = false;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

/** upload image并且刷新tableview */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.30f);
    NSArray *infoList = @[@{@"image":imageData, @"name":imageName}];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:infoList forKey:@"infoList"];
    
    if (!self.interfaceUploadData) {
        self.interfaceUploadData = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceUploadData interfaceWithType:INTERFACE_TYPE_UPLOAD_IMAGE param:param];
}

#pragma - mark 类的对象方法:监听点击事件
/** 判断是否所有项都已经选择，YES代表都已选择 */
- (BOOL)ifPopmoneyView
{
    if (![CustomStringUtils isBlankString:self.selfAddressDetail.contentAddress] &&
        (![CustomStringUtils isBlankString:self.targetAddressDetail.contentAddress] || ![CustomStringUtils isBlankString:self.targetAddressDetail.supplementAddress]) &&
        expressImageView.image &&
        ![self.sendInfo.itemWeight isEqualToString:@""] &&
        ![self.sendInfo.itemType isEqualToString:@""])
    {
        return YES;
    }
    [self.btnSubmit setBackgroundColor:KPlaceholderColor];
    [self.btnSubmit setUserInteractionEnabled:false];
    return NO;
}



#pragma mark - DDSelfAddressEditDelegate
/**  新增寄件地址保存  */
- (void)getValueWhenSaveInSelfAdressEdit:(DDSelfAdressEditController *)selfAdressEdit
                withChangedAddressDetail:(DDAddressDetail *)addressDetail
{
    self.selfAddressDetail = addressDetail;
    self.selfAddressDetail.addressID = @"";
}


#pragma mark - DDTargetAddressEditDelegate
/**  新增收件地址保存  */
- (void)addTargetAddressDetail:(DDAddressDetail *)person
{
    self.targetAddressDetail = person;
    self.targetAddressDetail.addressID = @"";
}

#pragma mark - DDTakeTimeViewDelegate
/** 取件时间窗口上的取消事件 */
- (void)takeTimeCancelAction
{
    [self removeAnimation];
}

/** 取件时间窗口上的确定时间 */
- (void)taketimeOKAction:(NSString *)timeString
{
    [self removeAnimation];
    
    if ([timeString rangeOfString:@"现在"].length > 0) {
        timeString = @"现在";
    }
    
    NSString *takeTime = [self getTimeIntervalByDateString:timeString];
    self.sendInfo.takeTime = takeTime;
    
    showGetExpressTime = timeString;
    
    [self reloadWithViewLoad];
}

- (NSString *)getTimeIntervalByDateString:(NSString *)dateString
{
    NSString *dayMode = [dateString substringWithRange:NSMakeRange(0, 2)];
    NSString *timeMode = [dateString substringWithRange:NSMakeRange(2, dateString.length - 2)];
    timeMode = [timeMode stringByAppendingString:@":00"];
    
    NSDate *date = [NSDate date];
    if ([dayMode isEqualToString:@"今天"]) {
        date = [NSDate date];
    } else if ([dayMode isEqualToString:@"明天"]) {
        date = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    } else if ([dayMode isEqualToString:@"后天"]) {
        date = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
        date = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *yearMD = [dateFormatter stringFromDate:date];
    
    NSString *commonDay = [yearMD stringByAppendingString:[NSString stringWithFormat:@" %@",timeMode]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *lastDate = [dateFormatter dateFromString:commonDay];
    return [NSString stringWithFormat:@"%lld", (long long)([lastDate timeIntervalSince1970] * 1000)];
}

#pragma mark - DDItemWeightViewDelegate
/** 物品重量窗口上的取消事件 */
-  (void)itemWeightCancelAction
{
    [self removeAnimation];
}

/** 物品重量窗口上的确定事件 */
- (void)itemWeightOKAction:(NSString *)weightString
{
    [self removeAnimation];
    self.sendInfo.itemWeight = weightString;
    
    [self reloadWithViewLoad];
}

#pragma makr - DDPremiumViewDelegate
/** 保费窗口上的取消事件 */
- (void)premiumCancelAction
{
    [self removeAnimation];
}

/** 保费窗口上的确定事件 */
- (void) premiumOKAction:(NSString *)premium
{
    [self removeAnimation];
    self.sendInfo.itemInsure = [[premium substringToIndex:premium.length - 1] floatValue];
    
    [self reloadWithViewLoad];
}

#pragma mark - DDTipViewDelegate
/** 小费窗口上的取消事件 */
- (void)tipCancelAction
{
    [self removeAnimation];
}

/** 小费窗口上的确定事件 */
- (void)tipOKAction:(NSString *)tipString
{
    [self removeAnimation];
    
    expressTipString = tipString;
    
    if ([tipString length] > 1)
    {
        self.sendInfo.itemTip = [[tipString substringToIndex:1] floatValue];
        
        [self.btnTipPrice setTitle:[tipString substringToIndex:2] forState:UIControlStateNormal];
        
//        [self reloadWithDeductionView:NO];
        [self reloadWithViewLoad];
        
        currentCostDetailInfo.tipCost = [NSString stringWithFormat:@"%.0f元", self.sendInfo.itemTip];
    }
}

#pragma mark - DDMessageViewDelegate
/** 捎句话窗口上的取消事件 */
- (void)messageCancelAction
{
    [self removeAnimation];
}

/** 捎句话窗口上的确定事件 */
- (void)messageOKAction:(NSString *)messageString
{
    [self removeAnimation];
//    if ([messageString length] == 0) {
//        return;
//    }
    
    
    if ([CustomStringUtils isBlankString:messageString]) {
        messageString = @"捎句话";
        self.sendInfo.itemTag = @"";
    } else {
        self.sendInfo.itemTag = messageString;
    }
    [self.btnTakeWords setTitle:messageString forState:UIControlStateNormal];
    [self.btnTakeWords.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.btnTakeWords.titleLabel setNumberOfLines:1];
    
    if ([messageString rangeOfString:@"到付"].location == NSNotFound) {
        self.sendInfo.targetPay = 0;
    } else {
        self.sendInfo.targetPay = 1;
    }
    
//    [self reloadWithDeductionView:NO];
    [self reloadWithViewLoad];
}

#pragma mark - DDItemTypeViewDelegate
/** 物品类型窗口上的取消事件 */
- (void)itemTypeCancelAction
{
    [self removeAnimation];
}

/** 物品类型窗口上的确定事件 */
- (void)itemTypeOKAction:(NSString *)typeString
{
    [self removeAnimation];
    self.sendInfo.itemType = typeString;

    [self reloadWithViewLoad];
}

#pragma mark - DDCourierCompanyViewDelegate
/** 获取快递公司 */
- (void)setCouriercompany:(NSMutableArray *)array withLimit:(BOOL)limitFlag
{
    NSMutableArray *arrayId = [[NSMutableArray alloc] init];
    [self.companyName removeAllObjects];
    if (limitFlag) {
        [self.companyName addObject:@"不限"];
        self.sendInfo.companyIds = arrayId;
    } else {
        for (DDCompanyModel *model in array) {
            if (![CustomStringUtils isBlankString:model.companyID]) {
                [arrayId addObject:model.companyID];
            }
            if (![CustomStringUtils isBlankString:model.companyName]) {
                [self.companyName addObject:model.companyName];
            }
        }
        self.sendInfo.companyIds = arrayId;
        
        if ([self.companyName count] > 1) {
            [[self.companyName firstObject] stringByAppendingString:@"..."];
        }
    }
    
    [self reloadWithViewLoad];
}

/** 初始化变量值 */
- (void)initValue
{
    minMoney = 0;
    maxMoney = 0;
    self.isFirstS = false;
}

- (NSMutableArray *)companyName
{
    if (!_companyName) {
        _companyName = [[NSMutableArray alloc] initWithObjects:@"不限", nil];
    }
    return _companyName;
}

- (NSArray *)arrayItemTitels
{
    if (!_arrayItemTitels) {
        _arrayItemTitels = [NSMutableArray arrayWithObjects:@"快递公司",@"取件时间",@"物品重量",@"物品类型",@"所寄物品", nil];
    }
    return _arrayItemTitels;
}

/** 懒加载初始化sendInfo */
- (DDSendInfo *)sendInfo
{
    if (_sendInfo == nil) {
        _sendInfo = [[DDSendInfo alloc] init];
        _sendInfo.selfAddressId = self.selfAddressDetail.addressID;
        _sendInfo.targetAddressId = @"";
        _sendInfo.companyIds = [NSArray array];
        _sendInfo.takeTime = @"现在";
        _sendInfo.itemWeight = @"";
        _sendInfo.budgetCost = @"";
        _sendInfo.itemImage = @"";
        _sendInfo.itemInsure = 0.0f;
        _sendInfo.itemTip = 0.0f;
        _sendInfo.itemType = @"";
        _sendInfo.itemTag = @"";
        _sendInfo.targetPay = 0;
    }
    return _sendInfo;
}
- (NSMutableArray *)provinceModelArr
{
    if (_provinceModelArr == NO) {
        /**<  JSON转NSData  */
        NSData *data = [NSData dataWithContentsOfFile:DDMainBundle(@"city.json")];
        /**<  NSData转字典  */
        NSArray *arr =  [self dictionaryWithJsonString:data];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            DDProvinceList *pvModel = [DDProvinceList yy_modelWithDictionary:dic];
            [mArr addObject:pvModel];
        }
        _provinceModelArr = mArr;
    }
    return _provinceModelArr;
}
/**<  json字符串转(数组字典都可以)  */
- (NSArray *)dictionaryWithJsonString:(NSData *)jsonData
{
    if (jsonData == nil) {
        return nil;
    }
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}
#pragma mark -  服务器请求
- (void)addAddressRequestWithType:(NSInteger)type
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    DDAddressDetail *addressDetail = type == 1 ? self.selfAddressDetail : self.targetAddressDetail;
    
    //地址经度
    [param setObject:@(addressDetail.longitude) ?: @"" forKey:@"addrLon"];
    
    //地址纬度
    [param setObject:@(addressDetail.latitude) ?: @"" forKey:@"addrLat"];
    
    //设置寄件地址经纬度
    [DDCenterCoordinate setSendExpressInfoWithCoordinate:CLLocationCoordinate2DMake(addressDetail.latitude, addressDetail.longitude)];
    
    //主地址
    [param setObject:addressDetail.contentAddress ?: @"" forKey:@"main"];
    
    //详细地址
    [param setObject:addressDetail.supplementAddress ?: @"" forKey:@"detail"];
    
    //标签信息
    [param setObject:addressDetail.sign ?: @"" forKey:@"tag"];
    
    //名字
    [param setObject:addressDetail.nick ?: @"" forKey:@"name"];
    
    //手机号
    [param setObject:addressDetail.phone ?: @"" forKey:@"phone"];
    
    NSArray *arr = [self getAddressIdFromCityName:self.selfAddressDetail.cityName andDstristName:self.selfAddressDetail.districtName];
    NSString *pvId = [NSString string];
    NSString *ctId = [NSString string];
    NSString *dtId = [NSString string];
    if (type == 1) {
        if (arr.count == 3) {
            pvId = arr[0];
            ctId = arr[1];
            dtId = arr[2];
        }
    }else{
        pvId = addressDetail.provinceId;
        ctId = addressDetail.cityId;
        dtId = addressDetail.districtId;
    }
    
    //省ID
    [param setObject:pvId ?: @"" forKey:@"provId"];
    
    //市id
    [param setObject:ctId ?: @"" forKey:@"townId"];
    
    //区id
    [param setObject:dtId ?: @"" forKey:@"areaId"];
    
    //信息类型(1寄件 2 收件)
    [param setObject:@(type) forKey:@"type"];
    
    DDInterface *interfaceAdd = [[DDInterface alloc] initWithDelegate:self];

    [interfaceAdd interfaceWithType:INTERFACE_TYPE_ADD_ADDRESS param:param];
    
    if (type == 1) {
        self.interfaceAddSelf = interfaceAdd;
    }else {
        self.interfaceAddTarget = interfaceAdd;
    }
}


- (NSArray *)getAddressIdFromCityName:(NSString *)cityName andDstristName:(NSString *)districtName
{
    NSString *pvId = [NSString string];
    NSString *ctId = [NSString string];
    NSString *dtId = [NSString string];
    NSMutableArray *mArr = [NSMutableArray array];
    for (DDProvinceList *pvModel in self.provinceModelArr) {
        NSArray *cityArr = pvModel.provinceSub;
        for (NSDictionary *ctDic in cityArr) {
            DDCityList *ctModel = [DDCityList yy_modelWithDictionary:ctDic];
            NSString *cName = ctModel.cityName;
            if ([cityName isEqualToString:cName]) {
                ctId = [NSString stringWithFormat:@"%ld",(long)ctModel.cityId];
                pvId = [NSString stringWithFormat:@"%ld",(long)pvModel.provinceId];
                for (NSDictionary *dtDic in ctModel.citySub) {
                    DDAreaList *areModel = [DDAreaList yy_modelWithDictionary:dtDic];
                    if ([areModel.areaName isEqualToString:districtName]) {
                        dtId = [NSString stringWithFormat:@"%ld",(long)areModel.areaId];
                    }
                }
            }
        }
    }
    
    [mArr addObject:pvId.length == 0 ? @"" : pvId];
    [mArr addObject:ctId.length == 0 ? @"" : ctId];
    [mArr addObject:dtId.length == 0 ? @"" : dtId];
    NSArray *arr = [NSArray arrayWithArray:mArr];
    return arr;
}

/**
 物品类型
 */
- (void)requestItemType
{
    if (!self.interfaceItemType) {
        self.interfaceItemType = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceItemType interfaceWithType:INTERFACE_TYPE_GOODS_TYPE_LIST param:nil];
}

/**
 等待快递员抢单
 */
- (void)waitForCourier
{
    if (!self.interfaceWaitCourier) {
        self.interfaceWaitCourier = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceWaitCourier interfaceWithType:INTERFACE_TYPE_WAIT_COURIER param:nil];
    
}

/** 确定订单 */
- (void)requestData
{
    //传参数字典(对应模型DDSendInfo)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //寄件地址ID
    [param setObject:self.selfAddressDetail.addressID ?: @"" forKey:@"sendAddrId"];
    
    [DDCenterCoordinate setSendExpressInfoWithCoordinate:CLLocationCoordinate2DMake(self.selfAddressDetail.latitude, self.selfAddressDetail.longitude)];
    
    //收件地址ID
    [param setObject:self.targetAddressDetail.addressID ?: @"" forKey:@"receAddrId"];
    
    //快递公司ID 数组(string类型)
    if ([self.sendInfo.companyIds count] > 0)
    {
        [param setObject:self.sendInfo.companyIds forKey:@"corIdList"];
    }
    
    //取件时间（-1代表没选时间和当前时间）
    NSString *str_time = [self.sendInfo.takeTime isEqualToString:@"现在"] ? @"-1" : self.sendInfo.takeTime;
    [param setObject:str_time ?: @"" forKey:@"getTime"];
    
    //物品照片(上传到阿里云服务器之后得到的URL)
    [param setObject:self.sendInfo.itemImage ?: @"" forKey:@"image"];
    
    //物品重量
    NSInteger number_weight = MAX(1, [self numberWithFiltrateString:self.sendInfo.itemWeight]);
    [param setObject:@(number_weight) forKey:@"weight"];
    
    //物品类型
    [param setObject:self.sendInfo.itemType ?: @"" forKey:@"type"];
    
    //小费
    [param setObject:@(self.sendInfo.itemTip) forKey:@"tip"];
    
    //捎句话
    [param setObject:self.sendInfo.itemTag ?: @"" forKey:@"tag"];
    
    //预估费用
    [param setObject:self.sendInfo.budgetCost ?: @"" forKey:@"cost"];
    
    //经纬度
    [param setObject:@([DDCenterCoordinate getUserLocationCoordinate].latitude) forKey:@"lat"];
    [param setObject:@([DDCenterCoordinate getUserLocationCoordinate].longitude) forKey:@"lon"];
    
    //是否现在付款(0 到付 1 不是到付)
    [param setObject:@(self.sendInfo.targetPay) forKey:@"pay"];
    
    if (!self.interfaceSubmit) {
        self.interfaceSubmit = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceSubmit interfaceWithType:INTERFACE_TYPE_DETERMIN_ORDER param:param];
}

/** 追加订单 */
- (void)additionalRequest
{
    //传参数字典(对应模型DDSendInfo)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (![CustomStringUtils isBlankString:currentOrderId]) {
        [param setObject:currentOrderId forKey:@"orderId"];
    }
    
    //收件地址ID
    [param setObject:self.targetAddressDetail.addressID ?: @"" forKey:@"receAddrId"];
    
    //取件时间（-1代表没选时间和当前时间）
    NSString *str_time = [self.sendInfo.takeTime isEqualToString:@"现在"] ? @"-1" : self.sendInfo.takeTime;
    [param setObject:str_time ?: @"" forKey:@"getTime"];
    
    //物品照片(上传到阿里云服务器之后得到的URL)
    [param setObject:self.sendInfo.itemImage ?: @"" forKey:@"image"];
    
    //物品重量
    NSInteger number_weight = MAX(1, [self numberWithFiltrateString:self.sendInfo.itemWeight]);
    [param setObject:@(number_weight) forKey:@"weight"];
    
    //物品类型
    [param setObject:self.sendInfo.itemType ?: @"" forKey:@"type"];
    
    //小费
    [param setObject:@(self.sendInfo.itemTip) forKey:@"tip"];
    
    //捎句话
    [param setObject:self.sendInfo.itemTag ?: @"" forKey:@"tag"];
    
    //预估费用
    [param setObject:self.sendInfo.budgetCost ?: @"" forKey:@"cost"];
    
    //是否现在付款(0 到付 1 不是到付)
    [param setObject:@(self.sendInfo.targetPay) forKey:@"pay"];
    
    if (!self.interfaceAdditinal) {
        self.interfaceAdditinal = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceAdditinal interfaceWithType:INTERFACE_TYPE_ADD_ORDER param:param];
}

/** 寄件信息 */
- (void)sendInfoInterface
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (!self.interfaceSendInfo) {
        self.interfaceSendInfo = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceSendInfo interfaceWithType:INTERFACE_TYPE_SENDER_INFO param:param];
}

/** 预估费用 */
- (void)budgetCostAction
{
    //传参数字典(对应模型DDSendInfo)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if ([CustomStringUtils isBlankString:self.selfAddressDetail.cityId] && [CustomStringUtils isBlankString:self.selfAddressDetail.provinceId] && [CustomStringUtils isBlankString:self.selfAddressDetail.districtId]) {
        NSArray *arr = [self getAddressIdFromCityName:self.selfAddressDetail.cityName andDstristName:self.selfAddressDetail.districtName];
        NSString *pvId = [NSString string];
        NSString *ctId = [NSString string];
        NSString *dtId = [NSString string];
        if (arr.count == 3) {
            pvId = arr[0];
            ctId = arr[1];
            dtId = arr[2];
        }
        [param setObject:pvId ?: @"" forKey:@"sProvId"];
        [param setObject:ctId ?: @"" forKey:@"sTownId"];
        [param setObject:dtId ?: @"" forKey:@"sAreaId"];
        
        self.selfAddressDetail.provinceId = pvId;
        self.selfAddressDetail.cityId = ctId;
        self.selfAddressDetail.districtId = dtId;
    } else {
        [param setObject:self.selfAddressDetail.provinceId ?: @"" forKey:@"sProvId"];
        [param setObject:self.selfAddressDetail.cityId ?: @"" forKey:@"sTownId"];
        [param setObject:self.selfAddressDetail.districtId ?: @"" forKey:@"sAreaId"];
    }
    
    
    [param setObject:self.targetAddressDetail.provinceId?: @"" forKey:@"rProvId"];
    [param setObject:self.targetAddressDetail.cityId?: @"" forKey:@"rTownId"];
    [param setObject:self.targetAddressDetail.districtId?: @"" forKey:@"rAreaId"];
    
    //物品重量
    NSInteger number_weight = MAX(1, [self numberWithFiltrateString:self.sendInfo.itemWeight]);
    [param setObject:@(number_weight) forKey:@"weight"];
    
    //快递公司ID数组
    [param setObject:self.sendInfo.companyIds forKey:@"corIdList"];
    
    //小费
    [param setObject:@(self.sendInfo.itemTip) forKey:@"tip"];
    
    [param setObject:@(self.sendInfo.targetPay) forKey:@"ePay"];
    
    if (!self.interfaceBudget) {
        self.interfaceBudget = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceBudget interfaceWithType:INTERFACE_TYPE_BUDGET_COST param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceSubmit) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            NSString *orderId = [NSString stringWithFormat:@"%@",result[@"orderId"]];
            if (orderId.length == 0) {
                [MBProgressHUD showError:@"返回订单号异常"];
                return;
            } else {
                currentOrderId = orderId;
            }
            
            if ([result[@"code"] intValue] == 200) {
                //               [self waitForCourier];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                //模型转字典
                [defaults setObject:[self dictionaryFromSendInfo] forKey:@"SendInfo"];
                [defaults setObject:[self dictionaryFromSelfPerson] forKey:@"SelfPerson"];
                [defaults synchronize];
            }
            
            //if (self.lastViewFlag != 1) {
                if ([self.delegate respondsToSelector:@selector(prepareSendView:popAnimationWithOrderId:andOrderType:)]) {
                    [self.delegate prepareSendView:self popAnimationWithOrderId:orderId andOrderType:self.lastViewFlag];
                }
            
            //}
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (interface == self.interfaceAdditinal) {
        NSString *orderId = [NSString stringWithFormat:@"%@",result[@"orderId"]];
        if ([CustomStringUtils isBlankString:orderId]) {
            [MBProgressHUD showError:@"返回订单号异常"];
            return;
        } else {
            if ([self.delegate respondsToSelector:@selector(prepareSendView:popWaitCourierGetWithOrderId:)]) {
                [self.delegate prepareSendView:self popWaitCourierGetWithOrderId:orderId];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (interface == self.interfaceBudget) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            if ([[result objectForKey:@"cost"] isKindOfClass:[NSString class]]) {
                if ([[result objectForKey:@"cost"] rangeOfString:@"-"].length > 0) {
                    NSArray * moneyArray = [result[@"cost"] componentsSeparatedByString:@"-"];
                    minMoney = [[moneyArray firstObject] integerValue];
                    maxMoney = [[moneyArray lastObject] integerValue];
                }
                
                self.sendInfo.budgetCost = result[@"cost"];
            } else {
                self.sendInfo.budgetCost = [NSString stringWithFormat:@"%d", [result[@"cost"] intValue]];
            }
            
            [self.btnSubmit setBackgroundColor:DDGreen_Color];
            [self.btnSubmit setUserInteractionEnabled:true];
            
            currentCostDetailInfo = [[DDCostDetailInfo alloc] init];
            currentCostDetailInfo.firstWeightCost = [result objectForKey:@"first"];
            currentCostDetailInfo.secondWeightCost = [result objectForKey:@"conti"];
            
            if ([[result objectForKey:@"coupon"] intValue] > 0) {
                currentCostDetailInfo.couponCost = [NSString stringWithFormat:@"%d", [[result objectForKey:@"coupon"] intValue]];
            }
            
            /** 显示预估费用view */
            [self showDidViewDeduction];
        }
    } else if(interface == self.interfaceSendInfo) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            self.selfAddressDetail = [DDAddressDetail yy_modelWithDictionary:result];
            
            self.selfAddressDetail.latitude = [[result objectForKey:@"lat"] floatValue];
            self.selfAddressDetail.longitude = [[result objectForKey:@"lon"] floatValue];

            self.selfAddressDetail.nick = self.selfAddressDetail.name;
            self.selfAddressDetail.name = @"";
            [self reloadWithViewLoad];
        }
    } else if (interface == self.interfaceItemType) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            self.itemTypeArray = result[@"typeList"];
        }
    } else if (interface == self.interfaceUploadData) {
        _isUploadImage = false;
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            for (NSString *dataUrl in result[@"images"]) {
                if ([CustomStringUtils isBlankString:dataUrl]) {
                    continue;
                }
                [self.sendInfo setItemImage:dataUrl];
                break;
            }
        }
    }else if (interface == self.interfaceAddSelf) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            self.selfAddressDetail.addressID = [result objectForKey:@"addrId"];
        
            if ([CustomStringUtils isBlankString:self.targetAddressDetail.addressID]) {
                [self addAddressRequestWithType:2];
            } else {
                [self confirmOrderRequest];
            }
        }
    }else if (interface == self.interfaceAddTarget) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
             self.targetAddressDetail.addressID = [result objectForKey:@"addrId"];
            [self confirmOrderRequest];
        }
    }else {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:result forKey:@"OrderAgain"];
            [defaults synchronize];
        }
    }
}



- (void)confirmOrderRequest
{
    if (self.lastViewFlag == 1) {
        [self additionalRequest];
    } else {
        [self requestData];
    }
}

/** sendInfo转字典 */
- (NSDictionary *)dictionaryFromSendInfo
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    [dic setValue:_sendInfo.selfAddressId forKey:@"selfAddressId"];
    [dic setValue:_sendInfo.targetAddressId forKey:@"targetAddressId"];
    [dic setValue:_sendInfo.companyIds forKey:@"companyIds"];
    [dic setValue:_sendInfo.takeTime forKey:@"takeTime"];
    [dic setValue:_sendInfo.itemWeight forKey:@"itemWeight"];
    [dic setValue:_sendInfo.budgetCost forKey:@"budgetCost"];
    [dic setValue:_sendInfo.itemImage forKey:@"itemImage"];
    [dic setValue:[NSNumber numberWithFloat:_sendInfo.itemInsure] forKey:@"itemInsure"];
    [dic setValue:[NSNumber numberWithFloat:_sendInfo.itemTip] forKey:@"itemInsure"];
    [dic setValue:_sendInfo.itemType forKey:@"itemType"];
    [dic setValue:_sendInfo.itemTag forKey:@"itemTag"];
    [dic setValue:[NSNumber numberWithFloat:_sendInfo.targetPay] forKey:@"targetPay"];
    return dic;
}

/** selfPerson转字典 */
- (NSDictionary *)dictionaryFromSelfPerson
{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSNumber numberWithFloat:self.selfAddressDetail.longitude] forKey:@"longitude"];
    [dic setValue:[NSNumber numberWithFloat:self.selfAddressDetail.latitude] forKey:@"latitude"];
    [dic setValue:[NSNumber numberWithFloat:self.selfAddressDetail.addressType] forKey:@"addressType"];
    [dic setValue:self.selfAddressDetail.addressID forKey:@"addressID"];
    [dic setValue:self.selfAddressDetail.addressName forKey:@"addressName"];
    [dic setValue:self.selfAddressDetail.contentAddress forKey:@"contentAddress"];
    [dic setValue:self.selfAddressDetail.supplementAddress forKey:@"supplementAddress"];
    [dic setValue:self.selfAddressDetail.localDetailAddress forKey:@"localDetailAddress"];
    [dic setValue:self.selfAddressDetail.nick forKey:@"name"];
    [dic setValue:self.selfAddressDetail.phone forKey:@"phone"];
    [dic setValue:self.selfAddressDetail.sign forKey:@"sign"];
    [dic setValue:self.selfAddressDetail.provinceId forKey:@"provinceId"];
    [dic setValue:self.selfAddressDetail.cityId forKey:@"cityId"];
    [dic setValue:self.selfAddressDetail.districtId forKey:@"districtId"];
    [dic setValue:currentOrderId forKey:@"orderId"];
    
    return dic;
}


@end
