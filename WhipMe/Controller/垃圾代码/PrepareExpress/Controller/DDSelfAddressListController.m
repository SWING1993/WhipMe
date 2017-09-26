//
//  DDSelfAddressListController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDSelfAddressListController.h"
#import "DDSendAddressCell.h"
#import "DDAddressDetail.h"
#import "DDSelfAdressEditController.h"
#import "YYModel.h"
#import "Constant.h"
#import "UITableViewRowAction+JZExtension.h"
#import "DDSelfAdressEditController.h"
#import "DDInterface.h"
#import "DDPrepareSendViewController.h"
#import "DDGlobalVariables.h"

#import "DDCenterCoordinate.h"

NSString *const TNavigationItemTitle = @"常用寄件地址";
NSString *const TImageName = @"S2.png";
CGFloat   const SectionHeaderHeight = 0.1f;
CGFloat   const TableViewRowHeight = 77;


@interface DDSelfAddressListController () <UITableViewDataSource,UITableViewDelegate,DDInterfaceDelegate>

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DDInterface *interfaceAddress;
@property (nonatomic, strong) DDInterface *interfaceDelete;
@end

@implementation DDSelfAddressListController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.tableView];
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:TNavigationItemTitle segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    [self disableBackGesture];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getAddressListInfo];
}

#pragma mark - TableView Delegate And Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addressDetailArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"selfAddressCell";
    DDSendAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[DDSendAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    DDAddressDetail * person = [self.addressDetailArray objectAtIndex:[indexPath row]];
    cell.addressDetail = person;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TableViewRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDAddressDetail * newPerson = [self.addressDetailArray objectAtIndex:[indexPath row]];
    
    [DDGlobalVariables sharedInstance].selfAddressDetail = newPerson;
    [DDCenterCoordinate setSendExpressInfoWithCoordinate:CLLocationCoordinate2DMake(newPerson.latitude, newPerson.longitude)];

    for (DDPrepareSendViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[DDPrepareSendViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    void(^rowActionEdit)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        self.index = indexPath.row;
        DDAddressDetail *addressDetail = [self.addressDetailArray objectAtIndex:self.index];
        DDSelfAdressEditController *selfAddressEditView = [[DDSelfAdressEditController alloc] init];
        selfAddressEditView.isEdit = YES;
        selfAddressEditView.editAddressDetail = addressDetail;
        [self.navigationController pushViewController:selfAddressEditView animated:YES];
    };
    void(^rowActionDelete)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSInteger row = [indexPath row];
        NSString * addressId = [(DDAddressDetail *)[self.addressDetailArray objectAtIndex:row] addressID];
        [self deleteAddrInfo:addressId];
        [self.addressDetailArray removeObjectAtIndex:row];
        [self.tableView reloadData];
        if (self.addressDetailArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    UITableViewRowAction *actionEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"edit"] handler:rowActionEdit];
    actionEdit.backgroundColor = DDRGBColor(201, 201, 201);
    
    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"delete"] handler:rowActionDelete];
    actionDelete.backgroundColor = DDRGBColor(255, 56, 17);
    
    return @[actionDelete,actionEdit];
}

#pragma mark - Event Method
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network Request
/**
 *  获取寄件人/收件人地址
 */
- (void)getAddressListInfo
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //信息类型(1寄件 2 收件)
    [param setObject:@1 forKey:@"type"];
    
    //页码
    [param setObject:@1 forKey:@"page"];
    
    //搜索key(不传代表所有)
    //[param setObject:@"" forKey:@"searchKey"];
    
    //初始化连接
    DDInterface *interface = [[DDInterface alloc] initWithDelegate:self];
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [interface interfaceWithType:INTERFACE_TYPE_ADDRESS_LIST param:param];
    
    self.interfaceAddress = interface;
}

/**
 *  删除寄件人/收件人地址
 */
- (void)deleteAddrInfo:(NSString *  )addressId
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //信息类型(1寄件 2 收件)
    [param setObject:@1 forKey:@"type"];
    
    //地址ID
    [param setObject:addressId forKey:@"addrId"];
    
    //初始化连接
    DDInterface *interface = [[DDInterface alloc] initWithDelegate:self];
    
    //向服务器发送请求,返回参数在DDInterfaceDelegate获取
    [interface interfaceWithType:INTERFACE_TYPE_DELETE_ADDRESS param:param];
    
    self.interfaceDelete = interface;
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    //获取缓存的用户电话号码
    NSString *userPhone = [DDInterfaceTool getPhoneNumber];
    if (interface == self.interfaceAddress)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }else {
            [self.addressDetailArray removeAllObjects];
            for (NSDictionary *dict in result[@"addrList"]) {
                DDAddressDetail *addressDetail = [DDAddressDetail yy_modelWithDictionary:dict];
                addressDetail.nick = addressDetail.name;
                addressDetail.name = [LocalUserInfo valueForKey:@"name"];
                addressDetail.phone = userPhone;
                [self.addressDetailArray addObject:addressDetail];
            }
            [self.tableView reloadData];
        }
    }else if (interface == self.interfaceDelete)
    {
        NSLog(@"delete _____result_%@______error_%@",result,error);
        if (error) {
            [MBProgressHUD showError:error.domain];
        }
    }
}

#pragma mark - Setter && Getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), MainScreenHeight - 64) style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
//        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        tableView.separatorColor = BORDER_COLOR;
        _tableView = tableView;
    }
    return _tableView;
}

-(NSMutableArray *)addressDetailArray
{
    if (_addressDetailArray == nil) {
        _addressDetailArray = [[NSMutableArray alloc] init];
    }
    return _addressDetailArray;
}



@end
