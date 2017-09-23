//
//  DDInputAddressController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDInputAddressController.h"
#import "Constant.h"
#import "DDAddressCell.h"
#import "DDGlobalVariables.h"
#import "DDSelfAdressEditController.h"
#import "DDProvinceList.h"
#import "DDCityList.h"
#import "DDAreaList.h"
#import "YYModel.h"
#import "MBProgressHUD+MJ.h"
#import "DDHomeController.h"
#import "UITableView+DefaultPage.h"


#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

NSString *const DDInputAddressControllerOldCellReuseId = @"DDAddressCell";
NSString *const ADDRESS_PLACE_HOLDER = @"您的寄件地址";

@interface DDInputAddressController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,BMKSuggestionSearchDelegate,BMKGeoCodeSearchDelegate>

/** 地址输入框背景视图 */
@property (strong, nonatomic) UIView *addressBackView;
/** 地址输入框 */
@property (strong, nonatomic) UITextField *inputAddressTextField;
/** 取消按钮 */
@property (strong, nonatomic) UIButton *cancelButton;
/** 表视图 */
@property (strong, nonatomic) UITableView *addressTableView;

@property (nonatomic, strong) UIView *addressTableFooterView;
/** 清楚所有历史按钮 */
@property (strong, nonatomic) UIButton *clearButton;
/**  建议索引对象  */
@property (nonatomic, strong) BMKSuggestionSearch *suggestionSearcher;
/**  建议查询选项  */
@property (nonatomic, strong) BMKSuggestionSearchOption *suggestionOption;
/**  反地理编码对象  */
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearcher;
/**  反地理编码选项  */
@property (nonatomic, strong) BMKReverseGeoCodeOption *geoOption;
@property (nonatomic, assign) NSInteger getDetailIndex;
/** 旧地址模型列表 */
@property (strong, nonatomic) NSMutableArray *arrayOldAddress;
/** 新地址模型列表 */
@property (strong, nonatomic) NSMutableArray *arraySuggestAddress;
/** textfield中没有值 */
@property (assign, nonatomic) DDInputTextExist isNoTextInTextField;
/**  背景毛玻璃视图  */
@property (nonatomic, strong) UIImageView *backImageView;
/**<  省模型数组  */
@property (nonatomic,strong) NSMutableArray *provinceModelArr;

@end

@implementation DDInputAddressController
@synthesize arrayOldAddress;
@synthesize arraySuggestAddress;
@synthesize isNoTextInTextField;

- (instancetype)init
{
    self = [super init];
    if (self) {
        //实例化数组
        arraySuggestAddress = [[NSMutableArray alloc] initWithCapacity:0];
        arrayOldAddress = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self initWithData];
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self.view addSubview:self.backImageView];
    [self.view addSubview:self.addressBackView];
    [self.addressBackView addSubview:self.cancelButton];
    [self.addressBackView addSubview:self.inputAddressTextField];
    [self.view addSubview:self.addressTableView];
    [self.addressTableFooterView addSubview:self.clearButton];
    [self.addressTableView setTableFooterView:self.addressTableFooterView];
    [self.inputAddressTextField becomeFirstResponder];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true];
}


#pragma mark - TableView Delegate And Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arraySuggestAddress.count > 0 || isNoTextInTextField == DDHaveTextInTextField ) {
        return arraySuggestAddress.count;
    }else {
        [self.clearButton setHidden:arrayOldAddress.count <= 0];
        [self.addressTableView.defaultPageView setHidden:YES];
    }
    return arrayOldAddress.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //实例化地址信息显示Cell
    DDAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:DDInputAddressControllerOldCellReuseId];
    if (!cell) {
        cell = [DDAddressCell cellWithTableView:tableView];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if (arraySuggestAddress.count > 0 || isNoTextInTextField == DDHaveTextInTextField)
    {
        [cell.headImageView setImage:[UIImage imageNamed:DDInputAddressMap]];
        DDAddressDetail *addressDetail = arraySuggestAddress[indexPath.row];
        [cell setAddressDetail:addressDetail];
    }else {
        [cell.headImageView setImage:[UIImage imageNamed:DDOldAddressClock]];
        DDAddressDetail *addressDetail = arrayOldAddress[indexPath.row];
        [cell setAddressDetail:addressDetail];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    DDAddressDetail *model = [[DDAddressDetail alloc]init];
    if (arraySuggestAddress.count > 0 || isNoTextInTextField == DDHaveTextInTextField)
    {
        model = arraySuggestAddress[indexPath.row];
        [arrayOldAddress insertObject:model atIndex:0];
        [self setOldFileLists];
    } else {
        model = [arrayOldAddress objectAtIndex:indexPath.row];
        //每次选择新搜索地址，同步本地保存的plist文件
        [arrayOldAddress removeObject:model];
        [arrayOldAddress insertObject:model atIndex:0];
        [self setOldFileLists];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(passInputAddress:withSuggestionAddress:)]) {
        [self.delegate passInputAddress:self withSuggestionAddress:model];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arraySuggestAddress.count > 0 || isNoTextInTextField == DDHaveTextInTextField) {
        return NO;
    } else {
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KDDTitleForDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [arrayOldAddress removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self setOldFileLists];
        [self.clearButton setHidden:arrayOldAddress.count <= 0];
    }
}




#pragma mark - BMK - Suggestion Search Delegate && Datasource
- (void)onGetSuggestionResult:(BMKSuggestionSearch *)searcher result:(BMKSuggestionResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        [arraySuggestAddress removeAllObjects];
        for (int i = 0; i < result.ptList.count; i ++) {
            CLLocationCoordinate2D coordinate;
            [result.ptList[i] getValue:&coordinate];
            if (coordinate.latitude != 0) {
                
                DDAddressDetail *addressDetail = [[DDAddressDetail alloc]init];
                addressDetail.addressName = result.keyList[i];
                addressDetail.latitude = coordinate.latitude;
                addressDetail.longitude = coordinate.longitude;
                [arraySuggestAddress addObject:addressDetail];
                
                BMKGeoCodeSearch *geoSearcher = [[BMKGeoCodeSearch alloc]init];
                geoSearcher.delegate = self;
                self.geoOption.reverseGeoPoint = coordinate;
                BOOL flag = [geoSearcher reverseGeoCode:self.geoOption];
                if (!flag) NSLog(@"反地理编码失败");
            }
        }
        if (isNoTextInTextField == DDHaveTextInTextField) {
            [self.addressTableView.defaultPageView setHidden:arraySuggestAddress.count > 0];
        }else{
            [self.addressTableView.defaultPageView setHidden:YES];
        }
        
        if (arraySuggestAddress.count > 0 || isNoTextInTextField == DDHaveTextInTextField)
            [self.clearButton setHidden:true];
        else [self.clearButton setHidden:false];
    }else {
        if (isNoTextInTextField == DDHaveTextInTextField) {
            [self.addressTableView.defaultPageView setHidden:arraySuggestAddress.count > 0];
        }else{
            [self.addressTableView.defaultPageView setHidden:YES];
        }
    }
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if ([self.arraySuggestAddress count] > 0  && self.getDetailIndex < self.arraySuggestAddress.count) {
        DDAddressDetail *addressDetail = self.arraySuggestAddress[self.getDetailIndex];
        addressDetail.localDetailAddress = result.address;
        addressDetail.contentAddress = [NSString stringWithFormat:@"%@/%@",addressDetail.localDetailAddress,addressDetail.addressName];
        addressDetail.provinceName = result.addressDetail.province;
        addressDetail.cityName = result.addressDetail.city;
        addressDetail.districtName = result.addressDetail.district;
        self.getDetailIndex ++;
        if (self.getDetailIndex == self.arraySuggestAddress.count) {
            [self.addressTableView reloadData];
            self.getDetailIndex = 0;
        }
    }
}




#pragma mark - Private Method
- (void)initWithData
{
    for (NSDictionary *dict in [self oldFileLists])
    {
        DDAddressDetail *model = [[DDAddressDetail alloc] init];
        model.addressName = [dict objectForKey:@"addressName"];
        model.localDetailAddress = [dict objectForKey:@"localDetailAddress"];
        model.contentAddress = [dict objectForKey:@"contentAddress"];
        model.supplementAddress = [dict objectForKey:@"supplementAddress"];
        model.cityName = [dict objectForKey:@"cityName"];
        model.districtName = [dict objectForKey:@"districtName"];
        model.provinceName = [dict objectForKey:@"provinceName"];
        model.latitude = [[dict objectForKey:@"latitude"] doubleValue];
        model.longitude = [[dict objectForKey:@"longitude"] doubleValue];
        [arrayOldAddress addObject:model];
    }
}


#pragma mark - Event Method

- (void)onClickWithBarBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 清除所有旧地址按钮 */
- (void)clearButtonClick
{
    [arrayOldAddress removeAllObjects];
    
    //清除历史搜索记录时，同步本地保存的plist文件
    [self setOldFileLists];
    [self.clearButton setHidden:arrayOldAddress.count <= 0];
    [self.addressTableView reloadData];
    
}

- (void)textFieldCharChanged:(UITextField *)textfield
{
    if ([textfield.text length] > 0)
    {
        isNoTextInTextField = DDHaveTextInTextField;
        self.suggestionOption.keyword = textfield.text;
        BOOL flag = [self.suggestionSearcher suggestionSearch:self.suggestionOption];
        if (flag) {
            NSLog(@"建议检索成功");
        }else {
            NSLog(@"建议检索失败");
        }
    } else {
        isNoTextInTextField = DDNoTextInTextField;
        [arraySuggestAddress removeAllObjects];
        [self.clearButton setHidden:false];
        [self.addressTableView reloadData];
    }
}








#pragma mark - Setter && Getter
- (UIImageView *)backImageView
{
    if (_backImageView == nil) {
        UIImageView *imageBackground = [[UIImageView alloc] init];
        [imageBackground setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height)];
        [imageBackground setBackgroundColor:DDRGBAColor(255, 255, 255, 1)];
        [imageBackground setContentMode:UIViewContentModeScaleAspectFit];
        [imageBackground setImage:self.backgroundMapImage];
        if (isIos7 > 7.0f)
        {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
            [effectView setFrame:imageBackground.bounds];
            [effectView setAlpha:0.9f];
            [imageBackground addSubview:effectView];
        }
        _backImageView = imageBackground;
    }
    return _backImageView;
}

- (UITableView *)addressTableView
{
    if (_addressTableView == nil) {
        UITableView *addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
        [addressTableView setBackgroundColor:isIos7 > 7.0f ? [UIColor clearColor] : [UIColor colorWithWhite:1.0f alpha:0.8f]];
        [addressTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [addressTableView setDataSource:self];
        [addressTableView setDelegate:self];
        [addressTableView addDefaultPageWithImageName:@"no-address" andTitle:@"未查询到该地址，请重新输入" andSubTitle:nil andBtnImage:nil andbtnTitle:nil andBtnAction:nil];
        
        _addressTableView = addressTableView;
    }
    return _addressTableView;
}


-(UIView *)addressTableFooterView
{
    if (_addressTableFooterView == nil) {
        UIView *viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.addressTableView.width, 56)];
        [viewFooter setBackgroundColor:self.addressTableView.backgroundColor];
        _addressTableFooterView = viewFooter;
    }
    return _addressTableFooterView;
}


- (UIButton *)clearButton
{
    if (_clearButton == nil) {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2-62, 26, 124, 30)];
        [clearButton setTitle:@"清除所有历史" forState:UIControlStateNormal];
        [clearButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
        clearButton.layer.cornerRadius = clearButton.height/2.0f;
        clearButton.layer.masksToBounds = YES;
        clearButton.layer.borderColor = DDGreen_Color.CGColor;
        clearButton.layer.borderWidth = 1;
        clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [clearButton setHidden:self.arrayOldAddress.count <= 0];
        [clearButton addTarget:self action:@selector(clearButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.addressTableFooterView addSubview:clearButton];
        _clearButton = clearButton;
    }
    return _clearButton;
}

- (UIView *)addressBackView
{
    if (_addressBackView == nil) {
        UIView *addressBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, KNavHeight)];
        addressBackView.backgroundColor = DDRGBAColor(247, 247, 247, 1);
        addressBackView.layer.borderWidth = 0.5;
        addressBackView.layer.borderColor = BORDER_COLOR.CGColor;
        _addressBackView = addressBackView;
    }
    return _addressBackView;
}

- (UIButton *)cancelButton
{
    if (_cancelButton == nil) {
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-55, 20, 53, 44)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:DDGreen_Color forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:kContentFont];
        [cancelButton addTarget:self action:@selector(onClickWithBarBack) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton = cancelButton;
    }
    return _cancelButton;
}

- (UITextField *)inputAddressTextField
{
    if (_inputAddressTextField == nil) {
        UITextField *inputAddressTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, 26, self.view.frame.size.width-60-15, 32)];
        inputAddressTextField.backgroundColor = DDRGBAColor(229, 229, 229, 1);
        inputAddressTextField.layer.cornerRadius = inputAddressTextField.height/2.0f;
        inputAddressTextField.layer.masksToBounds = YES;
        inputAddressTextField.placeholder = ADDRESS_PLACE_HOLDER;
        [inputAddressTextField setValue:KPlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
        [inputAddressTextField setFont:kTitleFont];
        inputAddressTextField.delegate = self;
        inputAddressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [inputAddressTextField setTintColor:DDRGBAColor(32, 198, 122, 1)];
        [inputAddressTextField addTarget:self action:@selector(textFieldCharChanged:) forControlEvents:UIControlEventEditingChanged];
        
        //输入框左边的图标icon
        UIButton *leftView = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftView setFrame:CGRectMake(0, 0, 42.0f, inputAddressTextField.height)];
        [leftView setBackgroundColor:[UIColor clearColor]];
        [inputAddressTextField setLeftView:leftView];
        [inputAddressTextField setLeftViewMode:UITextFieldViewModeAlways];
        
        UIImageView *imgIcon = [[UIImageView alloc] init];
        [imgIcon setSize:CGSizeMake(15.0f, 15.0f)];
        [imgIcon setCenter:CGPointMake(leftView.centerx, leftView.centery)];
        [imgIcon setBackgroundColor:[UIColor clearColor]];
        [imgIcon setImage:[UIImage imageNamed:DDInputAddressMap]];
        [leftView addSubview:imgIcon];
        
        _inputAddressTextField = inputAddressTextField;
    }
    return _inputAddressTextField;
}

- (BMKSuggestionSearchOption *)suggestionOption
{
    if (_suggestionOption == nil) {
        _suggestionOption = [[BMKSuggestionSearchOption alloc]init];
        _suggestionOption.cityname = @"杭州";
    }
    return _suggestionOption;
}

- (BMKSuggestionSearch *)suggestionSearcher
{
    if (_suggestionSearcher == nil) {
        _suggestionSearcher = [[BMKSuggestionSearch alloc]init];
        _suggestionSearcher.delegate = self;
    }
    return _suggestionSearcher;
}


- (BMKReverseGeoCodeOption *)geoOption
{
    if (_geoOption == nil) {
        _geoOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    return _geoOption;
}


-(NSMutableArray *)provinceModelArr
{
    if (_provinceModelArr == NO) {
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
/**<  json字符串转(数组字典都可以)  */
- (NSArray *)dictionaryWithJsonString:(NSData *)jsonData {
    if (jsonData == nil) {
        return nil;
    }
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}

/** 从本地documents文件夹下获取地址搜索记录 */
- (NSArray *)oldFileLists
{
    NSArray *arary = [NSArray arrayWithContentsOfFile:DD_DocumentFilePath(KIINPUT_ADDRESS_OLD_PLIST)];
    if (!arary) {
        arary = [[NSMutableArray alloc] init];
    }
    return arary;
}

/** 保存在本地documents文件夹下 KVC*/
- (void)setOldFileLists
{
    NSMutableArray *muArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (DDAddressDetail *detail in arrayOldAddress)
    {
        [muArray addObject:[self dictionaryWithAddress:detail]];
    }
    [muArray writeToFile:DD_DocumentFilePath(KIINPUT_ADDRESS_OLD_PLIST) atomically:NO];
}

- (NSMutableDictionary *)dictionaryWithAddress:(DDAddressDetail *)model
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setValue:model.addressName ?: @"" forKey:@"addressName"];
    [dict setValue:model.localDetailAddress ?: @"" forKey:@"localDetailAddress"];
    [dict setValue:model.contentAddress ?: @"" forKey:@"contentAddress"];
    [dict setValue:model.supplementAddress ?: @"" forKey:@"supplementAddress"];
    [dict setValue:model.districtName ?: @"" forKey:@"districtName"];
    [dict setValue:model.cityName ?: @"" forKey:@"cityName"];
    [dict setValue:model.provinceName ?: @"" forKey:@"provinceName"];
    [dict setValue:[NSNumber numberWithDouble:model.latitude] forKey:@"latitude"];
    [dict setValue:[NSNumber numberWithDouble:model.longitude] forKey:@"longitude"];
    return dict;
}

@end
