//
//  JCHATLoadMessageTableViewCell.m
//  JChat
//
//  Created by HuminiOS on 15/10/23.
//  Copyright © 2015年 HXHG. All rights reserved.
//

#import "JCHATLoadMessageTableViewCell.h"

@implementation JCHATLoadMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self != nil) {
    loadIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([Define screenWidth]/2 - 10, 10, 20, 20)];
    [loadIndicator startAnimating];
    loadIndicator.hidesWhenStopped = NO;
    loadIndicator.color = [UIColor grayColor];
    [self addSubview:loadIndicator];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  return self;
}

- (void)startLoading {
  [loadIndicator startAnimating];
}

@end
