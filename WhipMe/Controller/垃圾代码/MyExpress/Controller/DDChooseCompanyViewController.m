//
//  DDChooseCompanyViewController.m
//  DDExpressClient
//
//  Created by yangg on 16/4/6.
//  Copyright © 2016年 NS. All rights reserved.
//
#define KExistChatsKey (@"existChatsCompany")
#define KExistSectionsKey (@"existSectionsCompany")

#import "DDChooseCompanyViewController.h"
#import "DDCourierCompanyViewCell.h"
#import "DDInterface.h"
#import "YYModel.h"
#import "CustomStringUtils.h"
#import "DDGlobalVariables.h"

@interface DDChooseCompanyViewController ()<UITableViewDataSource, UITableViewDelegate, DDInterfaceDelegate>

/** 本视图的数组展示表格 */
@property (nonatomic, strong) UITableView *courierTableView;
/** 字母索引 */
@property (nonatomic, strong) NSMutableArray *titleChats;
/** 常用快递公司 */
@property (nonatomic, strong) NSMutableArray *arrayCommonCompany;
/** 作为本界面的表格数据数组 */
@property (nonatomic, strong) NSMutableDictionary *contentSections;
/** 网络请求 */
@property (nonatomic, strong) DDInterface *interfaceAllCompany;
@property (nonatomic, strong) DDInterface *interfaceCommonCompany;

@end

@implementation DDChooseCompanyViewController

#pragma mark - 初始化生成临时数据
- (instancetype)initWithDelegate:(id<DDChooseCompanyViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:KBackground_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"选择快递公司" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    //创建UI界面
    [self ddCreateForTableView];
    
    [self getCompany];
    [self queryByCommonCompany];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.arrayContent count] == 0) {
        self.arrayContent = [[DDGlobalVariables sharedInstance].arrayCourierCompany mutableCopy];
        
        [self reloadWithTableView];
    }
}

- (void)reloadWithTableView
{
    if ([self.arrayContent count] == 0) {
        return;
    }
    NSMutableDictionary *param = [self dictionaryForSections:self.arrayContent];
    self.titleChats = [[param objectForKey:KExistChatsKey] mutableCopy];
    self.contentSections = [[param objectForKey:KExistSectionsKey] mutableCopy];
    
    if ([self.arrayCommonCompany count] > 0) {
        [self.titleChats insertObject:@"☆" atIndex:0];
        [self.contentSections setValue:self.arrayCommonCompany forKey:@"☆"];
    }
    
    [self.courierTableView reloadData];
}

#pragma mark - 类的对象方法:初始化页面
- (void)ddCreateForTableView
{
    UITableView *courierTableView = [[UITableView alloc] init];
    [courierTableView setFrame:CGRectMake(0, KNavHeight, self.view.width, self.view.height - KNavHeight)];
    [courierTableView setBackgroundColor:[UIColor whiteColor]];
    [courierTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [courierTableView setDataSource:self];
    [courierTableView setDelegate:self];
    [courierTableView setSectionIndexColor:TITLE_COLOR];
    [courierTableView setSectionIndexBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:courierTableView];
    self.courierTableView = courierTableView;
}

/** 根据传入的实体数组，返回字幕索引和整理好的键值队Dictionary */
- (NSMutableDictionary *)dictionaryForSections:(NSArray *)objects
{
    SEL selector = @selector(companyName);
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    
    NSMutableArray *mutableSections = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        [mutableSections addObject:[NSMutableArray array]];
    }
    
    for (id object in objects) {
        NSInteger sectionNumber = [collation sectionForObject:object collationStringSelector:selector];
        [[mutableSections objectAtIndex:sectionNumber] addObject:object];
    }
    
    for (NSUInteger idx = 0; idx < sectionTitlesCount; idx++) {
        NSArray *objectsForSection = [mutableSections objectAtIndex:idx];
        [mutableSections replaceObjectAtIndex:idx withObject:[[UILocalizedIndexedCollation currentCollation] sortedArrayFromArray:objectsForSection collationStringSelector:selector]];
    }
    
    //去掉空的数组和字符索引
    NSMutableDictionary *existTitleSections = [NSMutableDictionary dictionary];
    NSMutableArray *existTitleChats = [NSMutableArray array];
    
    NSArray *allSections = [collation sectionIndexTitles];
    for (NSUInteger i=0; i<[allSections count]; i++) {
        if ([mutableSections[i] count] > 0) {
            [existTitleChats addObject:allSections[i]];
            [existTitleSections setValue:mutableSections[i] forKey:allSections[i]];
        }
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:existTitleSections forKey:KExistSectionsKey];
    [param setValue:existTitleChats forKey:KExistChatsKey];
    
    return param;
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView 数据源及代理方法
//添加索引列
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return nil;
    }
    return self.titleChats;
}

//索引列点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *itemLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemLabel setFrame:CGRectMake(0, 0, tableView.width, 25.0f)];
    [itemLabel setBackgroundColor:KBackground_COLOR];
    [itemLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [itemLabel setTitleEdgeInsets:UIEdgeInsetsMake(0, 15.0f, 0, 0)];
    [itemLabel.titleLabel setFont:kTitleFont];
    [itemLabel setTitleColor:KPlaceholderColor forState:UIControlStateNormal];
    
    NSString *str_title = [self.titleChats[section] isEqualToString:@"☆"] ? @"常用快递公司" : self.titleChats[section];
    [itemLabel setTitle:str_title forState:UIControlStateNormal];
    
    return itemLabel;
}

//-----------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleChats.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentSections[self.titleChats[section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DDCC_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"courierCompanyViewCell";
    DDCourierCompanyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DDCourierCompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        UIView *selectView = [[UIView alloc] init];
        [selectView setFrame:CGRectMake(0, 0, tableView.width, DDCC_CELL_HEIGHT)];
        [selectView setBackgroundColor:HIGHLIGHT_COLOR];
        [cell setSelectedBackgroundView:selectView];
    }
    NSArray *cell_array = [self.contentSections objectForKey:self.titleChats[indexPath.section]];
    [cell setCellForCompany:cell_array[indexPath.row]];
    
    [cell.lblLine setHidden:indexPath.row == cell_array.count-1 ? true : false];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    NSArray *cell_array = [self.contentSections objectForKey:self.titleChats[indexPath.section]];
    DDCompanyModel *indexModel = [cell_array objectAtIndex:indexPath.row];
    [indexModel setCompanySelect:false];
    
    if ([cell_array count] > 1) {
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }
    if ([self.delegate respondsToSelector:@selector(chooseCompanyViewWithCompany:)]) {
        [self.delegate chooseCompanyViewWithCompany:indexModel];
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

- (NSMutableArray *)arrayContent
{
    if (!_arrayContent) {
        _arrayContent = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayContent;
}

- (NSMutableArray *)titleChats
{
    if (!_titleChats) {
        _titleChats = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _titleChats;
}

- (NSMutableDictionary *)contentSections
{
    if (!_contentSections) {
        _contentSections = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _contentSections;
}

- (NSMutableArray *)arrayCommonCompany
{
    if (!_arrayCommonCompany) {
        _arrayCommonCompany = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayCommonCompany;
}

/** 获取所有快递公司 */
- (void)getCompany
{
    if ([[DDGlobalVariables sharedInstance].arrayCourierCompany count] > 0) {
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (!self.interfaceAllCompany) {
        self.interfaceAllCompany = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceAllCompany interfaceWithType:INTERFACE_TYPE_TOTAL_COMPANY param:param];
}

/** 获取常用快递公司 */
- (void)queryByCommonCompany
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (!self.interfaceCommonCompany) {
        self.interfaceCommonCompany = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceCommonCompany interfaceWithType:INTERFACE_TYPE_COMPANY_LIST param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取，初始化快递公司列表
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceAllCompany) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.arrayContent removeAllObjects];
            
            for (NSDictionary *dict in result[@"corList"]) {
                DDCompanyModel *company = [DDCompanyModel yy_modelWithDictionary:dict];
                company.companyLogo         = [DDInterfaceTool logoWithCompanyId:[CustomStringUtils isBlankString:company.companyID] ? @"" : company.companyID];
                company.companySelect       = false;
                company.companyModelType    = DDCompanyModelAll;
                [self.arrayContent addObject:company];
            }
            [[DDGlobalVariables sharedInstance] setArrayCourierCompany:[self.arrayContent mutableCopy]];
            
            [self reloadWithTableView];
        }
    } else if (interface == self.interfaceCommonCompany) {
        NSLog(@"常用快递公司\n_____________result:%@___________error:%@",result, error);
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.arrayCommonCompany removeAllObjects];
            
            for (NSDictionary *dict in result[@"corList"]) {
                DDCompanyModel *company = [DDCompanyModel yy_modelWithDictionary:dict];
                company.companyLogo         = [DDInterfaceTool logoWithCompanyId:[CustomStringUtils isBlankString:company.companyID] ? @"" : company.companyID];
                company.companySelect       = false;
                company.companyModelType    = DDCompanyModelAll;
                [self.arrayCommonCompany addObject:company];
            }
            [self reloadWithTableView];
        }
    }
}



@end
