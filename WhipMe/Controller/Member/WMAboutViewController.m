//
//  WMAboutViewController.m
//  WhipMe
//
//  Created by anve on 17/1/23.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMAboutViewController.h"

#define kItemTag 7777

@interface WMAboutViewController ()

@property (nonatomic, strong) UIButton *btnBanner;
@property (nonatomic, strong) UILabel *lblAboutName, *lblVersion;
@property (nonatomic, strong) UIView *viewCurrent;

@end

@implementation WMAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"关于速速花"];
    [self.view setBackgroundColor:[Define kColorBackGround]];

    [self setup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    WEAK_SELF
    
    _btnBanner = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBanner setBackgroundColor:[Define kColorNavigation]];
    [_btnBanner setUserInteractionEnabled:NO];
    [_btnBanner setImage:[UIImage imageNamed:@"wmLOGO"] forState:UIControlStateNormal];
    [_btnBanner setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20.0, 7)];
    [self.view addSubview:self.btnBanner];
    [self.btnBanner mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view);
        make.height.mas_equalTo(330/2.0);
    }];
    
    _lblAboutName = [UILabel new];
    [_lblAboutName setBackgroundColor:[UIColor clearColor]];
    [_lblAboutName setTextColor:[UIColor whiteColor]];
    [_lblAboutName setTextAlignment:NSTextAlignmentCenter];
    [_lblAboutName setNumberOfLines:0];
    [self.btnBanner addSubview:self.lblAboutName];
    [self.lblAboutName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.btnBanner);
        make.bottom.equalTo(weakSelf.btnBanner).offset(-20.0);
        make.height.mas_equalTo(50.0);
        make.width.mas_equalTo(100.0);
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
   
    NSString *str_about_name = [NSString stringWithFormat:@"%@\n%@",app_Name, app_Version];
    NSRange  range_about = [str_about_name rangeOfString:app_Version];
    NSMutableParagraphStyle *pStyle = [NSMutableParagraphStyle new];
    [pStyle setLineSpacing:5.0f];
    [pStyle setAlignment:NSTextAlignmentCenter];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName:pStyle};
    
    CGSize size_h = [str_about_name boundingRectWithSize:CGSizeMake([Define screenWidth], MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    [self.lblAboutName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(floorf(size_h.height+5.0));
    }];
    NSMutableAttributedString *att_about_name = [[NSMutableAttributedString alloc] initWithString:str_about_name attributes:attribute];
    if (range_about.location != NSNotFound) {
        [att_about_name addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:range_about];
    }
    [self.lblAboutName setAttributedText:att_about_name];
    
    _viewCurrent = [UIView new];
    [_viewCurrent setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.viewCurrent];
    [self.viewCurrent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(weakSelf.view);
        make.height.mas_equalTo(324/2.0);
        make.top.equalTo(weakSelf.btnBanner.mas_bottom);
    }];
    
    //1198087202  @"检查更新",
    NSArray *titles = [NSArray arrayWithObjects:@"联系我们", nil];
    CGFloat origin_y = 0.0f;
    for (NSInteger i=1; i<=titles.count; i++) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setBackgroundColor:[UIColor whiteColor]];
        [itemButton setAdjustsImageWhenHighlighted:NO];
        [itemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15.0, 0, 0)];
        [itemButton setTitle:titles[i-1] forState:UIControlStateNormal];
        [itemButton setTag:i+kItemTag];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.viewCurrent addSubview:itemButton];
        [itemButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(48.0);
            make.left.and.width.equalTo(weakSelf.view);
            make.top.equalTo(weakSelf.viewCurrent).offset(origin_y);
        }];
        origin_y += 48.0;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 47.5, [Define screenWidth]-15.0, 0.5)];
        [lineView setBackgroundColor:[Define kColorLine]];
        [itemButton addSubview:lineView];
        
        if (i == 0) {
            _lblVersion = [UILabel new];
            [_lblVersion setBackgroundColor:[UIColor clearColor]];
            [_lblVersion setTextAlignment:NSTextAlignmentRight];
            [_lblVersion setFont:[UIFont systemFontOfSize:10.0]];
            [_lblVersion setTextColor:[Define kColorLight]];
            [_lblVersion setText:@"当前已是最新版本"];
            [itemButton addSubview:self.lblVersion];
            [self.lblVersion mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(itemButton).offset(-20.0);
                make.centerY.equalTo(itemButton);
                make.width.equalTo(itemButton).multipliedBy(0.5);
                make.height.equalTo(itemButton);
            }];
        } else {
            UIImageView *icon_arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_arrow"]];
            [icon_arrow setBackgroundColor:[UIColor clearColor]];
            [itemButton addSubview:icon_arrow];
            [icon_arrow mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20.0, 20.0));
                make.right.equalTo(itemButton).offset(-20.0);
                make.centerY.equalTo(itemButton);
            }];
        }
    }
    
    UILabel *lblDetail = [UILabel new];
    [lblDetail setBackgroundColor:[UIColor clearColor]];
    [lblDetail setTextAlignment:NSTextAlignmentLeft];
    [lblDetail setTextColor:[Define kColorLight]];
    [lblDetail setFont:[UIFont systemFontOfSize:14.0f]];
    [lblDetail setNumberOfLines:0];
    [self.viewCurrent addSubview:lblDetail];
    
    NSString *str_detail = @"官方微信号：biantawo\n微信公众号：速速花\nQQ群：214532421";
    NSMutableParagraphStyle *pStyle_2 = [NSMutableParagraphStyle new];
    [pStyle_2 setLineSpacing:5.0f];
    [pStyle_2 setAlignment:NSTextAlignmentLeft];
    attribute = @{NSFontAttributeName:lblDetail.font, NSForegroundColorAttributeName:lblDetail.textColor, NSParagraphStyleAttributeName:pStyle_2};
    size_h = [str_detail boundingRectWithSize:CGSizeMake([Define screenWidth]-30.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    [lblDetail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewCurrent).offset(15.0);
        make.width.equalTo(weakSelf.viewCurrent).offset(-30.0);
        make.bottom.equalTo(weakSelf.viewCurrent).offset(-30.0);
        make.height.mas_equalTo(floorf(size_h.height+1.0));
    }];
    
    NSMutableAttributedString *att_detail = [[NSMutableAttributedString alloc] initWithString:str_detail attributes:attribute];
    [lblDetail setAttributedText:att_detail];
    
    
}

- (void)onClickWithItem:(id)sender {

}

@end
