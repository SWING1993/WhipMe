//
//  DDCourierCompanyViewCell.m
//  DDExpressClient
//
//  Created by yangg on 16/3/8.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierCompanyViewCell.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "CustomStringUtils.h"

@interface DDCourierCompanyViewCell ()
{
    float _screenW;
}
@property (nonatomic, strong) UIImageView *imageIcon;   /** 快递的图片 */
@property (nonatomic, strong) UILabel *lblTitle;        /** 标题 */
@property (nonatomic, strong) UIImageView *imageState;  /** 快递选择的状态的图片 */

@end

@implementation DDCourierCompanyViewCell
@synthesize imageIcon;
@synthesize lblTitle;
@synthesize imageState;
@synthesize lblLine;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setItems];
    }
    return self;
}

- (void)setItems
{
    _screenW = [UIScreen mainScreen].bounds.size.width;
    
    /** 快递的图片 */
    imageIcon = [[UIImageView alloc] init];
    [imageIcon setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:imageIcon];
    
    lblLine = [[UILabel alloc] init];
    [lblLine setBackgroundColor:BORDER_COLOR];
    [self.contentView addSubview:lblLine];
    
    /** 标题 */
    lblTitle = [[UILabel alloc] init];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setTextColor:TITLE_COLOR];
    [lblTitle setFont:kTitleFont];
    [self.contentView addSubview:lblTitle];
    
    /** 类别 */
    imageState = [[UIImageView alloc] init];
    [imageState setSize:CGSizeMake(15.0f, 15.0f)];
    [imageState setBackgroundColor:[UIColor clearColor]];
    [imageState setImage:[UIImage imageNamed:DDChoseIcon]];
    [imageState setHidden:true];
    [self.contentView addSubview:imageState];
}

- (void)layoutSubviews
{
    [imageIcon setFrame:CGRectMake(15.0f, kMargin, 40.0f, 40.0f)];
    [imageIcon.layer setCornerRadius:imageIcon.height/2.0f];
    [imageIcon.layer setMasksToBounds:true];
    
    /** 判断如果是顶部“不限”选项，则隐藏图片 */
    if (_cellForCompany.companyModelType == DDCompanyModelHead)
    {
        [imageIcon setHidden:true];
        [lblTitle setFrame:CGRectMake(15.0f, kMargin, _screenW - 65.0f, 20.0f)];
        [lblLine setFrame:CGRectMake(imageIcon.left, DDCC_CELL_HEADER - 0.5f, _screenW -imageIcon.left, 0.5f)];
    } else {
        [imageIcon setHidden:false];
        [lblTitle setFrame:CGRectMake(imageIcon.right + kMargin, imageIcon.top, _screenW - imageIcon.right*2.0f, imageIcon.height)];
        [lblLine setFrame:CGRectMake(imageIcon.left, DDCC_CELL_HEIGHT - 0.5f, _screenW -imageIcon.left, 0.5f)];
    }
     
    [imageState setCenter:CGPointMake(_screenW - 20.0f - imageState.centerx, lblTitle.centerY)];
    
}

- (void)setCellForCompany:(DDCompanyModel *)cellForCompany
{
    _cellForCompany = cellForCompany;
    
    if (_cellForCompany.companyModelType == DDCompanyModelHead) {
        [imageIcon setImage:[UIImage imageNamed:KClientIcon78]];
    } else {
        NSString *img_url = [CustomStringUtils isBlankString:_cellForCompany.companyLogo] ? [NSString stringWithFormat:@"http://res.atxiaoge.com/res/images/%@.png",_cellForCompany.companyID] : _cellForCompany.companyLogo;
        [imageIcon sd_setImageWithURL:[NSURL URLWithString:img_url] placeholderImage:[UIImage imageNamed:KClientIcon78]];
    }
    
    if (![CustomStringUtils isBlankString:_cellForCompany.companyName]) {
        [lblTitle setText:[NSString stringWithFormat:@"%@",_cellForCompany.companyName]];
    }
    
    [imageState setHidden:_cellForCompany.companySelect ? false : true];
}


@end
