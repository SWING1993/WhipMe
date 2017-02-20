//
//  WMLoginManagerController.m
//  WhipMe
//
//  Created by anve on 17/1/23.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMLoginManagerController.h"
#import "WMMangerPageController.h"

@interface WMLoginManagerController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *txtField;
@property (nonatomic, strong) UIButton *btnSubmit;
@end

@implementation WMLoginManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"管理员登录"];
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
    
    _txtField = [UITextField new];
    _txtField.backgroundColor = [UIColor whiteColor];
    _txtField.font = [UIFont systemFontOfSize:16.0];
    _txtField.textAlignment = NSTextAlignmentLeft;
    _txtField.textColor = [Define kColorBlack];
    _txtField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtField.placeholder = @"密码";
    _txtField.layer.cornerRadius = 4.0;
    _txtField.layer.masksToBounds = true;
    _txtField.delegate = self;
    _txtField.secureTextEntry = YES;
    [self.view addSubview:self.txtField];
    [self.txtField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([Define screenWidth] - 36.0);
        make.height.mas_equalTo(44.0);
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(30.0);
    }];
    
    UIView *leftViwe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    [leftViwe setBackgroundColor:[UIColor clearColor]];
    [self.txtField setLeftView:leftViwe];
    [self.txtField setLeftViewMode:UITextFieldViewModeAlways];
    
    _btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btnSubmit setBackgroundColor:[Define kColorCyanOff]];
    [_btnSubmit.layer setMasksToBounds:YES];
    [_btnSubmit.layer setCornerRadius:4.0f];
    [_btnSubmit setTitle:@"登录" forState:UIControlStateNormal];
    [_btnSubmit.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_btnSubmit addTarget:self action:@selector(onClickWithManager:) forControlEvents:UIControlEventTouchUpInside];
    [_btnSubmit setEnabled:YES];
    [self.view addSubview:_btnSubmit];
    [_btnSubmit mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view).offset(-36.0);
        make.top.equalTo(weakSelf.txtField.mas_bottom).offset(28.0);
        make.height.mas_equalTo(44.0);
    }];
}

- (void)onClickWithManager:(id)sender {
    [self.view endEditing:NO];
    
    if ([self.txtField.text length] < 6) {
        [Tool showHUDTipWithTipStr:@"您的密码不足6位！"];
    } else {
        [self loginManager];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (text.length > 30) {
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - network
- (void)loginManager {
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"userId":user.userId ?: @"", @"pwd":self.txtField.text};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"supervisorLogin" params:param Success:^(id result) {
       
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            UserManager *model = [UserManager shared];
            model.isManager = YES;
            
            NSMutableDictionary *dict_value = [model mj_keyValues];
            [UserManager storeUserWithDict:dict_value];
            
            UIPageViewController *clubPage = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
            WMMangerPageController *managerVC = [[WMMangerPageController alloc] initWithRootViewController:clubPage];
            [weakSelf presentViewController:managerVC animated:YES completion:NULL];
            
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        
    }];
}

@end
