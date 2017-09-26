//
//  DDLogisticsViewCell.m
//  DDExpressClient
//
//  Created by yangg on 16/3/11.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDLogisticsViewCell.h"
#import "Constant.h"
#import "NSDate+DateHelper.h"

/** cell的默认高度 */
NSInteger const KLogisticsCellHeight = 92.0f;
/** title的x */
NSInteger const DDLogisticsLeftX = 60.0f;

@interface DDLogisticsViewCell ()
{
    /** 屏幕的快递*/
    float _screenW;
    /** 每一项Cell的下标 */
    NSIndexPath *_kIndexPath;
    /** 黑色的状态 */
    NSDictionary *_attributeBlack;
    /** 灰色的状态 */
    NSDictionary *_attributeGrey;
    //字符串的换行设置行间距，字符居左
    NSMutableParagraphStyle *paragraphText;
}

/** 标题 */
@property (nonatomic, strong) UILabel *lblTitle;
/** 时间 */
@property (nonatomic, strong) UILabel *lblTime;

@property (nonatomic, strong) UIImageView *imageIcon;   /** 圆点的图片 */
@property (nonatomic, strong) UILabel *lineCol;         /** 分界线 */

/** cell的数据字典 */
@property (nonatomic, strong) NSDictionary *cellForLogistics;

@end

@implementation DDLogisticsViewCell
@synthesize lblTime;
@synthesize lblTitle;
@synthesize imageIcon;
@synthesize lineCol;
@synthesize lineRow;

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
        
        //字符串的换行设置行间距，字符居左
        paragraphText = [[NSMutableParagraphStyle alloc]init];
        paragraphText.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphText.lineSpacing = 5.0f;
        paragraphText.alignment = NSTextAlignmentLeft;
        
        _attributeBlack = @{NSFontAttributeName:kTimeFont,
                      NSForegroundColorAttributeName:TITLE_COLOR,
                      NSParagraphStyleAttributeName:paragraphText};
        
        _attributeGrey = @{NSFontAttributeName:kTimeFont,
                           NSForegroundColorAttributeName:TIME_COLOR,
                           NSParagraphStyleAttributeName:paragraphText};
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
    
    /** 标题 */
    lblTitle = [[UILabel alloc] init];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setTextColor:TIME_COLOR];
    [lblTitle setFont:kTitleFont];
    [lblTitle setNumberOfLines:0];
    [self.contentView addSubview:lblTitle];
    
    /** 时间 */
    lblTime = [[UILabel alloc] init];
    [lblTime setBackgroundColor:[UIColor clearColor]];
    [lblTime setTextAlignment:NSTextAlignmentLeft];
    [lblTime setTextColor:KPlaceholderColor];
    [lblTime setFont:kTitleFont];
    [self.contentView addSubview:lblTime];
    
    /** 分界线 */
    lineRow = [[UILabel alloc] init];
    [lineRow setBackgroundColor:BORDER_COLOR];
    [self.contentView addSubview:lineRow];
    
    lineCol = [[UILabel alloc] init];
    [lineCol setBackgroundColor:HIGHLIGHT_COLOR];
    [self.contentView addSubview:lineCol];
    
    /** 圆点的图片 */
    imageIcon = [[UIImageView alloc] init];
    [imageIcon setBackgroundColor:[UIColor clearColor]];
    [imageIcon.layer setCornerRadius:imageIcon.height/2.0f];
    [imageIcon.layer setMasksToBounds:true];
    [self.contentView addSubview:imageIcon];
    
}

/** 返回Cell的高度 */
- (CGFloat)LogisticsCellHeight
{
    if ([_cellForLogistics[@"content"] isEqualToString:@""] || _cellForLogistics[@"content"] == [NSNull null]) {
        return KLogisticsCellHeight;
    }
    NSString *text_str = [NSString stringWithFormat:@"%@",_cellForLogistics[@"content"]];
    CGSize sizeItem = [text_str boundingRectWithSize:CGSizeMake(_screenW - DDLogisticsLeftX - kMargin*2.0f, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:_attributeBlack
                                             context:nil].size;
    
    return 15.0f*2.0f + floorf(sizeItem.height+1.0f) + 5.0f + 14.0f;
}

/** 根据字符串内容长度，更改标签的位置大小 */
- (void)layoutSubviews
{
    [lblTitle setFrame:CGRectMake(DDLogisticsLeftX, 15.0f, _screenW - DDLogisticsLeftX - kMargin*2.0f, 16.0f)];
    
    NSString *text_str = [NSString stringWithFormat:@"%@",_cellForLogistics[@"content"]];
    CGSize sizeItem = [text_str boundingRectWithSize:CGSizeMake(lblTitle.width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:_attributeBlack
                                             context:nil].size;
    [lblTitle setSize:CGSizeMake(_screenW - DDLogisticsLeftX - kMargin*2.0f, floorf(sizeItem.height)+1.0f)];
    
    [imageIcon setSize:CGSizeMake(10.0f, 10.0f)];
    [imageIcon setCenter:CGPointMake(DDLogisticsLeftX/2.0f, lblTitle.top + 8.0f)];
    
    [lblTime setFrame:CGRectMake(lblTitle.left, lblTitle.bottom + 5.0f, lblTitle.width, 14.0f)];
    [lineRow setFrame:CGRectMake(lblTitle.left, lblTime.bottom + 15.0f - 0.5f, _screenW - lblTitle.left, 0.5f)];
    
    if (_kIndexPath.row == 0) {
        [lineCol setFrame:CGRectMake(DDLogisticsLeftX/2.0f, imageIcon.centerY, 0.5f, lblTime.bottom + 15.0f - imageIcon.centerY)];
    } else {
        [lineCol setFrame:CGRectMake(DDLogisticsLeftX/2.0f, 0, 0.5f, lblTime.bottom + 15.0f)];
    }
    
}

/** 重写传入数据的setter方法,给cell上的控件传值 */
- (void)setCellForLogistics:(NSDictionary *)cellForLogistics withIndexPath:(NSIndexPath *)indexPath
{
    _cellForLogistics = cellForLogistics;
    _kIndexPath = indexPath;
    
    [imageIcon setImage:[UIImage imageNamed:indexPath.row == 0 ? DDLogisticsOn : DDLogisticsOff]];
    
    if (_cellForLogistics[@"time"]) {
        NSDate *tempDate = [NSDate dateFromString:_cellForLogistics[@"time"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *tempTime = [tempDate stringWithFormat:@"yyyy-MM-dd HH:mm"];
        [lblTime setText:tempTime ?: @""];
    } else {
        [lblTime setText:@""];
    }
    
    
    //创建可编辑字符串
    NSString *text_str = [NSString stringWithFormat:@"%@",_cellForLogistics[@"content"]];
    [lblTitle setAttributedText:[[NSMutableAttributedString alloc] initWithString:text_str attributes:_attributeBlack]];
   
}

@end
