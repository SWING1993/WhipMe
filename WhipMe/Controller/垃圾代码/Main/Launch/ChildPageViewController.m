//
//  ChildPageViewController.m
//  YouShaQi
//
//  Created by JC_CP3 on 14-4-8.
//  Copyright (c) 2014年 HangZhou RuGuo Network Technology Co.Ltd. All rights reserved.
//

#import "ChildPageViewController.h"
#import "Constant.h"

#define offsetOneUnit (IS_IPAD ? 20 : (IS_IPHONE_6P || IS_IPHONE_6 ? 15 : (iPhone5 ? 10 : 0)))

@interface ChildPageViewController ()

@end

@implementation ChildPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    switch (self.pageIndex) {
        case 0:
            view.backgroundColor = RGBCOLOR(172, 211, 59);
            break;
        case 1:
            view.backgroundColor = RGBCOLOR(79, 190, 255);
            break;
        case 2:
            view.backgroundColor = RGBCOLOR(255, 218, 43);
            break;
        case 3:
            view.backgroundColor = RGBCOLOR(227, 49, 36);
            
        default:
            break;
    }
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    switch (self.pageIndex) {
        case 0:
            currentImageView.image = ImageNamed(@"");
            break;
        case 1:
            currentImageView.image = ImageNamed(@"");
            break;
        case 2:
            currentImageView.image = ImageNamed(@"");
            break;
        case 3:
            currentImageView.image = ImageNamed(@"");
            break;
            
        default:
            currentImageView.image = ImageNamed(@"");
            break;
    }
    
    [self.view addSubview:currentImageView];
}

- (void)clickAuthBtn:(UIButton *)btn
{
    if ([self.childPageViewDelegate respondsToSelector:@selector(authBtnClicked:)]) {
        [self.childPageViewDelegate authBtnClicked:btn.tag];
    }
}

- (void)clickEnterBtn
{
    if ([self.childPageViewDelegate respondsToSelector:@selector(enterBtnClicked)]) {
        [self.childPageViewDelegate enterBtnClicked];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***********************************************************
 以下是垃圾代码区域，不要删！不要添加！不要动！
 ***********************************************************/

@end
