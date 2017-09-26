//
//  HPTextViewInternal.h
//  DDExpressClient
//
//  Created by yangg on 16/3/8.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HPTextViewInternal : UITextView

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic) BOOL displayPlaceHolder;

@end
