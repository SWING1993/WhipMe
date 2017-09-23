//
//  DDLogisticsViewCell.h
//  DDExpressClient
//
//  Created by yangg on 16/3/11.
//  Copyright © 2016年 NS. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface DDLogisticsViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *lineRow;         /** 分界线 */

/** 重写传入数据的setter方法,给cell上的控件传值 */
- (void)setCellForLogistics:(NSDictionary *)cellForLogistics withIndexPath:(NSIndexPath *)indexPath;

/** 返回Cell的高度 */
@property (nonatomic, assign, readonly) CGFloat LogisticsCellHeight;

@end
