//
//  KRootViewController.m
//  DDExpressClient
//
//  Created by yangg on 16/2/23.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDRootViewController.h"
#import "NSDate+DateHelper.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+MultipleConstraints.h"
#import "CustomStringUtils.h"
#import "CustomSizeUtils.h"
#import "MobClick.h"
#import "BaseNavController.h"
#import "AFNetworkReachabilityManager.h"

static const CGFloat segmentItemWidth = 68.5;
static const CGFloat segmentItemHeight = 29;

@interface DDRootViewController ()
{
    UIView *navBarView;
    UIButton *navLeftBarBtn;
    UIButton *navSecondLeftBarBtn;
    UILabel *navTitleLabel;
    UIButton *navFirstRightBarBtn;
    UIButton *navSecondRightBarBtn;
    
    NSArray *currentSegmentArray;
    CustomNavigationBarColorTag customBgTag;
    
    UISegmentedControl *segmentedControl;
    NSString *currentTitle;
    
    UIColor *navBarBackgroundColor;
    UIColor *navBarTextColor;
    UIColor *navBarSeparatorColor;
    UIColor *navItemNormalColor;
    UIColor *navItemHighlightedColor;
}

@end

@implementation DDRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self enableBackGesture];
    
    navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, KNavHeight)];
    [self.view addSubview:navBarView];
    
    navLeftBarBtn = [[UIButton alloc] init];
    [navLeftBarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navLeftBarBtn addTarget:self action:@selector(onClickLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:navLeftBarBtn];
    
    navSecondLeftBarBtn = [[UIButton alloc] init];
    navSecondLeftBarBtn.hidden = YES;
    [navSecondLeftBarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navSecondLeftBarBtn addTarget:self action:@selector(onClickSecondLeftItem) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:navSecondLeftBarBtn];
    
    navTitleLabel = [[UILabel alloc] init];
    navTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [navBarView addSubview:navTitleLabel];
    
    navFirstRightBarBtn = [[UIButton alloc] init];
    [navFirstRightBarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navFirstRightBarBtn addTarget:self action:@selector(onClickFirstRightItem) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:navFirstRightBarBtn];
    
    navSecondRightBarBtn = [[UIButton alloc] init];
    [navSecondRightBarBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [navSecondRightBarBtn addTarget:self action:@selector(onClickSecondRightItem) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:navSecondRightBarBtn];
    
    segmentedControl = [[UISegmentedControl alloc] init];
    segmentedControl.hidden = YES;
    [segmentedControl addTarget:self action:@selector(onClickSegment:) forControlEvents:UIControlEventValueChanged];
    [navBarView addSubview:segmentedControl];
    
    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, MainScreenHeight)];
    self.shadowView.layer.zPosition = 99999;
    self.shadowView.hidden = YES;
    self.shadowView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.shadowView];
    [self.view bringSubviewToFront:self.shadowView];
    
    
    DDAddNotification(@selector(reachability), AFNetworkingReachabilityDidChangeNotification);
}
-(void)dealloc
{
    DDRemoveNotificationWithName(AFNetworkingReachabilityDidChangeNotification);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)adaptNavBarWithBgTag:(CustomNavigationBarColorTag)bgTag navTitle:(NSString *)title segmentArray:(NSArray *)array
{
    switch (bgTag) {
        case CustomNavigationBarColorRed:
            navBarBackgroundColor = RGBCOLOR(167, 10, 10);
            navBarTextColor = [UIColor whiteColor];
            navBarSeparatorColor = RGBCOLOR(133, 11, 11);
            
            navItemNormalColor = RGBCOLOR(255, 255, 255);
            navItemHighlightedColor = RGBACOLOR(255, 255, 255, 0.4f);
            break;
            
        case CustomNavigationBarColorWhite:
            navBarBackgroundColor = RGBCOLOR(247, 247, 247);
            navBarTextColor = RGBCOLOR(51, 51, 51);
            navBarSeparatorColor = RGBCOLOR(170, 170, 170);
            
            navItemNormalColor = RGBCOLOR(32, 198, 122);
            navItemHighlightedColor = RGBCOLOR(32, 198, 122);
            break;
            
        case CustomNavigationBarColorLightWhite:
            navBarBackgroundColor = RGBCOLOR(250, 250, 250);
            navBarTextColor = RGBCOLOR(33, 33, 33);
            navBarSeparatorColor = RGBCOLOR(128, 128, 128);
            
            navItemNormalColor = RGBCOLOR(214, 44, 44);
            navItemHighlightedColor = RGBCOLOR(242, 206, 206);
            break;
            
        case CustomNavigationBarColorBlack:
            navBarBackgroundColor = RGBCOLOR(30, 30, 30);
            navBarTextColor = [UIColor whiteColor];
            
            navItemNormalColor = RGBCOLOR(255, 255, 255);
            navItemHighlightedColor = RGBCOLOR(255, 255, 255);
            break;
    }
    
    [navBarView setBackgroundColor:navBarBackgroundColor];
    
    currentSegmentArray = array;
    customBgTag = bgTag;
    currentTitle = title;
    
    [self updateNavBarWithTitle:title];
    
    [self updateSegmentControl];
    
    [self updateSeparateLine];
}

- (void)updateNavBarWithTitle:(NSString *)title
{
    [navTitleLabel setFrame:CGRectMake(50, 20.f, MainScreenWidth - 100, 40)];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.text = title;
    navTitleLabel.textColor = navBarTextColor;
}

- (void)updateNavLeftSecondBarBtnWithNormalImage:(UIImage *)normalImage hightlightedImage:(UIImage *)highlightedImage
{
    navSecondLeftBarBtn.hidden = YES;
    [navSecondLeftBarBtn setImage:normalImage forState:UIControlStateNormal];
    [navSecondLeftBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    [navSecondLeftBarBtn setFrame:CGRectMake(CGRectGetMaxX(navLeftBarBtn.frame), 20.f, normalImage.size.width + 40, 44.f)];
}

- (void)updateNavLeftSecondBarBtnShow:(BOOL)show
{
    navSecondLeftBarBtn.hidden = !show;
}

- (void)updateSegmentControl
{
    // sengment
    if ([currentSegmentArray count] > 0) {
        [segmentedControl setTintColor:navItemNormalColor];
        UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [segmentedControl setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
        CGFloat segmentCount = [currentSegmentArray count];
        [navBarView setFrame:CGRectMake(0, 0, MainScreenWidth, 64)];
        if (segmentedControl.numberOfSegments != segmentCount) {
            for (int i = 0; i < segmentCount; i++) {
                NSString *title = [currentSegmentArray objectAtIndex:i];
                [segmentedControl insertSegmentWithTitle:title atIndex:i animated:NO];
            }
        }
        [segmentedControl setFrame:CGRectMake(0, 0, (segmentCount * segmentItemWidth), segmentItemHeight)];
        [navBarView alignCenterSubview:segmentedControl withBottomPadding:10];
        
        segmentedControl.hidden = NO;
    } else {
        segmentedControl.hidden = YES;
    }
}

- (void)updateSeparateLine
{
    if (navBarSeparatorColor) {
//        CGFloat customNavHeight = [currentSegmentArray count] > 0 ? 64 + 44 : 64;
        CGFloat customNavHeight = 64;
        UIView *navBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, customNavHeight - 0.5f, CGRectGetWidth(self.view.bounds), 0.5f)];
        navBottomLine.backgroundColor = navBarSeparatorColor;
        [self.view addSubview:navBottomLine];
        [self.view resetSubViewWidthEqualToSuperView:navBottomLine];
    }
}

- (void)adaptNavigationBarHidden:(BOOL)flag
{
    CGFloat _origin_y = flag ? -KNavHeight : 0;
    
    [UIView animateWithDuration:0.35f animations:^{
        [navBarView setOrigin:CGPointMake(0, _origin_y)];
    } completion:^(BOOL finish) {
        [navBarView setHidden:flag];
    }];
}

#pragma mark - segmentControl
- (NSInteger)getCurrentSelectedSegmentIndex
{
    return segmentedControl.selectedSegmentIndex;
}

- (void)updateSegmentControlWithIndex:(NSInteger)index
{
    segmentedControl.selectedSegmentIndex = index;
}

#pragma mark - LeftItem
- (void)adaptLeftItemWithTitle:(NSString *)title backArrow:(BOOL)backArrow
{
    if ([CustomStringUtils isBlankString:title]) {
        navLeftBarBtn.hidden = YES;
        return;
    }
    
    [navLeftBarBtn setTitleColor:navItemNormalColor forState:UIControlStateNormal];
    [navLeftBarBtn setTitleColor:navItemHighlightedColor forState:UIControlStateHighlighted];
    
    if (backArrow) {
        UIImage *normalImage = [self createNormalImageWithTitle:title];
        [navLeftBarBtn setImage:normalImage forState:UIControlStateNormal];
        
        UIImage *highlightedImage = [self createHighlightedImageWithTitle:title];
        [navLeftBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
        [navLeftBarBtn setFrame:CGRectMake(0, 20.f, normalImage.size.width, 44.f)];
    } else {
        [navLeftBarBtn setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [CustomSizeUtils simpleSizeWithStr:title font:navLeftBarBtn.titleLabel.font];
        CGFloat itemWidth = titleSize.width + 30;
        [navLeftBarBtn setFrame:CGRectMake(0, 20.f, itemWidth, 44.f)];
    }
}

- (UIImage *)createNormalImageWithTitle:(NSString *)title
{
    UIFont *textFont = [UIFont systemFontOfSize:15];
    CGSize textSize = [CustomSizeUtils simpleSizeWithStr:title font:textFont];
    CGFloat textWidth = textSize.width >= 55 ? 90 : 75;
    
    CGSize imgSize = CGSizeMake(textWidth, 44);
    CGRect textRect = CGRectMake(25, 13.5f, 65, 16);
    
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, [[UIScreen mainScreen] scale]);
    
    UIImage *originImage;
    switch (customBgTag) {
        case CustomNavigationBarColorRed:
            originImage = ImageNamed(@"nav_back_white.png");
            break;
            
        case CustomNavigationBarColorWhite:
            originImage = ImageNamed(@"nav_back_red.png");
            break;
            
        case CustomNavigationBarColorLightWhite:
            originImage = ImageNamed(@"nav_back_red.png");
            break;
            
        case CustomNavigationBarColorBlack:
            break;
    }
    
    [originImage drawAtPoint:CGPointMake(0, 0)];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:textRect];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.font = textFont;
    backLabel.textColor = navItemNormalColor;
    backLabel.text = title;
    
    [backLabel drawTextInRect:backLabel.frame];
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)createHighlightedImageWithTitle:(NSString *)title
{
    UIFont *textFont = [UIFont systemFontOfSize:15];
    CGSize textSize = [CustomSizeUtils simpleSizeWithStr:title font:textFont];
    CGFloat textWidth = textSize.width >= 55 ? 90 : 75;
    
    CGSize imgSize = CGSizeMake(textWidth, 44);
    CGRect textRect = CGRectMake(25, 13.5f, 65, 16);
    
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 2.0);
    
    UIImage *originImage;
    switch (customBgTag) {
        case CustomNavigationBarColorRed:
            originImage = ImageNamed(@"nav_back_white_selected.png");
            break;
            
        case CustomNavigationBarColorWhite:
            originImage = ImageNamed(@"nav_back_red_selected.png");
            break;
            
        case CustomNavigationBarColorLightWhite:
            originImage = ImageNamed(@"nav_back_red_selected.png");
            break;
            
        case CustomNavigationBarColorBlack:
            break;
    }
    [originImage drawAtPoint:CGPointMake(0, 0)];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:textRect];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.font = textFont;
    backLabel.textColor = navItemHighlightedColor;
    backLabel.text = title;
    
    [backLabel drawTextInRect:backLabel.frame];
    
    // Read the UIImage object
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (void)adaptLeftItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    if (!normalImage) {
        navLeftBarBtn.hidden = YES;
        return;
    }
    
    [navLeftBarBtn setImage:normalImage forState:UIControlStateNormal];
    [navLeftBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    [navLeftBarBtn setFrame:CGRectMake(0, 20.f, normalImage.size.width + 40, 44.f)];
}


#pragma mark FirstRightItem
- (void)adaptFirstRightItemWithTitle:(NSString *)title
{
    if ([CustomStringUtils isBlankString:title]) {
        [UIView animateWithDuration:0.3f animations:^{
            navFirstRightBarBtn.layer.opacity = 0;
        } completion:^(BOOL finished) {
            navFirstRightBarBtn.hidden = YES;
            navFirstRightBarBtn.layer.opacity = 1;
        }];
        return;
    }
    
    navFirstRightBarBtn.hidden = NO;
    [navFirstRightBarBtn setTitle:title forState:UIControlStateNormal];
    [navFirstRightBarBtn setTitleColor:navItemNormalColor forState:UIControlStateNormal];
    [navFirstRightBarBtn setTitleColor:navItemHighlightedColor forState:UIControlStateHighlighted];
    
    CGSize titleSize = [CustomSizeUtils simpleSizeWithStr:title font:navFirstRightBarBtn.titleLabel.font];
    CGFloat itemWidth = titleSize.width + 30;
    [navFirstRightBarBtn setFrame:CGRectMake(MainScreenWidth - itemWidth, 20.f, itemWidth, 44.f)];
}

- (void)adaptFirstRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    if (!normalImage) {
        navFirstRightBarBtn.hidden = YES;
        return;
    }
    
    navFirstRightBarBtn.hidden = NO;
    [navFirstRightBarBtn setImage:normalImage forState:UIControlStateNormal];
    [navFirstRightBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [navFirstRightBarBtn setFrame:CGRectMake(MainScreenWidth - normalImage.size.width - 30 , 20.f, normalImage.size.width + 30, 44.f)];
}

- (void)setFirstRightItemEnabled:(BOOL)enabled
{
    navFirstRightBarBtn.enabled = enabled;
}


#pragma mark SecondRightItem
- (void)adaptSecondRightItemWithTitle:(NSString *)title
{
    if ([CustomStringUtils isBlankString:title]) {
        navSecondRightBarBtn.hidden = YES;
        return;
    }
    
    navSecondRightBarBtn.hidden = NO;
    [navSecondRightBarBtn setTitle:title forState:UIControlStateNormal];
    [navSecondRightBarBtn setTitleColor:navItemNormalColor forState:UIControlStateNormal];
    [navSecondRightBarBtn setTitleColor:navItemHighlightedColor forState:UIControlStateHighlighted];
    
    CGSize titleSize = [CustomSizeUtils simpleSizeWithStr:title font:navSecondRightBarBtn.titleLabel.font];
    CGFloat itemWidth = titleSize.width + 30;
    
    [navSecondRightBarBtn setFrame:CGRectMake(MainScreenWidth - CGRectGetWidth(navFirstRightBarBtn.frame) - itemWidth, 20.f, itemWidth, 44.f)];
}

- (void)adaptSecondRightItemWithNormalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage
{
    if (!normalImage) {
        navSecondRightBarBtn.hidden = YES;
        return;
    }
    
    navSecondRightBarBtn.hidden = NO;
    [navSecondRightBarBtn setImage:normalImage forState:UIControlStateNormal];
    [navSecondRightBarBtn setImage:highlightedImage forState:UIControlStateHighlighted];
    
    [navSecondRightBarBtn setFrame:CGRectMake(MainScreenWidth - CGRectGetWidth(navFirstRightBarBtn.frame) - normalImage.size.width, 20.f, normalImage.size.width, 44.f)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UtilityFunction
- (BOOL)reachability
{
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (AFNetworkReachabilityStatusNotReachable == status) {
        return NO;
    } else {
        return YES;
    }
}
- (void)showForErrorMsg:(NSError *)objMsg
{
    NSString *errorMsg = objMsg.domain;

    if (errorMsg == nil || [errorMsg isEqualToString:@""] == true)
    {
        if (objMsg.code == ErrorNoReachable) {
            errorMsg = @"没有连接网络!";
        } else if(objMsg.code == ErrorHostDisConnect) {
            errorMsg = @"服务器断开连接!";
        } else if (objMsg.code == 404) {
            errorMsg = @"404-服务器错误!";
        } else {
            errorMsg = @"网络错误!";
        }
    }
    [self displayForErrorMsg:errorMsg];
}

/** 错误消息提示窗 */
- (void)displayForErrorMsg:(NSString *)objMsg;
{
    [MBProgressHUD showError:objMsg];
}

#pragma mark - 数据转换、检测
/** 手机号的验证 */
- (BOOL)isValidateMobile:(NSString *)mobile {
    NSString *phoneRegex = @"^1(3|4|5｜7|8)\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/** 数字的验证 */
- (BOOL)isValidateNumber:(NSString *)number
{
    NSString *numberRegex = @"^[0-9]*$";
    NSPredicate *numberText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberText evaluateWithObject:number];
}

/** 邮箱的验证 */
- (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/** 筛选字符串中的数字 自区分字符和汉字，特殊字符没有限制*/
- (NSInteger)numberWithFiltrateString:(NSString *)string
{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z\u4e00-\u9fa5]" options:0 error:NULL];
    NSString *result = [regular stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@""];
   
    NSLog(@"number:%@", result);
    
    return [result integerValue];
}

/** 计算转换后字符的个数*/
- (NSUInteger)lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString *pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
}

- (NSString *)getWithDate:(NSString *)time
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *tempDate = [NSDate dateFromString:time withFormat:@"yyyy-MM-dd"];
    if (tempDate) {
        comps = [calendar components:unitFlags fromDate:tempDate];
        
        return [self getWithMonth:comps.month day:comps.day];
    }
    return @"";
}

/** 星座 */
- (NSString *)getWithMonth:(NSInteger)m day:(NSInteger)d
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1 || m>12 || d<1 || d>31) {
        return @"";
    }
    
    if(m==2 && d>29) {
        return @"";
    } else if (m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"";
        }
    }
    result = [NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2 - (d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2, 2)]];
    return result;
}

/** 年龄  */
- (NSInteger)ageWithDateOfBirth:(NSString *)time
{
    NSDate *nowDate = [NSDate dateFromString:time withFormat:@"yyyy-MM-dd"];
    if (!nowDate) {
        return 0;
    }
    
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:nowDate];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateMonth = [components1 month];
    NSInteger brithDateDay   = [components1 day];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateMonth = [components2 month];
    NSInteger currentDateDay   = [components2 day];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

- (NSString *)generateUuidString
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    
    return uuidString;
}

- (UIImage *)scaleImage:(UIImage *)image
{
    if (MAX(image.size.height, image.size.width) < 1280.0f)
    {
        return image;
    }
    
    CGSize newImageS = CGSizeZero;
    if (image.size.height > image.size.width) {
        newImageS.height = 1280.0f;
        float ratio = 1280.0f / image.size.height;
        newImageS.width = image.size.width * ratio;
    } else {
        newImageS.width = 1280.0f;
        float ratio = 1280.0f / image.size.width;
        newImageS.height = image.size.height * ratio;
    }
    
    UIGraphicsBeginImageContext(newImageS);
    [image drawInRect:CGRectMake(0, 0, newImageS.width, newImageS.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (UIImage *)fixOrientation:(UIImage *)aImage
{
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  拨打电话
 */
- (void)callCustomerService:(NSString *)phone
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
    NSURL *telURL = [NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

//友盟计数
- (void)uploadCountEventWithId:(NSString *)eventId label:(NSString *)eventLabel
{
    if (![CustomStringUtils isBlankString:eventId]) {
        if (![CustomStringUtils isBlankString:eventLabel]) {
            [MobClick event:eventId label:eventLabel];
        } else {
            [MobClick event:eventId];
        }
    }
}

//友盟计算
- (void)uploadCaculateEventWithId:(NSString *)eventId attributes:(NSDictionary *)eventAttributes
{
    if (![CustomStringUtils isBlankString:eventId]) {
        if (eventAttributes && ![eventAttributes isKindOfClass:[NSNull class]]) {
            [MobClick event:eventId attributes:eventAttributes];
        }
    }
}

#pragma mark - Target Action
- (void)onClickLeftItem
{
    
}

- (void)onClickFirstRightItem
{
    
}

- (void)onClickSecondRightItem
{
    
}

- (void)onClickSegment:(UISegmentedControl *)segmentControl
{
    
}

- (void)onClickSecondLeftItem
{
    
}

#pragma mark - Gesture
#pragma mark - 共用方法
- (void)enableBackGesture
{
    if ([self.navigationController isKindOfClass:[BaseNavController class]] || [self.navigationController isMemberOfClass:[BaseNavController class]]) {
        [(BaseNavController *)self.navigationController setEnableBackGesture:YES];
    }
}

- (void)disableBackGesture
{
    if ([self.navigationController isKindOfClass:[BaseNavController class]] || [self.navigationController isMemberOfClass:[BaseNavController class]]) {
        [(BaseNavController *)self.navigationController setEnableBackGesture:NO];
    }
}

@end
