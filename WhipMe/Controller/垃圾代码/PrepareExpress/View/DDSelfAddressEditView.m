//
//  DDSelfAddressEditView.m
//  DDExpressClient
//
//  Created by SongGang on 2/25/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import "DDSelfAddressEditView.h"
#import "Constant.h"
#import "DDCustomField.h"

@interface DDSelfAddressEditView ()
@property (nonatomic, weak) UIImageView *addressIcon;
@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, weak) UIImageView *nameIcon;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *phoneIcon;
@property (nonatomic, weak) UILabel *phoneLabel;
@property (nonatomic, weak) UILabel *biaoQianLabel;
@property (nonatomic, weak) UILabel *otherLabel;
@property (nonatomic, weak) UIImageView * firstStarIcon;
@property (nonatomic, weak) UIImageView * secondStarIcon;
@property (nonatomic, weak) UIImageView * thirdStarIcon;

/**
 *  寄件人头label
 */
@property (nonatomic, strong) UILabel *userHeadLabel;
/**
 *  联系方式头label
 */
@property (nonatomic, strong) UILabel *contactWayHeadLabel;
/**
 *  定位地址头label
 */
@property (nonatomic, strong) UILabel *locationAddressHeadLabel;
/**
 *  详细地址头label
 */
@property (nonatomic, strong) UILabel *contentAddressHeadLabel;
/**
 *  标签头label
 */
@property (nonatomic, strong) UILabel *labelHeaderLabel;


/*第一个地址栏*/
@property (nonatomic, weak) DDCustomField *firstAddressText;
/*第二个地址栏*/
@property (nonatomic, weak) DDCustomField *secondAddressText;
/*名字栏*/
@property (nonatomic, weak) DDCustomField *nameText;
/*标签：公司按钮*/
@property (nonatomic, weak) UIButton *companyButton;
/*标签：家按钮*/
@property (nonatomic, weak) UIButton *homeButton;
/*标签：学校按钮*/
@property (nonatomic, weak) UIButton *schoolButton;
/*标签，其他栏*/
@property (nonatomic, weak) DDCustomField *otherText;
/*联系方式栏*/
@property (nonatomic, weak) UILabel *phoneText;

@end

@implementation DDSelfAddressEditView
@synthesize addressDetail = _addressDetail;
@synthesize delegate;

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


/**
    初始化界面
 */
-(void)initView
{
    UIImageView *addressIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S2.png"]];
    [self addSubview:addressIcon];
    self.addressIcon = addressIcon;
    
    UILabel *addressLabel = [[UILabel alloc] init];
    [self addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    DDCustomField *fAddressText = [DDCustomField new];
    [self addSubview:fAddressText];
    self.firstAddressText = fAddressText;

    DDCustomField *sAddressText = [[DDCustomField alloc] init];
    [self addSubview:sAddressText];
    self.secondAddressText = sAddressText;
    
    UIImageView *nameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S2.png"]];
    [self addSubview:nameIcon];
    self.nameIcon = nameIcon;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    DDCustomField *nText = [[DDCustomField alloc]  init];
    [self addSubview:nText];
    self.nameText = nText;
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S2.png"]];
    [self addSubview:phoneIcon];
    self.phoneIcon = phoneIcon;
   
    UILabel *phoneLabel = [[UILabel alloc] init];
    [self addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
    UILabel *pText = [[UILabel alloc]  init];
    [self addSubview:pText];
    self.phoneText = pText;
    
    UILabel *biaoQianLabel = [[UILabel alloc] init];
    [self addSubview:biaoQianLabel];
    self.biaoQianLabel = biaoQianLabel;
    
    UIButton *companyButton = [[UIButton alloc] init];
    [self addSubview:companyButton];
    self.companyButton = companyButton;
    [self.companyButton addTarget:self action:@selector(signAction:) forControlEvents: UIControlEventTouchUpInside ];
    
    UIButton *homeButton = [[UIButton alloc] init];
    [self addSubview:homeButton];
    self.homeButton = homeButton;
    [self.homeButton addTarget:self action:@selector(signAction:) forControlEvents: UIControlEventTouchUpInside ];
    
    UIButton *schoolButton = [[UIButton alloc] init];
    [self addSubview:schoolButton];
    self.schoolButton = schoolButton;
    [self.schoolButton addTarget:self action:@selector(signAction:) forControlEvents: UIControlEventTouchUpInside ];
    
    UILabel *otherLabel = [[UILabel alloc] init];
    [self addSubview:otherLabel];
    self.otherLabel = otherLabel;
    
    DDCustomField *otherText = [[DDCustomField alloc] init];
    [self addSubview:otherText];
    self.otherText = otherText;
    self.otherText.delegate = self;
    
    UIImageView * fStarIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S2.png"]];
    [self addSubview:fStarIcon];
    self.firstStarIcon = fStarIcon;
    
    UIImageView * sStarIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S2.png"]];
    [self addSubview:sStarIcon];
    self.secondStarIcon = sStarIcon;
    
    UIImageView * tStarIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"S2.png"]];
    [self addSubview:tStarIcon];
    self.thirdStarIcon = tStarIcon;
    
    [self setItemInfo];
}

/**
    为界面上的控件设置常量值
 */
- (void)setItemInfo
{
    self.addressLabel.text = @"寄件地址：";
    self.nameLabel.text    = @"寄件人：";
    self.phoneLabel.text   = @"联系方式：";
    self.biaoQianLabel.text = @"标签：";
    
    self.addressLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    self.biaoQianLabel.textAlignment = NSTextAlignmentRight;
    
    self.addressLabel.font = kTitleFont;
    self.nameLabel.font = kTitleFont;
    self.phoneLabel.font = kTitleFont;
    self.biaoQianLabel.font = kTitleFont;
    
    [self.companyButton setTitle:@"公司" forState:UIControlStateNormal];
    [self.homeButton setTitle:@"家" forState:UIControlStateNormal];
    [self.schoolButton setTitle:@"学校" forState:UIControlStateNormal];
    
    [self.companyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.schoolButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.companyButton.titleLabel.font = kTimeFont;
    self.homeButton.titleLabel.font = kTimeFont;
    self.schoolButton.titleLabel.font = kTimeFont;
    
    self.otherLabel.text = @"其他";
    self.otherLabel.font = kTimeFont;
    
}

/**
    界面布局
 */
-(void)layoutSubviews
{
    CGFloat imageWidth = 30;
    CGFloat imageHeight = 30;
    CGFloat labelHeight = 30;
    CGFloat labelWidth = 90;
    CGFloat textWidth = CGRectGetWidth(self.frame)-150;
    CGFloat textHeight = 30;
    CGFloat buttonWidth = (CGRectGetWidth(self.frame)-210)/4;
    CGFloat buttonHeight = 30;
    
    [self.addressIcon setFrame:CGRectMake(10, 10, imageWidth, imageHeight)];
    [self.addressLabel setFrame:CGRectMake(10+imageWidth, 10,labelWidth, labelHeight)];
    [self.firstAddressText setFrame:CGRectMake(10+imageWidth+labelWidth, 10,textWidth, textHeight)];
    [self.secondAddressText setFrame:CGRectMake(10+imageWidth+labelWidth, 10+textHeight,textWidth, textHeight)];
    [self.firstStarIcon setFrame:CGRectMake(10+imageWidth+labelWidth+textWidth, textHeight,10, 10)];
    [self.secondStarIcon setFrame:CGRectMake(10+imageWidth+labelWidth+textWidth, 2*textHeight,10, 10)];
    
    [self.nameIcon setFrame:CGRectMake(10, 20+2*textHeight, imageWidth, imageHeight)];
    [self.nameLabel setFrame:CGRectMake(10+imageWidth, 20+2*textHeight,labelWidth, labelHeight)];
    [self.nameText setFrame:CGRectMake(10+imageWidth+labelWidth, 20+2*textHeight,textWidth, textHeight)];
    [self.thirdStarIcon setFrame:CGRectMake(10+imageWidth+labelWidth+textWidth, 10+3*textHeight,10, 10)];
    
    [self.phoneIcon setFrame:CGRectMake(10, 30+3*textHeight,imageWidth, imageHeight)];
    [self.phoneLabel setFrame:CGRectMake(10+imageWidth, 30+3*textHeight,labelWidth, labelHeight)];
    [self.phoneText setFrame:CGRectMake(10+imageWidth+labelWidth, 30+3*textHeight,textWidth, textHeight)];
    
    [self.biaoQianLabel setFrame:CGRectMake(10+imageWidth, 40+4*textHeight,labelWidth, labelHeight)];
    [self.companyButton setFrame:CGRectMake(10+imageWidth+labelWidth, 40+4*textHeight, buttonWidth, buttonHeight)];
    [self.homeButton setFrame:CGRectMake(20+imageWidth+labelWidth+buttonWidth, 40+4*textHeight, buttonWidth, buttonHeight)];
    [self.schoolButton setFrame:CGRectMake(30+imageWidth+labelWidth+2*buttonWidth, 40+4*textHeight, buttonWidth, buttonHeight)];
    [self.otherLabel setFrame:CGRectMake(40+imageWidth+labelWidth+3*buttonWidth, 40+4*textHeight,30,30)];
    [self.otherText setFrame:CGRectMake(40+imageWidth+labelWidth+3*buttonWidth+30, 40+4*textHeight, buttonWidth, 30)];
}

/**
    addressDetail赋值
 */
- (void)setAddressDetail:(DDAddressDetail *)addressDetail
{
    _addressDetail = addressDetail;
    self.firstAddressText.text = _addressDetail.addressName;
    self.secondAddressText.text = _addressDetail.localDetailAddress;
    self.nameText.text = _addressDetail.name;
    self.phoneText.text = _addressDetail.phone;
}

/**
    获取addressDetail值
 */
- (DDAddressDetail *) addressDetail
{
    _addressDetail.addressName = self.firstAddressText.text;
    _addressDetail.localDetailAddress = self.secondAddressText.text;
    _addressDetail.name = self.nameText.text;
    _addressDetail.phone = self.phoneText.text;
    
    return _addressDetail;
}

/**
    标签中button按钮的触发动作
 */
- (IBAction)signAction:(id)sender
{
    if ([delegate respondsToSelector:@selector(signButtonAction:)]) {
        [delegate signButtonAction:sender];
    }
}

/**
    标签其他输入结束时的delegate方法
 */
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![[textField text] isEqualToString:@""] ) {
        [self.schoolButton setBackgroundColor:[UIColor whiteColor]];
        [self.homeButton setBackgroundColor:[UIColor whiteColor]];
        [self.companyButton setBackgroundColor:[UIColor whiteColor]];
    }
}
@end
