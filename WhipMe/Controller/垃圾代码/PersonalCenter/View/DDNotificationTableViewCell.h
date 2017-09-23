//
//  DDNotificationTableViewCell.h
//  DDExpressClient
//
//  Created by Sxx on 16/4/27.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol   DDNotificationCellDelegate;
@class      DDNotificationCellInfo;


/**
 *  通知列表单元格
 */
@interface DDNotificationTableViewCell : UITableViewCell

@property (nonatomic, weak)     id<DDNotificationCellDelegate>                               delegate;                  /**< 代理 */
@property (nonatomic, strong)   DDNotificationCellInfo                                      *cellInfo;                  /**< cell数据 */

@end


/**
 *  单元格代理
 */
@protocol DDNotificationCellDelegate <NSObject>

@optional

/**
 *  cell点击
 *
 *  @param cell      cell实例
 *  @param indexPath 索引
 */
- (void)cell:(UITableViewCell *)cell selectWithIndexPath:(NSIndexPath *)indexPath;

@end


/**
 *  单元格数据
 */
@interface DDNotificationCellInfo : NSObject

@property (nonatomic, strong, readonly)     NSIndexPath                             *indexPath;                         /**< 索引 */
@property (nonatomic, copy, readonly)       NSString                                *title;                             /**< 标题 */
@property (nonatomic, copy, readonly)       NSString                                *content;                           /**< 内容 */
@property (nonatomic, copy, readonly)       NSString                                *time;                              /**< 时间 */
@property (nonatomic, assign, readonly)     BOOL                                     canSelect;                         /**< 是否能选择 */

/**
 *  初始化
 *
 *  @param indexPath 索引
 *  @param title     标题
 *  @param content   内容
 *  @param time      时间
 *  @param canSelect 是否可以选择
 *
 *  @return cell信息实体
 */
- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title content:(NSString *)content time:(NSString *)time canSelect:(BOOL)canSelect;

@end