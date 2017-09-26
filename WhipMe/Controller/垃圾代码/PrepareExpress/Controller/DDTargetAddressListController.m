
//  DDTargetAddressListController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.


#import "DDTargetAddressListController.h"
#import "DDAddressDetail.h"
#import "DDTargetAddressEditController.h"
#import "YYModel.h"
#import "Constant.h"
#import "UITableViewRowAction+JZExtension.h"
#import "DDInterface.h"
#import "DDPrepareSendViewController.h"
#import "DDGlobalVariables.h"
#import "CustomStringUtils.h"

NSString *const SNavigationItemTitle = @"常用收件地址";
NSString *const SearchBarPlaceholder = @"请输入姓名，地址或手机号";
CGFloat   const SSectionHeaderHeight = 42;
CGFloat   const STableViewRowHeight = 77;


@interface DDTargetAddressListController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DDInterfaceDelegate>
//{
//    /*编辑地址时，用来保存该条地址在所有地址中的位置*/
//    NSUInteger index;
//}

/** 地址列表的展示的数据源 */
@property (nonatomic,strong) NSMutableArray *addressArray;
/**  所有的地址 */
@property (nonatomic,strong) NSMutableArray *allAddressArray;

@property (nonatomic, strong) DDInterface *interfaceAddress;
@property (nonatomic, strong) DDInterface *interfaceDelete;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *headerView;

@end

@implementation DDTargetAddressListController
#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:SNavigationItemTitle segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];

    [self disableBackGesture];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getAddressInfoListRequest];
}

#pragma mark - Table view Delegate && Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.addressArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    DDAddressDetail *addressDetail = [self.addressArray objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",addressDetail.nick, addressDetail.phone];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = DDRGBAColor(51, 51, 51, 1);
    
    if ([CustomStringUtils isBlankString:addressDetail.contentAddress] || ![CustomStringUtils isBlankString:addressDetail.supplementAddress]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",addressDetail.contentAddress, addressDetail.supplementAddress];
    }
    cell.detailTextLabel.textColor = DDRGBAColor(153, 153, 153, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  SSectionHeaderHeight;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return STableViewRowHeight;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    void(^rowActionEdit)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSInteger row = [indexPath row];
        DDAddressDetail *addressDetail = self.allAddressArray[row];
        DDTargetAddressEditController * targetAddressEditView = [[DDTargetAddressEditController alloc] init];
        targetAddressEditView.editAddressDetail = addressDetail;
        targetAddressEditView.isEdit = YES;
        [self.navigationController pushViewController:targetAddressEditView animated:YES];
    };
    void(^rowActionDelete)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSInteger row = [indexPath row];
        NSString * addressId = [(DDAddressDetail *)[self.addressArray objectAtIndex:row] addressID];
        [self deleteAddressInfoWithAddressId:addressId];
        [self.addressArray removeObjectAtIndex:row];
        for (DDAddressDetail * object in self.allAddressArray) {
            if ([object.addressID isEqualToString:addressId]) {
                [self.allAddressArray removeObject:object];
                break;
            }
        }
        [self.tableView reloadData];
        if (self.allAddressArray.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    
    UITableViewRowAction *actionEdit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"edit"] handler:rowActionEdit];
    actionEdit.backgroundColor = DDRGBColor(201, 201, 201);
    
    UITableViewRowAction *actionDelete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"delete"] handler:rowActionDelete];
    actionDelete.backgroundColor = DDRGBColor(255, 56, 17);
    
    return @[actionDelete,actionEdit];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDAddressDetail * selectedAddressDetail = [self.addressArray objectAtIndex:[indexPath row]];
    
    [DDGlobalVariables sharedInstance].targetAddressDetail = selectedAddressDetail;
    for (DDPrepareSendViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[DDPrepareSendViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}



#pragma mark - Event Method
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) searchTextFieldChanged:(id)sender
{
    UITextField * search = (UITextField *) sender;
    NSString * searchString = [search text];
    
    if (searchString.length == 0) {
        self.addressArray = [[NSMutableArray alloc] initWithArray:self.allAddressArray];
    }else{
        self.addressArray = [[NSMutableArray alloc] init];
        for (int i = 0 ; i <self.allAddressArray.count ; i++) {
            DDAddressDetail * object = [self.allAddressArray objectAtIndex:i];
            if ([object.contentAddress containsString:searchString]) {
                [self.addressArray addObject:object];
            }else if ([object.supplementAddress containsString:searchString]) {
                [self.addressArray addObject:object];
            }else if ([object.nick containsString:searchString]) {
                [self.addressArray addObject:object];
            }else if ([object.phone containsString:searchString]) {
                [self.addressArray addObject:object];
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Network Request
- (void)getAddressInfoListRequest
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //信息类型(1寄件 2 收件)
    [param setObject:@2 forKey:@"type"];
    
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
- (void)deleteAddressInfoWithAddressId:(NSString *)addressId
{
    //传参数字典(无模型)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //信息类型(1寄件 2 收件)
    [param setObject:@2 forKey:@"type"];
    
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
    if (interface == self.interfaceAddress)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }else {
            NSMutableArray *mArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in result[@"addrList"]) {
                DDAddressDetail *company = [DDAddressDetail yy_modelWithDictionary:dict];
                company.nick = company.name;
                company.name = @"";
                [mArr addObject:company];
            }
            self.allAddressArray = mArr;
            self.addressArray =  [[NSMutableArray alloc] initWithArray:self.allAddressArray];
            [self.tableView reloadData];
        }
    }else if (interface == self.interfaceDelete)
    {
        if (error) {
            [MBProgressHUD showError:error.domain];
        }
    }
}

#pragma mark - Setter && Getter
- (NSMutableArray *)allAddressArray
{
    if (_allAddressArray == nil) {
        _allAddressArray = [[NSMutableArray alloc]init];
    }
    return _allAddressArray;
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), MainScreenHeight - 64) style:UITableViewStyleGrouped];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        tableView.separatorColor = DDRGBColor(233, 233, 233);
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 42)];
        view.backgroundColor = WHITE_COLOR;
        NSLog(@"%@",NSStringFromCGRect(view.frame));
        UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search"]];
        [image setFrame:CGRectMake(15, 13, 16, 16)];
        NSLog(@"%@",NSStringFromCGRect(image.frame));
        CGFloat searchX = 15 + image.width +8;
        UITextField *search = [[UITextField alloc] initWithFrame:CGRectMake(searchX, 0, view.width - searchX, view.height)];
        [search setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:SearchBarPlaceholder attributes:@{NSForegroundColorAttributeName:KPlaceholderColor}]];
        [search setFont:[UIFont systemFontOfSize:14]];
        [search addTarget:self action:@selector(searchTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(15, view.height -0.5f, view.width - 15, 0.5f)];
        [label setBackgroundColor:BORDER_COLOR];
        
        [view addSubview:image];
        [view addSubview:search];
        [view addSubview:label];
        _headerView = view;
    }
    return _headerView;
}
@end
