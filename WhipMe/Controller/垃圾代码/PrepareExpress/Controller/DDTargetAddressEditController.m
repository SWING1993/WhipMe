//
//  DDTargetAddressEditController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDTargetAddressEditController.h"
#import "DDTargetAddressListController.h"
#import "DDTargetAddressEditView.h"
#import "DDAddressDetail.h"
#import "Constant.h"
#import "CoreAddressBookVC.h"
#import "DDInterface.h"
#import "DDCenterCoordinate.h"
//#import "DDChooseAreaView.h"
#import "DDSelectPickerView.h"
#import "MBProgressHUD.h"
#import "DDProvinceList.h"
#import "DDCityList.h"
#import "DDAreaList.h"
#import "YYModel.h"
#import "CustomStringUtils.h"

NSString * const SEditAddressTitle = @"收件人信息编辑";
NSString * const SAddAddressTitle = @"新增收件地址";
NSString * const SMessage = @"地址,名字和联系方式都不能为空，请重新输入";

typedef NS_ENUM(NSInteger,DDTargetAddressEditPickerComponent) {
    DDTargetAddressEditPickerProvince = 0,
    DDTargetAddressEditPickerCity = 1,
    DDTargetAddressEditPickerDistrict = 2,
};


@interface DDTargetAddressEditController ()<
CoreAddressBookVCDelegate,
DDInterfaceDelegate,
HPGrowingTextViewDelegate,
DDSelectPickerViewDelegate,
UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *_tempView;
    BOOL _isshowed;
}
@property (nonatomic, strong) UIScrollView *detailScroll;
@property (nonatomic, strong) DDTargetAddressEditView *mainView;

@property (nonatomic, strong) DDInterface * interfaceEdit;

@property (nonatomic, strong) UIButton * animationButton;

@property (nonatomic, strong) DDSelectPickerView *selectPickerView;


/**<  省模型数组  */
@property (nonatomic,strong) NSMutableArray *provinceModelArr;
/**<  市模型数组  */
@property (nonatomic,strong) NSMutableArray *cityModelArr;
/**<  区模型数组  */
@property (nonatomic,strong) NSMutableArray *areaModelArr;
/**<  选择的省  */
@property (nonatomic,assign) NSInteger selectedPvIndex;
/**<  选择的市  */
@property (nonatomic,assign) NSInteger selectedctIndex;
/**<  选择的区  */
@property (nonatomic,assign) NSInteger selectedarIndex;

@property (nonatomic, strong) UIButton *targetAddressListButton;

@end

@implementation DDTargetAddressEditController

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *titleString = self.isEdit ? @"编辑收件地址" : @"添加收件人地址";
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:titleString segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self adaptFirstRightItemWithTitle:@"保存"];
    
    [self.view addSubview:self.detailScroll];
    
    [self.detailScroll addSubview:self.mainView];
    
    [self setUpDistrictArrays];
    
    if (self.addressDetail) {
        
        if (![CustomStringUtils isBlankString:self.addressDetail.provinceId] || ![CustomStringUtils isBlankString:self.addressDetail.cityId] || ![CustomStringUtils isBlankString:self.addressDetail.districtId]) {
            NSArray *array = [self getAddressNameFromProvinceId:self.addressDetail.provinceId andCityId:self.addressDetail.cityId andDistrictId:self.addressDetail.districtId];
            if (array.count == 3) {
                self.addressDetail.provinceName = array[0];
                self.addressDetail.cityName = array[1];
                self.addressDetail.districtName = array[2];
            }
        }
        
        self.mainView.addressDetail = self.addressDetail;
    } else {
        self.addressDetail = [[DDAddressDetail alloc] init];
    }
    
    [self.view addSubview:self.targetAddressListButton];
}

- (NSArray *)getAddressNameFromProvinceId:(NSString *)pvId andCityId:(NSString *)ctId andDistrictId:(NSString *)dtId
{
    NSInteger provId = [pvId integerValue];
    NSInteger citId = [ctId integerValue];
    NSInteger dstId = [dtId integerValue];
    NSString *provName = [NSString string];
    NSString *citName = [NSString string];
    NSString *distName = [NSString string];
    NSMutableArray *arr = [NSMutableArray array];
    for (DDProvinceList *pvModel in self.provinceModelArr) {
        if (pvModel.provinceId == provId) {
            provName = pvModel.provinceName;
            for (NSDictionary *ctDic in pvModel.provinceSub) {
                DDCityList *ctModel = [DDCityList yy_modelWithDictionary:ctDic];
                if (ctModel.cityId == citId) {
                    citName = ctModel.cityName;
                    for (NSDictionary *dtDic in ctModel.citySub) {
                        DDAreaList *dtModel = [DDAreaList yy_modelWithDictionary:dtDic];
                        if (dtModel.areaId == dstId) {
                            distName = dtModel.areaName;
                            [arr addObject:provName];
                            [arr addObject:citName];
                            [arr addObject:distName];
                            return arr;
                        }
                    }
                }
            }
        }
    }
    
    return @[];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.isEdit == YES) {
        self.addressDetail = self.editAddressDetail;
        self.mainView.addressDetail = self.addressDetail;
    }
    DDAddNotification(@selector(keyBoardWillShow:), UIKeyboardWillShowNotification);
    DDAddNotification(@selector(keyBoardWillHide:), UIKeyboardWillHideNotification);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:false];
    DDRemoveNotificationObserver();
}

#pragma mark - Private Method
/** 判断必填项是否填写 */
- (BOOL)ifNeedReturn
{
    DDAddressDetail *adetail  = self.mainView.addressDetail;
    if (adetail.contentAddress != 0 &&
        adetail.nick != 0 &&
        adetail.phone != 0) {
        return YES;
    }
    return NO;
}
/**<  json字符串转(数组字典都可以)  */
- (NSArray *)dictionaryWithJsonString:(NSData *)jsonData
{
    if (jsonData == nil) return nil;
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) return nil;
    return arr;
}

/**
 *  将市列表和区列表设置为第一个省的市列表和第一个省的第一个市的区列表
 */
- (void)setUpDistrictArrays
{
    DDProvinceList *pvModel = self.provinceModelArr[0];
    NSArray *cityArr = pvModel.provinceSub;
    NSMutableArray *cityMarr = [NSMutableArray array];
    for (NSDictionary *dic in cityArr) {
        DDCityList *cModel = [DDCityList yy_modelWithDictionary:dic];
        [cityMarr addObject:cModel];
    }
    self.cityModelArr = cityMarr;
    
    DDCityList *cModel = self.cityModelArr[0];
    NSArray *areaArr = cModel.citySub;
    NSMutableArray *areaMarr = [NSMutableArray array];
    for (NSDictionary *dic in areaArr) {
        DDAreaList *arModel = [DDAreaList yy_modelWithDictionary:dic];
        [areaMarr addObject:arModel];
    }
    self.areaModelArr = areaMarr;
}

#pragma mark - Event Method
/**<  取消按钮点击事件  */
- (void)pickerCancelButtonClick
{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectPickerView.backView.alpha = 0;
        self.selectPickerView.y = 0;
    } completion:^(BOOL finished) {
        [self.selectPickerView setHidden:YES];
    }];
}

/**<  确定按钮点击事件  */
- (void)pickerSaveButtonClick
{
    DDProvinceList *pv;
    DDCityList *ct;
    DDAreaList *ar;
    
    if (self.provinceModelArr && [self.provinceModelArr count] > 0) {
        pv = self.provinceModelArr[self.selectedPvIndex];
        self.addressDetail.provinceName = pv.provinceName;
        self.addressDetail.provinceId = [NSString stringWithFormat:@"%ld",(long)pv.provinceId];
    }
    
    if (self.cityModelArr && [self.cityModelArr count] > 0) {
        ct = self.cityModelArr[self.selectedctIndex];
        self.addressDetail.cityName = ct.cityName;
        self.addressDetail.cityId = [NSString stringWithFormat:@"%ld",(long)ct.cityId];
    }
    
    if (self.areaModelArr && [self.areaModelArr count] > 0) {
        ar = self.areaModelArr[self.selectedarIndex];
        self.addressDetail.districtName = ar.areaName;
        self.addressDetail.districtId = [NSString stringWithFormat:@"%ld",(long)ar.areaId];
    }
    self.mainView.addressDetail = self.addressDetail;
    [self pickerCancelButtonClick];
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  保存按钮
 */
- (void)onClickFirstRightItem
{
    if (![self ifNeedReturn]) {
        [self displayForErrorMsg:SMessage];
        return;
    }
    
    if (![self isValidateMobile:self.addressDetail.phone]) {
        [self displayForErrorMsg:@"手机号有误"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(addTargetAddressDetail:)]) {
        [self.delegate addTargetAddressDetail:self.addressDetail];
    }
    
    
    if (self.isEdit == YES) {
        [self changeAddressRequest];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)clickWithTapGr
{
    [self.view endEditing:false];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self clickWithTapGr];
}



#pragma mark - DDTargetAddressEditViewDelegate
/** 添加手机联系人 */
- (void) addToAddressBook
{
    CoreAddressBookVC *addrBVC = [[CoreAddressBookVC alloc] init];
    addrBVC.delegate = self;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addrBVC];
    [self presentViewController:navVC animated:YES completion:nil];
}

/** 弹出所在区域选择器 */
- (void)createDistrictSelectPickerViewWithTitle:(NSString *)title
{
    [self.view endEditing:false];
    if (!self.selectPickerView) {
        DDSelectPickerView *view = [[DDSelectPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height+280)];
        view.pickerView.delegate = self;
        view.pickerView.dataSource = self;
        view.delegate = self;
        view.title = title;
        [self.view addSubview:view];
        self.selectPickerView = view;
        [self.selectPickerView.pickerView reloadAllComponents];
    }else {
        [self.selectPickerView setHidden:NO];
        [self.selectPickerView.pickerView selectRow:self.selectedPvIndex inComponent:0 animated:NO];
        [self.selectPickerView.pickerView selectRow:self.selectedctIndex inComponent:1 animated:NO];
        [self.selectPickerView.pickerView selectRow:self.selectedarIndex inComponent:2 animated:NO];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.selectPickerView.backView.alpha = 0.2;
        self.selectPickerView.y = -280;
    }];
}



#pragma mark - CoreAddressBookVCDelegate
/** 添加手机通讯录 */
- (void)addressBookVCSelectedContact:(JXPersonInfo *)personInfo
{
    NSString * name = [personInfo fullName];
    NSString * phone = personInfo.selectedPhoneNO;
    self.addressDetail.nick = name;
    self.addressDetail.phone = phone;
    self.mainView.addressDetail = self.addressDetail;
}

#pragma mark HPGrowingTextViewDelegate
- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView
{
    _tempView = self.mainView;
    return true;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    _tempView = nil;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    //计算文本框根据字符串得到的高度差
    float diff = (height - growingTextView.height);
    [self.mainView.btnSecondAddr setSize:CGSizeMake(self.mainView.btnSecondAddr.width, MAX(44.0f, self.mainView.btnSecondAddr.height + diff))];
    
    if (_isshowed) {
        CGFloat offset_Y = MAX(self.detailScroll.contentOffset.y+diff, 0);
        [self.detailScroll setContentOffset:CGPointMake(self.detailScroll.contentOffset.x, offset_Y)];
        [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, self.detailScroll.height+offset_Y)];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [growingTextView resignFirstResponder];
        return false;
    }
    NSString *str_text = [growingTextView.text stringByReplacingCharactersInRange:range withString:text];
    if ([self lenghtWithString:str_text] > 120) {
        growingTextView.text = [self subToStirng:str_text length:120];
        return false;
    }
    return true;
}

- (NSString *)subToStirng:(NSString *)str_text length:(NSInteger)length
{
    NSString *subStirng = @"";
    for (NSInteger i=1; i<[str_text length]; i++) {
        NSString *item_str = [str_text substringToIndex:i];
        if ([self lenghtWithString:item_str] > length) {
            break;
        }
        subStirng = item_str;
    }
    return subStirng;
}

#pragma mark - KeyBoard Notification Method
- (void)keyBoardWillShow:(NSNotification *)note
{
    _isshowed = true;
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    CGFloat offset_Y = MAX(_tempView.bottom+kMargin+ty - self.detailScroll.height, 0);
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.detailScroll setContentOffset:CGPointMake(self.detailScroll.contentOffset.x, offset_Y)];
    } completion:^(BOOL finish) {
        [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, self.detailScroll.height+offset_Y)];
    }];
}

- (void)keyBoardWillHide:(NSNotification *)note
{
    _isshowed = false;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.detailScroll setContentOffset:CGPointMake(self.detailScroll.contentOffset.x, 0)];
    } completion:^(BOOL finish) {
        [self.detailScroll setContentSize:CGSizeMake(self.detailScroll.width, self.detailScroll.height)];
    }];
}


#pragma mark - PickerView Delegate
/**<  竖条数  */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

/**<  每一竖条的行数  */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count;
    switch (component) {
        case DDTargetAddressEditPickerProvince:
            count = self.provinceModelArr.count;
            break;
        case DDTargetAddressEditPickerCity:
            count = self.cityModelArr.count;
            break;
        case DDTargetAddressEditPickerDistrict:
            count = self.areaModelArr.count;
            break;
        default:
            break;
        }
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id model = nil;
    NSString *title = @"";
    switch (component) {
        case DDTargetAddressEditPickerProvince:
            model = self.provinceModelArr[row];
            title = ((DDProvinceList *)model).provinceName;
            break;
        case DDTargetAddressEditPickerCity:
            model = self.cityModelArr[row];
            title = ((DDCityList *)model).cityName;
            break;
        case DDTargetAddressEditPickerDistrict:
            model = self.areaModelArr[row];
            title = ((DDAreaList *)model).areaName;
            break;
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
        if (component == DDTargetAddressEditPickerProvince) {
            //选择省
            DDProvinceList *pvModel = self.provinceModelArr[row];
            NSArray *ctArr = pvModel.provinceSub;
            NSMutableArray *ctMArr = [NSMutableArray array];
            for (NSDictionary *dic in ctArr) {
                DDCityList *cModel = [DDCityList yy_modelWithDictionary:dic];
                [ctMArr addObject:cModel];
            }
            //获得所选择省的市列表
            self.cityModelArr = ctMArr;
            
            DDCityList *ctModel = self.cityModelArr[0];
            NSArray *arArr = ctModel.citySub;
            NSMutableArray *mArArr = [NSMutableArray array];
            for (NSDictionary *dic in arArr) {
                DDAreaList *arModel = [DDAreaList yy_modelWithDictionary:dic];
                [mArArr addObject:arModel];
            }
            self.areaModelArr = mArArr;
            self.selectedPvIndex = row;
            self.selectedctIndex = 0;
            [pickerView selectRow:self.selectedctIndex inComponent:1 animated:NO];
            self.selectedarIndex = 0;
            [pickerView selectRow:self.selectedarIndex inComponent:2 animated:NO];
        }else if (component == DDTargetAddressEditPickerCity) {
            //选择市
            DDCityList *ctModel = self.cityModelArr[row];
            NSArray *arArr = ctModel.citySub;
            NSMutableArray *mArArr = [NSMutableArray array];
            for (NSDictionary *dic in arArr) {
                DDAreaList *arModel = [DDAreaList yy_modelWithDictionary:dic];
                [mArArr addObject:arModel];
            }
            self.areaModelArr = mArArr;
            self.selectedctIndex = row;
            self.selectedarIndex = 0;
            [pickerView selectRow:self.selectedarIndex inComponent:2 animated:NO];
        }else {
            //选择区
            self.selectedarIndex = row;
        }
    [pickerView reloadAllComponents];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        pickerLabel.textColor = DDRGBAColor(51, 51, 51, 1);
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}



#pragma mark - Setter && Getter
- (UIScrollView *)detailScroll
{
    if (!_detailScroll) {
        _detailScroll = [[UIScrollView alloc] init];
        [_detailScroll setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
        [_detailScroll setBackgroundColor:KBackground_COLOR];
        [_detailScroll setShowsHorizontalScrollIndicator:false];
        [_detailScroll setShowsVerticalScrollIndicator:false];
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWithTapGr)];
        [_detailScroll addGestureRecognizer:tapGr];
    }
    return _detailScroll;
}

- (DDTargetAddressEditView *)mainView
{
    if (!_mainView) {
        _mainView = [[DDTargetAddressEditView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 179.0)];
        _mainView.delegate = self;
        _mainView.textSecondAddr.delegate = self;
    }
    return _mainView;
}

- (NSMutableArray *)provinceModelArr
{
    if (_provinceModelArr == nil) {
        /**<  JSON转NSData  */
        NSData *data = [NSData dataWithContentsOfFile:DDMainBundle(@"city.json")];
        /**<  NSData转字典  */
        NSArray *arr =  [self dictionaryWithJsonString:data];
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSDictionary *dic in arr) {
            DDProvinceList *pvModel = [DDProvinceList yy_modelWithDictionary:dic];
            [mArr addObject:pvModel];
        }
        _provinceModelArr = mArr;
    }
    return _provinceModelArr;
}

-(UIButton *)targetAddressListButton
{
    if (_targetAddressListButton == nil) {
        UIButton *addressListButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.width - 145)/2, self.view.height - 50, 145, 30)];
        [addressListButton setBackgroundColor:DDRGBColor(32, 198, 122)];
        [addressListButton setTitle:@"常用收件地址" forState:UIControlStateNormal];
        [addressListButton setTitleColor:DDRGBColor(255, 255, 255) forState:UIControlStateNormal];
        addressListButton.titleLabel.font = [UIFont systemFontOfSize:16];
        addressListButton.layer.cornerRadius = addressListButton.height/2;
        addressListButton.layer.masksToBounds = YES;
        [addressListButton addTarget:self action:@selector(onClickSelfAddressListButton) forControlEvents:UIControlEventTouchUpInside];
        _targetAddressListButton = addressListButton;
    }
    return _targetAddressListButton;
}

- (void)onClickSelfAddressListButton
{
    DDTargetAddressListController *controller = [[DDTargetAddressListController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)changeAddressRequest
{
    //传参数字典(对应模型DDAddressDetail)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //地址ID
    [param setObject:self.addressDetail.addressID forKey:@"addrId"];
    
    //地址经度
    [param setObject:@(self.addressDetail.longitude) forKey:@"addrLon"];
    
    //地址纬度
    [param setObject:@(self.addressDetail.latitude) forKey:@"addrLat"];
    
    //主地址
    [param setObject:self.addressDetail.contentAddress forKey:@"main"];
    
    //详细地址
    [param setObject:self.addressDetail.supplementAddress forKey:@"detail"];
    
    //标签信息
    [param setObject:self.addressDetail.sign forKey:@"tag"];
    
    //名字
    [param setObject:self.addressDetail.nick forKey:@"name"];
    
    //手机号
    [param setObject:self.addressDetail.phone forKey:@"phone"];
    
    //省ID
    [param setObject:self.addressDetail.provinceId? : @"" forKey:@"provId"];
    
    //市id
    [param setObject:self.addressDetail.cityId? : @"" forKey:@"townId"];
    
    //区id
    [param setObject:self.addressDetail.districtId? : @"" forKey:@"areaId"];
    //信息类型(1寄件 2 收件)
    [param setObject:@2 forKey:@"type"];
    
    if (!self.interfaceEdit) {
        self.interfaceEdit = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceEdit interfaceWithType:INTERFACE_TYPE_MODIFY_ADDRESS param:param];
}

#pragma mark - DDInterfaceDelegate
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceEdit) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
@end
