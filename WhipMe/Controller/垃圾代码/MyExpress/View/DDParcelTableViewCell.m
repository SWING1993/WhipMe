//
//  DDParcelTableViewCell.m
//  DuDu Courier
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 yangg. All rights reserved.
//

#import "DDParcelTableViewCell.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "NSDate+DateHelper.h"
#import "CustomStringUtils.h"

@interface DDParcelTableViewCell ()
{
    float _screenW;
}
/** 快递的图片 */
@property (nonatomic, strong) UIImageView *imageIcon;
    
/** 标题 */
@property (nonatomic, strong) UILabel *lblTitle;

/** 快递单号 */
@property (nonatomic, strong) UILabel *lblNumber;

/** 副标题 */
@property (nonatomic, strong) UILabel *lblFlow;

/** 收件人 */
@property (nonatomic, strong) UILabel *lblRecipient;

/** 时间 */
@property (nonatomic, strong) UILabel *lblTime;
    
/** 类别 */
@property (nonatomic, strong) UILabel *lblState;
    
/** 分界线 */
@property (nonatomic, strong) UILabel *lblLine;


@end

@implementation DDParcelTableViewCell

@synthesize imageIcon;
@synthesize lblFlow;
@synthesize lblState;
@synthesize lblTitle;
@synthesize lblTime;
@synthesize lblLine;

@synthesize lblNumber;
@synthesize lblRecipient;

/** 
    自定义cell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //初始化cell上的自定义控件
        [self setItems];
    }
    return self;
}

/**
    初始化自定义控件
 */
- (void)setItems
{
    //屏幕的宽度
    _screenW = [UIScreen mainScreen].bounds.size.width;
    
    UIView *selectView = [[UIView alloc] init];
    [selectView setFrame:CGRectMake(0, 0, _screenW, KMyExpressCellHeight)];
    [selectView setBackgroundColor:HIGHLIGHT_COLOR];
    [self setSelectedBackgroundView:selectView];
    
    /** 快递的图片 */
    imageIcon = [[UIImageView alloc] init];
    [imageIcon setFrame:CGRectMake(15.0f, 15.0f, 24.0f, 24.0f)];
    [imageIcon setBackgroundColor:HIGHLIGHT_COLOR];
    [imageIcon.layer setCornerRadius:imageIcon.height/2.0f];
    [imageIcon.layer setMasksToBounds:true];
    [self.contentView addSubview:imageIcon];
    
    /** 分界线 */
    lblLine = [[UILabel alloc] init];
    [lblLine setFrame:CGRectMake(0, KMyExpressCellHeight - 0.5f, _screenW, 0.5f)];
    [lblLine setBackgroundColor:BORDER_COLOR];
    [self.contentView addSubview:lblLine];
    
    /** 标题 */
    lblTitle = [[UILabel alloc] init];
    [lblTitle setFrame:CGRectMake(imageIcon.right + kMargin, imageIcon.top + 3.0f, _screenW - imageIcon.right*2.0f - kMargin*2.0f, 16.0f)];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setTextColor:TITLE_COLOR];
    [lblTitle setFont:kContentFont];
    [self.contentView addSubview:lblTitle];
    
    /** 类别 */
    lblState = [[UILabel alloc] init];
    [lblState setFrame:CGRectMake(lblTitle.right, lblTitle.top, 44.0f, 14.0f)];
    [lblState setBackgroundColor:[UIColor clearColor]];
    [lblState.layer setCornerRadius:lblState.height/2.0f];
    [lblState.layer setMasksToBounds:true];
    [lblState.layer setBorderWidth:0.5f];
    [lblState.layer setBorderColor:TIME_COLOR.CGColor];
    [lblState setTextAlignment:NSTextAlignmentCenter];
    [lblState setTextColor:TIME_COLOR];
    [lblState setFont:KCountFont];
    [self.contentView addSubview:lblState];
    
    /** 快递单号 */
    lblNumber = [[UILabel alloc] init];
    [lblNumber setFrame:CGRectMake(lblTitle.left, lblTitle.bottom + 10.0f, _screenW - imageIcon.right - 25.0f, 14.0f)];
    [lblNumber setBackgroundColor:[UIColor clearColor]];
    [lblNumber setTextAlignment:NSTextAlignmentLeft];
    [lblNumber setTextColor:TIME_COLOR];
    [lblNumber setFont:kTitleFont];
    [self.contentView addSubview:lblNumber];
    
    /** 副标题 */
    lblFlow = [[UILabel alloc] init];
    [lblFlow setFrame:CGRectMake(lblNumber.left, lblNumber.bottom + 7.0f, lblNumber.width, lblNumber.height)];
    [lblFlow setBackgroundColor:[UIColor clearColor]];
    [lblFlow setTextAlignment:NSTextAlignmentLeft];
    [lblFlow setTextColor:TIME_COLOR];
    [lblFlow setFont:kTitleFont];
    [self.contentView addSubview:lblFlow];
    
    /** 收件人 */
    lblRecipient = [[UILabel alloc] init];
    [lblRecipient setFrame:CGRectMake(lblFlow.left, lblFlow.bottom + 7.0f, lblFlow.width, lblFlow.height)];
    [lblRecipient setBackgroundColor:[UIColor clearColor]];
    [lblRecipient setTextAlignment:NSTextAlignmentLeft];
    [lblRecipient setTextColor:TIME_COLOR];
    [lblRecipient setFont:kTitleFont];
    [self.contentView addSubview:lblRecipient];
    
    /** 时间 */
    lblTime = [[UILabel alloc] init];
    [lblTime setFrame:CGRectMake(lblRecipient.left, lblRecipient.top, lblRecipient.width, lblRecipient.height)];
    [lblTime setBackgroundColor:[UIColor clearColor]];
    [lblTime setTextAlignment:NSTextAlignmentRight];
    [lblTime setTextColor:TIME_COLOR];
    [lblTime setFont:kTitleFont];
    [self.contentView addSubview:lblTime];
    
}

- (void)layoutSubviews
{
    CGSize size_state = [lblState.text sizeWithAttributes:@{NSFontAttributeName:lblState.font}];
    [lblState setSize:CGSizeMake(floorf(size_state.width) + 14.0f, lblState.height)];
    [lblState setOrigin:CGPointMake(_screenW - lblState.width - 15.0f, lblState.top)];
    
    [lblTitle setSize:CGSizeMake(lblState.left - imageIcon.right-kMargin*2.0f, lblTitle.height)];
    
    CGSize size_time = [lblTime.text sizeWithAttributes:@{NSFontAttributeName:lblTime.font}];
    [lblTime setSize:CGSizeMake(floorf(size_time.width) + 14.0f, lblTime.height)];
    [lblTime setOrigin:CGPointMake(_screenW - lblTime.width - 15.0f, lblTime.top)];
    
    [lblRecipient setSize:CGSizeMake(lblTime.left - lblFlow.left - kMargin*2.0f, lblRecipient.height)];
    
}

/** 重写传入数据的setter方法,给cell上的控件传值 */
- (void)setCellForMyExpress:(DDMyExpress *)model
{
    _cellForMyExpress = model;
    
    NSString *img_url = [CustomStringUtils isBlankString:model.companyLogo] ? @"" : model.companyLogo;
    [imageIcon sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:KClientIcon48]];
    
    if (![CustomStringUtils isBlankString:model.expressComment]) {
        [lblTitle setText:model.expressComment];
    } else {
        [lblTitle setText:[NSString stringWithFormat:@"%@的包裹",model.companyName]];
    }
    
    NSString *str_number = [CustomStringUtils isBlankString:model.companyName] ? @"运单号：" : [NSString stringWithFormat:@"%@：",model.companyName];
    str_number = [str_number stringByAppendingString:model.expressNumber];
    [lblNumber setText:str_number];
    
    [lblState setText:[DDMyExpress expressForStatu:model.expressStatus]];
    [lblState setHidden:model.expressStatus == -1 ? true : false];
    
    [lblFlow setText:[CustomStringUtils isBlankString:model.laLog] ? @"" : model.laLog];
    
    if (![CustomStringUtils isBlankString:model.expressDate]) {
        NSDate *tempDate = [NSDate dateFromString:model.expressDate withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tempTime = [tempDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [lblTime setText:tempTime ?: @""];
    } else {
        [lblTime setText:@""];
    }
    
    if ([lblState.text isEqualToString:@"已签收"]) {
        [lblState setTextColor:TIME_COLOR];
        [lblState.layer setBorderColor:TIME_COLOR.CGColor];
    } else {
        [lblState setTextColor:DDGreen_Color];
        [lblState.layer setBorderColor:DDGreen_Color.CGColor];
    }
    if (model.expressType == 1) {
        [lblRecipient setText:[NSString stringWithFormat:@"收件人 : %@",model.revName]];
    } else if (_cellForMyExpress.expressType == 2) {
        [lblRecipient setText:[NSString stringWithFormat:@"寄件人 : %@",model.sendName]];
    }
}

@end
