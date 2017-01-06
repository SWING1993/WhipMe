//
//  WMUserEditViewController.m
//  WhipMe
//
//  Created by anve on 16/11/30.
//  Copyright © 2016年 -. All rights reserved.
//

#import "WMUserEditViewController.h"

@interface WMUserEditViewController ()

@end

@implementation WMUserEditViewController

- (instancetype)initWithPlaceholder:(NSString *)string delegate:(id<WMUserEditViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _strPlaceholder = string;
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self controlTitle:self.editControl];
    self.view.backgroundColor = [Define kColorBackGround];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(clickWithSave)];
    [rightBarItem setTintColor:[UIColor whiteColor]];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    if (self.editControl == EditControlNickname) {
        [self setupField];
    } else if (self.editControl == EditControlSign) {
        [self setupTextView];
    }
}

- (void)setupField {
    WEAK_SELF
    _txtField = [UITextField new];
    _txtField.backgroundColor = [UIColor whiteColor];
    _txtField.font = [UIFont systemFontOfSize:16.0];
    _txtField.textColor = [Define kColorBlack];
    _txtField.text = self.strPlaceholder ?: @"";
    _txtField.textAlignment = NSTextAlignmentLeft;
    _txtField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.txtField];
    [self.txtField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.mas_equalTo(30.0);
        make.height.mas_equalTo(50.0);
    }];
    
    UIView *viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 0)];
    viewLeft.backgroundColor = [UIColor clearColor];
    self.txtField.leftView = viewLeft;
    self.txtField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *viewLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Define screenWidth], 0.5)];
    viewLine1.backgroundColor = [Define kColorLine];
    [self.txtField addSubview:viewLine1];
    
    UIView *viewLine2 = [UIView new];
    viewLine2.backgroundColor = [Define kColorLine];
    [self.txtField addSubview:viewLine2];
    [viewLine2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.txtField);
        make.bottom.equalTo(weakSelf.txtField);
        make.height.mas_equalTo(0.5);
    }];
    
}

- (void)setupTextView {
    
    WEAK_SELF
    UIView *viewTemp = [UIView new];
    viewTemp.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTemp];
    [viewTemp mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view);
        make.top.mas_equalTo(30.0);
        make.height.mas_equalTo(82.0);
    }];
    
    _txtView = [UITextView new];
    _txtView.backgroundColor = [UIColor whiteColor];
    _txtView.font = [UIFont systemFontOfSize:16.0];
    _txtView.textColor = [Define kColorBlack];
    _txtView.textAlignment = NSTextAlignmentLeft;
    _txtView.text = self.strPlaceholder ?: @"";
    [viewTemp addSubview:self.txtView];
    [self.txtView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view);
        make.top.mas_equalTo(1.0);
        make.height.mas_equalTo(80.0);
    }];
    
    UIView *viewLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Define screenWidth], 0.5)];
    viewLine1.backgroundColor = [Define kColorLine];
    [viewTemp addSubview:viewLine1];
    
    UIView *viewLine2 = [UIView new];
    viewLine2.backgroundColor = [Define kColorLine];
    [viewTemp addSubview:viewLine2];
    [viewLine2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTemp);
        make.width.equalTo(viewTemp);
        make.bottom.equalTo(viewTemp);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - Action
- (NSString *)controlTitle:(EditControlType)editType {
    if (editType == EditControlNickname) {
        return @"昵称";
    } else if (editType == EditControlSign) {
        return @"签名";
    }
    return @"昵称";
}

- (void)clickWithSave {
    DebugLog(@"%@",NSStringFromClass(self.class));
    NSString *strEdited = @"";
    if (self.editControl == EditControlNickname) {
        strEdited = self.txtField.text;
    } else if (self.editControl == EditControlSign) {
        strEdited = self.txtView.text;
    }
    if ([NSString isBlankString:strEdited]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(userEditView:editConterol:)]) {
        [self.delegate userEditView:strEdited editConterol:self.editControl];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

@end
