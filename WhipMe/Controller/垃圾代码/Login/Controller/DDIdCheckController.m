//
//  DDIdCheckController.m
//  DDExpressClient
//
//  Created by Jadyn on 16/2/25.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDIdCheckController.h"
#import "JJRegexKit.h"
#import "MBProgressHUD+MJ.h"
#import "DDUploadIdCardView.h"
#import "CustomStringUtils.h"
#import "DDGlobalVariables.h"
#import "DDSelfInfomation.h"

#import "DDPersonalDetailController.h"

#import "DDLocalUserInfoUtils.h"

#define NAMECHECK @"[\\u4E00-\\u9FA5]{2,5}(?:·[\\u4E00-\\u9FA5]{2,5})*"

#define IDCARDCHECK_18 @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$"
#define IDCARDCHECK_15 @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$"

#define KIdCheckItem 7777

#define NAME_CHECK_PLACEHOLDER @"请输入姓名"
#define ID_CHECK_PLACEHOLDER @"请输入身份证号"

#define ID_CARD_TEXT  @"身份证正面照"
#define PORTRAIT_TEXT @"手持身份证照"

#define POINT_CONTENT_TEXT @"请用手机横向拍摄以保证图片正常显示"
#define AFFIRM_TITLE_TEXT @"请确认以上信息真实无误"

/**
 actionsheet的选项
 */
typedef enum {
    DDChooseCamera = 0,             /**相机*/
    DDChoosePhotoLibrary = 1,       /**在相册中选照片*/
    DDChooseCancel                  /**取消*/
} DDChooseImageStyle;



@interface DDIdCheckController () <
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
DDUploadIdCardViewDelegate,
DDInterfaceDelegate>
{
    /** 用来判断肖像照片、 身份证正面照片*/
    BOOL _isImagePicekerPhoto;
}
@property (strong, nonatomic) UIScrollView *detailScroll;                                                               /** 本视图的整体滚动视图 */
@property (strong, nonatomic) UITextField *nameTextField;                                                               /** 姓名输入框 */
@property (strong, nonatomic) UITextField *idCardTextField;                                                             /** 身份证输入框 */

@property (strong, nonatomic) UIButton *btnAssure;                                                                      /** 安全保密承诺 */
@property (strong, nonatomic) UIButton *btnSubmit;                                                                      /** 提交按钮 */

@property (strong, nonatomic) UIButton *btnIdCard;                                                                      /** 身份证 正面照片 */
@property (strong, nonatomic) UIButton *btnPortrait;                                                                    /** 身份证 正面肖像照片 */
@property (strong, nonatomic) NSString *fullPathToIdCard;                                                               /** 身份证 正面照片 url */
@property (strong, nonatomic) NSString *fullPathToPortrait;                                                             /** 身份证 正面肖像照片 url */

@property (strong, nonatomic) UIImageView *imageAssure;                                                                 /** 喇叭视图 */

@property (strong, nonatomic) NSString *nameCheckText;                                                                  /** 姓名正则表达式验证码 */
@property (strong, nonatomic) NSString *idCardCheckText15;                                                              /** 15位身份证正则表达式验证信息 */
@property (strong, nonatomic) NSString *idCardCheckText18;                                                              /** 18位正则表达式验证信息 */

/** 网络请求 */
@property (strong, nonatomic) DDInterface *interfaceIdCard;
@property (strong, nonatomic) DDInterface *interfaceUploadData;

@end

@implementation DDIdCheckController
@synthesize detailScroll;
@synthesize btnAssure;

@synthesize btnSubmit;
@synthesize btnPortrait;
@synthesize btnIdCard;
@synthesize imageAssure;


#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"身份认证" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //初始化界面的控件
    [self ddCreateForViewControl];
    
    self.navigationController.delegate = self;
    
}

#pragma mark - 初始化界面的控件
/** 初始化界面的控件 */
- (void)ddCreateForViewControl
{
    //创建滚动视图，作为界面的所有内容父视图
    detailScroll = [[UIScrollView alloc] init];
    [detailScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
    [detailScroll setBackgroundColor:[UIColor whiteColor]];
    [detailScroll setShowsHorizontalScrollIndicator:false];
    [detailScroll setShowsVerticalScrollIndicator:false];
    [self.view addSubview:detailScroll];
    
    //安全保密承诺
    btnAssure = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAssure setFrame:CGRectMake(0, 0, detailScroll.width, 20.0f)];
    [btnAssure setBackgroundColor:DDAssure_Color];
    [btnAssure.titleLabel setNumberOfLines:0];
    [btnAssure setAdjustsImageWhenHighlighted:false];
    [btnAssure setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [btnAssure setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btnAssure setTitleEdgeInsets:UIEdgeInsetsMake(12.0f, 28.0f, 12.0f, 12.0f)];
    [detailScroll addSubview:btnAssure];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    [paragraphStyle setLineSpacing:5.0];
    
    NSDictionary *attribute = @{NSFontAttributeName:kTimeFont,
                                NSForegroundColorAttributeName:TIME_COLOR,
                                NSParagraphStyleAttributeName:paragraphStyle};
    
    NSString *str_assure = [NSString stringWithFormat:@"为保障快递安全，根据国家邮政局通知，手机快递需实名认证，您提供的注册信息仅供审核使用，我们将为您的信息严格保密"];
    
    CGSize size_assure = [str_assure boundingRectWithSize:CGSizeMake(btnAssure.width - 40.0f, MAXFLOAT)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attribute
                                                        context:nil].size;
    [btnAssure setSize:CGSizeMake(detailScroll.width, floorf(size_assure.height)+25.0f)];
    
    NSMutableAttributedString *att_str_assure = [[NSMutableAttributedString alloc] initWithString:str_assure attributes:attribute];
    [btnAssure setAttributedTitle:att_str_assure forState:UIControlStateNormal];
    
    imageAssure = [[UIImageView alloc] init];
    [imageAssure setSize:CGSizeMake(15.0f, 15.0f)];
    [imageAssure setCenter:CGPointMake(14.0f, imageAssure.centery+12.0f)];
    [imageAssure setBackgroundColor:[UIColor clearColor]];
    [imageAssure setImage:[UIImage imageNamed:DDAssureIcon]];
    [btnAssure addSubview:imageAssure];
    
    NSArray *arrayTitles = [NSArray arrayWithObjects:NAME_CHECK_PLACEHOLDER, ID_CHECK_PLACEHOLDER, nil];
    for (int i=0; i<arrayTitles.count; i++)
    {
        //初始化输入框
        UITextField *textItem = [[UITextField alloc] init];
        [textItem setFrame:CGRectMake( 30.0f, btnAssure.bottom + 25.0f + i*44.0f, detailScroll.width - 60.0f, 44.0f)];
        [textItem setBackgroundColor:[UIColor clearColor]];
        [textItem setTextAlignment:NSTextAlignmentLeft];
        [textItem setTextColor:TITLE_COLOR];
        [textItem setFont:kTitleFont];
        [textItem setDelegate:self];
        [textItem setTag:KIdCheckItem + i];
        [textItem setClearButtonMode:UITextFieldViewModeWhileEditing];
        [textItem setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [textItem setPlaceholder:arrayTitles[i]];
        [textItem setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        [detailScroll addSubview:textItem];
        
        //分界线
        UIView *lineView = [[UIView alloc] init];
        [lineView setFrame:CGRectMake(textItem.left/2.0f, textItem.bottom - 0.5f, detailScroll.width - textItem.left, 0.5f)];
        [lineView setBackgroundColor:BORDER_COLOR];
        [detailScroll addSubview:lineView];
        
        if (i == 0) {
            //1.姓名textfield
            [textItem setKeyboardType:UIKeyboardTypeDefault];
            [textItem setReturnKeyType:UIReturnKeyNext];
            self.nameTextField = textItem;
            [self.nameTextField addTarget:self action:@selector(TextNameFieldChange:) forControlEvents:UIControlEventEditingChanged];
        } else {
            //2.身份证textfield
            [textItem setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [textItem setReturnKeyType:UIReturnKeyDone];
            self.idCardTextField = textItem;
        }
    }
    
    for (int i=0; i<2; i++)
    {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setSize:[self sizeItemWH]];
        [itemButton setOrigin:CGPointMake(15.0f + i*(itemButton.width+20.0f), self.idCardTextField.bottom + 25.0f)];
        [itemButton setBackgroundColor:[UIColor clearColor]];
        [itemButton setTag:KIdCheckItem + 100 + i];
        [itemButton setAdjustsImageWhenHighlighted:false];
        [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [itemButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [itemButton addTarget:self action:@selector(onClickWithPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [detailScroll addSubview:itemButton];
        [self drawDottedLine:itemButton];
        
        if (i == 0) {
            btnIdCard = itemButton;
        } else {
            btnPortrait = itemButton;
        }
        
        UIImageView *itemIcon = [[UIImageView alloc] init];
        [itemIcon setFrame:CGRectMake(itemButton.width/2-22, 15, 44, 44)];
        [itemIcon setBackgroundColor:[UIColor clearColor]];
        [itemIcon setContentMode:UIViewContentModeScaleToFill];
        [itemIcon setImage:[UIImage imageNamed:i==0 ? DDPersonalIdCard : DDPersonalPortrait]];
        [itemIcon setUserInteractionEnabled:false];
        [itemButton addSubview:itemIcon];
        
        UILabel *itemLable = [[UILabel alloc] init];
        [itemLable setFrame:CGRectMake(0, itemIcon.bottom + 5, itemButton.width, 15.0f)];
        [itemLable setBackgroundColor:[UIColor clearColor]];
        [itemLable setTextColor:KPlaceholderColor];
        [itemLable setFont:kTitleFont];
        [itemLable setTextAlignment:NSTextAlignmentCenter];
        [itemLable setText:i==0 ? ID_CARD_TEXT : PORTRAIT_TEXT];
        [itemLable setUserInteractionEnabled:false];
        [itemButton addSubview:itemLable];
    }
    
    UILabel *lblMessage = [[UILabel alloc] init];
    [lblMessage setFrame:CGRectMake(15.0f, btnPortrait.bottom + kMargin, detailScroll.width - 30.0f, 14.0f)];
    [lblMessage setBackgroundColor:[UIColor clearColor]];
    [lblMessage setTextColor:TIME_COLOR];
    [lblMessage setFont:kTimeFont];
    [lblMessage setTextAlignment:NSTextAlignmentLeft];
    [lblMessage setText:POINT_CONTENT_TEXT];
    [lblMessage setUserInteractionEnabled:false];
    [detailScroll addSubview:lblMessage];
    
    /** 提交按钮 */
    btnSubmit = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSubmit setFrame:CGRectMake( 15.0f, lblMessage.bottom + kMargin*3.0f, detailScroll.width - 30.0f, 40.0f)];
    [btnSubmit setBackgroundColor:KPlaceholderColor];
    [btnSubmit.layer setCornerRadius:btnSubmit.height/2.0f];
    [btnSubmit.layer setMasksToBounds:true];
    [btnSubmit setAdjustsImageWhenHighlighted:false];
    [btnSubmit setUserInteractionEnabled:false];
    [btnSubmit.titleLabel setFont:kButtonFont];
    [btnSubmit setTitle:@"提  交" forState:UIControlStateNormal];
    [btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(presentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [detailScroll addSubview:btnSubmit];
    [detailScroll setContentSize:CGSizeMake(detailScroll.width, btnSubmit.bottom+kMargin*3.0f)];
}



#pragma mark - Action Click Method
/**  提交按钮点击事件 */
- (void)presentBtnClick
{
    if ([self checkOutTextFieldByZZ] && [self.fullPathToPortrait length] > 0 && [self.fullPathToIdCard length] > 0) {
        //绑定身份证
        [self idCardWithRequest];
    }
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  添加身份证图片按钮
 */
- (void)onClickWithPhoto:(UIButton *)sender
{
    //如果出现写完textfield直接点击按钮的情况
    [self.idCardTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
    NSString *image_path = @"";
    NSString *title_image = @"";
    if (sender == btnIdCard) {
        _isImagePicekerPhoto = true;
        image_path = DDDefaultIdCard;
        title_image = [NSString stringWithFormat:@"请上传%@",ID_CARD_TEXT];
    } else {
        _isImagePicekerPhoto = false;
        image_path = DDDefaultIdPortrait;
        title_image = [NSString stringWithFormat:@"请上传%@",PORTRAIT_TEXT];
    }
    
    //初始化弹窗栏
    DDUploadIdCardView *alertView = [[DDUploadIdCardView alloc] initWithImagePath:image_path withTitle:title_image delegate:self withNext:@"立即拍摄" withOther:@"本地上传"];
    [alertView show];
    
}
/** 姓名输入框的编辑检测 */
- (void)TextNameFieldChange:(UITextField *)textField
{
    NSString *str_text = [NSString stringWithFormat:@"%@",textField.text];
    
    //1. 输入的长度到了(4-10位字符和2-5位中文), 就停止编写
    if ([self lenghtWithString:str_text] > 10) {
        for (NSInteger i=1; i<[str_text length]; i++) {
            NSString *item_str = [str_text substringToIndex:i];
            if ([self lenghtWithString:item_str] > 10) {
                break;
            }
            [textField setText:item_str];
        }
    }
}

#pragma mark - Delegate Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.nameTextField == textField) {
        [self.idCardTextField becomeFirstResponder];
    } else {
        [self.idCardTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self isPresentButtonCanUserInteractionEnabled];
    return true;
}

/**
 *  监听字符的输入
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *str_text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (self.nameTextField == textField)
    {
        if ([self lenghtWithString:str_text] > 10)
        {
            for (NSInteger i=1; i<[str_text length]; i++) {
                NSString *item_str = [str_text substringToIndex:i];
                if ([self lenghtWithString:item_str] > 10) {
                    break;
                }
                [textField setText:item_str];
            }
            return false;
        }
        [self isPresentButtonCanUserInteractionEnabled];
    }
    else if (self.idCardTextField == textField)
    {
        str_text = [str_text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //排除数字、大小写 “xX” 意外的字符
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789xX\b"];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return false;
        }
        //转化大写
        str_text = [str_text capitalizedString];
        
        //超出字符限制长度 截取
        if (str_text.length > 18) {
            [textField resignFirstResponder];
            str_text = [str_text substringToIndex:18];
        } else if (str_text.length < 18) {
            //排除最后一位是 非 “X”
            NSRange range_X = [str_text rangeOfString:@"X"];
            if (range_X.location != NSNotFound) {
                return false;
            }
        }
        [textField setText:[str_text stringByTrimmingCharactersInSet:[characterSet invertedSet]]];
        
        [self isPresentButtonCanUserInteractionEnabled];
        return false;
    }
    return YES;
}

#pragma mark - DDUploadIdCardViewDelegate
/** 身份认真上传图片身份证照片，和手持身份证消息弹窗 */
- (void)uploadIdCardView:(DDUploadIdCardView *)cardView withIndex:(NSInteger)indexButton
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = false;
    imagePicker.delegate = self;
    
    if (indexButton == 0) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } else {
            [self displayForErrorMsg:@"该设备不支持照相机!"];
            return;
        }
    } else if (indexButton == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
        } else {
            [self displayForErrorMsg:@"该设备不支持相片库!"];
            return;
        }
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
/**
 *  当从UIImagePickerController出来(结束拍照或选照片)
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_isImagePicekerPhoto == true) {
        for (UIView *objView in btnIdCard.subviews) {
            [objView setHidden:true];
            if ([objView isKindOfClass:[UIImageView class]]) {
                UIImageView *itemImage = (UIImageView *)objView;
                [itemImage setHidden:false];
                [itemImage setFrame:btnIdCard.bounds];
                [itemImage setImage:editedImage];
            }
        }
    } else {
        for (UIView *objView in btnPortrait.subviews) {
            [objView setHidden:true];
            if ([objView isKindOfClass:[UIImageView class]]) {
                UIImageView *itemImage = (UIImageView *)objView;
                [itemImage setHidden:false];
                [itemImage setFrame:btnPortrait.bounds];
                [itemImage setImage:editedImage];
            }
        }
    }
    
    
    UIImage *newImage = [self scaleImage:editedImage];
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

#pragma mark - Private Method
/** 计算每一个方块的大小，按照一定的比例 */
- (CGSize)sizeItemWH
{
    CGFloat imageW = (detailScroll.width - 15*2.0f - 20.0f)/2.0f;
    CGFloat imageR = 142.0f / imageW;
    CGFloat imageH = 84.0 / imageR;
    return CGSizeMake(imageW, imageH);
}
/**
 *  返回一个bool值, 判断是否符合条件, 提交按钮变的可以点击
 *
 *  @param nameText 姓名输入框
 *  @param idText   身份证输入框
 *  @param image    图片
 */
- (void)isPresentButtonCanUserInteractionEnabled
{
    self.nameCheckText = nil;
    [JJRegexKit stringsSeparatedByText:self.nameTextField.text pattern:NAMECHECK TextPart:^(JJTextPart *textPart) {
        self.nameCheckText = textPart.text;
    }];
    NSString *idText   = self.idCardTextField.text;
    
    if ([idText length] != 18 ||
        self.nameCheckText == nil ||
        [self.fullPathToIdCard length] == 0 ||
        [self.fullPathToPortrait length] == 0) {
        
        [btnSubmit setUserInteractionEnabled:false];
        [btnSubmit setBackgroundColor:KPlaceholderColor];
    } else {
        [btnSubmit setUserInteractionEnabled:true];
        [btnSubmit setBackgroundColor:DDGreen_Color];
    }
}


/**
 *  正则表达式验证
 *
 *  @return 是否验证成功
 */
- (BOOL)checkOutTextFieldByZZ
{
    self.idCardCheckText15 = nil;
    self.idCardCheckText18 = nil;
    self.nameCheckText = nil;
    
    //1.如果姓名格式有误
    [JJRegexKit stringsSeparatedByText:self.nameTextField.text pattern:NAMECHECK TextPart:^(JJTextPart *textPart) {
        self.nameCheckText = textPart.text;
    }];
    //2.如果15位身份证号格式有误
    [JJRegexKit stringsSeparatedByText:self.idCardTextField.text pattern:IDCARDCHECK_15 TextPart:^(JJTextPart *textPart) {
        self.idCardCheckText15 = textPart.text;
    }];
    
    //3.如果18位身份证号格式有误
    [JJRegexKit stringsSeparatedByText:self.idCardTextField.text pattern:IDCARDCHECK_18 TextPart:^(JJTextPart *textPart) {
        self.idCardCheckText18 = textPart.text;
    }];
    
    
    if ([self.idCardTextField.text length] == 15) {
        //姓名格式优先级
        if (self.nameCheckText!= nil) {
            [MBProgressHUD showError:@"姓名格式不符合规则, 请输入正确的姓名"];
            return NO;
        } else if(self.idCardCheckText15 != nil) {
            [MBProgressHUD showError:@"身份证号码不符合规则, 请输入正确的身份证号码"];
            return NO;
        } else {
            return YES;
        }
    } else if ([self.idCardTextField.text length] == 18) {
        //姓名格式优先级
        if (self.nameCheckText!= nil) {
            [MBProgressHUD showError:@"姓名格式不符合规则, 请输入正确的姓名"];
            return NO;
        } else if(self.idCardCheckText18 != nil) {
            [MBProgressHUD showError:@"身份证号码不符合规则, 请输入正确的身份证号码"];
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

/**
 *  画虚线
 *
 *  @param view 传入需要画的视图
 */
- (void)drawDottedLine:(UIView *)view
{
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线颜色
    border.strokeColor = KPlaceholderColor.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, view.width, view.height)].CGPath;
    border.frame = view.bounds;
    border.lineWidth = 0.5f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [view.layer addSublayer:border];
}

#pragma mark - netWork Request
/** 绑定身份证 网络请求 */
- (void)idCardWithRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:[NSString stringWithFormat:@"%@",self.nameTextField.text.length > 0 ? self.nameTextField.text : @""] forKey:@"name"];
    [param setValue:[NSString stringWithFormat:@"%@",self.idCardTextField.text.length > 0 ? self.idCardTextField.text : @""] forKey:@"card"];
    
    /** 身份证 正面照片 的 url */
    [param setValue:[NSString stringWithFormat:@"%@",self.fullPathToIdCard.length > 0 ? self.fullPathToIdCard : @""] forKey:@"cardImg"];
    /** 身份证 正面肖像照片 的 url */
    [param setValue:[NSString stringWithFormat:@"%@",self.fullPathToPortrait.length > 0 ? self.fullPathToPortrait : @""] forKey:@"perImg"];
    
    if (!self.interfaceIdCard) {
        self.interfaceIdCard = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceIdCard interfaceWithType:INTERFACE_TYPE_CERTIFY_IDENTITY param:param];
}

#pragma mark - DDInterfaceDelegate
/**<  得到网络反回结果  */
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceIdCard) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [DDLocalUserInfoUtils updateUserAuth:@"1"];
            
            DDPostNotification(DDRefreshCourierUserView);
            //返回个人中心详情 并修改身法认证状态
            for (UIViewController *control in self.navigationController.viewControllers) {
                if ([control isKindOfClass:[DDPersonalDetailController class]]) {
                    [self.navigationController popToViewController:control animated:true];
                    break;
                }
            }
        }
    } else if (interface == self.interfaceUploadData) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            for (NSString *dataUrl in result[@"images"]) {
                if ([CustomStringUtils isBlankString:dataUrl]) {
                    continue;
                }
                if (_isImagePicekerPhoto == true) {
                    self.fullPathToIdCard = dataUrl;
                } else {
                    self.fullPathToPortrait = dataUrl;
                }
                [self isPresentButtonCanUserInteractionEnabled];
                break;
            }
        }
    }
}




@end
