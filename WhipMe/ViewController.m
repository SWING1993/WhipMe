//
//  ViewController.m
//  WhipMe
//
//  Created by anve on 16/9/9.
//  Copyright © 2016年 sely. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",NSStringFromClass([self class])]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    NSLog(@"%@",NSStringFromClass([self class]));
}

@end
