//
//  DDPersonalCheckingController.m
//  DDExpressClient
//
//  Created by yoga on 16/4/12.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDPersonalCheckingController.h"
#import "DDIdCheckController.h"
#import "DDLocalUserInfoUtils.h"

#define DDPersonalCheckingCardIdShowLocation 1

typedef NS_ENUM(NSInteger, DDPersonalCheckingType) {
    DDPersonalCheckingIsChecking = 1,
    DDPersonalCheckingPass = 2,
    DDPersonalCheckingUnPass = 3
};

@interface DDPersonalCheckingController ()
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) NSString *btnTitleImgName;
@property (nonatomic, strong) UIView *infoMainView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nameInfoLabel;
@property (nonatomic, strong) UILabel *idLabel;
@property (nonatomic, strong) UILabel *idInfoLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *unPassPointOut;
@property (nonatomic, strong) UIButton *reCheckButton;
@end

@implementation DDPersonalCheckingController
- (instancetype)initWithCheckingType:(NSInteger)type
{
    self = [super init];
    if (self) {
        NSString *str = [NSString string];
        if (type == DDPersonalCheckingIsChecking) {
            str = @"isChecking";
        }else if (type == DDPersonalCheckingPass) {
            str = @"isPass";
        }else if (type == DDPersonalCheckingUnPass) {
            str = @"checkLose";
        }
        self.btnTitleImgName = str;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DDRGBAColor(238, 238, 238, 1);
    [self initNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.titleButton.x = 0;
    self.titleButton.y = 64;
    self.titleButton.height = 150;
    self.titleButton.width = self.view.width;
    
    self.infoMainView.x = 0;
    self.infoMainView.y = 150 + 64;
    self.infoMainView.width = self.view.width;
    self.infoMainView.height = 90;
    
    self.nameLabel.x = 15;
    self.nameLabel.y = 0;
    self.nameLabel.height = 45;
    self.nameLabel.width = 50;
    
    self.idLabel.x = 15;
    self.idLabel.y = 45;
    self.idLabel.height = 45;
    self.idLabel.width = 50;
    
    self.nameInfoLabel.x = 105;
    self.nameInfoLabel.y = 0;
    self.nameInfoLabel.width = self.infoMainView.width - 120;
    self.nameInfoLabel.height = 45;
    
    self.idInfoLabel.x = 105;
    self.idInfoLabel.y = 45;
    self.idInfoLabel.height = 45;
    self.idInfoLabel.width = self.infoMainView.width - 120;
    
    self.lineView.x = 15;
    self.lineView.width = self.infoMainView.width-15;
    self.lineView.height = 0.5;
    self.lineView.y = 45;
    
    self.unPassPointOut.x = 15;
    self.unPassPointOut.y = 120;
    self.unPassPointOut.height = 30;
    self.unPassPointOut.width = self.view.width-30;
    
    self.reCheckButton.x = self.view.width/2-63;
    self.reCheckButton.y = 170;
    self.reCheckButton.height = 30;
    self.reCheckButton.width = 126;
    [self.reCheckButton addTarget:self action:@selector(reCheckButtonClick) forControlEvents:UIControlEventTouchUpInside];
}




#pragma mark - Private Method
- (void)initNavBar {
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"个人认证" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
}

- (NSString *)hideCardIdSectionStringFromCardIdNumber:(NSString *)cardNumber
{
//    if (cardNumber.length == 18) {
//        NSString *firstChar = [cardNumber substringWithRange:NSMakeRange(0, 1)];
//        NSString *lastChar = [cardNumber substringWithRange:NSMakeRange(cardNumber.length - 1, 1)];
//        NSString *showStr = [NSString stringWithFormat:@"%@****************%@",firstChar,lastChar];
//        return showStr;
//    }else if (cardNumber.length == 15) {
//        NSString *firstChar = [cardNumber substringWithRange:NSMakeRange(0, 1)];
//        NSString *lastChar = [cardNumber substringWithRange:NSMakeRange(cardNumber.length - 1, 1)];
//        NSString *showStr = [NSString stringWithFormat:@"%@*************%@",firstChar,lastChar];
//        return showStr;
//    }else{
//        return cardNumber;
//    }

    if (!cardNumber || [cardNumber isEqualToString:@""]) return @"";
    NSString *asteriskStr = @"******************";
    NSUInteger location = DDPersonalCheckingCardIdShowLocation;
    NSUInteger length = cardNumber.length - location*2;
    NSString *replaceMentStr = [asteriskStr substringToIndex:length];
    return [cardNumber stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:replaceMentStr];
}

#pragma mark - click Method

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  重新提交按钮点击事件
 */
- (void)reCheckButtonClick
{
    DDIdCheckController  *vc = [[DDIdCheckController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setter && Getter
- (UILabel *)unPassPointOut
{
    if (_unPassPointOut == nil) {
        _unPassPointOut = [[UILabel alloc]init];
        
        _unPassPointOut.textAlignment = NSTextAlignmentCenter;
        _unPassPointOut.font = [UIFont systemFontOfSize:14];
        _unPassPointOut.textColor = DDRGBAColor(153, 153, 153, 1);
        _unPassPointOut.text = [DDLocalUserInfoUtils getReason];
        _unPassPointOut.numberOfLines = 2;
        if ([self.btnTitleImgName isEqualToString:@"isChecking"] || [self.btnTitleImgName isEqualToString:@"isPass"]) {
            _unPassPointOut.hidden = YES;
        }else
        {
            _unPassPointOut.hidden = NO;
        }
        [self.view addSubview:_unPassPointOut];
        
    }
    return _unPassPointOut;
}


-(UIButton *)reCheckButton
{
    if (_reCheckButton == nil) {
        _reCheckButton = [[UIButton alloc]init];
        [_reCheckButton setTitle:@"重新认证" forState:UIControlStateNormal];
        _reCheckButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_reCheckButton setTitleColor:DDRGBAColor(32, 198, 122, 1) forState:UIControlStateNormal];
        _reCheckButton.layer.borderColor = DDRGBAColor(32, 198, 122, 1).CGColor;
        _reCheckButton.layer.borderWidth = 1;
        _reCheckButton.layer.cornerRadius = 15;
        _reCheckButton.layer.masksToBounds = YES;
        if ([self.btnTitleImgName isEqualToString:@"isChecking"] || [self.btnTitleImgName isEqualToString:@"isPass"]) {
            _reCheckButton.hidden = YES;
        }else
        {
            _reCheckButton.hidden = NO;
        }
        [self.view addSubview:_reCheckButton];
    }
    return _reCheckButton;
}

- (UIButton *)titleButton
{
    if (_titleButton == nil) {
        _titleButton = [[UIButton alloc]init];
        _titleButton.backgroundColor = [UIColor clearColor];
        [_titleButton setImage:[UIImage imageNamed:self.btnTitleImgName] forState:UIControlStateNormal];
        _titleButton.contentMode = UIViewContentModeCenter;
        _titleButton.userInteractionEnabled = NO;
        [self.view addSubview:_titleButton];
    }
    return _titleButton;
}


- (UIView *)infoMainView
{
    if (_infoMainView == nil) {
        _infoMainView = [[UIView alloc]init];
        if ([self.btnTitleImgName isEqualToString:@"isChecking"] || [self.btnTitleImgName isEqualToString:@"isPass"]) {
            _infoMainView.hidden = NO;
        }else
        {
            _infoMainView.hidden = YES;
        }
        _infoMainView.backgroundColor = DDRGBAColor(255, 255, 255, 1);
        [self.view addSubview:_infoMainView];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"姓名";
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.textColor  = DDRGBAColor(51, 51, 51, 1);
        nameLabel.font = [UIFont systemFontOfSize:14];
        [_infoMainView addSubview:nameLabel];
        _nameLabel = nameLabel;
        
        UILabel *nameInfoLabel = [[UILabel alloc]init];
        nameInfoLabel.textAlignment = NSTextAlignmentRight;
        nameInfoLabel.textColor  = DDRGBAColor(188, 188, 188, 1);
        nameInfoLabel.text = [DDLocalUserInfoUtils getUserName];
        nameInfoLabel.font = [UIFont systemFontOfSize:14];
        [_infoMainView addSubview:nameInfoLabel];
        self.nameInfoLabel = nameInfoLabel;
        
        UILabel *idLabel = [[UILabel alloc]init];
        idLabel.text = @"身份证";
        idLabel.textColor = DDRGBAColor(51, 51, 51, 1);
        idLabel.textAlignment = NSTextAlignmentLeft;
        idLabel.font = [UIFont systemFontOfSize:14];
        [_infoMainView addSubview:idLabel];
        self.idLabel = idLabel;
        
        UILabel *idInfoLabel = [[UILabel alloc]init];
        idInfoLabel.textColor = DDRGBAColor(188, 188, 188, 1);
        idInfoLabel.textAlignment = NSTextAlignmentRight;
        idInfoLabel.text = [self hideCardIdSectionStringFromCardIdNumber:[DDLocalUserInfoUtils getCardId]];
        
        idInfoLabel.font = [UIFont systemFontOfSize:14];
        [_infoMainView addSubview:idInfoLabel];
        self.idInfoLabel = idInfoLabel;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = DDRGBAColor(233, 233, 233, 1);
        [_infoMainView addSubview:line];
        self.lineView = line;
    }
    return _infoMainView;
}
@end
