//
//  DDLabelLists.m
//  DDExpressClient
//
//  Created by yangg on 16/3/9.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDLabelLists.h"
#import <QuartzCore/QuartzCore.h>
#import "Constant.h"

#define CORNER_RADIUS 10.0f

#define FONT_SIZE 12.0f
#define HORIZONTAL_PADDING 12.0f
#define VERTICAL_PADDING 20.0f
#define SPACING_PADDING 10.0f

#define BACKGROUND_COLOR [UIColor colorWithRed:181/255.0f green:181/255.0f blue:181/255.0f alpha:1.00]
#define TEXT_COLOR [UIColor whiteColor]

#define ITEM_TAG 1111

@implementation DDLabelLists
@synthesize view, textArray;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
    }
    return self;
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
}

- (void)setLabelBorderColor:(BOOL)color
{
    labelBorderColor = color;
}

- (void)setItemLabels:(NSMutableArray *)array
{
    textArray = [array mutableCopy];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)display
{
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    float totalHeight = 0;
    float totalWidth = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    
    for (int i=0; i<textArray.count; i++)
    {
        NSString *text = textArray[i];
        if (text.length == 0) continue;
        CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]}];
        textSize.width = floorf(textSize.width) + HORIZONTAL_PADDING*2;
        textSize.height = VERTICAL_PADDING;
        
       
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!gotPreviousFrame)
        {
            [itemBtn setFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        }
        else
        {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + SPACING_PADDING > self.frame.size.width)
            {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + SPACING_PADDING);
                totalHeight += textSize.height + SPACING_PADDING;
                if (totalHeight > self.height) {
                    break;
                }
            }
            else
            {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + SPACING_PADDING, previousFrame.origin.y);
            }
            newRect.size = textSize;
            [itemBtn setFrame:newRect];
        }
        previousFrame = itemBtn.frame;
        totalWidth = MAX(totalWidth, itemBtn.right);
        
        gotPreviousFrame = YES;
        if (!lblBackgroundColor) {
            [itemBtn setBackgroundColor:BACKGROUND_COLOR];
        } else {
            [itemBtn setBackgroundColor:lblBackgroundColor];
        }
        [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [itemBtn setTitle:text forState:UIControlStateNormal];
        
        [itemBtn setAdjustsImageWhenHighlighted:false];
        [itemBtn.layer setMasksToBounds:YES];
        [itemBtn.layer setCornerRadius:CORNER_RADIUS];
        [itemBtn.layer setBorderWidth:1.0f];
        if (labelBorderColor) {
            [itemBtn.layer setBorderColor:DDGreen_Color.CGColor];
            [itemBtn setTitleColor:DDGreen_Color forState:UIControlStateNormal];
        } else {
            [itemBtn.layer setBorderColor:KPlaceholderColor.CGColor];
            [itemBtn setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        }
        [itemBtn setSelected:false];
        itemBtn.tag = ITEM_TAG + i;
        [itemBtn addTarget:self action:@selector(onItem:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [self addSubview:itemBtn];
    }
    sizeFit = CGSizeMake(totalWidth, ceilf(totalHeight));
}

- (void)setDetailTags:(NSMutableArray *)array
{
    textArray = [array mutableCopy];
    sizeFit = CGSizeZero;
    [self playDetailTags];
}

- (void)playDetailTags
{
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    
    float totalWidth = 0;
    
    CGSize textSize = CGSizeZero;
    for (NSString *item_str in textArray) {
        CGSize tempSize = [item_str sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FONT_SIZE]}];
        textSize = CGSizeMake(MAX(textSize.width, floorf(tempSize.width) + VERTICAL_PADDING*2), VERTICAL_PADDING);
    }
    
    for (int i=0; i<textArray.count; i++)
    {
        NSString *text = textArray[i];
        
        UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setFrame:CGRectMake(i*(textSize.width + SPACING_PADDING), 0, textSize.width, textSize.height)];
        [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [itemBtn setTitle:text forState:UIControlStateNormal];
        [itemBtn setAdjustsImageWhenHighlighted:false];
        [itemBtn setSelected:false];
        [itemBtn setTag:ITEM_TAG + i];
        [itemBtn addTarget:self action:@selector(clickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [itemBtn.layer setMasksToBounds:YES];
        [itemBtn.layer setCornerRadius:CORNER_RADIUS];
        [itemBtn.layer setBorderWidth:1.0f];
        
        if (!lblBackgroundColor) {
            [itemBtn setBackgroundColor:BACKGROUND_COLOR];
        } else {
            [itemBtn setBackgroundColor:lblBackgroundColor];
        }
        if (labelBorderColor) {
            [itemBtn.layer setBorderColor:DDGreen_Color.CGColor];
            [itemBtn setTitleColor:DDGreen_Color forState:UIControlStateNormal];
        } else {
            [itemBtn.layer setBorderColor:KPlaceholderColor.CGColor];
            [itemBtn setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        }
        [itemBtn setTitleColor:DDGreen_Color forState:UIControlStateSelected];
        totalWidth = MAX(totalWidth, itemBtn.right);
        
        [self addSubview:itemBtn];
    }
    sizeFit = CGSizeMake(totalWidth, self.height);
}

- (CGSize)fittedSize
{
    return sizeFit;
}

- (void)onItem:(UIButton *)sender
{
    if (!sender.selected) {
        [sender setSelected:true];
        [sender setTitleColor:DDGreen_Color forState:UIControlStateNormal];
        [sender.layer setBorderColor:DDGreen_Color.CGColor];
    } else {
        [sender setSelected:false];
        [sender setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
        [sender.layer setBorderColor:KPlaceholderColor.CGColor];
    }
    
    if ([self.delegate respondsToSelector:@selector(ddLabelLists:index:withSelect:)]) {
        [self.delegate ddLabelLists:self index:sender.tag-ITEM_TAG withSelect:sender.selected];
    }
}

- (void)clickWithItem:(UIButton *)sender
{
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *itemButton = (UIButton *)subView;
            [itemButton setSelected:itemButton.tag == sender.tag ? !itemButton.selected  : false];
            [itemButton.layer setBorderColor:itemButton.selected ? DDGreen_Color.CGColor : KPlaceholderColor.CGColor];
        }
    }
    if ([self.delegate respondsToSelector:@selector(ddLabelLists:index:withSelect:)]) {
        [self.delegate ddLabelLists:self index:sender.tag-ITEM_TAG withSelect:true];
    }
}

- (void)selectedWithAllItems:(BOOL)flag
{
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *itemButton = (UIButton *)subView;
            if (flag) {
                [itemButton setSelected:true];
                [itemButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
                [itemButton.layer setBorderColor:DDGreen_Color.CGColor];
            } else {
                [itemButton setSelected:false];
                [itemButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
                [itemButton.layer setBorderColor:KPlaceholderColor.CGColor];
            }
        }
    }
}

- (void)selectedWithIndexItems:(NSInteger)index
{
    UIButton *sender = (UIButton *)[self viewWithTag:ITEM_TAG+index];
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *itemButton = (UIButton *)subView;
            if (itemButton.tag == sender.tag) {
                [itemButton setSelected:true];
                [itemButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
                [itemButton.layer setBorderColor:DDGreen_Color.CGColor];
            } else {
                [itemButton setSelected:false];
                [itemButton setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
                [itemButton.layer setBorderColor:KPlaceholderColor.CGColor];
            }
        }
    }
}

@end
