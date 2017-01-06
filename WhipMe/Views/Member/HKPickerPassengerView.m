//
//  HKPickerPassengerView.m
//  BlackCard
//
//  Created by anve on 16/12/13.

#import "HKPickerPassengerView.h"

@implementation HKPickerPassengerView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title delegate:(id<HKPickerPassengerViewDelegate>)delegate type:(HKPickerPassengerViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _title = title;
        _pickerType = type;
        [self setup];
        [self setData];
    }
    return self;
}

- (void)setData {
    
    if (self.title) {
        [self.lblTitle setText:self.title];
    }
    
    if (self.pickerType == HKPickerPassengerViewTypeBirthday) {
        [self.datePicker setHidden:NO];
        [self.pickerView setHidden:YES];
    } else {
        [self.pickerView setHidden:NO];
        [self.datePicker setHidden:YES];
        if (self.pickerType == HKPickerPassengerViewTypeSchoolYear) {
            [self createSchoolYear];
        } else if (self.pickerType == HKPickerPassengerViewTypeEductionalSystme) {
            [self createEductionalSystme];
        }
        [self.pickerView reloadAllComponents];
    }
}

- (void)setDefault_birghday:(NSString *)default_birghday {
    _default_birghday = default_birghday;
    if ([NSString isBlankString:default_birghday]) {
        return;
    }
    if (self.pickerType == HKPickerPassengerViewTypeBirthday) {
        [self.datePicker setDate:[NSDate dateWithString:default_birghday format:@"yyyy-MM-dd"]];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.lblTitle setText:title];
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    [self.pickerView selectRow:selectIndex inComponent:0 animated:NO];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    _viewBlack = [UIView new];
    [_viewBlack setBackgroundColor:[UIColor blackColor]];
    [_viewBlack setAlpha:0.0];
    [_viewBlack setUserInteractionEnabled:YES];
    [self addSubview:self.viewBlack];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWithBlack)];
    [self.viewBlack addGestureRecognizer:singleTap1];
    [self.viewBlack mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _viewCurrent = [UIView new];
    [_viewCurrent setBackgroundColor:[Define kColorBackGround]];
    [self addSubview:self.viewCurrent];
    [self.viewCurrent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(264.0);
        make.left.and.width.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    _titleView = [UIView new];
    [_titleView setBackgroundColor:[UIColor whiteColor]];
    [self.viewCurrent addSubview:self.titleView];
    [self.titleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(48.0);
        make.left.and.top.and.width.equalTo(self.viewCurrent);
    }];
    
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [_btnCancel.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_btnCancel setTitleColor:[Define kColorLight] forState:UIControlStateNormal];
    [_btnCancel addTarget:self action:@selector(clickWithCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:self.btnCancel];
    [self.btnCancel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50.0);
        make.height.equalTo(self.titleView);
        make.left.and.top.equalTo(self.titleView);
    }];
    
    _btnSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSave setTitle:@"确定" forState:UIControlStateNormal];
    [_btnSave.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_btnSave setTitleColor:[Define kColorBlack] forState:UIControlStateNormal];
    [_btnSave addTarget:self action:@selector(clickWithSave) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:self.btnSave];
    [self.btnSave mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50.0);
        make.height.equalTo(self.titleView);
        make.top.and.right.equalTo(self.titleView);
    }];
    
    _lblTitle = [UILabel new];
    [_lblTitle setBackgroundColor:[UIColor clearColor]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    [_lblTitle setFont:[UIFont systemFontOfSize:16.0]];
    [_lblTitle setTextColor:[Define kColorBlack]];
    [self.titleView addSubview:self.lblTitle];
    [self.lblTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.titleView);
        make.top.equalTo(self.titleView);
        make.left.equalTo(self.btnCancel.mas_right);
        make.right.equalTo(self.btnSave.mas_left);
    }];
    
    _lineView = [UIView new];
    [_lineView setBackgroundColor:[Define kColorLine]];
    [self.titleView addSubview:self.lineView];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.and.top.and.width.equalTo(self.titleView);
    }];
    
    _lineTwo = [UIView new];
    [_lineTwo setBackgroundColor:[Define kColorLine]];
    [self.titleView addSubview:self.lineTwo];
    [self.lineTwo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.and.width.equalTo(self.titleView);
        make.bottom.equalTo(self.titleView);
    }];
    
    _datePicker = [[UIDatePicker alloc] init];
    [_datePicker setBackgroundColor:[UIColor whiteColor]];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setDate:[NSDate date]];
    [_datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
    [_datePicker setMaximumDate:[NSDate date]];
    [_datePicker setHidden:YES];
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [self.viewCurrent addSubview:_datePicker];
    [self.datePicker mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.viewCurrent);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.viewCurrent);
    }];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    self.datePicker.locale = locale;
    
    _pickerView = [UIPickerView new];
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    [_pickerView setDelegate:self];
    [_pickerView setDataSource:self];
    [self.viewCurrent addSubview:self.pickerView];
    [self.pickerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.viewCurrent);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.viewCurrent);
    }];
    
    
}

- (void)clickWithBlack
{
    [self clickWithCancel];
}

- (void)clickWithCancel
{
    if ([self.delegate respondsToSelector:@selector(pickerPassengerViewCancel:)]) {
        [self.delegate pickerPassengerViewCancel:self];
    }
}

- (void)clickWithSave
{
    NSString *str_title = [NSString string];
    if (self.pickerType == HKPickerPassengerViewTypeBirthday) {
        str_title = [self.datePicker.date formatYMDWith:@"-"];
    } else {
        NSInteger row = [self.pickerView selectedRowInComponent:0];
        if (self.arrayContent.count > row) {
            str_title = [self.arrayContent objectAtIndex:row];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(pickerPassengerView:didData:)]) {
        [self.delegate pickerPassengerView:self didData:str_title];
    }
}

- (void)dateChanged:(UIDatePicker *)picker
{
//    NSString *birghday = [picker.date formatYMD];
}

#pragma mark - UIPickerViewDelegate And UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.arrayContent count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.arrayContent count] > row) {
        return self.arrayContent[row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    if (component == 2) {
//        self.indexArea = row;
//    } else if (component == 1) {
//        if ([self.arrayCity count] > row) {
//            CityModel *city = [self.arrayCity objectAtIndex:row];
//            
//            [self.arrayArea removeAllObjects];
//            for (NSDictionary *itemObj in city.sub) {
//                AreaModel *areaModel = [AreaModel mj_objectWithKeyValues:itemObj];
//                [self.arrayArea addObject:areaModel];
//            }
//        }
//        self.indexCity = row;
//        self.indexArea = 0;
//        [pickerView selectRow:self.indexArea inComponent:2 animated:NO];
//    } else {
//        if ([self.arrayProvince count] > row) {
//            ProvinceModel *province = [self.arrayProvince objectAtIndex:row];
//            
//            [self.arrayCity removeAllObjects];
//            for (NSDictionary *itemObj in province.sub) {
//                CityModel *cityModel = [CityModel mj_objectWithKeyValues:itemObj];
//                [self.arrayCity addObject:cityModel];
//            }
//            
//            if ([self.arrayCity count] > 0) {
//                CityModel *cityModel = [self.arrayCity firstObject];
//                
//                [self.arrayArea removeAllObjects];
//                for (NSDictionary *itemObj in cityModel.sub) {
//                    AreaModel *areaModel = [AreaModel mj_objectWithKeyValues:itemObj];
//                    [self.arrayArea addObject:areaModel];
//                }
//            }
//            self.indexProvince = row;
//            self.indexCity = 0;
//            [pickerView selectRow:self.indexCity inComponent:1 animated:NO];
//            self.indexArea = 0;
//            [pickerView selectRow:self.indexArea inComponent:2 animated:NO];
//        }
//    }
    [pickerView reloadAllComponents];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setAdjustsFontSizeToFitWidth:YES];
        [pickerLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16.0]];
        [pickerLabel setTextColor:[UIColor blackColor]];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - 懒加载
- (NSMutableArray *)arrayContent
{
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

- (void)createEductionalSystme {
    [self.arrayContent removeAllObjects];
    for (NSInteger i=0; i<9; i++) {
        NSString *str_title = [NSString stringWithFormat:@"%ld年",(long)(i+1)];
        [self.arrayContent addObject:str_title];
    }
}

- (void)createSchoolYear {
    NSInteger year_int = [NSDate year:[NSDate date]];
    DebugLog(@"________year_int:%ld",(long)year_int);
    
    [self.arrayContent removeAllObjects];
    for (NSInteger i=year_int; i>=(year_int-9); i--) {
        NSString *str_title = [NSString stringWithFormat:@"%ld年",(long)i];
        [self.arrayContent addObject:str_title];
    }
}

@end
