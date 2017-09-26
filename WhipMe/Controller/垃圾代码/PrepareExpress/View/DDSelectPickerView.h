//
//  DDSelectPickerView.h
//  DDExpressCourier
//
//  Created by yoga on 16/3/31.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDSelectPickerView;
@protocol DDSelectPickerViewDelegate <NSObject>
/**<  取消按钮点击事件  */
- (void)pickerCancelButtonClick;
/**<  确定按钮点击事件  */
- (void)pickerSaveButtonClick;
@end



@interface DDSelectPickerView : UIView
/**<  选择器  */
@property (nonatomic,strong) UIPickerView *pickerView;
/**<  背景变暗视图  */
@property (nonatomic,strong) UIView *backView;
/**<  标题  */
@property (nonatomic,strong) NSString *title;

@property (nonatomic,weak) id<DDSelectPickerViewDelegate> delegate;


@end
