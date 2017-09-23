//
//  DDItemTypeView.m
//  DDExpressClient
//
//  Created by SongGang on 3/11/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDItemTypeView.h"
#import "Constant.h"

@interface DDItemTypeView ()
/** 选择器 */
@property (nonatomic,strong) UIPickerView * pickerView;
/** 取消按钮 */
@property (nonatomic,strong) UIButton * cancelButton;
/** 确定按钮 */
@property (nonatomic,strong) UIButton * okButton;
/** 选择器的名字 */
@property (nonatomic,strong) UIView * titleView;
@end


@implementation DDItemTypeView

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
    self.cancelButton.titleLabel.font = kTitleFont;
    [self.cancelButton setTitleColor:CONTENT_COLOR forState:UIControlStateNormal];
    self.cancelButton.x = 0;
    self.cancelButton.y = 0;
    self.cancelButton.width = 50;
    self.cancelButton.height = 45;
    
    [self.okButton setTitle:@" 确定" forState:UIControlStateNormal];
    self.okButton.titleLabel.font = kTitleFont;
    [self.okButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
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
    titleLabel.text = @"物品类型";
    titleLabel.font = kContentFont;
    titleLabel.textColor = TITLE_COLOR;
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
    return [self.itemTypeArray count];
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
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
     
    UILabel * label = [[UILabel alloc] init];
    label.x = 0 ;
    label.y = 0;
    label.width = 102.5;
    label.height = 45;
    label.textColor = DDRGBColor(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.text = [self.itemTypeArray objectAtIndex:row];
    
    return label ;
}

/**
   取消动作
 */
-(void) cancelAction
{
    if ([_delegate respondsToSelector:@selector(itemTypeCancelAction)]) {
        [_delegate itemTypeCancelAction];
    }
}

/**
    确定动作
 */
- (void) okAction
{
    NSUInteger row = [self.pickerView selectedRowInComponent:0];
    NSString * string = [self.itemTypeArray objectAtIndex:row];
    if ([_delegate respondsToSelector:@selector(itemTypeOKAction:)]) {
        [_delegate itemTypeOKAction:string];
    }
}

- (void)showSelectedType:(NSString *)type
{
    NSInteger index = [self.itemTypeArray indexOfObject:type];
    
    [self.pickerView selectRow:index inComponent:0 animated:YES];
}


@end
