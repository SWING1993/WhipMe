//
//  HKPickerPassengerView.h
//  BlackCard
//
//  Created by anve on 16/12/13.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HKPickerPassengerViewType) {
    /** 学制 */
    HKPickerPassengerViewTypeEductionalSystme = 0,
    /** 入学年份 */
    HKPickerPassengerViewTypeSchoolYear,
    /** 出生日期 */
    HKPickerPassengerViewTypeBirthday,
};

@protocol HKPickerPassengerViewDelegate;

@interface HKPickerPassengerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

/** 选择器灰色背景  */
@property (nonatomic, strong) UIView *viewBlack;
/** 选择器背景  */
@property (nonatomic, strong) UIView *viewCurrent;
/** 选择器上层条  */
@property (nonatomic, strong) UIView *titleView;
/** 选择器标题  */
@property (nonatomic, strong) UILabel *lblTitle;
/** 取消按钮  */
@property (nonatomic, strong) UIButton *btnCancel;
/** 保存按钮  */
@property (nonatomic, strong) UIButton *btnSave;
/** 分割线  */
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineTwo;
/** 选择器  */
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, strong) NSMutableArray *arrayContent;

/** 初始化生日，默认为［NSDate date］ */
@property (nonatomic, copy  ) NSString *default_birghday;

@property (nonatomic, assign) HKPickerPassengerViewType pickerType;
@property (nonatomic, weak  ) id<HKPickerPassengerViewDelegate> delegate;
@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, assign) NSInteger selectIndex;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title delegate:(id<HKPickerPassengerViewDelegate>)delegate type:(HKPickerPassengerViewType)type;

- (void)setData;

@end


@protocol HKPickerPassengerViewDelegate <NSObject>
@optional
- (void)pickerPassengerViewCancel:(HKPickerPassengerView *)pickerView;
- (void)pickerPassengerView:(HKPickerPassengerView *)pickerView didData:(NSString *)string;

@end

