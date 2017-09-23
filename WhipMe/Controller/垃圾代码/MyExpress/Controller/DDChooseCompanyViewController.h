//
//  DDChooseCompanyViewController.h
//  DDExpressClient
//
//  Created by yangg on 16/4/6.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRootViewController.h"


@class DDCompanyModel;
@protocol DDChooseCompanyViewDelegate <NSObject>
@optional
- (void)chooseCompanyViewWithCompany:(DDCompanyModel *)model;
@end


@interface DDChooseCompanyViewController : DDRootViewController

@property (nonatomic, assign) id<DDChooseCompanyViewDelegate> delegate;
/** 所有快递公司 */
@property (nonatomic, strong) NSMutableArray *arrayContent;

- (instancetype)initWithDelegate:(id<DDChooseCompanyViewDelegate>)delegate;


@end
