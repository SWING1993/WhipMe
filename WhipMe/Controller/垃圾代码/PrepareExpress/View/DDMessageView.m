//
//  DDMessageView.m
//  DDExpressClient
//
//  Created by SongGang on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDMessageView.h"

#import "Constant.h"

@interface DDMessageView ()

/** 取消按钮 */
@property (nonatomic,strong) UIButton *cancelButton;
/** 确定按钮 */
@property (nonatomic,strong) UIButton *okButton;
/** 选择器的名字 */
@property (nonatomic,strong) UIView *titleView;
/** 捎句话View */
@property (nonatomic,strong) UIView *contentView;
/** 捎句话按钮数组 */
@property (nonatomic, strong) NSMutableArray *btnArray;


@end


@implementation DDMessageView

#pragma mark - 类的初始化方法

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, DDSCreenBounds.size.width, 200.0f)];
        
        [self initView];
    }
    return self;
}

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _btnArray;
}

/**
    初始化View
 */
- (void)initView
{
    UIView *tView = [[UIView alloc] init];
    [tView setFrame:CGRectMake(0, 0, self.width, 45.0f)];
    [tView setBackgroundColor:DDRGBColor(253, 253, 253)];
    [self addSubview:tView];
    self.titleView = tView;
    
    UIButton * cbutton = [[UIButton alloc] init];
    [cbutton setFrame:CGRectMake(0, 0, 50.0f, 45.0f)];
    [cbutton setBackgroundColor:[UIColor clearColor]];
    [cbutton setTitle:@"取消" forState:UIControlStateNormal];
    [cbutton setTitleColor:DDRGBColor(102 ,102 ,102 ) forState:UIControlStateNormal];
    [cbutton.titleLabel setFont:kTitleFont];
    [cbutton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:cbutton];
    self.cancelButton = cbutton;
    
    UIButton * okbutton = [[UIButton alloc] init];
    [okbutton setFrame:CGRectMake(self.width - 50, 0, 50.0f, 45.0f)];
    [okbutton setBackgroundColor:[UIColor clearColor]];
    [okbutton setTitle:@"确定" forState:UIControlStateNormal];
    [okbutton.titleLabel setFont:kTitleFont];
    [okbutton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
    [okbutton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:okbutton];
    self.okButton = okbutton;
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.size = CGSizeMake(150, self.titleView.height);
    titleLabel.center = CGPointMake(self.titleView.width/2, self.titleView.height/2);
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    titleLabel.text = @"捎句话";
    titleLabel.font = kContentFont;
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:titleLabel];
    
    
    UILabel *linelabel = [[UILabel alloc] init];
    [linelabel setFrame:CGRectMake(0, self.titleView.height - 0.5f, self.titleView.width, 0.5f)];
    [linelabel setBackgroundColor:DDRGBColor(229, 229, 229)];
    [self.titleView addSubview:linelabel];
    
    float item_w = (self.width-15*4.0f)/3.0f;
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"带面单",@"带袋子",@"带箱子",@"带胶带",@"到付",@"已打包好",@"有多件",@"面单已填好",@"可拿下楼",nil];
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setFrame:CGRectMake(0, self.titleView.height, self.width, (titleArray.count/3)*45.0f + 20.0f)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    for(int i=0; i<titleArray.count; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setFrame:CGRectMake(15 + i%3 * (item_w+15.0f), 20 + i/3 * 45, item_w, 25)];
        [itemButton.layer setCornerRadius:itemButton.height/2.0f];
        [itemButton.layer setMasksToBounds:true];
        [itemButton.layer setBorderWidth:0.5f];
        [itemButton.layer setBorderColor:KPlaceholderColor.CGColor];
        [itemButton setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [itemButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [itemButton setTitleColor:DDGreen_Color forState:UIControlStateSelected];
        [itemButton.titleLabel setFont:kTitleFont];
        [itemButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:itemButton];
        [self.btnArray addObject:itemButton];
    }
    [self setFrame:CGRectMake(0, 0, DDSCreenBounds.size.width, self.contentView.bottom)];
}

/**
 * 选择捎句话的内容
 */
- (void)messageButtonClick:(UIButton *)btnMessage
{
    if (btnMessage.isSelected) {
        [btnMessage setSelected:NO];
        [btnMessage.layer setBorderColor:KPlaceholderColor.CGColor];
    } else {
        [btnMessage setSelected:YES];
        [btnMessage.layer setBorderColor:DDGreen_Color.CGColor];
    }
}

- (void)setMessageString:(NSString *)messageString
{
    for (int i = 0;i < self.btnArray.count; i ++)
    {
        UIButton *button = [self.btnArray objectAtIndex:i];
        
        if ([messageString rangeOfString:button.titleLabel.text].location != NSNotFound)
        {
            [button setSelected:YES];
            [button.layer setBorderColor:DDGreen_Color.CGColor];
        }
    }
}

/** 取消动作 */
- (void)cancelAction
{
    if ([_delegate respondsToSelector:@selector(messageCancelAction)]) {
        [_delegate messageCancelAction];
    }
}

/** 确定动作 */
- (void)okAction
{
    NSString * string = @"";
    for (int i = 0; i < self.btnArray.count; i++) {
        UIButton * button  = [self.btnArray objectAtIndex:i];
        if (button.isSelected) {
            string = [string stringByAppendingString:button.titleLabel.text];
            string = [string stringByAppendingString:@" "];
        }
    }
        
    if ([_delegate respondsToSelector:@selector(messageOKAction:)]) {
        [_delegate messageOKAction:string];
    }
}



@end
