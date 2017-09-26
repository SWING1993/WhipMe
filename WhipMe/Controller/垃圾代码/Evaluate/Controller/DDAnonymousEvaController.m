//
//  DDAnonymousEvaController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDAnonymousEvaController.h"
#import "DDCheckCostDetailController.h"
#import "DDComplainController.h"

@interface DDAnonymousEvaController ()
/** 一颗星按钮 */
@property (nonatomic,strong) IBOutlet UIButton * oneStarButton;
/** 两颗星按钮 */
@property (nonatomic,strong) IBOutlet UIButton * twoStarButton;
/** 三颗星按钮 */
@property (nonatomic,strong) IBOutlet UIButton * threeStarButton;
/** 四颗星按钮 */
@property (nonatomic,strong) IBOutlet UIButton * fourStarButton;
/** 五颗星按钮 */
@property (nonatomic,strong) IBOutlet UIButton * fiveStarButton;
@end

@implementation DDAnonymousEvaController

#pragma mark -- 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -- 类对象方法，点击事件
/** 
    星星按钮触发的事件
 */
- (IBAction)StarAction:(id)sender
{
    
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"DDEvaView" owner:self options:nil];
    UIView  * view = [nib objectAtIndex:0];
    [self setAnimation:view];
    [self.view addSubview:view];
    
    UIButton *button = (UIButton *)sender;
    for (UIView *object in [view subviews]){
        if ([[object restorationIdentifier] isEqualToString:@"StarView"]) {
            
            UIView  * StarView = [nib objectAtIndex:button.tag];
            [StarView setFrame:CGRectMake(0, 0, CGRectGetWidth(object.frame), CGRectGetHeight(object.frame))];
            [object addSubview:StarView];
            for (UIView * object in [StarView subviews]) {
                if (object.tag == 1 || object.tag == 2 ||object.tag == 3 ||object.tag == 4 ||object.tag == 5)
                {
                    UIButton * button = (UIButton *)object;
                    [button addTarget:self action:@selector(evaStarAction:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
}


/** 
    设置从底部弹出窗口的动画
 */
- (void) setAnimation : (UIView *) view
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    [view setFrame:CGRectMake(0, screen.size.height, screen.size.width, screen.size.height-100)];
    [UIView beginAnimations:@"animateQjsjView" context:nil];
    [UIView setAnimationDuration:0.4];
    [view setFrame:CGRectMake(0, 100, screen.size.width, screen.size.height-100)];
    [UIView commitAnimations];
    view.opaque = NO;
}

/** 
    弹出的窗口上星星按钮的触发事件
 */
- (IBAction)evaStarAction:(id)sender
{
    UIButton * button = (UIButton *)sender;
    UIView * secondSuperView = [button superview];
    UIView * firstSuperView = [secondSuperView superview];

    [secondSuperView removeFromSuperview];
    
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"DDEvaView" owner:self options:nil];

    UIView  * StarView = [nib objectAtIndex:button.tag];
    [StarView setFrame:CGRectMake(0, 0, CGRectGetWidth(firstSuperView.frame), CGRectGetHeight(firstSuperView.frame))];
    [firstSuperView addSubview:StarView];
    
    for (UIView * object in [StarView subviews]) {
        if (object.tag == 1 || object.tag == 2 ||object.tag == 3 ||object.tag == 4 ||object.tag == 5)
        {
            UIButton * button = (UIButton *)object;
            [button addTarget:self action:@selector(evaStarAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    };

    [firstSuperView setNeedsDisplay];
}

/** 
    弹出查看明细窗口
 */
 -(IBAction)checkCostDetailAction:(id)sender
{
    DDCheckCostDetailController *checkCostDetailController = [[DDCheckCostDetailController alloc] init];
    [self.navigationController pushViewController:checkCostDetailController animated:YES];
}

/**
    弹出投诉窗口
 */
- (IBAction)complainAction:(id)sender
{
    DDComplainController *complainController = [[DDComplainController alloc] init];
    [self.navigationController pushViewController:complainController animated:YES];
}
@end
