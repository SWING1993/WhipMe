//
//  DDWaitCourierRushOrderView.m
//  DDExpressClient
//
//  Created by Jadyn on 16/2/29.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDWaitCourierRushOrderView.h"
#import "DDHomeController.h"
#import "DDGlobalVariables.h"


NSString *const DDNaviTitleText = @"等待应答";
NSString *const DDCancelTitle = @"取消订单";

/** 本视图的高 */
#define KViewFrame_H 168.0f
/**<  倒计时时间  单位(s)  */
#define TOTAL_COUNTDOWN_TIME 180
/**<  倒计时时间  单位(10 ms)  */
#define WAIT_COUNTDOWN_TIME TOTAL_COUNTDOWN_TIME*100

@interface DDWaitCourierRushOrderView()
{
    /** 根控制器 */
    //UIWindow *_window;
}

/** 下层倒计时视图 */
@property (strong, nonatomic) UIView *viewCountDown;
/** 上层navigation视图 */
@property (strong, nonatomic) UIView *viewUpTitle;
/** 取消订单按钮 */
@property (strong, nonatomic) UIButton *btnCancel;
/** 标题label */
@property (strong, nonatomic) UILabel *lblTitle;
/** 倒计时label */
@property (strong, nonatomic) UILabel *lblMinTen;
@property (strong, nonatomic) UILabel *lblMin;
@property (strong, nonatomic) UILabel *lblSTen;
@property (strong, nonatomic) UILabel *lblS;
@property (strong, nonatomic) UILabel *lblColon;
@property (strong, nonatomic) UILabel *lblMsHundred;
@property (strong, nonatomic) UILabel *lblMsTen;
@property (strong, nonatomic) UILabel *lblOneDash;
@property (strong, nonatomic) UILabel *lblTwoDash;

/** 倒计时提示语label */
@property (strong, nonatomic) UILabel *lblPrompt;
/** 条形进度条 */
@property (strong, nonatomic) UISlider *slideView;

@property (nonatomic, strong) UIImageView *rightBoxImageView;
@property (nonatomic, strong) UIImageView *imageIconRun;

/**< GCD定时器 */
@property (nonatomic, strong) dispatch_source_t timer;
/**< 分十位标签 */
@property (nonatomic, retain) NSString *minTenString;
/**< 分个位标签 */
@property (nonatomic, retain) NSString *minString;
/**< 秒十位标签 */
@property (nonatomic, retain) NSString *sTenString;
/**< 秒十位标签 */
@property (nonatomic, retain) NSString *sString;
/**< 毫秒百位标签 */
@property (nonatomic, retain) NSString *msHundredString;
/**< 毫秒十位标签 */
@property (nonatomic, retain) NSString *msTenString;
/**< 倒计时总时间(单位10ms) */
@property (nonatomic, assign) NSInteger countDown;


@end

@implementation DDWaitCourierRushOrderView
@synthesize viewCountDown;
@synthesize viewUpTitle;

@synthesize lblTitle;
@synthesize btnCancel;
@synthesize lblPrompt;
@synthesize slideView;

@synthesize lblMinTen;
@synthesize lblMin;
@synthesize lblSTen;
@synthesize lblS;
@synthesize lblMsHundred;
@synthesize lblMsTen;
@synthesize lblOneDash;
@synthesize lblTwoDash;
@synthesize lblColon;
@synthesize imageIconRun;

- (instancetype)initWithDelegate:(id<DDWaitCourierRushOrderViewDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [self setFrame:CGRectMake(0, -KViewFrame_H, CGRectGetWidth(DDSCreenBounds), KViewFrame_H)];
        [self setBackgroundColor:DDGreen_Color];
        
        self.delegate = delegate;
        self.countDown = WAIT_COUNTDOWN_TIME;
        
        /** 初始化底层视图 */
        [self setup];
        
        [window addSubview:self];
        
        DDRemoveNotificationWithName(KREFRESH_DOWN_COUNT_DOWN_VIEW);
        DDAddNotification(@selector(reloadCountDownView:), KREFRESH_DOWN_COUNT_DOWN_VIEW);
        
        DDRemoveNotificationWithName(KREMOVE_DOWN_COUNT_DOWN_VIEW);
        DDAddNotification(@selector(dismissAlert), KREMOVE_DOWN_COUNT_DOWN_VIEW);
    }
    return self;
}

/** 初始化底层视图 */
- (void)setup
{
    /** 初始化上层navigation视图 */
    [self ddCreateWithUpTitleView];
    
    /** 初始化倒计时下层视图 */
    [self ddCreateWithCountDownView];
    
}

/** 初始化上层navigation视图 */
- (void)ddCreateWithUpTitleView
{
    /** 上层navigation视图 */
    viewUpTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(DDSCreenBounds), 64.0f)];
    viewUpTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:viewUpTitle];
    
    /** 等待应答 */
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(85.0f, 20.0f, viewUpTitle.width - 85*2.0f, viewUpTitle.height - 20.0f)];
    lblTitle.text = DDNaviTitleText;
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.font = kButtonFont;
    lblTitle.textColor = [UIColor whiteColor];
    [viewUpTitle addSubview:lblTitle];
    
    /** 取消订单 */
    btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(viewUpTitle.width-85, lblTitle.top, 70.0f, viewUpTitle.height - lblTitle.top)];
    [btnCancel setTitle:DDCancelTitle forState:UIControlStateNormal];
    [btnCancel.titleLabel setFont:kContentFont];
    [btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCancel setAdjustsImageWhenHighlighted:false];
    [btnCancel addTarget:self action:@selector(onClickWithCancel) forControlEvents:UIControlEventTouchUpInside];
    [viewUpTitle addSubview:btnCancel];
   

}

/**
    初始化倒计时下层视图
 */
- (void)ddCreateWithCountDownView
{
    /** 下层倒计时视图 */
    viewCountDown = [[UIView alloc] initWithFrame:CGRectMake(0, viewUpTitle.bottom, CGRectGetWidth(DDSCreenBounds), KViewFrame_H - viewUpTitle.bottom)];
    viewCountDown.backgroundColor = [UIColor clearColor];
    [self addSubview:viewCountDown];
    
    /** 正在等待快递员抢单 */
    lblPrompt = [[UILabel alloc] init];
    lblPrompt.frame = CGRectMake(viewCountDown.width/2-80, 40, 160, 12);
    lblPrompt.text = @"正在等待快递员抢单";
    lblPrompt.font = kTimeFont;
    lblPrompt.textAlignment = NSTextAlignmentCenter;
    lblPrompt.textColor = [UIColor whiteColor];
    [viewCountDown addSubview:lblPrompt];

    
    
    for (int i = 0; i < 9; i ++) {
        UILabel *countDownLabel = [[UILabel alloc] init];
        countDownLabel.text = @"";
        countDownLabel.textAlignment = NSTextAlignmentLeft;
        countDownLabel.font = [UIFont systemFontOfSize:24.0f];
        countDownLabel.textColor = [UIColor whiteColor];
        [viewCountDown addSubview:countDownLabel];
        switch (i) {
            case 0:
                lblMinTen = countDownLabel;
                lblMinTen.frame = CGRectMake(lblPrompt.left + 27, 8, 15, 24);
                break;
            case 1:
                lblMin = countDownLabel;
                lblMin.frame = CGRectMake(lblMinTen.right, 8, 15, 24);
                break;
            case 2:
                lblColon = countDownLabel;
                lblColon.text = @"：";
                lblColon.frame = CGRectMake(lblMin.right-2, 9, 10, 24);
                break;
            case 3:
                lblSTen = countDownLabel;
                lblSTen.frame = CGRectMake(lblColon.right, 8, 15, 24);
                break;
            case 4:
                lblS = countDownLabel;
                lblS.frame = CGRectMake(lblSTen.right, 8, 15, 24);
                break;
            case 5:
                lblOneDash = countDownLabel;
                lblOneDash.text = @"’";
                lblOneDash.frame = CGRectMake(lblS.right, 8, 10, 24);
                break;
            case 6:
                lblMsHundred = countDownLabel;
                lblMsHundred.frame = CGRectMake(lblOneDash.right-1, 8, 15, 24);
                break;
            case 7:
                lblMsTen = countDownLabel;
                lblMsTen.frame = CGRectMake(lblMsHundred.right, 8, 15, 24);
                break;
            case 8:
                lblTwoDash = countDownLabel;
                lblTwoDash.text = @"’’";
                lblTwoDash.frame = CGRectMake(lblMsTen.right, 8, 18, 24);
                break;
            default:
                break;
        }
    }

    /** 进度条 */
    slideView = [[UISlider alloc] init];
    slideView.frame = CGRectMake(15, 72, viewCountDown.width-30, 9);
    slideView.maximumValue = TOTAL_COUNTDOWN_TIME;//秒 总计时
    slideView.minimumValue = 0;
    slideView.value = 0;
    slideView.minimumTrackTintColor = DDRGBAColor(5, 176, 106, 1);
    slideView.maximumTrackTintColor = DDRGBAColor(163, 255, 229, 1);
    [slideView setUserInteractionEnabled:NO];
    [slideView setThumbImage:[UIImage imageNamed:@"run_5"] forState:UIControlStateNormal];
    [viewCountDown addSubview:slideView];
    
    self.rightBoxImageView = [[UIImageView alloc]init];
    self.rightBoxImageView.x = viewCountDown.width - 58;
    self.rightBoxImageView.y = viewCountDown.height - 49;
    self.rightBoxImageView.width = 44;
    self.rightBoxImageView.height = 44;
    self.rightBoxImageView.image = [UIImage imageNamed:@"box"];
    [viewCountDown addSubview:self.rightBoxImageView];
    
    imageIconRun = [[UIImageView alloc] init];
    [imageIconRun setFrame:CGRectMake(viewCountDown.width - 58, viewCountDown.height - 49, 44, 44)];
    [imageIconRun setBackgroundColor:[UIColor clearColor]];
    [imageIconRun setImage:[UIImage imageNamed:@"run_5"]];
    [imageIconRun setHidden:true];
    [viewCountDown addSubview:imageIconRun];
}

/** 视图的显示方法 */
- (void)show
{
    self.hidden = NO;

    [self setOrigin:CGPointMake(0, -KViewFrame_H)];
    [UIView animateWithDuration:0.35f animations:^{
        [self setOrigin:CGPointMake(0, 0)];
    } completion:^(BOOL finished) {

    }];
}
/** 视图的删除方法 */
- (void)dismissAlert
{
    [UIView animateWithDuration:0.35f animations:^(void) {
        [self setOrigin:CGPointMake(0, -KViewFrame_H)];
    } completion:^(BOOL finished) {
        [self shutDownCountDownView];

        self.hidden = YES;
    }];
}

#pragma mark - 点击事件
/** 取消订单按钮 */
- (void)onClickWithCancel
{
    BOOL timeIsOver = self.timer == NULL ? YES : NO;
    [self popupCancelAlert:timeIsOver];
}

/** 刷新计时器 */
- (void)reloadCountDownView:(BOOL)clearPersistence
{
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
        self.timer = NULL;
    }
    
    NSUInteger count = clearPersistence ? 0 : [DDGlobalVariables sharedInstance].waitForCourierRushCountTime;
    self.countDown = count == 0 ? WAIT_COUNTDOWN_TIME : count;
    
    [self updateTimer];
}

/** 关闭计时器 */
- (void)shutDownCountDownView
{
    [DDGlobalVariables sharedInstance].waitForCourierRushCountTime = 0;
    if (self.timer != nil) {
        dispatch_source_cancel(self.timer);
        self.timer = NULL;
    }
    self.countDown = 0;
}

#pragma mark - delegate代理controller弹窗
/** 弹出取消订单按钮界面 */
- (void)popupCancelAlert:(BOOL)isTimeOver
{
    if ([self.delegate respondsToSelector:@selector(waitCourierRushOrderView:cancelWithTime:)])
    {
        [self.delegate waitCourierRushOrderView:self cancelWithTime:isTimeOver];
    }
}

#pragma mark - 倒计时

/**
 *  创建定时器
 */
- (void)updateTimer
{
    //如果有定时器   就先停止定时器
    if (self.timer != NULL) {
        dispatch_source_cancel(self.timer);
        self.timer = NULL;
    }
    //当倒计时结束, 就停止
    if (self.countDown <= 0) return;
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    //设置定时器的属性(定时器名,开始时间,间隔)
    dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC, 0.01 * NSEC_PER_SEC);
    //设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        //异步主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.countDown --;
            //刷新计时器执行的方法
            [self refreshCountDown:self.countDown];
            [DDGlobalVariables sharedInstance].waitForCourierRushCountTime = self.countDown;
            [imageIconRun setHidden:true];
            
            //当时间到
            if (0 >= --self.countDown) {
                //如果存在定时器,则删除定时器
                if (self.timer != NULL) {
                    //设置时间到
                    [self popupCancelAlert:true];
                    lblMinTen.text = @"0";
                    lblMin.text = @"0";
                    lblColon.text = @"：";
                    lblSTen.text = @"0";
                    lblS.text = @"0";
                    lblOneDash.text = @"’";
                    lblMsHundred.text = @"0";
                    lblMsTen.text = @"0";
                    lblTwoDash.text = @"’’";
                    
                    [slideView setValue:TOTAL_COUNTDOWN_TIME];
                    [imageIconRun setHidden:false];
                    //删除定时器
                    dispatch_source_cancel(self.timer);
                    self.timer = NULL;
                    [DDGlobalVariables sharedInstance].waitForCourierRushCountTime = 1;
                }
            }
        });
    });
    //启动定时器
    dispatch_resume(self.timer);
}

/**
 *  刷新倒计时
 *  @param countDown 倒计时
 */
- (void)refreshCountDown:(NSInteger)countDown
{
    countDown = countDown < 0 ? 0 : countDown;
    
    NSInteger minute    = countDown/6000;
    NSInteger second    = (countDown - minute*6000)/100;
    NSInteger mSecond   = countDown%100;
    
    NSInteger minTen    = minute    / 10;
    NSInteger min       = minute    % 10;
    NSInteger sTen      = second    / 10;
    NSInteger s         = second    % 10;
    NSInteger msHun     = mSecond   / 10;
    NSInteger msTen     = mSecond   % 10;
    
    self.minTenString      = [[NSNumber numberWithInteger:minTen] stringValue];
    self.minString          = [[NSNumber numberWithInteger:min] stringValue];
    self.sTenString         = [[NSNumber numberWithInteger:sTen] stringValue];
    self.sString           = [[NSNumber numberWithInteger:s] stringValue];
    self.msHundredString   = [[NSNumber numberWithInteger:msHun] stringValue];
    self.msTenString        = [[NSNumber numberWithInteger:msTen] stringValue];
    
    lblMinTen.text = self.minTenString;
    lblMin.text = self.minString;
    lblSTen.text = self.sTenString;
    lblS.text = self.sString;
    lblMsHundred.text = self.msHundredString;
    lblMsTen.text = self.msTenString;
    
    [slideView setValue:TOTAL_COUNTDOWN_TIME-countDown/100.0f animated:true];
    
    if (msHun == 0 || msHun == 5) {
        [slideView setThumbImage:[UIImage imageNamed:@"run_5"] forState:UIControlStateNormal];
    }else if (msHun == 1 || msHun == 6){
        [slideView setThumbImage:[UIImage imageNamed:@"run_4"] forState:UIControlStateNormal];
    }else if (msHun == 2 || msHun == 7){
        [slideView setThumbImage:[UIImage imageNamed:@"run_3"] forState:UIControlStateNormal];
    }else if (msHun == 3 || msHun == 8){
        [slideView setThumbImage:[UIImage imageNamed:@"run_2"] forState:UIControlStateNormal];
    }else if (msHun == 4 || msHun == 9){
        [slideView setThumbImage:[UIImage imageNamed:@"run_1"] forState:UIControlStateNormal];
    }
    
    
}


- (CGSize) sizeOfString : (NSString *) string withFont: (UIFont *) fnt
{
    CGSize size = [string sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    return size;
}
@end
