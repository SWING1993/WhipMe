//
//  DDCustomField.m
//  DDExpressClient
//
//  Created by SongGang on 2/25/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDCustomField.h"

@implementation DDCustomField

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}


@end
