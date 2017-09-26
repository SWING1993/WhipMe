//
//  DDTakeTimeView.m
//  DDExpressClient
//
//  Created by SongGang on 3/1/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDTakeTimeView.h"
#import "Constant.h"

@interface DDTakeTimeView()

/** 选择器 */
@property (nonatomic,strong) UIPickerView * pickerView;
/** 取消按钮 */
@property (nonatomic,strong) UIButton * cancelButton;
/** 确定按钮 */
@property (nonatomic,strong) UIButton * okButton;
/** 选择器的名字 */
@property (nonatomic,strong) UIView * titleView;

@property (nonatomic,strong) NSArray * firstArray;

@property (nonatomic,strong) NSArray * secondArray;

@property (nonatomic,strong) NSArray * thirdArray;

@end

@implementation DDTakeTimeView
#pragma mark - 类的初始化方法
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initArrayValue];
    }
    return self;
}

/**
   初始化时间数组
 */
- (void) initArrayValue
{
    _firstArray = [KSQSJDate componentsSeparatedByString:@"/"];
    _secondArray = [KSQSJTime componentsSeparatedByString:@"/"];
    _thirdArray = [KSQSJMinute componentsSeparatedByString:@"/"];
}
/**
 初始化view
 */
-(void)initView
{
     UIView *tView = [[UIView alloc] init];
    [self addSubview:tView];
    self.titleView = tView;
    
    UIPickerView *  pview = [[UIPickerView alloc] init];
    [self addSubview:pview];
    self.pickerView = pview;
    self.pickerView.dataSource = self;
    self.pickerView.delegate  = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerView setFrame:CGRectMake(0, 45,CGRectGetWidth(self.frame), 188.5)];
    
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
    titleLabel.text = @"选择日期";
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
    return 3;
}

/**
 选择器每组中的行数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return 3;
        case 1:
            return [_secondArray count];
        case 2:
            return [_thirdArray count];
        default:
            return 0;
    }
}

/**
 选择器的列宽
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{

    switch (component) {
        case 1:
            return 125;
        case 2:
        case 0:
            return 80;
        default:
            return 0;
    }
}

/**
 选择器的行高
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 45.0f;
}

/**
 选择器的cellview
 */
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];

    UILabel * label = [[UILabel alloc] init];
    label.x = 0 ;
    label.y = 0;
    
    if (component == 1) {
         label.width = 125;
    }else{
        label.width = 80;
    }
   
    label.height = 45;
    label.textColor = DDRGBColor(51, 51, 51);
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        label.text = [_firstArray objectAtIndex:row];
    } else if (component == 1) {
        label.text = [_secondArray objectAtIndex:row];
    } else if (component == 2) {
        label.text = [_thirdArray objectAtIndex:row];
    }
    
    if (component == 0 && row == 0) {
        
        _secondArray = @[@"--"];
        _thirdArray = @[@"--"];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    
     if ((component == 0  && row == 1) || (component == 0 && row == 2)) {
         
         _secondArray = [[KSQSJTime componentsSeparatedByString:@"/"] mutableCopy];
         _thirdArray = [[KSQSJMinute componentsSeparatedByString:@"/"] mutableCopy];
         
         [pickerView reloadComponent:1];
         [pickerView reloadComponent:2];
    }
    
    return label ;
}

/**
 取消动作
 */
-(void) cancelAction
{
    if ([_delegate respondsToSelector:@selector(takeTimeCancelAction)]) {
        [_delegate takeTimeCancelAction];
    }
}

/**
 确定动作
 */
- (void) okAction
{
    NSUInteger dateRow = [self.pickerView selectedRowInComponent:0];
    NSUInteger timeRow = [self.pickerView selectedRowInComponent:1];
    NSUInteger minuteRow = [self.pickerView selectedRowInComponent:2];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString * dateTime = [formatter stringFromDate:[NSDate date]];
    NSArray * timeArray = [dateTime componentsSeparatedByString:@":"];
    NSInteger  hourValue = [[timeArray firstObject] integerValue];
    NSInteger  minuvalue = [[timeArray lastObject] integerValue];
    
    NSString * dateString = [_firstArray objectAtIndex:dateRow];
    NSString * timeString = [[_secondArray objectAtIndex:timeRow] stringByAppendingString:@":"];
    NSString * minuteString = [_thirdArray objectAtIndex:minuteRow];
    
    if ([dateString isEqualToString:@"今天"]) {
        if ([[_secondArray objectAtIndex:timeRow] integerValue]< hourValue || ([[_secondArray objectAtIndex:timeRow] integerValue] == hourValue && [minuteString integerValue] < minuvalue)) {
            
            UIAlertView * alter = [[UIAlertView alloc] initWithTitle:nil
                                                             message:@"您的取件时间必须大于现在时间，请重新选择"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil, nil];
            [alter show];
            return;
        }
    }
    
    NSString * string = [[dateString stringByAppendingString:timeString] stringByAppendingString:minuteString];
    
    if ([_delegate respondsToSelector:@selector(taketimeOKAction:)]) {
        [_delegate taketimeOKAction:string];
    }
}

- (void)showCurrentTime:(NSString *)currentTime
{
    if ([currentTime isEqualToString:@"现在"]) {
        
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        [self.pickerView selectRow:0 inComponent:2 animated:YES];
        
    } else {
        NSString *dayMode = [currentTime substringWithRange:NSMakeRange(0, 2)];
        NSString *hourMode = [currentTime substringWithRange:NSMakeRange(2, 2)];
        NSString *minMode = [currentTime substringWithRange:NSMakeRange(5, 2)];
        
        NSInteger firstIndex = [_firstArray indexOfObject:dayMode];
        NSInteger secondIndex = [_secondArray indexOfObject:hourMode];
        NSInteger thirdIndex = [_thirdArray indexOfObject:minMode];
        
        [self.pickerView selectRow:firstIndex inComponent:0 animated:YES];
        [self.pickerView selectRow:secondIndex inComponent:1 animated:YES];
        [self.pickerView selectRow:thirdIndex inComponent:2 animated:YES];
    }
    
}

@end
