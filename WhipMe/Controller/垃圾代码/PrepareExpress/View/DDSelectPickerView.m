//
//  DDSelectPickerView.m
//  DDExpressCourier
//
//  Created by yoga on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDSelectPickerView.h"
#import "UIView+Size.h"
#import "Constant.h"

@interface DDSelectPickerView()

/**<  选择器背景白板  */
@property (nonatomic,strong) UIView *pickerBackView;
/**<  选择器上层条  */
@property (nonatomic,strong) UIView *titleBarView;
/**<  选择器标题  */
@property (nonatomic,strong) UILabel *titleLabel;
/**<  取消按钮  */
@property (nonatomic,strong) UIButton *cancelButton;
/**<  保存按钮  */
@property (nonatomic,strong) UIButton *saveButton;


@end



@implementation DDSelectPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}



- (void)createView
{
    self.backgroundColor = [UIColor clearColor];
    
    /**<  初始化pickerView的背景视图  */
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = DDRGBAColor(0, 0, 0, 1);
    backView.alpha = 0;
    backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickBackView)];
    [backView addGestureRecognizer:singleTap1];
    [self addSubview:backView];
    self.backView = backView;
    
    //创建时间选择器的父视图，透明
    UIView *pickerBackView = [[UIView alloc] init];
    pickerBackView.backgroundColor = DDRGBAColor(255, 255, 255, 1);
    [self addSubview:pickerBackView];
    self.pickerBackView = pickerBackView;
    
    //选择器的顶部白条，包含确定和取消按钮
    UIView *titleBarView = [[UIView alloc] init];
    [titleBarView setBackgroundColor:DDRGBAColor(253, 253, 253, 1)];
    titleBarView.layer.borderWidth = 0.5;
    titleBarView.layer.borderColor = DDRGBAColor(233, 233, 233, 1).CGColor;
    [self.pickerBackView addSubview:titleBarView];
    self.titleBarView = titleBarView;
    
    //选择器
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor = DDRGBAColor(255, 255, 255, 1);
    [self.pickerBackView addSubview:pickerView];
    self.pickerView = pickerView;
    
    //取消按钮
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:kTitleFont];
    [btnCancel setTitleColor:DDRGBAColor(102, 102, 102, 1) forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(pickerCancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBarView addSubview:btnCancel];
    self.cancelButton = btnCancel;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = DDRGBAColor(51, 51, 51, 1);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.titleBarView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    //确定按钮
    UIButton *btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSave setTitle:@"保存" forState:UIControlStateNormal];
    [btnSave.titleLabel setFont:kTitleFont];
    [btnSave setTitleColor:DDRGBAColor(32, 198, 122, 1) forState:UIControlStateNormal];
    [btnSave addTarget:self action:@selector(pickerSaveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBarView addSubview:btnSave];
    self.saveButton = btnSave;
}



- (void)layoutSubviews
{
    self.backView.frame = self.bounds;
    
    self.pickerBackView.x = 0;
    self.pickerBackView.y = self.height-262;
    self.pickerBackView.width = self.width;
    self.pickerBackView.height = 262;
    
    
    self.titleBarView.x = 0;
    self.titleBarView.y = 0;
    self.titleBarView.width = self.pickerBackView.width;
    self.titleBarView.height = 46;
    
    
    self.pickerView.y = self.titleBarView.height;
    self.pickerView.height = 216;
    self.pickerView.width = self.pickerBackView.width;
    self.pickerView.centerx = self.pickerBackView.centerx;
    
    
    self.cancelButton.x = 0;
    self.cancelButton.y = 0;
    self.cancelButton.height = self.titleBarView.height;
    self.cancelButton.width = 60;
    
    self.saveButton.x = self.titleBarView.width-60;
    self.saveButton.y = 0;
    self.saveButton.height = self.titleBarView.height;
    self.saveButton.width = 60;
    
    
    self.titleLabel.x = 60;
    self.titleLabel.y = 0;
    self.titleLabel.width = self.titleBarView.width - 120;
    self.titleLabel.height = self.titleBarView.height;

}




#pragma mark - 点击事件
/**
 *  取消按钮
 */
- (void)pickerCancelClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerCancelButtonClick)]) {
        [self.delegate pickerCancelButtonClick];
    }
}

/**
 *  保存按钮
 */
- (void)pickerSaveClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSaveButtonClick)]) {
        [self.delegate pickerSaveButtonClick];
    }
}





/**
 *  点击背景视图
 */
- (void)onClickBackView{
    [self pickerCancelClick];
}



-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}






@end
