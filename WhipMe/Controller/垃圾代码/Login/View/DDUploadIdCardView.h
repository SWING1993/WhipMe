//
//  DDUploadIdCardView.h
//  DDExpressClient
//
//  Created by yangg on 16/3/24.
//  Copyright © 2016年 NS. All rights reserved.
//
/**
 身份认真上传图片身份证照片，和手持身份证消息弹窗
 */

#import <UIKit/UIKit.h>

@class DDUploadIdCardView;
@protocol DDUploadIdCardViewDelegate <NSObject>
@optional
- (void)uploadIdCardView:(DDUploadIdCardView *)cardView withIndex:(NSInteger)indexButton;

@end


@interface DDUploadIdCardView : UIView

/**
 身份认真上传图片身份证照片，和手持身份证消息弹窗
 imagePath : 图片的名称
 title : 图片的说明，标题
 delegate : 弹窗按钮事件对应的协议
 nextTitle : 左边按钮的标题
 otherTitle : 右边按钮的标题
 */
- (instancetype)initWithImagePath:(NSString *)imagePath
                        withTitle:(NSString *)title
                         delegate:(id<DDUploadIdCardViewDelegate>)objDelegate
                         withNext:(NSString *)nextTitle
                        withOther:(NSString *)otherTitel;
/** 视图显示调用 */
- (void)show;

@end
