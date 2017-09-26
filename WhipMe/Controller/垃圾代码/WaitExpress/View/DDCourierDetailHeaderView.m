//
//  DDCourierDetailHeaderView.m
//  DDExpressClient
//
//  Created by Jadyn on 16/3/9.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierDetailHeaderView.h"
#import "Constant.h"
#import "UIView+Size.h"
#import "UIImageView+WebCache.h"

NSString *const DDCourierDetailHeaderViewHeaderBackViewName = @"courierBackImage";
NSString *const DDCourierDetailHeaderViewCourierGrade = @"courierGrade";
NSString *const DDCourierDetailHeaderViewCourierFinishiTimes = @"courierFinishTimes";
NSString *const DDCourierDetailHeaderViewCourierRank = @"courierRank";


@interface DDCourierDetailHeaderView ()
/**
 *  背景视图
 */
@property (strong, nonatomic) UIImageView *backImageView;
/**
 *  头像视图
 */
@property (strong, nonatomic) UIImageView *iconImageView;
/**
 *  头像阴影视图
 */
@property (strong, nonatomic) UIView *logoShadowViewOut;
/**
 *  快递员姓名
 */
@property (strong, nonatomic) UIButton *couierNameLabel;
/**
 *  快递员公司
 */
@property (strong, nonatomic) UIButton *courierCompanyLabel;
/**
 *  快递员身份证号
 */
@property (strong, nonatomic) UIButton *idNumberLabel;

/**
 *  快递员排名
 */
@property (strong, nonatomic) UIButton *courierRankLabel;
@property (nonatomic,strong) UILabel *courierRank;
/**
 *  快递员取件次数
 */
@property (strong, nonatomic) UIButton *courierSendTimesLabel;
@property (nonatomic,strong) UILabel *sendTimes;
/**
 *  快递员评分
 */
@property (strong, nonatomic) UIButton *courierEvaluateGradeLabel;
@property (nonatomic,strong) UILabel *evaluateGrade;

/**
 *  竖线
 */
@property (strong, nonatomic) UIView *lineLeftView;

/**
 *  竖线
 */
@property (strong, nonatomic) UIView *lineRightView;




@end



@implementation DDCourierDetailHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



/**
 *  初始化函数
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViews];
    }
    return self;
}

/**
 *  初始化视图
 */
- (void)createViews
{
    
    
    
    /**
     背景图
     */
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.image = [UIImage imageNamed:DDCourierDetailHeaderViewHeaderBackViewName];
    
    [self addSubview:backImageView];
    self.backImageView = backImageView;
    
    /**
     外框30%白图层
     */
    UIView *borderOutView = [[UIView alloc]init];
    borderOutView.backgroundColor = DDRGBAColor(255, 255, 255,0.3);
    borderOutView.layer.cornerRadius = 41.5;
    borderOutView.layer.masksToBounds = YES;
    [self addSubview:borderOutView];
    self.logoShadowViewOut = borderOutView;
    
    
    /**
     快递员头像
     */
    UIImageView *courierLogoView = [[UIImageView alloc]init];
    courierLogoView.layer.cornerRadius = 39.5;
    courierLogoView.layer.masksToBounds = YES;
    courierLogoView.layer.borderColor = DDRGBAColor(255, 255, 255, 0.6).CGColor;
    courierLogoView.layer.borderWidth = 2;
    [self.logoShadowViewOut addSubview:courierLogoView];
    self.iconImageView = courierLogoView;
    
    
    
    /**
     快递员姓名
     */
    UIButton *nameView = [[UIButton alloc]init];
    [nameView setTitleColor:DDRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
    nameView.titleLabel.font = [UIFont systemFontOfSize:14];
    nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    //button为不可点击状态
    [nameView setUserInteractionEnabled:NO];
    //不显示高亮状态
    nameView.adjustsImageWhenHighlighted = NO;
    
    
    [self addSubview:nameView];
    self.couierNameLabel = nameView;
    
    
    /**
     快递员公司
     */
    UIButton *companyView = [[UIButton alloc]init];
    [companyView setTitleColor:DDRGBAColor(166, 255, 229, 1) forState:UIControlStateNormal];
    companyView.titleLabel.font = [UIFont systemFontOfSize:14];
    companyView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    companyView.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6);
    //button为不可点击状态
    [companyView setUserInteractionEnabled:NO];
    //不显示高亮状态
    companyView.adjustsImageWhenHighlighted = NO;
    
    
    [self addSubview:companyView];
    self.courierCompanyLabel = companyView;
    
    
    
    /**
     身份证号码
     */
    UIButton *idCardLabel = [[UIButton alloc]init];
    [idCardLabel setTitleColor:DDRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
    idCardLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    idCardLabel.contentMode = UIViewContentModeCenter;    //button为不可点击状态
    [idCardLabel setUserInteractionEnabled:NO];
    //不显示高亮状态
    idCardLabel.adjustsImageWhenHighlighted = NO;
    
    [self addSubview:idCardLabel];
    self.idNumberLabel = idCardLabel;
    
    
    /**
     评分
     */
    UIButton *courierGradeLabel = [[UIButton alloc]init];
    [courierGradeLabel setImage:[UIImage imageNamed:DDCourierDetailHeaderViewCourierGrade] forState:UIControlStateNormal];
    [courierGradeLabel setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    //button为不可点击状态
    [courierGradeLabel setUserInteractionEnabled:NO];
    //不显示高亮状态
    courierGradeLabel.adjustsImageWhenHighlighted = NO;
    [self addSubview:courierGradeLabel];
    self.courierEvaluateGradeLabel = courierGradeLabel;
    /**
     评分数
     */
    UILabel *gradeLabel = [[UILabel alloc]init];
    gradeLabel.font = [UIFont systemFontOfSize:24];
    gradeLabel.textAlignment = NSTextAlignmentCenter;
    gradeLabel.textColor = DDRGBAColor(255, 255, 255, 1);
    //TOCHANGE:假数据
    gradeLabel.text = @"12343";
    [self addSubview:gradeLabel];
    self.evaluateGrade = gradeLabel;
    
    
    
    
    
    /**
     取件次数
     */
    UIButton *courierFinishTimes = [[UIButton alloc]init];
    [courierFinishTimes setImage:[UIImage imageNamed:DDCourierDetailHeaderViewCourierFinishiTimes] forState:UIControlStateNormal];
    [courierFinishTimes setImageEdgeInsets:UIEdgeInsetsMake(5,0, 0, 0)];
    courierFinishTimes.contentMode = UIViewContentModeCenter;
    //button为不可点击状态
    [courierFinishTimes setUserInteractionEnabled:NO];
    //不显示高亮状态
    courierFinishTimes.adjustsImageWhenHighlighted = NO;
    [self addSubview:courierFinishTimes];
    self.courierSendTimesLabel = courierFinishTimes;
    
    UILabel *finishTimes = [[UILabel alloc]init];
    finishTimes.font = [UIFont systemFontOfSize:24];
    finishTimes.textAlignment = NSTextAlignmentCenter;
    finishTimes.textColor = DDRGBAColor(255, 255, 255, 1);
    //TOCHANGE:假数据
    finishTimes.text = @"12343";
    [self addSubview:finishTimes];
    self.sendTimes = finishTimes;
    
    
    
    
    /**
     快递员排名
     */
    UIButton *courierRankLabel = [[UIButton alloc]init];
    [courierRankLabel setImage:[UIImage imageNamed:DDCourierDetailHeaderViewCourierRank] forState:UIControlStateNormal];
    [courierRankLabel setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
    //button为不可点击状态
    [courierRankLabel setUserInteractionEnabled:NO];
    //不显示高亮状态
    courierRankLabel.adjustsImageWhenHighlighted = NO;
    [self addSubview:courierRankLabel];
    self.courierRankLabel = courierRankLabel;
    
    UILabel *courierRank = [[UILabel alloc]init];
    courierRank.font = [UIFont systemFontOfSize:24];
    courierRank.textAlignment = NSTextAlignmentCenter;
    courierRank.textColor = DDRGBAColor(255, 255, 255, 1);
    //TOCHANGE:假数据
    courierRank.text = @"12343";
    [self addSubview:courierRank];
    self.courierRank = courierRank;
    
    
    
    
    /**
     白线
     */
    self.lineLeftView = [[UIView alloc]init];
    self.lineLeftView.backgroundColor = DDRGBAColor(233, 233, 233, 0.5);
    self.lineRightView = [[UIView alloc]init];
    self.lineRightView.backgroundColor = DDRGBAColor(233, 233, 233, 0.5);
    [self addSubview:self.lineLeftView];
    [self addSubview:self.lineRightView];
}






/**
 *  布局视图
 */
-(void)layoutSubviews
{
    self.backImageView.x = 0;
    self.backImageView.y = 0;
    self.backImageView.height = 238;
    self.backImageView.width = self.width;
    
    self.logoShadowViewOut.x = self.width/2-41.5;
    self.logoShadowViewOut.y = 20;
    self.logoShadowViewOut.width = 83;
    self.logoShadowViewOut.height = 83;
    
    self.iconImageView.x = 2;
    self.iconImageView.y = 2;
    self.iconImageView.width = 79;
    self.iconImageView.height = 79;
    
    self.couierNameLabel.x = 0;
    self.couierNameLabel.y = 120;
    self.couierNameLabel.width = self.width/2;
    self.couierNameLabel.height = 14;
    
    self.courierCompanyLabel.x = self.width/2;
    self.courierCompanyLabel.y = 120;
    self.courierCompanyLabel.height = 14;
    self.courierCompanyLabel.width = self.width/2;
    
    self.idNumberLabel.x = 0;
    self.idNumberLabel.y = 142;
    self.idNumberLabel.width = self.width;
    self.idNumberLabel.height = 12;
    
    /**<  评分  */
    self.courierEvaluateGradeLabel.x = 0;
    self.courierEvaluateGradeLabel.y = self.height-80;
    self.courierEvaluateGradeLabel.height = 80;
    self.courierEvaluateGradeLabel.width = self.width/3;
    
    self.evaluateGrade.x = 0;
    self.evaluateGrade.y = self.height - 80;
    self.evaluateGrade.height = 54;
    self.evaluateGrade.width = self.width/3;
    
    
    /**<  取件次数  */
    self.courierSendTimesLabel.x = self.width/3;
    self.courierSendTimesLabel.y = self.height-80;
    self.courierSendTimesLabel.height = 80;
    self.courierSendTimesLabel.width = self.width/3;
    
    self.sendTimes.x = self.width/3;
    self.sendTimes.y = self.height-80;
    self.sendTimes.height = 54;
    self.sendTimes.width = self.width/3;
    
    
    
    /**<  快递员排名  */
    self.courierRankLabel.x = self.width*2/3;
    self.courierRankLabel.y = self.height-80;
    self.courierRankLabel.height = 80;
    self.courierRankLabel.width = self.width/3;
    
    
    self.courierRank.x = self.width*2/3;
    self.courierRank.y = self.height-80;
    self.courierRank.height = 54;
    self.courierRank.width = self.width/3;
    
    
    
    self.lineLeftView.x = self.width/3;
    self.lineLeftView.height = 37;
    self.lineLeftView.y = self.height-57;
    self.lineLeftView.width = 0.5;
    
    self.lineRightView.x = self.width*2/3;
    self.lineRightView.height = 37;
    self.lineRightView.y = self.height-57;
    self.lineRightView.width = 0.5;
}





/**
 *  setter方法,传入快递员详细信息模型
 *
 *  @param detailModel 快递员详细信息模型
 */
- (void)setDetailModel:(DDCourierDetail *)detailModel
{
    _detailModel = detailModel;
    
    [self.couierNameLabel setTitle:[NSString stringWithFormat:@"%@",detailModel.courierName] forState:UIControlStateNormal];
    
    [self.courierCompanyLabel setTitle:detailModel.companyName ?: @"" forState:UIControlStateNormal];
    
    detailModel.courierIdentityID = [detailModel.courierIdentityID stringByReplacingCharactersInRange:NSMakeRange(4, detailModel.courierIdentityID.length - 8) withString:@"**********"];
    [self.idNumberLabel setTitle:[NSString stringWithFormat:@"身份证: %@",detailModel.courierIdentityID] forState:UIControlStateNormal];
    
    self.courierRank.text = detailModel.courierRank;
    
    self.sendTimes.text = detailModel.finishedOrderNumber;
    
    self.evaluateGrade.text = detailModel.courierStar;
    
  
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.courierHeadIcon]];
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.courierHeadIcon] placeholderImage:[UIImage imageNamed:DDPersonalHeadIcon]];
    
}





@end
