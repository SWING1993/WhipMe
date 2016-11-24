//
//  WMUserInfoViewController.m
//  WhipMe
//
//  Created by anve on 16/11/24.
//  Copyright © 2016年 -. All rights reserved.
//

#import "WMUserInfoViewController.h"

@interface WMUserInfoViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) UserManager *userModel;

@property (nonatomic, strong) UIImage *imagePath;

@end

static NSString *identifier_cell = @"userInfoViewCell";

@implementation WMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑个人资料";
    self.view.backgroundColor = [Define kColorBackGround];
    
    //        userModel.username = "幽叶"
    //        userModel.nickname = "榴莲"
    //        userModel.avatar = "system_monitoring"
    //        userModel.sex = "男"
    //        userModel.age = "22"
    //        userModel.birthday = "1992-10-05"
    //        userModel.signature = "寂寞的幻境，朦胧的身影"
    
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
            [cell.imageLogo setImageWithUrlString:self.userModel.icon placeholderImage:[Define kDefaultImageHead]];
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
            self.userModel.sex = true;
            [self.tableViewWM reloadData];
        }]];
        [sheetSex addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.userModel.sex = false;
            [self.tableViewWM reloadData];
        }]];
        [sheetSex addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.tableViewWM reloadData];
        }]];
        [self presentViewController:sheetSex animated:YES completion:nil];
    } else if (indexPath.row == 5) {
        [self selectUserBirthday];
    }
}

#pragma mark - Action
- (void)showUserEditContorl:(NSIndexPath *)indexPath placeholder:(NSString *)string {
    
//    EditControlType editControl = indexPath.row == 7 ? EditControlTypes : WMEditControlnickname;
    UserEditViewController *contorller = [[UserEditViewController alloc] init];
    
//    controller.editControl = editControl
//    controller.strPlaceholder = placeholder
//    controller.textEditedBlock = { (value, editType) -> Void in
//        print("value is :\(value) __:\(editType)")
//        if editType == EditControlType.signature {
//            self.userModel.sign = value
//        } else {
//            self.userModel.nickname = value
//        }
//        self.tableViewWM.reloadData()
//    }
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
    
//    SGHDateView.sharedInstance.pickerMode = .date
//    SGHDateView.sharedInstance.show();
//
//    //        let format = DateFormatter()
//    //        format.dateFormat = "yyyy-MM-dd"
//    //        format.timeZone = TimeZone.init(identifier: "Asia/Beijing")
//    
//    SGHDateView.sharedInstance.okBlock = { (date) -> Void in
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        self.userModel.birthday = formatter.string(from: date as Date)
//        self.tableViewWM.reloadData()
//    }
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
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@.png",filePath,[UIImage generateUuidString]];
    [self.tableViewWM reloadData];
    
    BOOL flag = [imageData writeToFile:fullPath atomically:YES];
    if (flag) {
        
        WEAK_SELF
        [HttpAPIClient uploadServletToHeader:fullPath Success:^(id result) {
            DebugLog(@"____________result:%@",result);
            
            if ([result[@"ret"] integerValue] != 0) {
                //图片上传失败!
                [Tool showHUDTipWithTipStr:result[@"desc"]];
            } else {
                weakSelf.userModel.icon = result[@"userInfo"][@"icon"];
                [weakSelf.tableViewWM reloadData];
            }
        } Failed:^(NSError *error) {
            [Tool showHUDTipWithTipStr:error.domain];
        }];
    }
}

- (UserManager *)userModel {
    if (!_userModel) {
        _userModel = [UserManager getUser];
    }
    return _userModel;
}
@end
