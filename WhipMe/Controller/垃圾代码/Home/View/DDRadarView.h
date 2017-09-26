//
//  DDRadarView.h
//  DDExpressClient
//
//  Created by JiChao on 16/5/5.
//  Copyright © 2016年 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDRadarView : UIView

@property (nonatomic, strong) UIImage *thumbnailImage;

- (instancetype)initWithFrame:(CGRect)frame thumbnail:(NSString *)thumbnailUrl;

@end
