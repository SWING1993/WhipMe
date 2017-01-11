//
//  WMNotificationController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMNotificationController.h"

@interface WMNotificationController ()

@end

@implementation WMNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
}

@end
