//
//  DDPersonalDetailController.m
//  DDExpressCourier
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 NS. All rights reserved.
//
#define KPersonalItem 7777
#define KPersonalSheet 8888

#import "DDPersonalDetailController.h"
#import "DDPersonalChangeController.h"
#import "DDPersonalUpdateController.h"
#import "DDIdCheckController.h"
#import "NSDate+DateHelper.h"

#import "DDSelfInfomation.h"
#import "YYModel.h"
#import "DDGlobalVariables.h"
#import "NSDate+DateHelper.h"

#import "UIImageView+WebCache.h"

#import "DDPersonalCheckingController.h"
#import "CustomStringUtils.h"
#import "DDLocalUserInfoUtils.h"

/** 头像栏的高度 */
#define  DDPDHead_Height 64
/** 其他栏的高度 */
#define  DDPDRow_Height 44.0f

/** arrowIcon的高和宽 */
#define DDPDArrowWH 13
/** arrow距离右侧边界的距离 */
#define DDPDArrowRight 12
/** arrow距离请输入标签的距离 */
#define DDPDArrowLabel 8
/** 每个视图中文字距离左边的间距 */
#define DDMarginSpacing 15.0f
/** 箭头图片名称 */
#define DDPersonalDetailArrowName @"AddressArrow"

typedef NS_ENUM(NSInteger, PersonalCheckType) {
    PersonalCheckIsChecking = 1,
    PersonalCheckPass = 2,
    PersonalCheckUnPass = 3
};


@interface DDPersonalDetailController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,DDInterfaceDelegate>
{
    UIImage *_imgData;
    NSInteger _imgTag;
}

/** 本视图的整体滚动视图 */
@property (nonatomic, strong) UIScrollView *userScroll;
/** 用于存储用户属性按钮 */
@property (nonatomic, strong) NSMutableArray *itemTitles;
/** 用于存储标签对象 */
@property (nonatomic, strong) NSMutableArray *arrayLabel;
/** 用户头像 */
@property (nonatomic, strong) UIImageView *headView;
/** 时间选择器的父视图 */
@property (nonatomic, strong) UIView *viewCheck;
/** 时间选择器 */
@property (nonatomic, strong) UIDatePicker *timePicker;

@property (nonatomic, strong) UIButton * animationButton;
/** 昵称 */
@property (nonatomic, strong) UILabel * nameLabel;
/** 手机号 */
@property (nonatomic, strong) UILabel * phoneLabel;
/** 邮箱 */
@property (nonatomic, strong) UILabel * mailLabel;
/** 性别 */
@property (nonatomic, strong) UILabel * sexLabel;
/** 职业 */
@property (nonatomic, strong) UILabel * professionLabel;
/** 生日 */
@property (nonatomic, strong) UILabel * birthdayLabel;
/** 身份认证 */
@property (nonatomic, strong) UILabel * idLabel;
/**<  修改个人信息  */
@property (nonatomic, strong) DDInterface *interfaceUpdate;
/**<  修改个人信息  */
@property (nonatomic, strong) DDInterface *interfaceUploadData;

@end

@implementation DDPersonalDetailController
@synthesize userScroll;
@synthesize itemTitles;
@synthesize headView;
@synthesize viewCheck;
@synthesize timePicker;

#pragma mark - 初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray *itemOne = [NSArray arrayWithObjects:@"头像", nil];
        NSArray *itemTwo = [NSArray arrayWithObjects:@"昵称",@"手机号",@"邮箱", nil];
        NSArray *itemThree = [NSArray arrayWithObjects:@"性别",@"职业",@"生日", nil];
        NSArray *itemFour = [NSArray arrayWithObjects:@"身份认证", nil];
        itemTitles = [NSMutableArray arrayWithObjects:itemOne, itemTwo,itemThree,itemFour, nil];
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = KBackground_COLOR;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"个人信息" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self createScrollView];
    
    [self updateUserInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDRemoveNotificationWithName(DDRefreshCourierUserView);
    DDAddNotification(@selector(updateUserInfo), DDRefreshCourierUserView);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DDRemoveNotificationWithName(DDRefreshCourierUserView);
}

- (void)updateUserInfo
{
    if (![CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"avatar"]]) {
        //头像
        NSString *imageUrl = [CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"avatar"]] ? @"" : [LocalUserInfo objectForKey:@"avatar"];
        [headView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:DDPersonalHeadIcon]];
    }
    
    if ([CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"nick"]]) {
        [self.nameLabel setText:@"请输入"];
    } else {
        [self.nameLabel setText:[LocalUserInfo objectForKey:@"nick"]];
    }
    [self textFontColor:self.nameLabel];
    
    if([CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"phone"]]) {
        [self.phoneLabel setText:@"请输入"];
    } else {
        [self.phoneLabel setText:[LocalUserInfo objectForKey:@"phone"]];
    }
    [self textFontColor:self.phoneLabel];
    
    if ([CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"email"]]) {
        [self.mailLabel setText:@"请输入"];
    } else {
        [self.mailLabel setText:[LocalUserInfo objectForKey:@"email"]];
    }
    [self textFontColor:self.mailLabel];
    
    //性别 0-女, 1-男
    if ([LocalUserInfo objectForKey:@"sex"]) {
        self.sexLabel.text = [[LocalUserInfo objectForKey:@"sex"] intValue] == 0 ? @"女" : @"男";
    } else {
        [self.sexLabel setText:@"请选择"];
    }
    [self textFontColor:self.sexLabel];
    
    //职业
    if ([CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"job"]]) {
        [self.professionLabel setText:@"请输入"];
    } else {
        [self.professionLabel setText:[LocalUserInfo objectForKey:@"job"]];
    }
    [self textFontColor:self.professionLabel];
    
    //生日
    if (![CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"birthday"]]) {
        long long timeCount = [[LocalUserInfo objectForKey:@"birthday"] longLongValue] / 1000;
        NSDate *tempDate = [[NSDate alloc] initWithTimeIntervalSince1970:timeCount];
        NSString *tempTime = [tempDate stringWithFormat:@"yyyy-MM-dd"];
        [self.birthdayLabel setText:tempTime ?: @"请选择"];
    } else {
        [self.birthdayLabel setText:@"请选择"];
    }
    [self textFontColor:self.birthdayLabel];
    
    //身份认证
    [self.idLabel setText:[self stringWithUserStyle:[[LocalUserInfo objectForKey:@"auth"] integerValue]]];
    [self textFontColor:self.idLabel];
}

#pragma mark - 对象方法:初始化页面
/** 创建本界面的整体滚动视图，作为所有显示空间的父视图 */
- (void)createScrollView
{
    userScroll = [[UIScrollView alloc] init];
    [userScroll setFrame:CGRectMake(0, 64, MainScreenWidth, MainScreenHeight - KNavHeight)];
    [userScroll setBackgroundColor:KBackground_COLOR];
    [userScroll setShowsHorizontalScrollIndicator:false];
    [userScroll setShowsVerticalScrollIndicator:false];
    [self.view addSubview:userScroll];
    
    self.arrayLabel = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self ddCreateForUserViewItem];
}

/** 新建视图，展示用户的基础信息
    包含：@"头像",@"昵称",@"邮箱",@"手机号",@"生日",@"性别",@"职业",@"身份认证", */
- (void)ddCreateForUserViewItem
{
    //每一项视图的高度
    CGFloat obj_item_h = DDPDRow_Height;
    
    //itemView的位置常量
    CGFloat obj_item_y = 0.0f;
    CGFloat origin_y = 0.0f;
    //数组下标，
    NSInteger tempIndex = 0;
    for (NSInteger i=0; i<itemTitles.count; i++)
    {
        NSArray *itemTitle = [itemTitles objectAtIndex:i];
        
        //创建白色的父视图
        UIView *itemView = [[UIView alloc] init];
        [itemView setFrame:CGRectMake(0, 0, self.view.width, itemTitle.count*obj_item_h)];
        [itemView setBackgroundColor:[UIColor whiteColor]];
        [itemView setTag:KPersonalItem + 1000 + i];
        [userScroll addSubview:itemView];
        
        origin_y = 0.0f;
        for (NSInteger k=0; k<itemTitle.count; k++)
        {
            //初始化每一项按钮
            UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [itemButton setBackgroundColor:[UIColor clearColor]];
            [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [itemButton setContentEdgeInsets:UIEdgeInsetsMake(0, DDMarginSpacing, 0, 0)];
            [itemButton setTag:tempIndex + KPersonalItem];
            [itemButton.titleLabel setFont:kTitleFont];
            [itemButton setTitleColor:TIME_COLOR forState:UIControlStateNormal];
            [itemButton setTitle:[itemTitle objectAtIndex:k] forState:UIControlStateNormal];
            [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:itemButton];
            
            //判断第一项数据是，添加一个头像图片ImageView，并更改视图大小
            if (k == 0 && i == 0)
            {
                [itemButton setFrame:CGRectMake(0, 0, itemView.width, DDPDHead_Height)];
                
                headView = [[UIImageView alloc] init];
                [headView setSize:CGSizeMake(41.0f, 41.0f)];
                [headView setCenter:CGPointMake(itemButton.width - headView.centerx - DDPDArrowLabel - DDPDArrowWH - DDPDArrowRight, itemButton.centery)];
                [headView.layer setCornerRadius:headView.height/2];
                [headView.layer setMasksToBounds:true];
                
                [headView setBackgroundColor:BORDER_COLOR];
                [headView setContentMode:UIViewContentModeScaleToFill];
                [headView setImage:[UIImage imageNamed:DDPersonalHeadIcon]];
                [itemButton addSubview:headView];
                
            } else {
                [itemButton setFrame:CGRectMake(0, origin_y, itemView.width, obj_item_h)];
                
                //设置每个按钮的背景图片和高亮
                UIImage *msgNormal = [UIImage imageWithDrawColor:[UIColor clearColor] withSize:itemButton.bounds];
                UIImage *Highlighted = [UIImage imageWithDrawColor:BORDER_COLOR withSize:itemButton.bounds];
                [itemButton setBackgroundImage:msgNormal forState:UIControlStateNormal];
                [itemButton setBackgroundImage:Highlighted forState:UIControlStateHighlighted];
                [itemButton setAdjustsImageWhenHighlighted:true];
                
                //内容文本
                UILabel *itemLbl = [[UILabel alloc] init];
                [itemLbl setFrame:CGRectMake(80.0f, 0, itemButton.width - 80 - DDPDArrowLabel - DDPDArrowWH - DDPDArrowRight, itemButton.height)];
                [itemLbl setBackgroundColor:[UIColor clearColor]];
                [itemLbl setTextAlignment:NSTextAlignmentRight];
                [itemLbl setNumberOfLines:0];
                [itemLbl setFont:kTitleFont];
                [itemLbl setTag:KPersonalItem + 100 + tempIndex];
                [itemButton addSubview:itemLbl];
                [self.arrayLabel addObject:itemLbl];
                
                if (tempIndex == 1) {
                    self.nameLabel = itemLbl;
                } else if (tempIndex == 2) {
                    self.phoneLabel = itemLbl;
                } else if (tempIndex == 3) {
                    self.mailLabel = itemLbl;
                } else if (tempIndex == 4) {
                    self.sexLabel = itemLbl;
                } else if (tempIndex == 5) {
                    self.professionLabel = itemLbl;
                } else if (tempIndex == 6) {
                    self.birthdayLabel = itemLbl;
                } else if (tempIndex == 7) {
                    self.idLabel = itemLbl;
                }
            }
            origin_y = itemButton.bottom;
            
            //右边箭头icon
            UIImageView *imageArrow = [[UIImageView alloc] init];
            [imageArrow setSize:CGSizeMake(DDPDArrowWH, DDPDArrowWH)];
            [imageArrow setCenter:CGPointMake(itemButton.width - DDPDArrowRight - DDPDArrowWH/2, itemButton.centery)];
            [imageArrow setImage:[UIImage imageNamed:DDPersonalDetailArrowName]];
            [itemButton addSubview:imageArrow];
            
            //每一项的下划线
            UILabel *lblLine = [[UILabel alloc] init];
            [lblLine setFrame:CGRectMake(DDMarginSpacing, itemButton.height - 0.5f, itemButton.width - DDMarginSpacing, 0.5f)];
            [lblLine setBackgroundColor:BORDER_COLOR];
            [lblLine setHidden:k < itemTitle.count-1 ? false : true];
            [itemButton addSubview:lblLine];
            
            tempIndex++;
        }
        [itemView setFrame:CGRectMake(0, obj_item_y, userScroll.width, origin_y)];
        obj_item_y = itemView.bottom + DDMarginSpacing;
    }
    [userScroll setContentSize:CGSizeMake(userScroll.width, MAX(userScroll.height, obj_item_y))];
}

/** 设置字体颜色 */
- (void)textFontColor:(UILabel *)sender
{
    NSString *text = sender.text;
    if ([text isEqualToString:@"请输入"] || [text isEqualToString:@"请选择"]) {
        [sender setTextColor:KPlaceholderColor];
    } else {
        [sender setTextColor:TITLE_COLOR];
    }
}

#pragma mark - 对象方法:监听点击
/** 按钮的响应事件，根据Tag下标判断 */
- (void)onClickWithItem:(UIButton *)sender
{
    NSInteger index = sender.tag % KPersonalItem;
    
    if (index == 0)
    {
        //头像选择
        UIActionSheet *sheet;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        } else {
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择", nil];
        }
        
        sheet.tag = KPersonalSheet;
        [sheet showInView:self.view];

    } else if (index == 1) {
        //真实姓名
        [self onClickWithPersonalChane:DDPCEditUserNickname];
    }  else if (index == 3) {
        //请输入邮箱
        [self onClickWithPersonalChane:DDPCEditUserMail];
    } else if (index == 2) {
        //手机号
        DDPersonalUpdateController *changeControl = [[DDPersonalUpdateController alloc] init];
        [self.navigationController pushViewController:changeControl animated:true];
    } else if (index == 6) {
        //生日
        [self ddShowForDatePicker:index];
    } else if (index == 4) {
        //性别
        UIActionSheet *sheetView = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        sheetView.tag = KPersonalSheet + index;
        [sheetView showInView:self.view];
        
    } else if (index == 5) {
        //请输入职业
        [self onClickWithPersonalChane:DDPCEditUserWork];
    } else {
        //身份认证
        NSInteger userAuthCode = [[LocalUserInfo objectForKey:@"auth"] integerValue];

        if (userAuthCode == 0) {
            
            DDIdCheckController *identifyController = [[DDIdCheckController alloc] init];
            [self.navigationController pushViewController:identifyController animated:YES];
            
        } else if (userAuthCode == PersonalCheckIsChecking) {
            
            DDPersonalCheckingController *vc = [[DDPersonalCheckingController alloc] initWithCheckingType:PersonalCheckIsChecking];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (userAuthCode == PersonalCheckPass) {
            
            DDPersonalCheckingController *vc = [[DDPersonalCheckingController alloc] initWithCheckingType:PersonalCheckPass];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (userAuthCode == PersonalCheckUnPass) {
            
            DDPersonalCheckingController *vc = [[DDPersonalCheckingController alloc] initWithCheckingType:PersonalCheckUnPass];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

/**
    编辑用户姓名、用户邮箱、用户职业的界面
 */
- (void)onClickWithPersonalChane:(DDPersonalChangeStyle)changeStyle
{
    DDPersonalChangeController *changeControl = [[DDPersonalChangeController alloc] initWithChange:changeStyle];
    changeControl.delegate = self;
    [self.navigationController pushViewController:changeControl animated:true];
}

#pragma mark - datePicker
/**
    创建一个时间选择器，并完成内容的展示
 */
- (void)ddShowForDatePicker:(NSInteger)index
{
    //判断视图是否存在，避免重复创建
    if (!viewCheck)
    {
        self.animationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.animationButton.x = 0 ;
        self.animationButton.y = 0 ;
        self.animationButton.width = self.view.width;
        self.animationButton.height = self.view.height;
        [self.animationButton addTarget:self action:@selector(removeAnimation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.animationButton];
        
        viewCheck = [[UIView alloc] init];
        [viewCheck setFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 236.5)];
        [viewCheck setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:viewCheck];
        
        UIView * titleView = [[UIView alloc] init];
        UIButton * cancelButton = [[UIButton alloc] init];
        UIButton * okButton = [[UIButton alloc] init];
        
        titleView.x = 0 ;
        titleView.y = 0 ;
        titleView.width = viewCheck.width;
        titleView.height = 45;
        titleView.backgroundColor = DDRGBColor(253, 253, 253);
        [viewCheck addSubview:titleView];
        
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [cancelButton setTitleColor:DDRGBColor(102 ,102 ,102 ) forState:UIControlStateNormal];
        cancelButton.x = 0;
        cancelButton.y = 0;
        cancelButton.width = 50;
        cancelButton.height = 45;
        [cancelButton addTarget:self action:@selector(datePickCancelAction) forControlEvents:UIControlEventTouchUpInside];
        
        [okButton setTitle:@" 确定" forState:UIControlStateNormal];
        okButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [okButton setTitleColor:DDRGBColor(32 ,198 ,122 ) forState:UIControlStateNormal];
        okButton.x = viewCheck.width - 50;
        okButton.y = 0;
        okButton.width = 50;
        okButton.height = 45;
        [okButton addTarget:self action:@selector(datePickOKAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:cancelButton];
        [titleView addSubview:okButton];
        
        UILabel * linelabel = [[UILabel alloc] init];
        linelabel.x = 0 ;
        linelabel.y = okButton.height ;
        linelabel.width = viewCheck.width;
        linelabel.height = 0.5f;
        linelabel.backgroundColor = DDRGBColor(229, 229, 229);
        [viewCheck addSubview:linelabel];
        
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"出生日期";
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = DDRGBColor(51, 51, 51);
        titleLabel.size = CGSizeMake(150, 45);
        titleLabel.center = CGPointMake(viewCheck.width/2, 45/2);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [viewCheck addSubview:titleLabel];

    }
    
    //初始化时间选择器
   
    if (!timePicker) {
        timePicker = [[UIDatePicker alloc] init];
        [timePicker setBackgroundColor:[UIColor clearColor]];
        [timePicker setFrame:CGRectMake(0, 46,CGRectGetWidth(viewCheck.frame), 188.5)];
        [timePicker setDatePickerMode:UIDatePickerModeDate];
        [timePicker setDate:[NSDate date]];
        [timePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
        [timePicker setMaximumDate:[NSDate date]];
        [viewCheck addSubview:timePicker];
    }
    
    
    //设置为中
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    timePicker.locale = locale;
    
    //设置默认显示时间
    if (![CustomStringUtils isBlankString:[LocalUserInfo objectForKey:@"birthday"]]) {
        long long timeCount = [[LocalUserInfo objectForKey:@"birthday"] longLongValue]/1000;
        NSDate *default_date = [[NSDate alloc] initWithTimeIntervalSince1970:timeCount];
        [timePicker setDate:default_date];
    } else {
        [timePicker setDate:[NSDate date]];
    }
    
    [self.animationButton setHidden:false];
    [viewCheck setHidden:false];
    //视图动画，显示从底部出现
    [UIView animateWithDuration:0.25f animations:^{
        [viewCheck setOrigin:CGPointMake(0, MainScreenHeight - viewCheck.height)];
        self.animationButton.backgroundColor = DDRGBAColor(0, 0, 0, 0.15);
    }];
    
}

#pragma mark - 时间选择器
- (void)removeAnimation
{
    if (viewCheck != nil  && self.animationButton != nil)
    {
        [UIView animateWithDuration:0.4 animations:^{
            viewCheck.y = self.view.height;
            self.animationButton.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finish) {
            [self.animationButton setHidden:true];
            [viewCheck setHidden:true];
        }];
    }
}

- (void)datePickCancelAction
{
    [self removeAnimation];
}

- (void)datePickOKAction:(UIDatePicker *)picker
{
    [self removeAnimation];
    
    NSDate *birthDay = self.timePicker.date;
    NSString *str_birghday = [NSDate stringFromDate:birthDay withFormat:@"yyyy-MM-dd"];
    long long timeCount = [birthDay timeIntervalSince1970]*1000;
    
    self.birthdayLabel.text = str_birghday;
    [self textFontColor:self.birthdayLabel];
    
    [DDLocalUserInfoUtils updateUserBirthday:[NSString stringWithFormat:@"%lld",timeCount]];
    [self updatePersonalDetailWithRequest];
}

#pragma mark - UIActionSheetDelegate
/** 实现相应的Action Sheet的选项的事件 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //如果选择器是头像
    if (actionSheet.tag == KPersonalSheet)
    {
        NSUInteger sourceType = 0;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 1:
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
                case 2:
                    return;
            }
        } else {
            if (buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
                return;
            }
        }
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        if (buttonIndex == 0) {
    
            [self.sexLabel setText:@"男"];
            [DDLocalUserInfoUtils updateUserSex:@"1"];
    
        } else if (buttonIndex == 1) {
            
            [self.sexLabel setText:@"女"];
            [DDLocalUserInfoUtils updateUserSex:@"0"];
            
        }
        [self textFontColor:self.sexLabel];
        if (buttonIndex != 2) {
            [self updatePersonalDetailWithRequest];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
/**
    获得已拍摄或者选择的图片，最后调用写好的upload方法将图片上传
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [headView setImage:editedImage];
    
    UIImage *imageOriginal = [self fixOrientation:editedImage];
    UIImage *newImage = [self scaleImage:imageOriginal];
    
    [self saveImage:newImage WithName:[NSString stringWithFormat:@"%@%@",[self generateUuidString],@".jpeg"]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/** upload image并且刷新tableview */
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.30f);
    NSArray *infoList = @[@{@"image":imageData, @"name":imageName}];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:infoList forKey:@"infoList"];
    
    if (!self.interfaceUploadData) {
        self.interfaceUploadData = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceUploadData interfaceWithType:INTERFACE_TYPE_UPLOAD_IMAGE param:param];
}

#pragma mark - DDPersonalChangeDelegate

/** delegate方法，修改名字 */
- (void)changeNick:(NSString *)nick
{
    if (![CustomStringUtils isBlankString:nick]) {
        [self.nameLabel setText:nick];
        [self textFontColor:self.nameLabel];
        
        [DDLocalUserInfoUtils updateUserNickName:nick];
    }
}

/** delegate方法，修改邮箱 */
- (void)changeEmail:(NSString *)email
{
    if (![CustomStringUtils isBlankString:email]) {
        [self.mailLabel setText:email];
        [self textFontColor:self.mailLabel];
        
        [DDLocalUserInfoUtils updateUserEmail:email];
    }
}

/** delegate方法，修改职业 */
- (void)changeProfessional:(NSString *)professional
{
    if (![CustomStringUtils isBlankString:professional]) {
        [self.professionLabel setText:professional];
        [self textFontColor:self.professionLabel];
        
        [DDLocalUserInfoUtils updateUserJob:professional];
    }
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取网络数据
/**
 *  修改个人信·息；
 */
- (void)updatePersonalDetailWithRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //个人头像url
    [param setObject:[LocalUserInfo objectForKey:@"avatar"] ?: @"" forKey:@"avatar"];
    //姓名
    [param setObject:[LocalUserInfo objectForKey:@"name"] ?: @"" forKey:@"name"];
    //昵称
    [param setObject:[LocalUserInfo objectForKey:@"nick"] ?: @"" forKey:@"nick"];
    //邮件
    [param setObject:[LocalUserInfo objectForKey:@"email"] ?: @"" forKey:@"email"];
    //生日
    [param setObject:[LocalUserInfo objectForKey:@"birthday"] ?: @"" forKey:@"birthday"];
    //性别 0 女 1 男
    [param setObject:[LocalUserInfo objectForKey:@"sex"] ?: @"" forKey:@"sex"];
    //职业
    [param setObject:[LocalUserInfo objectForKey:@"job"] ?: @"" forKey:@"job"];

    if (!self.interfaceUpdate) {
        self.interfaceUpdate = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceUpdate interfaceWithType:INTERFACE_TYPE_ALTER_INFORMATION param:param];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceUpdate) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }
    } else if (interface == self.interfaceUploadData) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            for (NSString *dataUrl in result[@"images"]) {
                if ([CustomStringUtils isBlankString:dataUrl]) {
                    continue;
                }
                [DDLocalUserInfoUtils updateUserAvatar:dataUrl];
                [self updatePersonalDetailWithRequest];
                break;
            }
        }
    }
}

/**
 *  根据身份认证状态，返回字符串
 *  @param style 0 待审核 1 审核中 2审核通过 3审核不通过
 *  @return 身份认证结果
 */
- (NSString *)stringWithUserStyle:(NSInteger)style
{
    NSString *identi_str = @"";
    switch (style) {
        case 1:
            identi_str = @"认证中";
            break;
        case 2:
            identi_str = @"认证通过";
            break;
        case 3:
            identi_str = @"认证未通过";
            break;
        default:
            identi_str = @"未认证";
            break;
    }
    return identi_str;
}

@end
