//
//  DDActivityController.m
//  DDExpressClient
//
//  Created by Steven.Liu on 16/5/5.
//  Copyright © 2016年 NS. All rights reserved.
//

#import "DDActivityController.h"
#import "DDInterface.h"
#import "DDActivity.h"
#import "YYModel.h"
#import "UIImageView+WebCache.h"


#define DDActivityControllerCellHeight 196
@interface DDActivityController () <UITableViewDataSource, UITableViewDelegate, DDInterfaceDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *activityList;
@property (nonatomic,strong) DDInterface *activityInterface;

@end

@implementation DDActivityController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:KBackground_COLOR];
    
    [self.view addSubview:self.tableView];
    
    [self activityRequest];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.tableView setFrame:self.view.bounds];
}


#pragma mark - TableView DataSource & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.activityList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DDActivityControllerCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ActivityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        [self configureCell:cell];
    }
    
    DDActivity *activity = self.activityList[indexPath.row];
    UIImageView *imageView =  [cell.contentView.subviews firstObject];
    [imageView sd_setImageWithURL:[NSURL URLWithString:activity.activityImage] placeholderImage:[UIImage imageNamed: @"courierBackImage"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(activityController:selectCellWithActivity:)]) {
        [self.delegate activityController:self selectCellWithActivity:self.activityList[indexPath.row]];
    }
}

#pragma mark - Privite Method
- (void)configureCell:(UITableViewCell *)cell
{
    [cell setBackgroundColor:KBackground_COLOR];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setSize:CGSizeMake(self.view.width, DDActivityControllerCellHeight)];

    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat padding = 8;
    [imageView setFrame:CGRectMake(padding*2, padding, cell.width - padding*4, cell.height - padding*2)];
    [cell.contentView addSubview:imageView];
}

#pragma mark - Server Request & Reply
- (void)activityRequest
{
    [self.activityInterface interfaceWithType:INTERFACE_TYPE_ACTIVITY_LIST param:nil];
}

- (void)interface:(DDInterface *)interface result:(NSDictionary *)result error:(NSError *)error
{
    if (interface == self.activityInterface) {
        if (error != nil) {
            [MBProgressHUD showError:error.domain];
            
            // FIXIT : 测试数据
            DDActivity *activity = [[DDActivity alloc] init];
            activity.activityImage = @"http://img.my.csdn.net/uploads/201303/02/1362205387_5682.jpg";
            activity.activityUrl = @"http://img4.imgtn.bdimg.com/it/u=4236942158,2307642402&fm=21&gp=0.jpg";
            [self.activityList addObject:activity];
            
            activity = [[DDActivity alloc] init];
            activity.activityImage = @"http://img.my.csdn.net/uploads/201303/02/1362205387_5682.jpg";
            activity.activityUrl = @"http://img4.imgtn.bdimg.com/it/u=4236942158,2307642402&fm=21&gp=0.jpg";
            [self.activityList addObject:activity];
            
            activity = [[DDActivity alloc] init];
            activity.activityImage = @"http://img.my.csdn.net/uploads/201303/02/1362205387_5682.jpg";
            activity.activityUrl = @"http://img4.imgtn.bdimg.com/it/u=4236942158,2307642402&fm=21&gp=0.jpg";
            [self.activityList addObject:activity];
            
            [self.tableView reloadData];
            ////////////////////
            
        } else {
            NSArray *array = result[@"acList"];
            for (NSDictionary *dict in array) {
                DDActivity *activity = [DDActivity yy_modelWithDictionary:dict];
                [self.activityList addObject:activity];
            }
            
            [self.tableView reloadData];
        }
    }
}

#pragma mark - setter & getter
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        [_tableView setBackgroundColor:KBackground_COLOR];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)activityList
{
    if (_activityList == nil) {
        _activityList = [NSMutableArray array];
    }
    return _activityList;
}

- (DDInterface *)activityInterface
{
    if (_activityInterface == nil) {
        _activityInterface = [[DDInterface alloc] initWithDelegate:self];
    }
    return _activityInterface;
}

@end
