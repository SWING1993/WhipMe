//
//  DDCheckCostDetailController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDCheckCostDetailController.h"
#import "DDCostDetail.h"
#import "YYModel.h"

@interface DDCheckCostDetailController () <DDInterfaceDelegate>
{
    //评分数
    NSInteger _GradeCount;
}

/** 本视图的整体滚动视图 */
@property (strong, nonatomic) UIScrollView *detailScroll;
/** 订单费用 */
@property (strong, nonatomic) UILabel *lblOrderPrice;
/** 消息提示（费用详情） */
@property (strong, nonatomic) UILabel *lblMessage;
/** 快递费 */
@property (strong, nonatomic) UILabel *lblCourierPrice;
 /** 小费 */
@property (strong, nonatomic) UILabel *lblTipPrice;
/** 保费 */
@property (strong, nonatomic) UILabel *lblInsurePrice;
/** 优惠券 */
@property (strong, nonatomic) UILabel *lblCouponPrice;
 /** 支付费用 */
@property (strong, nonatomic) UILabel *lblPayMoney;
/** 余额 */
@property (strong, nonatomic) UILabel *lblExtraMoney;
/** 明细数据模型 */
@property (nonatomic,strong) DDCostDetail *costData;
/** 支付方式的标签 */
@property (nonatomic,strong) UILabel  *lblPayMoneyTitle;
/**
 *  网络请求
 */
@property (nonatomic, strong) DDInterface *interCheckCost;
@end

@implementation DDCheckCostDetailController
@synthesize detailScroll;
@synthesize lblOrderPrice;
@synthesize lblMessage;

@synthesize lblTipPrice;
@synthesize lblCouponPrice;
@synthesize lblCourierPrice;
@synthesize lblInsurePrice;
@synthesize lblPayMoney;

#pragma mark - 初始化生成临时数据
- (instancetype)initWithOrderId:(NSString *)order
{
    self = [self init];
    if (self) {
        [self checkCostDetailRequest:order];
    }
    return self;
}

/**
 *  费用明细
 */
- (void)checkCostDetailRequest:(NSString *)order
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //订单 ID
    [param setObject:order forKey:@"orderId"];
    
    //初始化连接
    DDInterface *interface = [[DDInterface alloc] initWithDelegate:self];
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [interface interfaceWithType:INTERFACE_TYPE_COST_DETAIL param:param];
    
    self.interCheckCost = interface;
}


#pragma mark - DDInterfaceDelegate 用于数据获取
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interCheckCost)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            DDCostDetail *detail = [DDCostDetail yy_modelWithDictionary:result];
            self.costData = detail;
        }
    }
}


#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"查看明细" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //初始化界面的控件
    [self ddCreateForViewControl];
}


-(void)setCostData:(DDCostDetail *)costData
{
    _costData = costData;
    [lblCourierPrice setText:[NSString stringWithFormat:@"%.2f元",costData.originalCost]];
    [lblTipPrice setText:[NSString stringWithFormat:@"%.2f元",costData.tipCost]];
    [lblInsurePrice setText:[NSString stringWithFormat:@"%.2f元",costData.couponDiscount]];
    [lblCouponPrice setText:[NSString stringWithFormat:@"-%.2f元",costData.insuranceCost]];
    [lblPayMoney setText:[NSString stringWithFormat:@"%.2f元",costData.orderCost]];
    [self.lblExtraMoney setText:[NSString stringWithFormat:@"-%.2f元",costData.balance]];
    
    if (costData.payType == 0) {
        self.lblPayMoneyTitle.text = @"支付宝";
    }else if (costData.payType == 1) {
        self.lblPayMoneyTitle.text = @"微信";
    }else if (costData.payType == 2) {
        self.lblPayMoneyTitle.text = @"银联";
    }else if (costData.payType == 3) {
        self.lblPayMoneyTitle.text = @"Apple Pay";
    }
    
    NSString * orderPayType = @"";
    
    if (costData.orderPayType == 0 ) {
        orderPayType = @"总计";
    }else if(costData.orderPayType == 1 ) {
        orderPayType = @"到付";
    }
    
    NSString *orderPrice = [NSString stringWithFormat:@"%@",lblPayMoney.text];
    NSRange priceRange = [orderPrice rangeOfString:@"元"];
    NSMutableAttributedString *orderPriceAtt = [[NSMutableAttributedString alloc] initWithString:orderPrice];
    [orderPriceAtt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:priceRange];
    [lblOrderPrice setAttributedText:orderPriceAtt];
}


/**
 初始化界面的控件
 */
- (void)ddCreateForViewControl
{
    CGFloat padding = 45;
    
    //创建滚动视图，作为界面的所有内容父视图
    detailScroll = [[UIScrollView alloc] init];
    [detailScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
    [detailScroll setBackgroundColor:[UIColor whiteColor]];
    [detailScroll setShowsHorizontalScrollIndicator:false];
    [detailScroll setShowsVerticalScrollIndicator:false];
    [self.view addSubview:detailScroll];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.frame = CGRectMake(padding, 34, detailScroll.width - padding*2, 15);
    [lineView setImage:[UIImage imageNamed:DDCheckCostLine]];
    lineView.contentMode = UIViewContentModeCenter;
    [detailScroll addSubview:lineView];
    
    
    //消息提示（费用详情)
    lblMessage = [[UILabel alloc] init];
    lblMessage.frame = lineView.frame;
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    [lblMessage setTextAlignment:NSTextAlignmentCenter];
    [lblMessage setFont:kTitleFont];
    [lblMessage setTextColor:TIME_COLOR];
    [lblMessage setText:@"费用详情"];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    [detailScroll addSubview:lblMessage];

    
    //订单费用总计
    lblOrderPrice = [[UILabel alloc] init];
    lblOrderPrice.frame = CGRectMake(padding, lineView.bottom + 15, lineView.width, 35);
    [lblOrderPrice setTextAlignment:NSTextAlignmentCenter];
    [lblOrderPrice setFont:[UIFont systemFontOfSize:34.0f]];
    [lblOrderPrice setTextColor:TITLE_COLOR];
    [lblOrderPrice setText:@"3.00元"];
    [lblOrderPrice setNumberOfLines:0];
    [detailScroll addSubview:lblOrderPrice];
    
    /**
        循环创建费用明细标签
     */
    UIView *itemsView = [[UIView alloc] init];
    itemsView.frame = CGRectMake(padding, lblOrderPrice.bottom + 30, lineView.width, detailScroll.height - lineView.bottom);
    [detailScroll addSubview:itemsView];
    
    NSArray *arrayTitle = [NSArray arrayWithObjects:@"快递费",@"小费",@"保费",@"优惠券",@"余额",@"支付宝", nil];
    for (NSInteger i=0; i<arrayTitle.count; i++)
    {
        CGFloat itemPadding = 30;
        UILabel *itemLabel = [[UILabel alloc] init];
        [itemLabel setFrame:CGRectMake(0, i*itemPadding, itemsView.width, 15.0f)];
        [itemLabel setBackgroundColor:[UIColor clearColor]];
        [itemLabel setTextAlignment:NSTextAlignmentLeft];
        [itemLabel setFont:kTitleFont];
        [itemLabel setTextColor:TIME_COLOR];
        [itemLabel setText:arrayTitle[i]];
        [itemsView addSubview:itemLabel];
        
        UILabel *itemPrice = [[UILabel alloc] init];
        [itemPrice setFrame:itemLabel.frame];
        [itemPrice setBackgroundColor:[UIColor clearColor]];
        [itemPrice setTextAlignment:NSTextAlignmentRight];
        [itemPrice setFont:kTitleFont];
        [itemPrice setTextColor:TITLE_COLOR];
        [itemsView addSubview:itemPrice];
        
        if (i == 0) {
            //快递费
            lblCourierPrice = itemPrice;
        } else if (i == 1) {
            //小费
            lblTipPrice = itemPrice;
        } else if (i == 2) {
            //保费
            lblInsurePrice = itemPrice;
        } else if (i == 3) {
            //优惠券
            lblCouponPrice = itemPrice;
        } else if (i == 4) {
            self.lblExtraMoney = itemPrice;
        } else if (i == 5) {
            //支付费用
            lblPayMoney = itemPrice;
            self.lblPayMoneyTitle = itemLabel;
        }
    }
    [lblCouponPrice setTextColor:DDOrange_Color];
    [self.lblExtraMoney setTextColor:DDOrange_Color];
    [lblPayMoney setTextColor:DDGreen_Color];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    [lineLabel setFrame:CGRectMake(0, self.lblExtraMoney.bottom + 15.0f, itemsView.width, 0.5f)];
    [lineLabel setBackgroundColor:BORDER_COLOR];
    [itemsView addSubview:lineLabel];
    
    self.lblPayMoney.y = lineLabel.y + 14;
    self.lblPayMoneyTitle.y = lineLabel.y + 14;
    
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
