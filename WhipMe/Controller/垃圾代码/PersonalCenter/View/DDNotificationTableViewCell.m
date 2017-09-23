//
//  DDNotificationTableViewCell.m
//  DDExpressClient
//
//  Created by Sxx on 16/4/27.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDNotificationTableViewCell.h"


@interface DDNotificationTableViewCell ()

@property (nonatomic, strong)   IBOutlet UIView                             *backView;                                  /**< 背景视图 */
@property (nonatomic, strong)   IBOutlet UIControl                          *detailView;                                /**< 内容视图 */
@property (nonatomic, strong)   IBOutlet UILabel                            *titleLabel;                                /**< 标题标签 */
@property (nonatomic, strong)   IBOutlet UILabel                            *contentLabel;                              /**< 内容标签 */
@property (nonatomic, strong)   IBOutlet UILabel                            *timeLabel;                                 /**< 时间标签 */
@property (nonatomic, strong)   IBOutlet UIImageView                        *arrowImageView;                            /**< 箭头图片视图 */

@end

@implementation DDNotificationTableViewCell

#pragma mark -
#pragma mark Super Methods

- (void)dealloc {
    self.delegate       = nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.autoresizingMask               = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.contentView.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIView *cell    = [[[NSBundle mainBundle] loadNibNamed:@"DDNotificationTableViewCell" owner:self options:nil] firstObject];
        cell.frame      = self.contentView.bounds;
        [self.contentView addSubview:cell];
        
        [self initDetailView];
    }
    
    return self;
}

#pragma mark -
#pragma mark Public Methods

- (void)setCellInfo:(DDNotificationCellInfo *)cellInfo {
    _cellInfo   = cellInfo;
    
    self.titleLabel.text                    = self.cellInfo.title;
    self.contentLabel.text                  = self.cellInfo.content;
    self.timeLabel.text                     = self.cellInfo.time;
    self.arrowImageView.hidden              = self.cellInfo.canSelect ? NO : YES;
    self.detailView.userInteractionEnabled  = self.cellInfo.canSelect ? YES : NO;
}

#pragma mark -
#pragma mark Private Methods

#pragma mark Inits

/**
 *  初始化内容视图
 */
- (void)initDetailView {
    self.detailView.frame = CGRectMake(0.0f, 0.0f, self.backView.bounds.size.width, self.backView.bounds.size.height - 0.3f);
}

#pragma mark Actions

/**
 *  内容视图按下
 *
 *  @param sender 视图对象
 */
- (IBAction)detailViewTouchDown:(id)sender {
    UIView *view = (UIView *)sender;
    view.backgroundColor = [UIColor colorWithRed:0.97f green:0.96f blue:0.96f alpha:1.0f];
}

/**
 *  内容视图外面抬起
 *
 *  @param sender 视图对象
 */
- (IBAction)detailViewTouchUpOutside:(id)sender {
    UIView *view = (UIView *)sender;
    view.backgroundColor = [UIColor whiteColor];
}

/**
 *  内容视图取消
 *
 *  @param sender 视图对象
 */
- (IBAction)detailViewTouchCancel:(id)sender {
    UIView *view = (UIView *)sender;
    view.backgroundColor = [UIColor whiteColor];
}

/**
 *  内容视图中抬起
 *
 *  @param sender 视图对象
 */
- (IBAction)detailViewTouchUpInside:(id)sender {
    UIView *view = (UIView *)sender;
    view.backgroundColor = [UIColor whiteColor];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:selectWithIndexPath:)]) {
        [self.delegate cell:self selectWithIndexPath:self.cellInfo.indexPath];
    }
}

@end


/**
 *  单元格数据
 */
@interface DDNotificationCellInfo ()

@property (nonatomic, strong, readwrite)     NSIndexPath                            *indexPath;                         /**< 索引 */
@property (nonatomic, copy, readwrite)       NSString                               *title;                             /**< 标题 */
@property (nonatomic, copy, readwrite)       NSString                               *content;                           /**< 内容 */
@property (nonatomic, copy, readwrite)       NSString                               *time;                              /**< 时间 */
@property (nonatomic, assign, readwrite)     BOOL                                    canSelect;                         /**< 是否能选择 */

@end

@implementation DDNotificationCellInfo

#pragma mark -
#pragma mark Public Methods

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title content:(NSString *)content time:(NSString *)time canSelect:(BOOL)canSelect {
    self = [super init];
    if (self) {
        self.indexPath      = indexPath;
        self.title          = title;
        self.content        = content;
        self.time           = time;
        self.canSelect      = canSelect;
    }
    
    return self;
}

@end