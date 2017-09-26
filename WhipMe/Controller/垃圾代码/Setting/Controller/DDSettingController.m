//
//  DDSettingController.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/2/24.
//  Copyright © 2016年 NS. All rights reserved.
//

#define KSettingItem 7777

#import "DDSettingController.h"
#import "DDChangePassController.h"
#import "DDFeedbackController.h"
#import "DDAboutController.h"
#import "DDContractController.h"
#import "DDGlobalVariables.h"
#import "DDWebViewController.h"
#import "Constant.h"
#import "DDLocalUserInfoUtils.h"
#import "LSJPush.h"

@interface DDSettingController () <DDInterfaceDelegate>

@property (nonatomic, strong) NSMutableArray *arrayTitle;
/** 本视图的整体滚动视图 */
@property (nonatomic, strong) UIScrollView *detailScroll;
/** 上半部分的白色父视图 */
@property (nonatomic, strong) UIView *viewCurrent;
/** 退出按钮 */
@property (nonatomic, strong) UIButton *btnExit;
/** 退出登录 */
@property (nonatomic, strong) DDInterface *interfaceLogout;

@end

@implementation DDSettingController
@synthesize detailScroll;
@synthesize viewCurrent;
@synthesize btnExit;

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:KBackground_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"设置" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //本视图的整体滚动视图
    [self ddCreateForScrollView];
    
}

#pragma mark - 类对象方法:设置页面

/**
    本视图的整体滚动视图
 */
- (void)ddCreateForScrollView
{
    detailScroll = [[UIScrollView alloc] init];
    [detailScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
    [detailScroll setBackgroundColor:[UIColor clearColor]];
    [detailScroll setShowsHorizontalScrollIndicator:false];
    [detailScroll setShowsVerticalScrollIndicator:false];
    [self.view addSubview:detailScroll];
    
    //viewCurrent，并添加按钮
    [self ddCreateForUserViewItem];
    
    //创建下一步按钮
    [self ddCreateForButton];
}

/**
    新建viewCurrent视图
    包含："意见反馈","给嘟嘟好评","关于嘟嘟","服务条款"
 */
- (void)ddCreateForUserViewItem
{
    //初始化viewCurrent视图
    viewCurrent = [[UIView alloc] init];
    [viewCurrent setFrame:CGRectMake(0, 0, detailScroll.width, self.arrayTitle.count*45.0f)];
    [viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [detailScroll addSubview:viewCurrent];
    
    //上边框线
    UILabel *lineView = [[UILabel alloc] init];
    [lineView setFrame:CGRectMake(0, 0, viewCurrent.width, 0.5f)];
    [lineView setBackgroundColor:BORDER_COLOR];
    [viewCurrent addSubview:lineView];
    
    for (NSInteger k=0; k<self.arrayTitle.count; k++)
    {
        //初始化按钮，根据Tag下标来判断
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(0, k*45.0f, viewCurrent.width, 45.0f)];
        [itemButton setBackgroundColor:[UIColor clearColor]];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [itemButton setContentEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [itemButton setTag:k + KSettingItem];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
        [itemButton setTitle:[self.arrayTitle objectAtIndex:k] forState:UIControlStateNormal];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [viewCurrent addSubview:itemButton];
        
        //按钮的背景图片／高亮效果
        UIImage *msgNormal = [UIImage imageWithDrawColor:[UIColor clearColor] withSize:itemButton.bounds];
        UIImage *Highlighted = [UIImage imageWithDrawColor:BORDER_COLOR withSize:itemButton.bounds];
        [itemButton setBackgroundImage:msgNormal forState:UIControlStateNormal];
        [itemButton setBackgroundImage:Highlighted forState:UIControlStateHighlighted];
        
        //右边箭头icon
        UIImageView *imageArrow = [[UIImageView alloc] init];
        [imageArrow setSize:CGSizeMake(10.0f, 12.0f)];
        [imageArrow setCenter:CGPointMake(itemButton.width - 15.0f, itemButton.centery)];
        [imageArrow setImage:[UIImage imageNamed:KDDIconPDArraw]];
        [itemButton addSubview:imageArrow];
        
        //每一项的下划线(最后一行不要)
        if (k < self.arrayTitle.count-1) {
            UILabel *lblLine = [[UILabel alloc] init];
            [lblLine setFrame:CGRectMake(15, itemButton.height - 0.5f, itemButton.width, 0.5f)];
            [lblLine setBackgroundColor:BORDER_COLOR];
            [itemButton addSubview:lblLine];
        }
    }
}

/** 初始化退出账号按钮 */
- (void)ddCreateForButton
{
    btnExit = [[UIButton alloc]init];
    [btnExit setFrame:CGRectMake( 0, self.view.height - 45.0f, self.view.width, 45.0f)];
    [btnExit setBackgroundImage:[UIImage imageWithDrawColor:[UIColor whiteColor] withSize:btnExit.bounds] forState:UIControlStateNormal];
    [btnExit setBackgroundImage:[UIImage imageWithDrawColor:DDGreen_Color withSize:btnExit.bounds] forState:UIControlStateHighlighted];
    [btnExit.titleLabel setFont:kTitleFont];
    [btnExit setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [btnExit setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [btnExit setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnExit addTarget:self action:@selector(onClickWithExit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExit];
}

#pragma mark - 类的对象方法:监听点击
/**
    按钮的响应事件，根据Tag下标判断
    包含：@"意见反馈",@"给小哥好评",@"关于小哥",@"服务条款"
 */
- (void)onClickWithItem:(UIButton *)sender
{
    NSInteger index = sender.tag % KSettingItem;
    if (index == 0) {
        DDFeedbackController *control = [[DDFeedbackController alloc] init];
        [self.navigationController pushViewController:control animated:true];
    } else if (index == 1) {
        
        NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", ATXIAOGEAPPID];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    } else if (index == 2) {
        DDAboutController *control = [[DDAboutController alloc] init];
        [self.navigationController pushViewController:control animated:true];
    } else if (index == 3) {
        DDWebViewController *control = [[DDWebViewController alloc] init];
        control.URLString = ServiceTermsHtmlUrlStr;
        control.navTitle = @"服务条款";
        [self.navigationController pushViewController:control animated:true];
    }
}

/**
    退出按钮的响应事件
 */
- (void)onClickWithExit:(id)sender
{
    [self feedBackDetailWithRequest];
    
    [LSJPush setTags:[NSSet set] alias:@"" resBlock:^(BOOL res, NSSet *tags, NSString *alias) {
        if(res){
            NSLog(@"设置成功：%@,%@",@(res),alias);
        }else{
            NSLog(@"设置失败");
        }
    }];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)arrayTitle
{
    if (!_arrayTitle) {
        _arrayTitle = [NSMutableArray arrayWithObjects:@"意见反馈",@"给小哥好评",@"关于小哥",@"服务条款", nil];
    }
    return _arrayTitle;
}

#pragma mark - 获取网络数据
/**
 *  退出登录 网络请求
 *  可用于刷新
 */
- (void)feedBackDetailWithRequest
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //初始化连接
    if (!self.interfaceLogout) {
        self.interfaceLogout = [[DDInterface alloc] initWithDelegate:self];
    }
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [self.interfaceLogout interfaceWithType:INTERFACE_TYPE_LOGOUT param:param];
}

#pragma mark - DDInterfaceDelegate
/**<  得到网络反回结果  */
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceLogout) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            
            [DDLocalUserInfoUtils removeLocalUserInfo];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }
}

@end
