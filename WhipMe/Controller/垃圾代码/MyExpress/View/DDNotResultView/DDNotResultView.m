//
//  DDNotResultView.m
//  DDExpressClient
//
//  Created by yangg on 16/4/12.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNotResultView.h"
#import "Constant.h"

@interface DDNotResultView ()

/** 图片 icon */
@property (nonatomic, strong) UIButton *iconView;
/** 文本内容 */
@property (nonatomic, strong) UILabel *contentLabel;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *nextButton;
/** 文本编辑属性 */
@property (nonatomic, strong) NSDictionary *attribute;

@end

@implementation DDNotResultView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
/** 图片 */
- (void)setImageIcon:(UIImage *)imageIcon
{
    [self.iconView setHidden:false];
    [self.iconView setImage:imageIcon forState:UIControlStateNormal];
}

/** 文本内容 */
- (void)setContentText:(NSString *)contentText
{
    if ([contentText length] == 0) {
        return;
    }
    //创建可编辑字符串
    [self.contentLabel setHidden:false];
    [self.contentLabel setAttributedText:[[NSMutableAttributedString alloc] initWithString:contentText attributes:self.attribute]];
    
    //判断字符串长度是否大于默认值，并计算换行的视图大小
    CGFloat widthMsg = self.width - kMargin*6.0f;
    CGSize sizeMsg = [contentText boundingRectWithSize:CGSizeMake(widthMsg, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:self.attribute
                                               context:nil].size;
    
    //根据计算的Size，设置消息标签的Frame
    [self.contentLabel setSize:CGSizeMake(widthMsg, floorf(sizeMsg.height)+1.0f)];
}

/** 按钮标题 */
- (void)setTitleButton:(NSString *)titleButton
{
    if ([titleButton isEqualToString:@""] || titleButton == nil) {
        return;
    }
    [self.nextButton setHidden:false];
    [self.nextButton setTitle:titleButton forState:UIControlStateNormal];
    
    CGSize sizeMsg = [titleButton sizeWithAttributes:@{NSFontAttributeName : kTitleFont}];
    [self.nextButton setSize:CGSizeMake(floorf(sizeMsg.width)+50.0f, 28.0f)];
    
    [self.nextButton setBackgroundImage:[UIImage imageWithDrawColor:[UIColor clearColor] withSize:self.nextButton.bounds] forState:UIControlStateNormal];
    [self.nextButton setBackgroundImage:[UIImage imageWithDrawColor:DDGreen_Color withSize:self.nextButton.bounds] forState:UIControlStateHighlighted];
    [self.nextButton.layer setCornerRadius:self.nextButton.height/2.0f];
}

#pragma mark - 自动布局
- (void)layoutSubviews
{
    [self.iconView setSize:CGSizeMake(self.width - 100.0f, self.width - 100.0f)];
    [self.iconView setCenter:CGPointMake(self.centerx, self.iconView.centery)];
   
    [self.contentLabel setOrigin:CGPointMake(kMargin*3.0f, self.iconView.bottom)];
    
    [self.nextButton setOrigin:CGPointMake(self.centerx - self.nextButton.centerx, self.contentLabel.bottom + 20.0f)];
    
    [super layoutSubviews];
}

- (NSDictionary *)attribute
{
    if (!_attribute) {
        //用于字符串换行，设置行间距
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f;
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        _attribute =  @{NSFontAttributeName:kTitleFont,
                        NSForegroundColorAttributeName:KPlaceholderColor,
                        NSParagraphStyleAttributeName:paragraphStyle};
    }
    return _attribute;
}

#pragma 界面布局
/** 初始化UI控件 */
- (void)setup
{
    UIButton *imageIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageIcon setBackgroundColor:[UIColor clearColor]];
    [imageIcon setHidden:true];
    [imageIcon setAdjustsImageWhenDisabled:false];
    [imageIcon setUserInteractionEnabled:false];
    [self addSubview:imageIcon];
    self.iconView = imageIcon;
    
    //进行消息提示的标签
    UILabel *lblMessage = [[UILabel alloc] init];
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    [lblMessage setNumberOfLines:0];
    [lblMessage setHidden:true];
    [self addSubview:lblMessage];
    self.contentLabel = lblMessage;
    
    //创建没有数据时，下一步操作的按钮，title根据用户的选择进行更改，self.parcelStatus ＝＝ true／寄出
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnNext.layer setMasksToBounds:true];
    [btnNext.layer setBorderWidth:0.5f];
    [btnNext.layer setBorderColor:DDGreen_Color.CGColor];
    [btnNext.titleLabel setFont:kTitleFont];
    [btnNext setTitleColor:DDGreen_Color forState:UIControlStateNormal];
    [btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btnNext addTarget:self action:@selector(onClickWithNext) forControlEvents:UIControlEventTouchUpInside];
    [btnNext setHidden:true];
    [self addSubview:btnNext];
    self.nextButton = btnNext;
}

- (void)onClickWithNext
{
    if ([self.delegate respondsToSelector:@selector(notResultView:indexButton:)]) {
        [self.delegate notResultView:self indexButton:1];
    }
}

@end
