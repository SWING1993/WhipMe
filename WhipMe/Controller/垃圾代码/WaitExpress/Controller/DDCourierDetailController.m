//
//  DDCourierDetailController.m
//  DDExpressClient
//
//  Created by ywp on 16-2-23.
//  Copyright (c) 2016年 诺晟. All rights reserved.
//

#import "DDCourierDetailController.h"
#import "DDCourierDetail.h"
#import "DDCourierEvaluate.h"   //快递员评价信息表
#import "DDCourierEvaluateCell.h"
#import "DDCourierDetailHeaderView.h"
#import "Constant.h"
#import "DDInterface.h"
#import "YYModel.h"
//#import "DDHomeController.h"



/**
 *  imageView的高度
 */
#define COURIER_DETAIL_TITLEIMAGE_HEIGHT 238
/**    评价行高度 */
#define COURIER_DETAIL_APPRAISE_HEIGHT 62




@interface DDCourierDetailController ()<UITableViewDelegate, UITableViewDataSource,DDInterfaceDelegate>

/** 评价列表 */
@property (strong, nonatomic) UITableView *tableView;
/** 快递员头视图 */
@property (strong, nonatomic) DDCourierDetailHeaderView *headerView;
/** 快递员信息模型 */
@property (nonatomic, strong) DDCourierDetail *courierInfo;
/**<  快递员评价信息列表  */
@property (nonatomic, strong) NSMutableArray *courierEvalueteArr;
@property (nonatomic, assign) NSInteger pageIndex;

/**<  快递员评价列表  */
@property (nonatomic, strong) DDInterface *evaluateInterface;
/**<  快递员详细信息  */
@property (nonatomic, strong) DDInterface *courierinterface;

//**<  快递员Id  *//
@property (nonatomic, strong) NSString *courierId;


@end

@implementation DDCourierDetailController

- (instancetype)initWithCourierId:(NSString *)courier
{
    self = [super init];
    if (self) {
        self.courierId = courier;
        
    }
    return self;
}

#pragma mark - 视图声明周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self adaptNavBarWithBgTag:CustomNavigationBarColorWhite navTitle:@"快递员主页" segmentArray:nil];
    [self adaptLeftItemWithNormalImage:ImageNamed(DDBackGreenBarIcon) highlightedImage:ImageNamed(DDBackGreenBarIcon)];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];

    
    /**<  加载快递员评价列表  */
    [self evaluateListRequest];
    /**<  快递员详细信息  */
    [self courierDetailRequest];
}

#pragma mark - Button Click Event
- (void)onClickLeftItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courierEvalueteArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COURIER_DETAIL_APPRAISE_HEIGHT;
}

/** 设置cell  */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *const DDCourierEvaluateCellReuseIdentity = @"courierEvaluateCell";
    DDCourierEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:DDCourierEvaluateCellReuseIdentity];
    if (cell == nil) {
        cell = [[DDCourierEvaluateCell alloc] initWithFrame:CGRectMake(0, 0, self.view.width, COURIER_DETAIL_APPRAISE_HEIGHT)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.courierEvalueteArr[indexPath.row];
    return cell;
}

#pragma mark - Server Request
/**<  加载快递员评价列表  */
- (void)evaluateListRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[NSString stringWithFormat:@"%@",self.courierId] forKey:@"couId"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.pageIndex] forKey:@"page"];
    
    [self.evaluateInterface interfaceWithType:INTERFACE_TYPE_EVALUATE_LIST param:param];
}

/**<  快递员详细信息  */
- (void)courierDetailRequest
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setObject:[NSString stringWithFormat:@"%@",self.courierId] forKey:@"couId"];
    
    [self.courierinterface interfaceWithType:INTERFACE_TYPE_COURIIER_INFO param:param];
}

#pragma mark - DDInterfaceDelegate
- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.evaluateInterface)
    {
        NSLog(@"快递员详情评价列表");
        NSLog(@"_________result:%@______error:%@",result, error);
        if (error)
        {
            [MBProgressHUD showError:error.domain];
        } else {
            [self.courierEvalueteArr removeAllObjects];
            
            for (NSDictionary *itemModel in result[@"evlList"]) {
                DDCourierEvaluate *evaModel = [DDCourierEvaluate yy_modelWithDictionary:itemModel];
                evaModel.evaluateDate = [DDCourierEvaluate timeWithTimeInterval:evaModel.evaluateDate];
                
                [self.courierEvalueteArr addObject:evaModel];
            }
            [self.tableView reloadData];
        }
    }
    else if (interface == self.courierinterface)
    {
        NSLog(@"快递员详细信息");
        NSLog(@"_________result:%@______error:%@",result, error);
        if (error) {
            [MBProgressHUD showError:error.domain];
        } else {
            DDCourierDetail *orderDetail = [DDCourierDetail yy_modelWithDictionary:result];
            self.courierInfo = orderDetail;
        }
    }
}

#pragma mark - setter & getter
- (void)setCourierInfo:(DDCourierDetail *)courierInfo
{
    _courierInfo = courierInfo;
    self.headerView.detailModel = courierInfo;
}

- (NSMutableArray *)courierEvalueteArr
{
    if (!_courierEvalueteArr) {
        _courierEvalueteArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _courierEvalueteArr;
}

- (NSInteger)pageIndex
{
    if (_pageIndex < 1) {
        _pageIndex = 1;
    }
    return _pageIndex;
}

- (DDCourierDetailHeaderView *)headerView
{
    if (_headerView == nil) {
        DDCourierDetailHeaderView *headerViewr = [[DDCourierDetailHeaderView alloc] init];
        headerViewr.frame = CGRectMake(0, KNavHeight, self.view.width, 238.0f);
        headerViewr.backgroundColor = [UIColor redColor];
        headerViewr.detailModel = _courierInfo;
        
        _headerView = headerViewr;
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.height - KNavHeight)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView = tableView;
    }
    return _tableView;
}

- (DDInterface *)evaluateInterface
{
    if (_evaluateInterface == nil) {
        _evaluateInterface = [[DDInterface alloc] initWithDelegate:self];
    }
    return _evaluateInterface;
}

- (DDInterface *)courierinterface
{
    if (_courierinterface == nil) {
        _courierinterface = [[DDInterface alloc] initWithDelegate:self];
    }
    return _courierinterface;
}

@end
