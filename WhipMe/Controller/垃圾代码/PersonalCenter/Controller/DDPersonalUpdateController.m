//
//  DDPersonalUpdateController.m
//  DDExpressCourier
//
//  Created by yangg on 16/2/26.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPersonalUpdateController.h"
#import "DDPhoneChangedController.h"


#define DDPUToLabel 14
#define DDPUButtonSpace 15.0f
#define DDPersonalLabelSpaceToButton 12

@interface DDPersonalUpdateController ()
{
    
}

/** 顶部白色背景 */
@property (nonatomic, strong) UIButton *viewCurrent;
/** 电话 */
@property (nonatomic, strong) UILabel *lblPhone;
/** 下一步操作按钮 */
@property (nonatomic, strong) UIButton *btnSubmit;

@end

@implementation DDPersonalUpdateController
@synthesize viewCurrent;
@synthesize lblPhone;
@synthesize btnSubmit;

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:WHITE_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"更换手机号" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //创建本界面的所有消息控件
    [self ddCreateForContent];
    
    //创建"确认更换"按钮
    [self ddCreateForButton];
    
    //显示当前手机号
    NSString *userPhone = [DDInterfaceTool getPhoneNumber];
    if (![userPhone isEqualToString:@""] && userPhone != nil) {
        [lblPhone setText:userPhone];
    }
    
}

#pragma mark - 类的对象方法:设置界面
/**
    创建本界面的所有消息控件
 */
- (void)ddCreateForContent
{
    
    viewCurrent = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewCurrent setFrame:CGRectMake(0, 64, self.view.width, 64.0f)];
    [viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [viewCurrent setAdjustsImageWhenHighlighted:false];
    [viewCurrent.titleLabel setFont:kTitleFont];
    [viewCurrent setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [viewCurrent setTitle:@"手机号" forState:UIControlStateNormal];
    [viewCurrent setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [viewCurrent setContentEdgeInsets:UIEdgeInsetsMake(7, DDPUButtonSpace, -7, 0)];
    [self.view addSubview:viewCurrent];
  
    lblPhone = [[UILabel alloc] init];
    [lblPhone setFrame:CGRectMake(0, 20, viewCurrent.width - DDPUButtonSpace, viewCurrent.height - 20)];
    [lblPhone setBackgroundColor:[UIColor clearColor]];
    [lblPhone setTextColor:TIME_COLOR];
    [lblPhone setFont:kTitleFont];
    [lblPhone setTextAlignment:NSTextAlignmentRight];
    [viewCurrent addSubview:lblPhone];
    
    UILabel *lblLine = [[UILabel alloc] init];
    [lblLine setFrame:CGRectMake(15, viewCurrent.height - 0.5f, viewCurrent.width, 0.5f)];
    [lblLine setBackgroundColor:BORDER_COLOR];
    [viewCurrent addSubview:lblLine];

}

/**
 创建"确认更换"按钮 和 标签
 */
- (void)ddCreateForButton
{
    btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake( DDPUButtonSpace, viewCurrent.bottom+50.0f, self.view.width -2* DDPUButtonSpace, 44.0f)];
    [btnSubmit.layer setCornerRadius:btnSubmit.height/2.0f];
    [btnSubmit.layer setMasksToBounds:true];
    [btnSubmit setBackgroundColor:DDGreen_Color];
    [btnSubmit.titleLabel setFont:kButtonFont];
    [btnSubmit setTitle:@"更改手机号" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(onClickWithSubmit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSubmit];
    
    UILabel * label = [[UILabel alloc] init];
    label.x = 0;
    label.y = btnSubmit.bottom+DDPersonalLabelSpaceToButton;
    label.height = DDPUToLabel;
    label.width = self.view.width;
    label.textColor = TIME_COLOR;
    label.font = kTimeFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"更改后个人信息不变，可以使用新号码登录";
    [self.view addSubview:label];
}

#pragma mark - 对象方法:监听点击
/** 下一步按钮操作的事件 */
- (void)onClickWithSubmit
{
    DDPhoneChangedController *changeControl = [[DDPhoneChangedController alloc] init];
    [self.navigationController pushViewController:changeControl animated:true];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
