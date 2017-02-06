//
//  WMUserInfoViewController.m
//  WhipMe
//
//  Created by anve on 16/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

#import "WMUserInfoViewController.h"
#import "WMUserEditViewController.h"

#import "HKPickerPassengerView.h"

@interface WMUserInfoViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, WMUserEditViewControllerDelegate, HKPickerPassengerViewDelegate>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) UserManager *userModel;

@property (nonatomic, strong) UIImage *imagePath;

@property (nonatomic, strong) HKPickerPassengerView *pickerPassenger;

@end

static NSString *identifier_cell = @"userInfoViewCell";

@implementation WMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑个人资料";
    self.view.backgroundColor = [Define kColorBackGround];
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setup {
    
    _tableViewWM = [[UITableView alloc] init];
    _tableViewWM.backgroundColor = [UIColor clearColor];
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewWM.separatorColor = [Define kColorLine];
    _tableViewWM.separatorInset = UIEdgeInsetsZero;
    _tableViewWM.layoutMargins = UIEdgeInsetsZero;
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:_tableViewWM];
    [_tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.tableViewWM registerClass:[UserInfoTableViewCell class] forCellReuseIdentifier:identifier_cell];
    
    CGRect frame = CGRectMake(0, [Define screenHeight], [Define screenWidth], [Define screenHeight] - 64.0);
    _pickerPassenger = [[HKPickerPassengerView alloc] initWithFrame:frame title:nil delegate:self type:HKPickerPassengerViewTypeBirthday];
    [self.view addSubview:self.pickerPassenger];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.0;
    if (indexPath.row == 0) {
        rowHeight = 10.0;
    } else if (indexPath.row == 2 || indexPath.row == 6) {
        rowHeight = 12.0;
    } else if (indexPath.row == 1) {
        rowHeight = 75.0;
    } else {
        rowHeight = 48.0;
    }
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier_cell];
    if (!cell) {
        cell = [[UserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier_cell];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageLogo.hidden = true;
    cell.lblText.hidden = false;
    
    CGFloat margin_x = 0.0;
    if (indexPath.row == 1) {
        cell.lblTitle.text = @"头像";
        cell.lblText.hidden = true;
        cell.imageLogo.hidden = false;
        cell.imageLogo.backgroundColor = [Define kColorBackGround];
        if (self.imagePath) {
            cell.imageLogo.image = self.imagePath;
        } else {
            [cell.imageLogo setImageWithURL:[NSURL URLWithString:self.userModel.icon] placeholderImage:[Define kDefaultImageHead]];
        }
    } else if (indexPath.row == 3) {
        cell.lblTitle.text = @"昵称";
        cell.lblText.text = self.userModel.nickname;
        margin_x = 15.0;
    } else if (indexPath.row == 4) {
        cell.lblTitle.text = @"性别";
        NSString *sex_int = @"女";
        if (self.userModel.sex) {
            sex_int = @"男";
        }
        cell.lblText.text = sex_int;
        margin_x = 15.0;
    } else if (indexPath.row == 5) {
        cell.lblTitle.text = @"生日";
        cell.lblText.text = self.userModel.birthday;
    } else if (indexPath.row == 7) {
        cell.lblTitle.text = @"签名";
        cell.lblText.text = self.userModel.sign;
    } else {
        cell.lblTitle.text = @"";
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.layoutMargins = UIEdgeInsetsMake(0, margin_x, 0, 0);
    cell.separatorInset = UIEdgeInsetsMake(0, margin_x, 0, 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfoTableViewCell *cell = (UserInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    WEAK_SELF
    if (indexPath.row == 1) {
        UIAlertController *sheetAvatar = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [sheetAvatar addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf actionSheetButtonIndex:1];
        }]];
        [sheetAvatar addAction:[UIAlertAction actionWithTitle:@"图库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf actionSheetButtonIndex:2];
        }]];
        [sheetAvatar addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf actionSheetButtonIndex:0];
        }]];
        [self presentViewController:sheetAvatar animated:YES completion:nil];
    } else if (indexPath.row == 3 || indexPath.row == 7) {
        [self showUserEditContorl:indexPath placeholder:cell.lblText.text];
    } else if (indexPath.row == 4) {
        UIAlertController *sheetSex = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [sheetSex addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.userModel.sex = true;
            [weakSelf editUserInfo:@"1" editType:EditControlSex];
            [weakSelf.tableViewWM reloadData];
        }]];
        [sheetSex addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.userModel.sex = false;
            [weakSelf editUserInfo:@"0" editType:EditControlSex];
            [weakSelf.tableViewWM reloadData];
        }]];
        [sheetSex addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.tableViewWM reloadData];
        }]];
        [self presentViewController:sheetSex animated:YES completion:nil];
    } else if (indexPath.row == 5) {
        [self selectUserBirthday];
    }
}

#pragma mark - Action
- (void)showUserEditContorl:(NSIndexPath *)indexPath placeholder:(NSString *)string {
    
    EditControlType editControl = indexPath.row == 7 ? EditControlSign : EditControlNickname;
    WMUserEditViewController *contorller = [[WMUserEditViewController alloc] initWithPlaceholder:string delegate:self];
    contorller.editControl = editControl;
    [self.navigationController pushViewController:contorller animated:YES];
}

- (void)actionSheetButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    imagePicker.allowsEditing = true;
    imagePicker.delegate = self;
    
    if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"该设备不支持“照相机”" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertControl animated:YES completion:nil];
            return;
        }
    } else if (buttonIndex == 2) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        } else {
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"该设备不支持“相片库”" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alertControl animated:YES completion:nil];
            return;
        }
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)selectUserBirthday {
    [self.pickerPassenger setTitle:@"出生日期"];
    [self.pickerPassenger setPickerType:HKPickerPassengerViewTypeBirthday];
    [self.pickerPassenger setDefault_birghday:self.userModel.birthday];
    [self.pickerPassenger setData];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.pickerPassenger setOrigin:CGPointZero];
    }];
}

#pragma makr - UIImagePickerControllerDelegate, UINavigationControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *imageEdited = [UIImage fixOrientation:info[UIImagePickerControllerEditedImage]];
    _imagePath = [UIImage scaleImage:imageEdited];
    NSData  *imageData = [UIImage dataRepresentationImage:_imagePath];
    
    [self.tableViewWM reloadData];
    if (imageData) {
        WEAK_SELF
        [WMUploadFile upToData:imageData backInfo:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (resp == nil) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",info.error]];
            } else {
                NSString *img_url = [WMUploadFile kImageBaseUrl:resp[@"key"]];
                weakSelf.userModel.icon = img_url;
                [weakSelf editUserInfo:img_url editType:EditControlAvatar];
                [weakSelf.tableViewWM reloadData];
            }

        } fail:^(NSError *error) {
            [Tool showHUDTipWithTipStr:@"头像上传失败"];
        }];
    }
}

#pragma mark - WMUserEditViewControllerDelegate
- (void)userEditView:(NSString *)strEdited editConterol:(EditControlType)type {
    if (type == EditControlSign) {
        self.userModel.sign = strEdited;
    } else {
        self.userModel.nickname = strEdited;
    }
    [self editUserInfo:strEdited editType:type];
    [self.tableViewWM reloadData];
}

#pragma mark - HKPickerPassengerViewDelegate
- (void)pickerPassengerViewCancel:(HKPickerPassengerView *)pickerView {
    [UIView animateWithDuration:0.35 animations:^{
        [self.pickerPassenger setOrigin:CGPointMake(0, [Define screenHeight])];
    }];
}

- (void)pickerPassengerView:(HKPickerPassengerView *)pickerView didData:(NSString *)string {
    
    [UIView animateWithDuration:0.35 animations:^{
        [self.pickerPassenger setOrigin:CGPointMake(0, [Define screenHeight])];
    }];
    if (pickerView.pickerType == HKPickerPassengerViewTypeBirthday) {
        self.userModel.birthday = string;
        [self editUserInfo:string editType:EditControlBirthday];
    }
    [self.tableViewWM reloadData];
}

#pragma mark - get set
- (UserManager *)userModel {
    if (!_userModel) {
        _userModel = [UserManager shared];
    }
    return _userModel;
}

- (NSString *)keyWithEditType:(EditControlType)keyType {
    NSString *str_key = @"";
    switch (keyType) {
        case EditControlNickname:
            str_key = @"nickname";
            break;
        case EditControlSign:
            str_key = @"sign";
            break;
        case EditControlSex:
            str_key = @"sex";
            break;
        case EditControlAvatar:
            str_key = @"icon";
            break;
        case EditControlBirthday:
            str_key = @"birthday";
            break;
            
        default:
            break;
    }
    return str_key;
}

#pragma mark - Network
/** 编辑个人资料 （用户头像，用户昵称，用户签名，用户性别，用户生日） */
- (void)editUserInfo:(NSString *)strValue editType:(EditControlType)keyType {
    if ([NSString isBlankString:strValue]) {
        return;
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%@",self.userModel.userId] forKey:@"userId"];
    
    // 获取修改的key
    NSString *str_key = [self keyWithEditType:keyType];
    if (![NSString isBlankString:str_key]) {
        [param setObject:strValue forKey:str_key];
    }
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"editUserInfo" params:param Success:^(id result) {
        DebugLog(@"_______result:%@",result);
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            
            weakSelf.userModel = nil;
            UserManager *info = [UserManager mj_objectWithKeyValues:data[@"userInfo"]];
            UserManager *model = [UserManager shared];
            model.birthday = info.birthday;
            model.icon = info.icon;
            model.nickname = info.nickname;
            model.pwdim = info.pwdim;
            model.sex = info.sex;
            model.sign = info.sign;
            model.supervisor = info.supervisor;
            model.userId = info.userId;
            
            NSMutableDictionary *dict_value = [model mj_keyValues];
            [UserManager storeUserWithDict:dict_value];
            [[ChatMessage shareChat] updateJUserInfo];
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        DebugLog(@"_______error:%@",error);
    }];
    
}


@end
