//
//  DDZbarViewController.m
//  DDExpressClient
//
//  Created by yangg on 16/3/12.
//  Copyright © 2016年 NS. All rights reserved.
//

#define KZbarCodeItem 7777

#import "DDZbarViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "DDTextAlertView.h"
#import "DDBackgroundRectangleView.h"

@interface DDZbarViewController () <AVCaptureMetadataOutputObjectsDelegate, DDTextAlertViewDelegate>
{
    //存储按钮对象
    NSMutableArray *buttons;
    //解析出来的字符串
    NSString *_stringValue;
    BOOL _is_Anmotion;
}
@property (nonatomic, strong) NSTimer *timer;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession          *session;
/** 可视化输出 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer*preview;
/** 创建输出流 */
@property (nonatomic, strong) AVCaptureMetadataOutput *output;

/** 输入消息窗 */
@property (nonatomic, strong) DDTextAlertView *textAlertView;
@property (nonatomic, strong) DDBackgroundRectangleView *viewRectangle;
@property (nonatomic, strong) UIImageView *imgZbar;
@property (nonatomic, strong) UIImageView *lineView;
@end

@implementation DDZbarViewController
static SystemSoundID shake_sound_male_id = 0;

- (instancetype)initWithDelegate:(id<DDZbarViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeAll];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:true];
    
    /** 创建矩形阴影视图 */
    [self createForRectangleView];
    /** 设置导航栏 */
    [self createForNavigationView];
    [self createForBottomView];
    
    [self setupCamera];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adaptNavigationBarHidden:true];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self adaptNavigationBarHidden:false];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _is_Anmotion = false;
    [self.view.layer insertSublayer:_preview atIndex:0];
    //开始捕获
    [_session startRunning];
    [self performSelector:@selector(toTimer) withObject:nil afterDelay:0.25f];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    
    _is_Anmotion = true;
    [_timer invalidate], _timer = nil;
    [UIView animateWithDuration:0.35f animations:^(void) {
        [self.viewRectangle setAlpha:0];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 视图初始化
/** 设置导航栏 */
- (void)createForNavigationView
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0 , KNavHeight-44.0f, 50.0f, 44.0f)];
    [backButton setBackgroundColor:[UIColor clearColor]];
    [backButton setShowsTouchWhenHighlighted:NO];
    [backButton addTarget:self action:@selector(onClickWithBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIImageView *imgBack = [[UIImageView alloc] init];
    [imgBack setSize:CGSizeMake(20.0f, 20.0f)];
    [imgBack setCenter:CGPointMake(backButton.centerx, backButton.centery)];
    [imgBack setBackgroundColor:[UIColor clearColor]];
    [imgBack setImage:[UIImage imageNamed:DDBackWhiteBarIcon]];
    [backButton addSubview:imgBack];
}

/** 创建矩形阴影视图 */
- (void)createForRectangleView
{
    self.viewRectangle = [[DDBackgroundRectangleView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.viewRectangle setBackgroundColor:[UIColor clearColor]];
    [self.viewRectangle setAlphaRectangle:0.7];
    [self.view addSubview:self.viewRectangle];
    
    self.imgZbar = [[UIImageView alloc] init];
    [self.imgZbar setFrame:CGRectMake(20.0f, 100.0f, self.view.width - 40.0f, 175.0f)];
    [self.imgZbar setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.imgZbar];
    [self.viewRectangle setCurrentFrame:self.imgZbar.frame];
    
    UIImageView *imgLeftTop = [[UIImageView alloc] init];
    [imgLeftTop setFrame:CGRectMake(0, 0, 20.0f, 20.0f)];
    [imgLeftTop setImage:[UIImage imageNamed:DDZbar_Frame]];
    [self.imgZbar addSubview:imgLeftTop];
    
    UIImageView *imgRightTop = [[UIImageView alloc] init];
    [imgRightTop setFrame:CGRectMake(self.imgZbar.width - 20.0f, 0, 20.0f, 20.0f)];
    [imgRightTop setImage:[UIImage imageNamed:DDZbar_Frame]];
    [imgRightTop setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [self.imgZbar addSubview:imgRightTop];
    
    UIImageView *imgLeftBottom = [[UIImageView alloc] init];
    [imgLeftBottom setFrame:CGRectMake(0, self.imgZbar.height - 20.0f, 20.0f, 20.0f)];
    [imgLeftBottom setImage:[UIImage imageNamed:DDZbar_Frame]];
    [imgLeftBottom setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    [self.imgZbar addSubview:imgLeftBottom];
    
    UIImageView *imgRightBottom = [[UIImageView alloc] init];
    [imgRightBottom setFrame:CGRectMake(imgRightTop.left, imgLeftBottom.top, 20.0f, 20.0f)];
    [imgRightBottom setImage:[UIImage imageNamed:DDZbar_Frame]];
    [imgRightBottom setTransform:CGAffineTransformMakeRotation(M_PI)];
    [self.imgZbar addSubview:imgRightBottom];
    
    self.lineView = [[UIImageView alloc] init];
    [self.lineView setSize:CGSizeMake(216, 3.0f)];
    [self.lineView setCenter:CGPointMake(_imgZbar.centerx, _imgZbar.centery)];
    [self.lineView setImage:[UIImage imageNamed:DDZbar_LineRow]];
    [self.lineView setAlpha:1.0f];
    [self.imgZbar addSubview:self.lineView];
    
    UILabel *lblText = [[UILabel alloc] init];
    [lblText setFrame:CGRectMake(kMargin, self.imgZbar.bottom + 15.0f, self.view.width - kMargin*2.0f, 20.0f)];
    [lblText setBackgroundColor:[UIColor clearColor]];
    [lblText setTextAlignment:NSTextAlignmentCenter];
    [lblText setTextColor:[UIColor whiteColor]];
    [lblText setFont:kTitleFont];
    [lblText setText:@"请将绿线对准快递单号上的条形码"];
    [self.view addSubview:lblText];
}

/** 创建底部按钮 */
- (void)createForBottomView
{
    UIView *viewBottom = [[UIView alloc] init];
    [viewBottom setFrame:CGRectMake(0, self.view.height - KNavHeight, self.view.width, KNavHeight)];
    [viewBottom setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewBottom];
    
    UIImageView *imgBG = [[UIImageView alloc] init];
    [imgBG setFrame:viewBottom.bounds];
    [imgBG setBackgroundColor:[UIColor blackColor]];
    [imgBG setAlpha:0.3];
    [viewBottom addSubview:imgBG];
    
    NSString *item_str = [NSString stringWithFormat:@"手动输入"];
    CGSize size_str = [item_str sizeWithAttributes:@{NSFontAttributeName:kTitleFont}];
    
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setFrame:CGRectMake(0, 0, viewBottom.width, viewBottom.height)];
    [itemButton setBackgroundColor:[UIColor clearColor]];
    [itemButton setSelected:true];
    [itemButton.titleLabel setFont:kTitleFont];
    [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(onClickWithEdit:) forControlEvents:UIControlEventTouchUpInside];
    [viewBottom addSubview:itemButton];
    
    [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [itemButton setImageEdgeInsets:UIEdgeInsetsMake(5.0f, (itemButton.width - 36)/2.0f, 0, 0)];
    [itemButton setTitleEdgeInsets:UIEdgeInsetsMake(43.0f, (itemButton.width - floorf(size_str.width))/2.0f - 34.0f, 0, 0)];
    [itemButton setImage:[UIImage imageNamed:DDZbar_Editing] forState:UIControlStateNormal];
    [itemButton setTitle:item_str forState:UIControlStateNormal];
    
}

/** 创建输出流 , 设置代理 在主线程里刷新 , 扫描范围 rectOfInterest的原点是右上角，且宽高互换，想象着手机逆时针放倒的坐标*/
- (AVCaptureMetadataOutput *)output
{
    if (!_output) {
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_output setRectOfInterest:CGRectMake(self.imgZbar.y/self.view.height,
                                              self.imgZbar.x/self.view.width,
                                              self.imgZbar.height/self.view.height,
                                              self.imgZbar.width/self.view.width)];
    }
    return _output;
}

- (AVCaptureSession *)session
{
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _session;
}

- (void)setupCamera
{
    /** 获取摄像设备*/
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 因为模拟器是没有摄像头的，因此在此最好做一个判断
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"没有摄像头-%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
    }
    /**  设置扫码支持的编码格式(如下设置条形码和二维码兼容) */
    self.output.metadataObjectTypes =  @[AVMetadataObjectTypeQRCode,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeUPCECode,
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypePDF417Code,
                                         AVMetadataObjectTypeAztecCode,
                                         AVMetadataObjectTypeCode93Code,
                                         AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeCode39Mod43Code];
    
    _preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    [_preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_preview setFrame:self.view.bounds];
    
    [self playVoice];
}

/** 注册声音 */
- (void)playVoice
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"qrcode_completed_new" ofType:@"wav"];
    if (path && ![path isEqualToString:@""]) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
    }
}

- (void)toTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(didTimerInAnimation) userInfo:nil repeats:YES];
    }
}

/** 扫描动画 */
- (void)didTimerInAnimation
{
    [self.lineView setAlpha:1.0f];
    [UIView animateWithDuration:2.0 animations:^{
        [self.lineView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0 animations:^{
            [self.lineView setAlpha:1.0f];
        }];
    }];
}

- (void)onClickWithBack
{
    [self.navigationController popViewControllerAnimated:true];
}

/** 手动输入、完成按钮事件 */
- (void)onClickWithEdit:(UIButton *)sender
{
    [self.textAlertView setKeyboardTypeNumber:0];
    [self.textAlertView setPlaceholder:@""];
    [self.textAlertView setContentCount:24.0f];
    [self.textAlertView show];
}


- (DDTextAlertView *)textAlertView
{
    if (!_textAlertView) {
        _textAlertView = [[DDTextAlertView alloc] initWithTitle:@"手动输入运单号" delegate:self cancelTitle:@"取消" nextTitle:@"确定"];
        [_textAlertView setContentCount:24];
    }
    return _textAlertView;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    _stringValue = [[NSString alloc] init];
    
    [_session stopRunning];
    [_preview removeFromSuperlayer];
    
    if ([metadataObjects count] > 0)
    {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        _stringValue = obj.stringValue;
    }
    
    //播放声音
    AudioServicesPlaySystemSound(shake_sound_male_id);
    
    if ([self.delegate respondsToSelector:@selector(zbarViewWithMachineReadableCodeObject:)]) {
        [self.delegate zbarViewWithMachineReadableCodeObject:_stringValue];
    }
    
    [self onClickWithBack];
}

#pragma mark - DDTextAlertViewDelegate
- (void)textAlertView:(DDTextAlertView *)textView withText:(NSString *)text withFlag:(BOOL)flag
{
    if (flag) {
        if ([self.delegate respondsToSelector:@selector(zbarViewWithMachineReadableCodeObject:)]) {
            [self.delegate zbarViewWithMachineReadableCodeObject:text];
        }
        
        [self onClickWithBack];
    }
}


@end
