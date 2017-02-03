//
//  WMLoginWayController.m
//  WhipMe
//
//  Created by anve on 17/1/24.
//  Copyright © 2017年 -. All rights reserved.
//  第三方登录

#import "WMLoginWayController.h"
#import "WMLoginViewController.h"

static NSInteger const button_index = 7777;

@interface WMLoginWayController () <WXApiEngineDelegate>

@end

@implementation WMLoginWayController

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
    
    UIImageView *imageBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LoginBackground"]];
    imageBG.backgroundColor = [UIColor clearColor];
    imageBG.contentMode = UIViewContentModeScaleAspectFill;
    imageBG.clipsToBounds = YES;
    [self.view addSubview:imageBG];
    [imageBG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_icon_app"]];
    imageLogo.backgroundColor = [UIColor clearColor];
    imageLogo.contentMode = UIViewContentModeScaleAspectFill;
    imageLogo.clipsToBounds = YES;
    [self.view addSubview:imageLogo];
    [imageLogo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(152/2.0, 152/2.0));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(80.0);
    }];
    
    UIImageView *image_btw = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btw_name"]];
    image_btw.backgroundColor = [UIColor clearColor];
    image_btw.contentMode = UIViewContentModeScaleAspectFill;
    image_btw.clipsToBounds = YES;
    [self.view addSubview:image_btw];
    [image_btw mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(123/2.0, 36/2.0));
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(168.0);
    }];

    UILabel *lblMessage = [[UILabel alloc] init];
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    [lblMessage setTextAlignment:NSTextAlignmentLeft];
    [lblMessage setTextColor:[Define kColorLight]];
    [lblMessage setFont:[UIFont systemFontOfSize:12.0]];
    [lblMessage setNumberOfLines:0];
    [self.view addSubview:lblMessage];
    NSString *str_msg = @"先定一个能达到的";
    NSDictionary *attribute = @{NSFontAttributeName:lblMessage.font, NSForegroundColorAttributeName:lblMessage.textColor};
    CGSize size_h_msg = [str_msg boundingRectWithSize:CGSizeMake(16.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    NSMutableAttributedString *att_msg = [[NSMutableAttributedString alloc] initWithString:str_msg attributes:attribute];
    [lblMessage setAttributedText:att_msg];
    [lblMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.0, floorf(size_h_msg.height+1.0)));
        make.centerX.equalTo(weakSelf.view).offset(-8.0);
        make.top.equalTo(image_btw.mas_bottom).offset(30.0);
    }];
    
    UILabel *lblMessage2 = [[UILabel alloc] init];
    [lblMessage2 setBackgroundColor:[UIColor clearColor]];
    [lblMessage2 setTextAlignment:NSTextAlignmentLeft];
    [lblMessage2 setTextColor:[Define RGBColorFloat:251 g:127 b:119]];
    [lblMessage2 setFont:[UIFont boldSystemFontOfSize:18.0]];
    [lblMessage2 setNumberOfLines:0];
    [self.view addSubview:lblMessage2];
    NSString *str_msg2 = @"小目标";
    NSDictionary *attribute2 = @{NSFontAttributeName:lblMessage2.font, NSForegroundColorAttributeName:lblMessage2.textColor};
    CGSize size_h_msg2 = [str_msg2 boundingRectWithSize:CGSizeMake(20.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute2 context:nil].size;
    
    NSMutableAttributedString *att_msg2 = [[NSMutableAttributedString alloc] initWithString:str_msg2 attributes:attribute2];
    [lblMessage2 setAttributedText:att_msg2];
    [lblMessage2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20.0, floorf(size_h_msg2.height+1.0)));
        make.left.equalTo(lblMessage.mas_right);
        make.top.equalTo(lblMessage.mas_bottom).offset(-24.0);
    }];
    
    CGFloat origin_y = -5.0;
    for (NSInteger i=0; i<3; i++) {
        UILabel *itemLbl = [UILabel new];
        [itemLbl setBackgroundColor:[UIColor clearColor]];
        [itemLbl setTextColor:lblMessage2.textColor];
        [itemLbl setFont:[UIFont boldSystemFontOfSize:20.0]];
        [itemLbl setTextAlignment:lblMessage2.textAlignment];
        [itemLbl setText:@"."];
        [self.view addSubview:itemLbl];
        [itemLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20.0, 20.0));
            make.left.equalTo(lblMessage2.mas_left).offset(7.0);
            make.top.equalTo(lblMessage2.mas_bottom).offset(origin_y);
        }];
        origin_y += 8.0f;
    }
    
    UIView *viewButton = [UIView new];
    [viewButton setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewButton];
    [viewButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(weakSelf.view);
        make.height.mas_equalTo(120.0);
        make.top.equalTo(weakSelf.view).offset(456.0);
    }];

    NSArray *arrayTitle = @[@{@"title":@"新建用户",@"icon":@"button_create_off",},
                            @{@"title":@"手机登录",@"icon":@"button_phone_off",},
                            @{@"title":@"微信登录",@"icon":@"button_weixin_off",}];
    CGFloat origin_x = ([Define screenWidth]-84.0*3-40.0)/2.0;
    for (NSInteger i=0; i<arrayTitle.count; i++) {
        NSDictionary *dict = [arrayTitle objectAtIndex:i];
        
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setBackgroundColor:[UIColor clearColor]];
        [itemButton setImage:[UIImage imageNamed:dict[@"icon"]] forState:UIControlStateNormal];
        [itemButton setTitle:dict[@"title"] forState:UIControlStateNormal];
        [itemButton setTitleColor:[Define kColorBlack] forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake(100.0, -84.0, 0, 0)];
        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20.0, 0)];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [itemButton setAdjustsImageWhenHighlighted:NO];
        [itemButton setTag:i+button_index];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [viewButton addSubview:itemButton];
        
        [itemButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.and.height.equalTo(viewButton);
            make.width.mas_equalTo(84.0);
            make.left.equalTo(viewButton).offset(origin_x);
        }];
        origin_x += 84.0 + 20.0;
    }
}

- (void)onClickWithItem:(UIButton *)sender {
    
    NSInteger _index = sender.tag%button_index;
    
    if (_index == 0) {
        RegisterViewController *controller = [RegisterViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (_index == 1) {
        LoginViewController *controller = [LoginViewController new];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (_index == 2) {
        [[WMShareEngine sharedInstance] sendAuthRequest:self];
    }
}

#pragma mark - WXApiEngineDelegate
- (void)shareEngineWXApi:(SendAuthResp *)response {
    if (response.errCode == -2) {
        //用户取消
    } else if (response.errCode == -4) {
        //用户拒绝授权
        
    } else {
        // 0(用户同意)
        NSDictionary *param = @{@"unionId":[NSString stringWithFormat:@"%@",response.code]};
        [HttpAPIClient APIClientPOST:@"wlogin" params:param Success:^(id result) {
            NSDictionary *data = result[@"data"][0];
            if (data) {
                NSInteger ret_code = [data[@"ret"] integerValue];
                if (ret_code == 1) {
                    DebugLog(@"用户首次登录");
                    RegisterAndUserController *controller = [RegisterAndUserController new];
                    controller.unionId = response.code;
                    [self.navigationController pushViewController:controller animated:YES];
                } else if (ret_code == 0) {
                    DebugLog(@"用户登录成功");
                    for (NSDictionary *obj in data[@"list"]) {
                        [UserManager storeUserWithDict:obj];
                        break;
                    }
                    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app_delegate setupMainController];
                    [[ChatMessage shareChat] loginJMessage];
                } else if (ret_code == -1) {
                    DebugLog(@"用户登录成功，有两个手机号");
                    NSMutableArray *muArray = [NSMutableArray new];
                    for (NSDictionary *obj in data[@"list"]) {
                        UserManager *model = [UserManager mj_objectWithKeyValues:obj];
                        [muArray addObject:model];
                    }
                    WMLoginViewController *controller = [WMLoginViewController new];
                    [self.navigationController pushViewController:controller animated:YES];
                } else {
                    [Tool showHUDTipWithTipStr:@"用户登录失败!"];
                }
            }
        } Failed:^(NSError *error) {
            [Tool showHUDTipWithTipStr:@"网络不给力"];
        }];
    }
}

@end
