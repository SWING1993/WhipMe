//
//  DDPayCostController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

//
//  DDPayCostController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//
#define KPayStyleItem 7777

#import "DDPayCostController.h"
#import "DDCostDetail.h"
#import "UIImageView+WebCache.h"
#import "DDOrderDetail.h"
#import "YYModel.h"
#import "LSPay.h"
#import "CustomStringUtils.h"
#import "DDOrderDetailController.h"
#import "DDCourierDetailController.h"

typedef enum {
    DDPayCostStyleBalance = 0,
    DDPayCostStyleAlipay = 1,
    DDPayCostStyleWechatpay = 2,
    DDPayCostStyleApplepay = 3
} DDPayCostStyle;


NSString *const DDPayCostControllerConstList = @"费用明细";                                                              /** DDPayCostController费用明细 */
NSString *const DDPayCostControllerPayStyle = @"选择支付方式";                                                            /** DDPayCostController支付方式 */
NSString *const DDPayCostControllerPayExpressMoney = @"支付快递费";                                                       /** DDPayCostController支付快递费Title */

@interface DDPayCostController () <DDInterfaceDelegate>

@property (nonatomic, assign) DDPayCostStyle payStyle;
/** 本视图的整体滚动视图 */
@property (strong, nonatomic) UIScrollView *detailScroll;
/** 上层快递员信息视图 */
@property (strong, nonatomic) UIView *upSuperView;
/** 快递员头像 */
@property (strong, nonatomic) UIImageView *imageIcon;
/** 快递员名字 */
@property (strong, nonatomic) UILabel *nicknameLabel;
/** 快递公司名字 */
@property (strong, nonatomic) UILabel *companyLabel;
/** 快递员评分等级 */
@property (strong, nonatomic) UIImageView *trackLevel;
@property (strong, nonatomic) UIImageView *progressLevel;
/** 快递员评分值 */
@property (strong, nonatomic) UILabel *gradeLabel;
/** 订单数量 */
@property (strong, nonatomic) UIButton *orderCountBtn;
/** 电话按钮 */
@property (strong, nonatomic) UIButton *phoneBtn;
/** 下层支付视图 */
@property (strong, nonatomic) UIView *downSuperView;
/** 费用明细 */
@property (strong, nonatomic) UILabel *constListLabel;
/** 快递费 */
@property (strong, nonatomic) UILabel *courierPriceLabel;
/** 小费 */
@property (strong, nonatomic) UILabel *tipPriceLabel;
/** 保费 */
@property (strong, nonatomic) UILabel *lblInsurePrice;
/** 优惠券 */
@property (strong, nonatomic) UILabel *couponPriceLabel;
/** 支付费用 */
@property (strong, nonatomic) UILabel *payMoneyLabel;

@property (strong, nonatomic) UIView *lineView;
/** 应付金额标题 */
@property (strong, nonatomic) UILabel *totalTitle;
/** 费用 */
@property (strong, nonatomic) UILabel *totalMoney;
/** 支付方式背景视图 */
@property (strong, nonatomic) UIView *paySuperView;
/** 支付方式 */
@property (strong, nonatomic) UILabel *payStyleLabel;

@property (strong, nonatomic) NSMutableArray *arrayPayStyle;

@property (strong, nonatomic) UIButton *payAffirmButton;

@property (strong, nonatomic) UIButton *totalBalanceBtn;

@property (strong, nonatomic) UILabel *noBalanceLabel;

@property (strong, nonatomic) UIButton *btnCourierInfo;

/** 网络请求*/
@property (strong, nonatomic) DDInterface *interPayCost;
@property (strong, nonatomic) DDInterface *interOrderDetail;
@property (strong, nonatomic) DDInterface *interMyWallet;
@property (strong, nonatomic) DDInterface *confirmPayInterface;

@property (nonatomic,copy) NSString *totalBalance;

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *payTitlesArray;
@property (nonatomic,strong) NSArray *payIconsArray;

@property (nonatomic,strong) NSMutableArray *itemLabelArray;
@property (nonatomic,strong) NSMutableArray *priceLabelArray;

@end

@implementation DDPayCostController
@synthesize btnCourierInfo;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.payStyle = [self getSelectedPayStyle];
    
    //设置导航控制器
    [self createNavigationBar];
    
    self.titleArray = [NSArray arrayWithObjects:@"快递费",@"小费",@"优惠券",@"费用合计", nil];
    self.payTitlesArray = [NSArray arrayWithObjects:@"余额",@"支付宝",@"微信支付", nil];
    self.payIconsArray  = [NSArray arrayWithObjects:@"", DDAliayIcon, DDWechatPayIcon, nil];
   
    [self.view addSubview:self.detailScroll];
    
    [self.upSuperView setFrame:CGRectMake(0, 0, self.detailScroll.width, 80.0f)];
    [self.detailScroll addSubview:self.upSuperView];

    btnCourierInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCourierInfo setFrame:CGRectMake(0, 0, floorf(self.upSuperView.width/3.0f*2.0f), self.upSuperView.height)];
    [btnCourierInfo setBackgroundColor:[UIColor clearColor]];
    [btnCourierInfo setAdjustsImageWhenHighlighted:false];
    [btnCourierInfo addTarget:self action:@selector(onClickWithCourierInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.upSuperView addSubview:btnCourierInfo];
    
    [self.upSuperView addSubview:self.imageIcon];
    [self.upSuperView addSubview:self.nicknameLabel];
    [self.upSuperView addSubview:self.companyLabel];
    [self.upSuperView addSubview:self.trackLevel];
    [self.upSuperView addSubview:self.progressLevel];
    [self.upSuperView addSubview:self.gradeLabel];
    [self.upSuperView addSubview:self.orderCountBtn];
    [self.upSuperView addSubview:self.phoneBtn];
    
    [self.detailScroll addSubview:self.constListLabel];
    [self.detailScroll addSubview:self.downSuperView];
    [self.downSuperView addSubview:self.totalTitle];
    [self.downSuperView addSubview:self.totalMoney];
    [self.downSuperView addSubview:self.lineView];
    
    [self.detailScroll addSubview:self.payStyleLabel];
    [self.detailScroll addSubview:self.paySuperView];
    
    [self.totalBalanceBtn addSubview:self.noBalanceLabel];
    
    [self.detailScroll addSubview:self.payAffirmButton];

    
    if (self.orderId.length > 0) {
        [self orderDetailRequest];
        [self payCostRequest];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.detailScroll setFrame:CGRectMake(0, KNavHeight, MainScreenWidth, MainScreenHeight - KNavHeight)];
    [self.upSuperView setFrame:CGRectMake(0, 0, self.detailScroll.width, 80.0f)];
    [btnCourierInfo setFrame:CGRectMake(0, 0, floorf(self.upSuperView.width/3.0f*2.0f), self.upSuperView.height)];
    
    [self.imageIcon setFrame:CGRectMake(15.0f, 15.0f, 40.0, 40.0)];
    [self.imageIcon.layer setCornerRadius:self.imageIcon.height/2.0f];
    [self.imageIcon.layer setMasksToBounds:true];
    [self.nicknameLabel setFrame:CGRectMake(self.imageIcon.right + kMargin, self.imageIcon.top, self.upSuperView.width - self.imageIcon.right*2.0f - kMargin*2.0f, 16.0f)];
    [self.companyLabel setFrame:CGRectMake(self.nicknameLabel.left, self.nicknameLabel.bottom + 6.0f, self.nicknameLabel.width, self.nicknameLabel.height)];
    [self.trackLevel setFrame:CGRectMake(self.companyLabel.left, self.companyLabel.bottom + 4.0f, 64.0f, 11.0f)];
    [self.progressLevel setFrame:self.trackLevel.frame];
    [self.gradeLabel setFrame:CGRectMake(self.trackLevel.right + 5.0f, self.trackLevel.top, 40.0f, 12.0f)];
    [self.gradeLabel.layer setCornerRadius:self.gradeLabel.height/2.0f];
    [self.gradeLabel.layer setMasksToBounds:true];
    [self.orderCountBtn setFrame:CGRectMake(self.gradeLabel.right + 5.0f, self.gradeLabel.top, self.gradeLabel.width, self.gradeLabel.height)];
    [self.phoneBtn setFrame:CGRectMake(self.upSuperView.width - 55.0f, self.imageIcon.top, 40.0f, 40.0f)];
    [self.constListLabel setFrame:CGRectMake(0, self.upSuperView.bottom, self.detailScroll.width, 30.0f)];
    [self.downSuperView setFrame:CGRectMake(0, self.constListLabel.bottom, self.detailScroll.width, 80.0f)];
    for (NSInteger i = 0; i < self.itemLabelArray.count; i++) {
        UILabel *itemLabel = self.itemLabelArray[i];
        [itemLabel setFrame:CGRectMake(15.0f, 16.0f + i*32, self.detailScroll.width - 30.0f, 16.0f)];
        UILabel *priceLabel = self.priceLabelArray[i];
        [priceLabel setFrame:itemLabel.frame];
    }
    [self.lineView setFrame:CGRectMake(self.payMoneyLabel.left, 15.5f + self.titleArray.count*32, self.downSuperView.width - self.payMoneyLabel.left, 0.5f)];
    
    [self.totalTitle setFrame:CGRectMake(self.payMoneyLabel.left, self.titleArray.count*32.0f + 16.0f, self.payMoneyLabel.width, 52.0f)];
    [self.downSuperView setSize:CGSizeMake(self.downSuperView.width, self.totalTitle.bottom)];
    [self.totalMoney setFrame:CGRectMake(self.payMoneyLabel.left, self.titleArray.count*32.0f + 16.0f, self.payMoneyLabel.width, 52.0f)];
    [self.payStyleLabel setFrame:CGRectMake(0, self.downSuperView.bottom, self.detailScroll.width, 30.0f)];
    [self.paySuperView setFrame:CGRectMake( 0, self.payStyleLabel.bottom, self.detailScroll.width, self.payTitlesArray.count*42.0f)];
    
    for (NSInteger i = 0; i < self.paySuperView.subviews.count; i ++) {
        UIButton *itemButton = self.paySuperView.subviews[i];
        [itemButton setFrame:CGRectMake(0, i *42.0f, self.paySuperView.width, 42.0f)];
       
        for (UILabel *itemLine in itemButton.subviews) {
            [itemLine setFrame:CGRectMake(15.0f, itemButton.height - 0.5f, itemButton.width - 15.0f, 0.5f)];
        }
        
        UIImageView *imageState = self.arrayPayStyle[i];
        [imageState setSize:CGSizeMake(15.0f, 15.0f)];
        [imageState setCenter:CGPointMake(itemButton.width - 15.0f - imageState.centerx, itemButton.centery)];
    }
    
    self.noBalanceLabel.frame = self.totalBalanceBtn.frame;
    self.noBalanceLabel.width = self.totalBalanceBtn.width - 15;
    
    [self.payAffirmButton setFrame:CGRectMake( 15.0f, MAX(self.paySuperView.bottom + 15.0f, self.detailScroll.height - 55.0f), self.detailScroll.width - 30.0f, 40.0f)];
    [self.payAffirmButton setBackgroundImage:[UIImage imageWithDrawColor:DDGreen_Color withSize:self.payAffirmButton.bounds] forState:UIControlStateNormal];
    [self.payAffirmButton.layer setCornerRadius:self.payAffirmButton.height/2.0f];
    [self.payAffirmButton.layer setMasksToBounds:true];
    
    [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, MAX(self.detailScroll.height, self.payAffirmButton.bottom + 15.0f))];
}

#pragma mark - Privite Method
/** 设置导航控制器 */
- (void)createNavigationBar
{
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:DDPayCostControllerPayExpressMoney segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
}

///**
// 设置羊角符号的大小
// */
//- (void) setLabelAttributedString: (UILabel *) label
//{
//    NSString *order_price =  label.text;
//    NSMutableAttributedString *att_order_price = [[NSMutableAttributedString alloc] initWithString:order_price];
//    [att_order_price addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(0, 1)];
//    [label setAttributedText:att_order_price];
//}

/**
 *  拨打电话
 */
- (void)callCustomerService:(NSString *)phone
{
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telUrl]]];
    
    [self.view addSubview:callWebview];
}

- (BOOL)configSelectedPayStyle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.payStyle forKey:@"indexPayStyle"];
    
    return [userDefaults synchronize];
}

- (DDPayCostStyle)getSelectedPayStyle {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DDPayCostStyle indexPayStyle = (DDPayCostStyle)[userDefaults integerForKey:@"indexPayStyle"];
    
    return indexPayStyle;
}

#pragma mark - Event Method
/** 订单数量 */
- (void)onClickWithOrderCount
{
    
}

/**  拨打电话 */
- (void)onClickWithPhone
{
    [self callCustomerService:self.orderDetail.courierPhone];
}

/**
    选择支付方式
    以KPayStyleItem为下标基数判断： @"支付宝",@"微信支付",@"apple pay",
 */
- (void)onClickWithItem:(UIButton *)sender
{
    self.payStyle = sender.tag%KPayStyleItem;
    //当选择的时候，显示当前的打勾图片，其他隐藏
    for (NSInteger i=0; i<self.arrayPayStyle.count; i++) {
        UIImageView *imageState = [self.arrayPayStyle objectAtIndex:i];
        [imageState setHidden:self.payStyle==i?false:true];
    }
    
    [self configSelectedPayStyle];
}



- (void)onClickWithStyle:(DDPayCostStyle)style
{
    NSInteger tag = style + KPayStyleItem;
    UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
    [self onClickWithItem:btn];
}

/** 确认支付按钮 */
- (void)onClickWithPayAffirm
{
    [self confirmPayRequest];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 进入快递员详情 */
- (void)onClickWithCourierInfo:(id)sender
{
    DDCourierDetailController *controller = [[DDCourierDetailController alloc] initWithCourierId:self.orderDetail.courierId];
    [self.navigationController pushViewController:controller  animated:YES];
}

#pragma mark - Service Request
/** 我的钱包 数据请求 */
- (void)walletWithRequest
{
    if (!self.interMyWallet)
    {
        self.interMyWallet = [[DDInterface alloc] initWithDelegate:self];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [self.interMyWallet interfaceWithType:INTERFACE_TYPE_MY_WALLET param:param];
}

/**
 *  订单信息
 */
- (void)orderDetailRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (![CustomStringUtils isBlankString:self.orderId]) {
        //订单ID
        [param setObject:self.orderId  forKey:@"orderId"];
    }

    self.interOrderDetail = [[DDInterface alloc] initWithDelegate:self];
    [self.interOrderDetail interfaceWithType:INTERFACE_TYPE_ORDER_DETAIL  param:param];
}

/**
 费用明细
 */
- (void)payCostRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (![CustomStringUtils isBlankString:self.orderId]) {
        //订单ID
        [param setObject:self.orderId  forKey:@"orderId"];
    }
    
    self.interPayCost = [[DDInterface alloc] initWithDelegate:self];
    [self.interPayCost interfaceWithType:INTERFACE_TYPE_COST_DETAIL  param:param];
}

/**
 *  确认支付请求
 */
- (void)confirmPayRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (![CustomStringUtils isBlankString:self.orderId]) {
        //订单ID
        [param setObject:self.orderId  forKey:@"orderId"];
    }
    
    [param setObject:@(self.payStyle)  forKey:@"type"];
    //[param setObject:@0  forKey:@"uYue"];
    
    if (self.confirmPayInterface == nil) {
        self.confirmPayInterface = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.confirmPayInterface interfaceWithType:INTERFACE_TYPE_PAY_PARAM  param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interPayCost)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            DDCostDetail *costDetail = [DDCostDetail yy_modelWithDictionary:result];
            
            self.costDetail = costDetail;
            
            [self walletWithRequest];
        }
    } else if(interface == self.interOrderDetail) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }else{
            DDOrderDetail *orderDetail = [DDOrderDetail yy_modelWithDictionary:result];
            self.orderDetail = orderDetail;
            self.orderDetail.orderId = self.orderId;
        }
    } else if (interface == self.interMyWallet) {
        if (result[@"yue"] == nil) {
            self.totalBalance = @"0.00";
        } else {
            self.totalBalance = [NSString stringWithFormat:@"%@",result[@"yue"]];
        }
    } else if (interface == self.confirmPayInterface) {
        [LSPay payWithType:(LSPayType)self.payStyle orderString:result[@"data"] completeClosure:^(NSString *errorMsg) {
            if ([errorMsg isEqualToString:LSPaySuccess]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorMsg message:@"是否对此单进行评价" delegate:self cancelButtonTitle:@"评价" otherButtonTitles:@"取消", nil];
                [alert show];
            }
        }];
    }
}

#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //回到订单列表页,删除订单列表页已支付项
    if ([self.delegate respondsToSelector:@selector(payCost:didClickCallBackConfirmBtnWithIndexPath:)]) {
        [self.delegate payCost:self didClickCallBackConfirmBtnWithIndexPath:self.indexPath];
    }
    
    if ([self.delegate respondsToSelector:@selector(payCostView:didClickBackConfirmBtnWithOrderId:)]) {
        [self.delegate payCostView:self didClickBackConfirmBtnWithOrderId:self.orderId];
    }

    
    
    if (buttonIndex == 0) {
        DDOrderDetailController *detailController = [[DDOrderDetailController alloc] initWithOrderStyle:DDOrderDetailControlStyleAnonymous];
        detailController.orderDetail = self.orderDetail;
        
        [self.navigationController pushViewController:detailController animated:YES];
        [self removeFromParentViewController];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - setter & getter
- (void)setTotalBalance:(NSString *)totalBalance
{
    _totalBalance = totalBalance;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalBalance];
    if ([totalBalance floatValue] < self.costDetail.orderCost) {
        [attributedString replaceCharactersInRange:NSMakeRange(0, attributedString.length) withString:@"余额支付"];
        [attributedString addAttribute:NSForegroundColorAttributeName value:TIME_COLOR range:NSMakeRange(0, attributedString.length)];
        self.totalBalanceBtn.userInteractionEnabled = NO;
        self.noBalanceLabel.hidden = NO;
        if (self.payStyle == DDPayCostStyleBalance) {
            [self onClickWithStyle:DDPayCostStyleAlipay];
        } else {
            [self onClickWithStyle:self.payStyle];
        }
        
    } else {
        [attributedString addAttribute:NSForegroundColorAttributeName value:DDRGBColor(255, 173, 74) range:NSMakeRange(0, attributedString.length)];
    }
    [self.totalBalanceBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (void)setOrderDetail:(DDOrderDetail *)orderDetail
{
    _orderDetail = orderDetail;
    self.nicknameLabel.text = orderDetail.courierName;
    self.companyLabel.text = orderDetail.companyName;
    self.gradeLabel.text = orderDetail.courierStar;
    
    [self.orderCountBtn setTitle:[NSString stringWithFormat:@"%zd 单",orderDetail.finishedCount] forState:UIControlStateNormal];
    [self.imageIcon sd_setImageWithURL:[NSURL URLWithString:orderDetail.courierIcon]];
    self.progressLevel.image = [UIImage imageNamed:[NSString stringWithFormat:@"star%ld",(long)[orderDetail.courierStar integerValue]]];
    
    NSTextAttachment *countArrow = [[NSTextAttachment alloc] init];
    [countArrow setImage:[UIImage imageNamed:@"orderArrow"]];
    [countArrow setBounds:CGRectMake(0, 1, 7.0f, 7.0f)];
    NSAttributedString *countIcon = [NSAttributedString attributedStringWithAttachment:countArrow];
    
    NSString *countTitle = self.orderCountBtn.titleLabel.text;
    NSMutableAttributedString *countTitleAttri = [[NSMutableAttributedString alloc] initWithString:countTitle];
    [countTitleAttri addAttribute:NSFontAttributeName value:kTimeFont range:NSMakeRange(0, countTitle.length)];
    [countTitleAttri addAttribute:NSForegroundColorAttributeName value:TIME_COLOR range:NSMakeRange(0, countTitle.length)];
    [countTitleAttri insertAttributedString:countIcon atIndex:countTitle.length];
    [self.orderCountBtn setAttributedTitle:countTitleAttri forState:UIControlStateNormal];
    
    CGSize countSize = [countTitle sizeWithAttributes:@{NSFontAttributeName : self.orderCountBtn.titleLabel.font}];
    [self.orderCountBtn setSize:CGSizeMake(floorf(countSize.width) + 8.0f, self.orderCountBtn.height)];
}

- (void)setCostDetail:(DDCostDetail *)costDetail
{
    _costDetail = costDetail;
    
    self.courierPriceLabel.text = [NSString stringWithFormat:@"%.2f 元",costDetail.originalCost] ;
    self.tipPriceLabel.text =  [NSString stringWithFormat:@"%.2f 元",costDetail.tipCost] ;
    self.lblInsurePrice.text = [NSString stringWithFormat:@"%.2f 元",costDetail.insuranceCost] ;
    self.couponPriceLabel.text =  [NSString stringWithFormat:@"%.2f 元",costDetail.couponDiscount] ;
    self.payMoneyLabel.text = [NSString stringWithFormat:@"%.2f 元",costDetail.orderCost] ;
    
//    [self setLabelAttributedString:self.courierPriceLabel];
//    [self setLabelAttributedString:self.tipPriceLabel];
//    [self setLabelAttributedString:self.lblInsurePrice];
//    [self setLabelAttributedString:self.payMoneyLabel];
    
    NSMutableAttributedString *couponPriceAttriStr = [[NSMutableAttributedString alloc] initWithString:self.couponPriceLabel.text];
    [couponPriceAttriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:NSMakeRange(1, 1)];
    [self.couponPriceLabel setAttributedText:couponPriceAttriStr];
    
    [self.payAffirmButton setTitle:[NSString stringWithFormat:@"确认支付%.2f元",costDetail.orderCost] forState:UIControlStateNormal];
    
    NSString *orderPrice = self.payMoneyLabel.text;
    NSRange rangePrefix = [orderPrice rangeOfString:@"元"];
    NSRange rangeOrder = NSMakeRange(0, orderPrice.length);
    
    NSMutableAttributedString *orderPriceAttri = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [orderPriceAttri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27.0f] range:rangeOrder];
    [orderPriceAttri addAttribute:NSFontAttributeName value:kContentFont range:rangePrefix];
    [self.totalMoney setAttributedText:orderPriceAttri];
    
    CGSize gradeSize = [self.gradeLabel.text sizeWithAttributes:@{NSFontAttributeName : self.gradeLabel.font}];
    [self.gradeLabel setSize:CGSizeMake(floorf(gradeSize.width)+12.0f, 12.0f)];
    
    [self.orderCountBtn setOrigin:CGPointMake(self.gradeLabel.right + 7.0f, self.gradeLabel.top)];
}

- (UIScrollView *)detailScroll
{
    if (_detailScroll == nil) {
        UIScrollView *detailScroll = [[UIScrollView alloc] init];
        [detailScroll setBackgroundColor:KBackground_COLOR];
        [detailScroll setShowsHorizontalScrollIndicator:NO];
        [detailScroll setShowsVerticalScrollIndicator:NO];
        _detailScroll = detailScroll;
    }
    return _detailScroll;
}

- (UIView *)upSuperView
{
    if (_upSuperView == nil) {
        UIView *upSuperView = [[UIView alloc] init];
        [upSuperView setBackgroundColor:[UIColor whiteColor]];
        _upSuperView = upSuperView;
    }
    return _upSuperView;
}

- (UIImageView *)imageIcon
{
    if (_imageIcon == nil) {
        UIImageView *imageIcon = [[UIImageView alloc] init];
        [imageIcon setBackgroundColor:KBackground_COLOR];
        _imageIcon = imageIcon;
    }
    return _imageIcon;
}

- (UILabel *)nicknameLabel
{
    if (_nicknameLabel == nil) {
        UILabel *nicknameLabel = [[UILabel alloc] init];
        [nicknameLabel setBackgroundColor:[UIColor clearColor]];
        [nicknameLabel setTextAlignment:NSTextAlignmentLeft];
        [nicknameLabel setFont:kTitleFont];
        [nicknameLabel setTextColor:TITLE_COLOR];
        _nicknameLabel = nicknameLabel;
    }
    return _nicknameLabel;
}

- (UILabel *)companyLabel
{
    if (_companyLabel == nil) {
        UILabel *companyLabel = [[UILabel alloc] init];
        [companyLabel setBackgroundColor:[UIColor clearColor]];
        [companyLabel setTextAlignment:NSTextAlignmentLeft];
        [companyLabel setFont:kTitleFont];
        [companyLabel setTextColor:TIME_COLOR];
        _companyLabel = companyLabel;
    }
    return _companyLabel;
}

- (UIImageView *)trackLevel
{
    if (_trackLevel == nil) {
        UIImageView *trackLevel = [[UIImageView alloc] init];
        [trackLevel setBackgroundColor:[UIColor clearColor]];
        _trackLevel = trackLevel;
    }
    return _trackLevel;
}

- (UIImageView *)progressLevel
{
    if (_progressLevel == nil) {
        UIImageView *progressLevel = [[UIImageView alloc] init];
        _progressLevel = progressLevel;
    }
    return _progressLevel;
}

- (UILabel *)gradeLabel
{
    if (_gradeLabel == nil) {
        UILabel *gradeLabel = [[UILabel alloc] init];
        [gradeLabel setBackgroundColor:DDGreen_Color];
        [gradeLabel setTextAlignment:NSTextAlignmentCenter];
        [gradeLabel setTextColor:[UIColor whiteColor]];
        [gradeLabel setFont:KCountFont];
        _gradeLabel = gradeLabel;
    }
    return _gradeLabel;
}

- (UIButton *)orderCountBtn
{
    if (_orderCountBtn == nil) {
        UIButton *orderCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderCountBtn setBackgroundColor:[UIColor clearColor]];
        [orderCountBtn.titleLabel setFont:kTimeFont];
        [orderCountBtn setTitleColor:TIME_COLOR forState:UIControlStateNormal];
        [orderCountBtn setAdjustsImageWhenHighlighted:false];
        [orderCountBtn addTarget:self action:@selector(onClickWithOrderCount) forControlEvents:UIControlEventTouchUpInside];
        _orderCountBtn = orderCountBtn;
    }
    return _orderCountBtn;
}

- (UIButton *)phoneBtn
{
    if (_phoneBtn == nil) {
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [phoneBtn.layer setCornerRadius:phoneBtn.height/2.0f];
        [phoneBtn.layer setMasksToBounds:true];
        [phoneBtn setAdjustsImageWhenHighlighted:false];
        [phoneBtn setBackgroundImage:[UIImage imageNamed:DDOrderPhone] forState:UIControlStateNormal];
        [phoneBtn addTarget:self action:@selector(onClickWithPhone) forControlEvents:UIControlEventTouchUpInside];
        _phoneBtn = phoneBtn;
    }
    return _phoneBtn;
}

- (UILabel *)constListLabel
{
    if (_constListLabel == nil) {
        UILabel *constListLabel = [[UILabel alloc] init];
        [constListLabel setBackgroundColor:[UIColor clearColor]];
        [constListLabel setTextAlignment:NSTextAlignmentCenter];
        [constListLabel setTextColor:TIME_COLOR];
        [constListLabel setFont:kTimeFont];
        [constListLabel setText:DDPayCostControllerConstList];
        _constListLabel = constListLabel;
    }
    return _constListLabel;
}

- (UILabel *)payMoneyLabel
{
    if (_payMoneyLabel == nil) {
        
    }
    return _payMoneyLabel;
}

- (UIView *)downSuperView
{
    if (_downSuperView == nil) {
        UIView *downSuperView = [[UIView alloc] init];

        [downSuperView setBackgroundColor:[UIColor whiteColor]];
        
        NSArray *arrayTitle = self.titleArray;
        for (NSInteger i=0; i<arrayTitle.count; i++)
        {
            UILabel *itemLabel = [[UILabel alloc] init];
            [itemLabel setBackgroundColor:[UIColor clearColor]];
            [itemLabel setTextAlignment:NSTextAlignmentLeft];
            [itemLabel setFont:kTitleFont];
            [itemLabel setTextColor:TIME_COLOR];
            [itemLabel setText:arrayTitle[i]];
            [downSuperView addSubview:itemLabel];
            [self.itemLabelArray addObject:itemLabel];
            
            UILabel *itemPrice = [[UILabel alloc] init];
            [itemPrice setBackgroundColor:[UIColor clearColor]];
            [itemPrice setTextAlignment:NSTextAlignmentRight];
            [itemPrice setFont:kTitleFont];
            [itemPrice setTextColor:TITLE_COLOR];
            [itemPrice setText:@"0元"];
            [downSuperView addSubview:itemPrice];
            [self.priceLabelArray addObject:itemPrice];
            
            if (i == 0) {
                //快递费
                self.courierPriceLabel = itemPrice;
            } else if (i == 1) {
                //小费
                self.tipPriceLabel = itemPrice;
            }else if (i == 2) {
                //优惠券
                self.couponPriceLabel = itemPrice;
                [itemPrice setTextColor:DDOrange_Color];
            } else if (i == 3) {
                //支付费用
                self.payMoneyLabel = itemPrice;
            }
        }
        _downSuperView = downSuperView;
    }
    return _downSuperView;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        UIImageView *lineView = [[UIImageView alloc] init];
        [lineView setBackgroundColor:BORDER_COLOR];
        _lineView = lineView;
    }
    return _lineView;
}

- (NSMutableArray *)itemLabelArray
{
    if (_itemLabelArray == nil) {
        _itemLabelArray = [NSMutableArray array];
    }
    return _itemLabelArray;
}

- (NSMutableArray *)priceLabelArray
{
    if (_priceLabelArray == nil) {
        _priceLabelArray = [NSMutableArray array];
    }
    return _priceLabelArray;
}

- (UILabel *)totalTitle
{
    if (_totalTitle == nil) {
        UILabel *totalTitle = [[UILabel alloc] init];
        [totalTitle setBackgroundColor:[UIColor clearColor]];
        [totalTitle setTextAlignment:NSTextAlignmentLeft];
        [totalTitle setTextColor:TIME_COLOR];
        [totalTitle setFont:kTitleFont];
        [totalTitle setText:@"应付金额"];
        _totalTitle = totalTitle;
    }
    return _totalTitle;
}

- (UILabel *)totalMoney
{
    if (_totalMoney == nil) {
        UILabel *totalMoney = [[UILabel alloc] init];
        [totalMoney setBackgroundColor:[UIColor clearColor]];
        [totalMoney setTextAlignment:NSTextAlignmentRight];
        [totalMoney setTextColor:DDGreen_Color];
        [totalMoney setFont:kTitleFont];
        _totalMoney = totalMoney;
    }
    return _totalMoney;
}

- (UILabel *)payStyleLabel
{
    if (_payStyleLabel == nil) {
        UILabel *payStyleLabel = [[UILabel alloc] init];
        [payStyleLabel setBackgroundColor:[UIColor clearColor]];
        [payStyleLabel setTextAlignment:NSTextAlignmentCenter];
        [payStyleLabel setTextColor:TIME_COLOR];
        [payStyleLabel setFont:kTimeFont];
        [payStyleLabel setText:DDPayCostControllerPayStyle];
        _payStyleLabel = payStyleLabel;
    }
    return _payStyleLabel;
}

- (UIView *)paySuperView
{
    if (_paySuperView == nil) {
        NSArray *payTitles = self.payTitlesArray;
        NSArray *payIcons  = self.payIconsArray;
        
        UIView *paySuperView = [[UIView alloc] init];

        [paySuperView setBackgroundColor:[UIColor whiteColor]];
        
        for (int i = 0; i < payTitles.count; i++)
        {
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [itemButton setBackgroundColor:[UIColor whiteColor]];
            [itemButton setTag:KPayStyleItem + i];
            [itemButton setAdjustsImageWhenHighlighted:false];
            [itemButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15.0f, 0, 0)];
            [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
            [paySuperView addSubview:itemButton];
            
            //给字符串添加图标
            if (((NSString *)payIcons[i]).length >0 ) {
                NSTextAttachment *itemArrow = [[NSTextAttachment alloc] init];
                [itemArrow setImage:[UIImage imageNamed:payIcons[i]]];
                [itemArrow setBounds:CGRectMake(0, -10, 30.0f, 30.0f)];
                NSAttributedString *itemIcon = [NSAttributedString attributedStringWithAttachment:itemArrow];
                
                //给按钮添加Title
                NSString *itemTitle = [NSString stringWithFormat:@"   %@",payTitles[i]];
                NSRange  rangeItem = NSMakeRange(0, itemTitle.length);
                NSMutableAttributedString *itemTitleAttri = [[NSMutableAttributedString alloc] initWithString:itemTitle];
                [itemTitleAttri addAttribute:NSFontAttributeName value:kTitleFont range:rangeItem];
                [itemTitleAttri addAttribute:NSForegroundColorAttributeName value:TITLE_COLOR range:rangeItem];
                [itemTitleAttri insertAttributedString:itemIcon atIndex:0];
                [itemButton setAttributedTitle:itemTitleAttri forState:UIControlStateNormal];
            } else {
                
                [itemButton setTitle:payTitles[i] forState:UIControlStateNormal];
                itemButton.titleLabel.font = kTitleFont;
                
                
                if (i == 0) {
                    _totalBalanceBtn = itemButton;
                    UILabel *noBalanceLabel = [[UILabel alloc] init];
                    noBalanceLabel.frame = self.totalBalanceBtn.frame;
                    noBalanceLabel.width = self.totalBalanceBtn.width - 15;
                    noBalanceLabel.textAlignment = NSTextAlignmentRight;
                    noBalanceLabel.font = kTitleFont;
                    noBalanceLabel.textColor = TIME_COLOR;
                    noBalanceLabel.text = @"余额不足";
                    noBalanceLabel.hidden = YES;
                    _noBalanceLabel = noBalanceLabel;
                    
                }
            }
            
            //创建打勾的图片
            UIImageView *imageState = [[UIImageView alloc] init];

            [imageState setBackgroundColor:[UIColor clearColor]];
            [imageState setImage:[UIImage imageNamed:DDChoseIcon]];
            [imageState setHidden:self.payStyle==i?false:true];
            [itemButton addSubview:imageState];
            
            [self.arrayPayStyle addObject:imageState];
            
            if (i < payTitles.count-1) {
                //分界线
                UILabel *itemLine = [[UILabel alloc] init];
                [itemLine setFrame:CGRectMake(15.0f, itemButton.height - 0.5f, itemButton.width - 15.0f, 0.5f)];
                [itemLine setBackgroundColor:BORDER_COLOR];
                [itemButton addSubview:itemLine];
            }
        }
        _paySuperView = paySuperView;
    }
    return _paySuperView;
}

- (UIButton *)payAffirmButton
{
    if (_payAffirmButton == nil) {
        UIButton *payAffirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [payAffirmButton setAdjustsImageWhenHighlighted:false];
        [payAffirmButton.titleLabel setFont:kButtonFont];
        [payAffirmButton setUserInteractionEnabled:true];
        [payAffirmButton setTitle:@"确认支付" forState:UIControlStateNormal];
        [payAffirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payAffirmButton addTarget:self action:@selector(onClickWithPayAffirm) forControlEvents:UIControlEventTouchUpInside];
        _payAffirmButton = payAffirmButton;
    }
    return _payAffirmButton;
}

- (NSMutableArray *)arrayPayStyle
{
    if (_arrayPayStyle == nil) {
        _arrayPayStyle = [NSMutableArray array];
    }
    return _arrayPayStyle;
}

@end
