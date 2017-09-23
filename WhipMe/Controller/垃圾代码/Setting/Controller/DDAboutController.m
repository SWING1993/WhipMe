//
//  DDAboutController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDAboutController.h"
#import "Constant.h"
#import "NSBundle+AppIcon.h"

#define DDAboutLogoImageHeight 220
#define DDAboutIntroductionHeight 220
#define DDAboutMainText @"艾特小哥是一款快递在线服务应用，为用户提供快递查询、在线寄件、物流跟踪等服务，致力于解决用户与快递员之间由于位置、时间、信息不对称而导致的寄收快递体验差的问题。"

@interface DDAboutController ()
@property (nonatomic, strong) UILabel *lblMessage;
@end

@implementation DDAboutController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DDRGBAColor(253, 253, 253, 1);
    [self initNavBar];
    //设置页面
    [self setAboutView];
}

#pragma mark - 对象方法:设置页面
- (void)initNavBar
{
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"关于" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(@"back") highlightedImage:ImageNamed(@"back")];
}




- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 设置关于页面
 */
- (void)setAboutView
{
    //    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    //    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    //设置logo图像
    UIButton *imageLogo = [[UIButton alloc] init];
    [imageLogo setSize:CGSizeMake(self.view.width,137)];
    [imageLogo setOrigin:CGPointMake(0, 64)];
    [imageLogo setBackgroundColor:[UIColor clearColor]];
    imageLogo.contentMode = UIViewContentModeCenter;
    [imageLogo setImage:[UIImage imageNamed:@"AboutUs"] forState:UIControlStateNormal];
    imageLogo.userInteractionEnabled = NO;
    [self.view addSubview:imageLogo];
    
    
    UIView *greenLineView = [[UIView alloc]initWithFrame:CGRectMake(self.view.width/2 - 17, 64 + 155, 34, 3)];
    greenLineView.backgroundColor = DDRGBAColor(32, 198, 122, 1);
    [self.view addSubview:greenLineView];
    
    
    //设置版本号标签
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.frame = CGRectMake(15, 104 + KNavHeight, self.view.width-30, 40.0f);
    versionLabel.textColor = DDRGBAColor(102, 102, 102, 1);
    versionLabel.font = [UIFont systemFontOfSize:12];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    //CFBundleVersion
    NSString *nowVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [versionLabel setText:[NSString stringWithFormat:@"艾特小哥 v%@",nowVersion]];
    
    
    //设置介绍文本
    UILabel *introductionText = [[UILabel alloc] init];
    introductionText.origin = CGPointMake(47, 180 + kMargin);
    introductionText.numberOfLines = 0;
    introductionText.textColor = DDRGBAColor(153, 153, 153, 1);
    introductionText.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:introductionText];
    self.lblMessage = introductionText;
    [self setUpContentLabel:DDAboutMainText];
    
    
    
    
    UILabel *downTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.view.height-60, self.view.width-30, 30)];
    downTitleLabel.text = @"艾特小哥";
    downTitleLabel.font = [UIFont systemFontOfSize:18];
    downTitleLabel.textColor = DDRGBAColor(188, 188, 188, 1);
    downTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:downTitleLabel];
    
    UILabel *downCopyrightLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.view.height-30, self.view.width-30, 13)];
    downCopyrightLabel.text = @"©2015 aitexiaoge.com all rights reserved";
    downCopyrightLabel.font = [UIFont systemFontOfSize:12];
    downCopyrightLabel.textColor = DDRGBAColor(188, 188, 188, 1);
    downCopyrightLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:downCopyrightLabel];
}



/**
 *  设置固定宽度    可调高度的label
 */
- (void)setUpContentLabel:(NSString *)strMsg
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineSpacing:5.0f];
    
    //定义字符串颜色，大小，行距设置
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle,NSForegroundColorAttributeName:DDRGBAColor(153, 153, 153, 1)};
    //定义可编辑字符串
    NSMutableAttributedString *attMsg = [[NSMutableAttributedString alloc] initWithString:strMsg attributes:attributes];
    //添加设置
    [self.lblMessage setAttributedText:attMsg];
    
    //根据字符串获取长度
    CGSize sizeMsg = [strMsg sizeWithAttributes:attributes];
    CGFloat widthMsg = self.view.width-94;
    //判断字符串长度是否大于默认值，并计算换行的视图大小
    if (floorf(sizeMsg.width) > widthMsg)
    {
        sizeMsg = [strMsg boundingRectWithSize:CGSizeMake(widthMsg, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil].size;
    }
    //根据计算的Size，设置消息标签的Frame
    [self.lblMessage setSize:CGSizeMake(widthMsg, floorf(sizeMsg.height)+1.0f)];
    self.lblMessage.x = 47;
    self.lblMessage.y = 180 + 64;
}

@end
