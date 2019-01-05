//
//  WMLoginViewController.m
//  WhipMe
//
//  Created by anve on 17/1/25.
//  Copyright © 2017年 -. All rights reserved.
//  登录页面


#import "WMLoginViewController.h"

static NSInteger const wm_button_index = 7777;

@interface WMLoginViewController ()

@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) NSMutableArray<UserManager *> *arrayContent;
@end

@implementation WMLoginViewController

- (instancetype)initWithUsers:(NSMutableArray<UserManager *> *)users
{
    self = [super init];
    if (self) {
        _arrayContent = users;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    WEAK_SELF
    
    UIImageView *imageBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_login_bg"]];
    imageBG.backgroundColor = [UIColor clearColor];
    imageBG.contentMode = UIViewContentModeScaleAspectFill;
    imageBG.clipsToBounds = YES;
    [self.view addSubview:imageBG];
    [imageBG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    _btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnBack setBackgroundColor:[UIColor clearColor]];
    [_btnBack setImage:[UIImage imageNamed:@"wm_login_back"] forState:UIControlStateNormal];
    [_btnBack setAdjustsImageWhenHighlighted:NO];
    [_btnBack addTarget:self action:@selector(onclickWithBack) forControlEvents:UIControlEventTouchUpInside];
    [_btnBack sizeToFit];
    [self.view addSubview:self.btnBack];
    [self.btnBack mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50.0, 44.0));
        make.top.mas_equalTo(20.0);
        make.left.mas_equalTo(0);
    }];
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wm_login_icon"]];
    imageLogo.backgroundColor = [UIColor clearColor];
    imageLogo.contentMode = UIViewContentModeScaleAspectFill;
    imageLogo.clipsToBounds = YES;
    [self.view addSubview:imageLogo];
    [imageLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(136/2.0, 132/2.0));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(120.0);
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    UILabel *lblAppName = [[UILabel alloc] init];
    [lblAppName setBackgroundColor:[UIColor clearColor]];
    [lblAppName setTextAlignment:NSTextAlignmentCenter];
    [lblAppName setTextColor:[Define kColorRed]];
    [lblAppName setFont:[UIFont systemFontOfSize:12.0]];
    [lblAppName setText:app_Name ?:@""];
    [self.view addSubview:lblAppName];
    [lblAppName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(imageLogo.mas_width);
        make.top.equalTo(imageLogo.mas_bottom).offset(10.0);
        make.height.mas_equalTo(12.0);
        make.centerX.equalTo(imageLogo.mas_centerX);
    }];
    
    UILabel *lblMessage = [[UILabel alloc] init];
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    [lblMessage setTextAlignment:NSTextAlignmentCenter];
    [lblMessage setTextColor:[Define RGBColorFloat:255 g:147 b:80]];
    [lblMessage setFont:[UIFont systemFontOfSize:14.0]];
    [lblMessage setText:@"选择您要登录的账号"];
    [self.view addSubview:lblMessage];
    [lblMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(weakSelf.view);
        make.top.equalTo(lblAppName.mas_bottom).offset(75.0);
        make.height.mas_equalTo(20.0);
    }];
    
    //wm_login_head
    CGFloat origin_y = 30.0f;
    for (NSInteger i=0; i<MIN(2, self.arrayContent.count); i++) {
        if (self.arrayContent.count <= i) {
            break;
        }
        UserManager *model = [self.arrayContent objectAtIndex:i];
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        itemButton.backgroundColor = [Define RGBColorFloat:161 g:157 b:158];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [itemButton setTitle:model.nickname ?:@"" forState:UIControlStateNormal];
        [itemButton.layer setCornerRadius:6.0f];
        [itemButton.layer setMasksToBounds:YES];
        [itemButton setAdjustsImageWhenHighlighted:NO];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton setTag:wm_button_index+i];
        [self.view addSubview:itemButton];
        [itemButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([Define screenWidth] - 36.0);
            make.height.mas_equalTo(54.0);
            make.centerX.equalTo(weakSelf.view);
            make.top.equalTo(lblMessage.mas_bottom).offset(origin_y);
        }];
        origin_y += 68.0;
        
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setFrame:CGRectMake(0, 0, 60.0, 54.0)];
        [leftView setBackgroundColor:[UIColor clearColor]];
        [leftView setImage:[UIImage imageNamed:@"wm_login_head"] forState:UIControlStateNormal];
        [leftView setUserInteractionEnabled:NO];
        [itemButton addSubview:leftView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(59.5, 0, 0.5, 54.0)];
        [lineView setBackgroundColor:[Define kColorLine]];
        [leftView addSubview:lineView];
        
        UIView *rightView = [[UIView alloc] init];
        [rightView setBackgroundColor:[UIColor clearColor]];
        [itemButton addSubview:rightView];
        [rightView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60.0, 54.0));
            make.top.and.right.equalTo(itemButton);
        }];
    }
}

#pragma mark - Action 
- (void)onclickWithBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickWithItem:(UIButton *)sender {
    NSInteger _index = sender.tag%wm_button_index;
    if (self.arrayContent.count > _index) {
        UserManager *model = [self.arrayContent objectAtIndex:_index];
        
        NSMutableDictionary *dict_value = [model mj_keyValues];
        [UserManager storeUserWithDict:dict_value];
        
        AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app_delegate setupMainController];
        [[ChatMessage shareChat] loginJMessage];
    }
}

- (NSMutableArray<UserManager *> *)arrayContent {
    if (_arrayContent == nil) {
        _arrayContent = [NSMutableArray new];
    }
    return _arrayContent;
}

@end
