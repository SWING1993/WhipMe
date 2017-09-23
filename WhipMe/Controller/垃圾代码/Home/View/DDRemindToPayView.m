//
//  DDPayCostView.m
//  DDExpressClient
//
//  Created by SongGang on 3/28/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDRemindToPayView.h"

@interface DDRemindToPayView ()

/** 知道了按钮 */
@property (nonatomic,strong) UIButton * knownButton;
/** 去支付按钮 */
@property (nonatomic,strong) UIButton * payButton;
/** 提示标签 */
@property (nonatomic,strong) UILabel * titleLabel;
/** 图片 */
@property (nonatomic,strong) UIImageView * imageView;
/** 背景黑色半隐身视图 */
@property (nonatomic, strong) UIView *backView;
/** 弹窗视图 */
@property (nonatomic, strong) UIView *alertView;

@end

@implementation DDRemindToPayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //先隐身
        [self initView];
        self.alpha = 1;
    }
    return self;
}

- (void) initView
{
    UIView * backView = [[UIView alloc] init];
    [self addSubview:backView];
    self.backView = backView;
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.3;
    
    UIView * alterView = [[UIView alloc] init];
    [self addSubview:alterView];
    self.alertView = alterView;
    self.alertView.backgroundColor = DDRGBAColor(255, 255, 255, 1);
    self.alertView.layer.cornerRadius = 5;
    //self.alertView.layer.masksToBounds = YES;
    
    UIButton * knowButton = [[UIButton alloc] init];
    [self.alertView addSubview:knowButton];
    self.knownButton = knowButton;
    [self.knownButton setTitle:@"知道了" forState:UIControlStateNormal];
    [self.knownButton setTitleColor:DDRGBAColor(188, 188, 188, 1) forState:UIControlStateNormal];
    self.knownButton.layer.borderWidth = 1;
    self.knownButton.layer.borderColor = DDRGBAColor(188, 188, 188, 1).CGColor;
    self.knownButton.layer.cornerRadius = 15;
    self.knownButton.titleLabel.font = kContentFont;
    [self.knownButton addTarget:self action:@selector(knowButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton * payButton = [[UIButton alloc] init];
    [self.alertView addSubview:payButton];
    self.payButton = payButton;
    [self.payButton setTitle:@"去支付" forState:UIControlStateNormal];
    [self.payButton setTitleColor:DDRGBAColor(255, 255, 255, 1) forState:UIControlStateNormal];
    [self.payButton setBackgroundColor:DDRGBAColor(32, 198, 122, 1)];
    self.payButton.layer.cornerRadius = 15;
    self.payButton.titleLabel.font = kContentFont;
    [self.payButton addTarget:self action:@selector(payButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    [self.alertView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = DDRGBAColor(51, 51, 51, 1);

    UIImageView * imageView = [[UIImageView alloc] init];
    [self.alertView addSubview:imageView];
    self.imageView = imageView;
    imageView.image = [UIImage imageNamed:@"unPayViewBg"];
    imageView.contentMode = UIViewContentModeCenter;
}

- (void)layoutSubviews
{
    self.backView.frame = self.frame;
    
    self.alertView.x = 30;
    self.alertView.y = self.center.y - 126;
    self.alertView.width = self.backView.width - 60;
    self.alertView.height = 252;
    
    self.imageView.x = self.alertView.width/2-64;
    self.imageView.y = 28;
    self.imageView.width = 128;
    self.imageView.height = 76;

    self.knownButton.x = 25;
    self.knownButton.y = self.alertView.height-55;
    self.knownButton.width = self.alertView.width/2-32;
    self.knownButton.height = 30;
 
    self.payButton.x = self.alertView.width/2+7;
    self.payButton.y = self.alertView.height-55;
    self.payButton.width = self.alertView.width/2-32;
    self.payButton.height = 30;

    self.titleLabel.x = 25;
    self.titleLabel.y = 133;
    self.titleLabel.width = self.alertView.width-50;
    self.titleLabel.height = 18*3;
}

- (void)setUnPayCount:(NSInteger)unPayCount
{
    _unPayCount = unPayCount;
    if (unPayCount == -1) {
        self.titleLabel.text = [NSString stringWithFormat:@"您有未支付订单,需完成支付才能继续寄件"];
        [self.knownButton setTitle:@"取消" forState:UIControlStateNormal];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"您有%ld个快递订单正在进行",(long)unPayCount];
        [self.knownButton setTitle:@"知道了" forState:UIControlStateNormal];
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
        int attributedLength = (int)([self.titleLabel.text length] - 11);
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, attributedLength)];
        self.titleLabel.attributedText = attributedString;
    }

    
}
- (void) knowButtonClick
{
    [self setHidden:YES];
}

- (void) payButtonClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(remindToPayView:didClickPayBtn:)]) {
        [_delegate remindToPayView:self didClickPayBtn:self.unPayCount];
    }
}
@end
