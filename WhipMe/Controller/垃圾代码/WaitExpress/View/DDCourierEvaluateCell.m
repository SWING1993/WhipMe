//
//  DDCourierEvaluateCell.m
//  DDExpressClient
//
//  Created by Jadyn on 16/3/9.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDCourierEvaluateCell.h"
#import "Constant.h"

@interface DDCourierEvaluateCell()
/**
 *  评价内容
 */
@property (strong, nonatomic) UILabel *evaluateTextLabel;
/**
 *  时间
 */
@property (strong, nonatomic) UILabel *timeTextLabel;
/**
 *  评星图
 */
@property (strong, nonatomic) UIImageView *starImageView;



@end

@implementation DDCourierEvaluateCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        [self addSubview:self.evaluateTextLabel];
        [self addSubview:self.timeTextLabel];
        [self addSubview:self.starImageView];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.evaluateTextLabel setFrame:CGRectMake(15, 15, self.width - 100, 15)];
    
    [self.timeTextLabel setFrame:CGRectMake(15, self.evaluateTextLabel.bottom + 10, 100, 13)];
    
    [self.starImageView setFrame:CGRectMake(self.width - 80, 25, 65, 12)];
    
    self.height = 62;
}




#pragma mark - setter & getter
/**
 *  setter方法.写入model
 *
 *  @param model 快递员评价信息模型
 */
- (void)setModel:(DDCourierEvaluate *)model
{
    _model = model;
    if (model.evaluateContent.count == 0) {
        self.evaluateTextLabel.text = @"无";
    }else {
        self.evaluateTextLabel.text = [model.evaluateContent lastObject];
    }
    
  
    self.timeTextLabel.text = model.evaluateDate;
    NSInteger star = [model.evaluateGrade intValue] > 0 ? [model.evaluateGrade intValue] : 1;
    switch (star) {
        case 1:
            self.starImageView.image = [UIImage imageNamed:@"star1"];
            break;
        case 2:
            self.starImageView.image = [UIImage imageNamed:@"star2"];
            break;
        case 3:
            self.starImageView.image = [UIImage imageNamed:@"star3"];
            break;
        case 4:
            self.starImageView.image = [UIImage imageNamed:@"star4"];
            break;
        case 5:
            self.starImageView.image = [UIImage imageNamed:@"star5"];
            break;
    }
}

- (UILabel *)evaluateTextLabel
{
    if (_evaluateTextLabel == nil) {
        _evaluateTextLabel = [[UILabel alloc] init];
        [_evaluateTextLabel setFont:kTitleFont];
        [_evaluateTextLabel setTextColor:CONTENT_COLOR];
    }
    return _evaluateTextLabel;
}

- (UILabel *)timeTextLabel
{
    if (_timeTextLabel == nil) {
        _timeTextLabel = [[UILabel alloc] init];
        [_timeTextLabel setFont:kTimeFont];
        [_timeTextLabel setTextColor:TIME_COLOR];
    }
    return _timeTextLabel;
}

- (UIImageView *)starImageView
{
    if (_starImageView == nil) {
        _starImageView = [[UIImageView alloc] init];
        _starImageView.contentMode = UIViewContentModeLeft;
    }
    return _starImageView;
}
@end
