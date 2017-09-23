//
//  CourierCompanyViewController.h
//  DuDu Courier
//
//  Created by yangg on 16/2/19.
//  Copyright © 2016年 yangg. All rights reserved.
//

/**
    快递公司列表视图
 */

#import "DDRootViewController.h"
#import "DDInterface.h"

/** limitFlag=YES, 为不限，NO取array数组的值 */
@protocol DDCourierCompanyViewDelegate <NSObject>
@optional
- (void)setCouriercompany:(NSMutableArray *)array withLimit:(BOOL)limitFlag;
@end

@interface DDCourierCompanyViewController : DDRootViewController

@property (nonatomic, strong) id<DDCourierCompanyViewDelegate> delegate ;

@property (nonatomic, strong) NSArray *idArray;

@end
