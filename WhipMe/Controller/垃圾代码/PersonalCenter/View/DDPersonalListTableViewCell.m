//
//  DDPersonalListTableViewCell.m
//  DDExpressClient
//
//  Created by SongGang on 3/4/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDPersonalListTableViewCell.h"

/** tableView section header的高度 */
#define DDHeightForHeader 10.0f
/** tableViewCell的高度 */
#define DDHeightForRowCell (DDHeightForHeader*2.0f + 30.0f)
/** 图片与Title之间的距离 */
#define  DDCellIconSpaceToTitle 60.0f
/** 图片的宽和高 */
#define DDCellListIconWH 18.0f
/** Icon的X坐标 */
#define DDCellLeftSpace 20.0f

@implementation DDPersonalListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.textLabel setFont:kTitleFont];
        [self.textLabel setTextColor:TITLE_COLOR];
        [self.textLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(DDCellLeftSpace, (DDHeightForRowCell - DDCellListIconWH)/2.0f, DDCellListIconWH, DDCellListIconWH)];
    
    CGSize text_size = [self.textLabel.text sizeWithAttributes:@{NSFontAttributeName : self.textLabel.font}];
    
    [self.textLabel setFrame:CGRectMake(DDCellIconSpaceToTitle, self.imageView.top, floorf(text_size.width)+1.0f, DDCellListIconWH)];
}

@end
