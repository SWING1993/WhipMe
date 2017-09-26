//
//  CourierCompanyViewController.m
//  DuDu Courier
//
//  Created by yangg on 16/2/19.
//  Copyright © 2016年 yangg. All rights reserved.
//

/**
    快递公司列表视图
 */

#import "DDCourierCompanyViewController.h"
#import "DDCourierCompanyViewCell.h"
#import "DDInterface.h"
#import "YYModel.h"
#import "CustomStringUtils.h"

@interface DDCourierCompanyViewController () <UITableViewDataSource, UITableViewDelegate, DDInterfaceDelegate>
{
    /** 全选和全不选 */
    BOOL _isSelecting;
}
/** 侧边的字母索引数组 */
@property (nonatomic, strong) NSMutableArray *titleChats;

/** 本视图的数组展示表格 */
@property (nonatomic, strong) UITableView *courierTableView;

/** 内容数组 */
@property (nonatomic, strong) NSMutableArray *arrayContent;

/** 网络请求 */
@property (nonatomic, strong) DDInterface *interfaceCourier;

@end

@implementation DDCourierCompanyViewController
@synthesize courierTableView;
@synthesize titleChats;

#pragma mark - 生命周期方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置背景色
    [self.view setBackgroundColor:KBackground_COLOR];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"选择快递公司" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self adaptFirstRightItemWithTitle:@"完成"];
    
    //创建UITableView对象视图－courierTableView，作为本界面的内容展示，覆盖除导航栏所有的界面
    [self ddCreateForTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getCompany];
}

#pragma mark - 类的对象方法:初始化页面
/** 创建UITableView对象视图－courierTableView，作为本界面的内容展示，覆盖除导航栏所有的界面 */
- (void)ddCreateForTableView
{
    courierTableView = [[UITableView alloc] init];
    [courierTableView setFrame:CGRectMake(0, 64, self.view.width, MainScreenHeight - KNavHeight)];
    [courierTableView setBackgroundColor:[UIColor whiteColor]];
    [courierTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [courierTableView setDataSource:self];
    [courierTableView setDelegate:self];
    [courierTableView setSectionIndexColor:TITLE_COLOR];
    [self.view addSubview:courierTableView];
    _isSelecting = true;
}

#pragma mark - tableView 数据源及代理方法
/** 设置tableView行数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayContent.count;
}

/** 设置tableView的行高 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return DDCC_CELL_HEADER;
    }
    return DDCC_CELL_HEIGHT;
}

/** 设置tableView的cell */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"courierCompanyViewCell";
    DDCourierCompanyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDCourierCompanyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor whiteColor]];
        
        UIView *selectView = [[UIView alloc] init];
        [selectView setFrame:CGRectMake(0, 0, tableView.width, indexPath.row==0 ? DDCC_CELL_HEADER : DDCC_CELL_HEIGHT)];
        [selectView setBackgroundColor:HIGHLIGHT_COLOR];
        [cell setSelectedBackgroundView:selectView];
    }
    [cell setCellForCompany:self.arrayContent[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    /**
     表格Cell所对应的选择事件;
     当cell组是“不限”选择事件，对应“全选”或“全不选”；否则为单个Cell选择，一个cell对应一个事件
     */
    
    DDCompanyModel *indexModel = [self.arrayContent objectAtIndex:indexPath.row];
    if (indexPath.row == 0)
    {
        for (DDCompanyModel *model in self.arrayContent) {
            [model setCompanySelect:!_isSelecting];
        }
        _isSelecting = !_isSelecting;
        [tableView reloadData];
    } else {
        NSMutableArray *muArary = [NSMutableArray array];
        [indexModel setCompanySelect:!indexModel.companySelect];
        [muArary addObject:indexPath];
        
        BOOL flag = false;
        for (DDCompanyModel *model in self.arrayContent) {
            if (!model.companySelect && ![CustomStringUtils isBlankString:model.companyID]) {
                flag = true;
                break;
            }
        }
        
        DDCompanyModel *model = [self.arrayContent objectAtIndex:0];
        [model setCompanySelect:!flag];
        [muArary addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [tableView reloadRowsAtIndexPaths:muArary withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 完成 */
- (void)onClickFirstRightItem
{
    NSMutableArray *choosedArray = [[NSMutableArray alloc] init];
    for (DDCompanyModel *model in self.arrayContent) {
        if (model.companySelect && ![CustomStringUtils isBlankString:model.companyID]) {
            [choosedArray addObject:model];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(setCouriercompany:withLimit:)]) {
        BOOL flag = choosedArray.count == self.arrayContent.count-1 ? true : false;
        [self.delegate setCouriercompany:choosedArray withLimit:flag];
    }
    
    [self.navigationController popViewControllerAnimated:true];
}

- (NSMutableArray *)arrayContent
{
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

- (NSArray *)idArray
{
    if (!_idArray) {
        _idArray = [NSArray array];
    }
    return _idArray;
}
/** 获取附件快递公司列表 */
- (void)getCompany
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (!self.interfaceCourier) {
        self.interfaceCourier = [[DDInterface alloc] initWithDelegate:self];
    }
    [self.interfaceCourier interfaceWithType:INTERFACE_TYPE_COMPANY_LIST param:param];
}

#pragma mark - DDInterfaceDelegate 用于数据获取，初始化快递公司列表
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.interfaceCourier) {
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.arrayContent removeAllObjects];
            
            DDCompanyModel *company = [[DDCompanyModel alloc] init];
            [company setCompanyName:@"不限"];
            [company setCompanySelect:_isSelecting];
            [company setCompanyModelType:DDCompanyModelHead];
            
            for (NSDictionary *dict in result[@"corList"]) {
                DDCompanyModel *itemModel = [DDCompanyModel yy_modelWithDictionary:dict];
                [itemModel setCompanyLogo:[DDInterfaceTool logoWithCompanyId:itemModel.companyID]];
                [itemModel setCompanyModelType:DDCompanyModelAll];
                
                if ([self.idArray count] == 0) {
                    [itemModel setCompanySelect:_isSelecting];
                } else {
                    for (NSString *companyId in self.idArray) {
                        if ([companyId isEqualToString:itemModel.companyID]) {
                            [itemModel setCompanySelect:true];
                            break;
                        }
                    }
                }
                [self.arrayContent addObject:itemModel];
            }
            if ([self.arrayContent count] != [self.idArray count] && [self.idArray count] > 0) {
                [company setCompanySelect:false];
            }
            [self.arrayContent insertObject:company atIndex:0];
            
            [courierTableView reloadData];
        }
    }
}

@end
