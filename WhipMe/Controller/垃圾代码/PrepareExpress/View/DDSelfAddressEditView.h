//
//  DDSelfAddressEditView.h
//  DDExpressClient
//
//  Created by SongGang on 2/25/16.
//  Copyright © 2016 NS. All rights reserved.
//

/**
    编辑寄件人地址
 */

#import <UIKit/UIKit.h>
#import "DDAddressDetail.h"
#import "DDCustomField.h"

@class DDAddressDetail;


@protocol DDSelfAddressEditViewDelegate <NSObject>
- (IBAction)signButtonAction:(id)sender;
@end

@interface DDSelfAddressEditView : UIView <UITextFieldDelegate>

@property (nonatomic,strong) DDAddressDetail * addressDetail;
@property (nonatomic , weak) id <DDSelfAddressEditViewDelegate> delegate;

@end
