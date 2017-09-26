//
//  DDTipView.m
//  DDExpressClient
//
//  Created by SongGang on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDTipView.h"

#import "Constant.h"

@interface DDTipView ()
/** 选择器 */
@property (nonatomic,strong) UIPickerView * pickerView;
/** 取消按钮 */
@property (nonatomic,strong) UIButton * cancelButton;
/** 确定按钮 */
@property (nonatomic,strong) UIButton * okButton;
/** 选择器的名字 */
@property (nonatomic,strong) UIView * titleView;
@end


@implementation DDTipView
#pragma mark - 类的初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

/**
 初始化View
 */
-(void)initView
{
    UIView *tView = [[UIView alloc] init];
    [self addSubview:tView];
    self.titleView = tView;
    
    UIPickerView * pview = [[UIPickerView alloc] init];
    [self addSubview:pview];
    self.pickerView = pview;
    self.pickerView.dataSource = self;
    self.pickerView.delegate  = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerView setFrame:CGRectMake(0, 46,CGRectGetWidth(self.frame), 188.5)];
    
    UIButton * cbutton = [[UIButton alloc] init];
    [self.titleView addSubview:cbutton];
    self.cancelButton = cbutton;
    [self.cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * okbutton = [[UIButton alloc] init];
    [self.titleView addSubview:okbutton];
    self.okButton = okbutton;
    [self.okButton addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

/**
 布局view
 */
-(void)layoutSubviews
{
    self.titleView.x = 0 ;
    self.titleView.y = 0 ;
    self.titleView.width = self.width;
    self.titleView.height = 45;
    self.titleView.backgroundColor = DDRGBColor(253, 253, 253);
    
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.cancelButton setTitleColor:DDRGBColor(102 ,102 ,102 ) forState:UIControlStateNormal];
    self.cancelButton.x = 0;
    self.cancelButton.y = 0;
    self.cancelButton.width = 50;
    self.cancelButton.height = 45;
    
    [self.okButton setTitle:@" 确定" forState:UIControlStateNormal];
    self.okButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.okButton setTitleColor:DDRGBColor(32 ,198 ,122 ) forState:UIControlStateNormal];
    self.okButton.x = self.width - 50;
    self.okButton.y = 0;
    self.okButton.width = 50;
    self.okButton.height = 45;
    
    UILabel * linelabel = [[UILabel alloc] init];
    linelabel.x = 0 ;
    linelabel.y = self.okButton.height ;
    linelabel.width = self.width;
    linelabel.height = 0.5f;
    linelabel.backgroundColor = DDRGBColor(229, 229, 229);
    [self addSubview:linelabel];
    
    for (int i = 0; i <2 ; i ++) {
        
        UILabel * upLine = [[UILabel alloc] init];
        upLine.x =  15;
        upLine.y = 115.5 + i * 45;
        upLine.width = self.width -30;
        upLine.height = 0.5f;
        upLine.backgroundColor = DDRGBColor(213, 214, 215);
        [self addSubview:upLine];
    }
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择小费金额";
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = DDRGBColor(51, 51, 51);
    titleLabel.size = CGSizeMake(150, 45);
    titleLabel.center = CGPointMake(self.width/2, 45/2);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
}

/**
 选择器的分组数
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**
 选择器每组中的行数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

/**
 选择器的列宽
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component __TVOS_PROHIBITED
{
    return self.width;
}

/**
 选择器的行高
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45.0f;
}

/**
 选择器的每项的view
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *itemWeight = @"0元（普通件）/2元（60分钟必达件）/4元（30分钟必达件）";
    NSArray * firstArray = [itemWeight componentsSeparatedByString:@"/"];
    
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    
    UILabel * label = [[UILabel alloc] init];
    label.x = 0 ;
    label.y = 0;
    label.width = self.width;
    label.height = 45;
    label.textColor = DDRGBColor(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = [firstArray objectAtIndex:row];
    
    return label ;
}

/**
 取消动作
 */
-(void) cancelAction
{
    if ([_delegate respondsToSelector:@selector(tipCancelAction)]) {
        [_delegate tipCancelAction];
    }
}


/**
 确定动作
 */
- (void) okAction
{
    NSUInteger row = [self.pickerView selectedRowInComponent:0];
    NSString *itemWeight = @"0元（普通件）/2元（60分钟必达件）/4元（30分钟必达件）";
    NSArray * firstArray = [itemWeight componentsSeparatedByString:@"/"];
    NSString * string = [firstArray objectAtIndex:row];
    
    if ([_delegate respondsToSelector:@selector(tipOKAction:)]) {
        [_delegate tipOKAction:string];
    }
}

- (void)showSelectedTip:(NSString *)tip
{
    NSString *tmp = @"0元（普通件）/2元（60分钟必达件）/4元（30分钟必达件）";
    NSArray *arr = [tmp componentsSeparatedByString:@"/"];
    NSInteger index = [arr indexOfObject:tip];
    [self.pickerView selectRow:index inComponent:0 animated:YES];
}

@end
