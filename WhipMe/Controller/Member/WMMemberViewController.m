//
//  VMMemberViewController.m
//  WhipMe
//
//  Created by anve on 17/1/9.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMMemberViewController.h"
#import "SetingViewController.h"
#import "MyWalletViewController.h"
#import "WMUserInfoViewController.h"
#import "WMHistoricalReviewController.h"
#import "WMFansAndFocusController.h"

typedef NS_ENUM(NSUInteger, MyTaskType) {
    MyTaskTypeZero = 0,
    MyTaskTypeOne = 1,
};

CGFloat const kHead_WH = 60.0;
NSInteger const kItem_Tag = 7777;

@interface WMMemberViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MemberTableCellDelegate>

@property (nonatomic, strong) UITableView *tableViewWM;
@property (nonatomic, strong) UIView *superviseView, *growView, *viewHead, *view_item;
/** 历史监督 */
@property (nonatomic, strong) NSMutableArray *arraySupervise;
/** 历史养成 */
@property (nonatomic, strong) NSMutableArray *arrayGrow;

@property (nonatomic, strong) UIImageView *imageHead, *iconWallet, *sexView;
@property (nonatomic, strong) UILabel *lblUserName, *lblDescribe, *lblFansNum, *lblFocusNum, *lblWallet;

@property (nonatomic, strong) NSIndexPath *index_delete;

@end

static NSString *identifier_member = @"MemberTableViewCell";
static NSString *identifier_head = @"tableViewView_head";

@implementation WMMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [Define kColorBackGround];
    
    [self setup];
    
    [self queryByUserInfo];
    
    DDRemoveNotificationWithName(KQueryAccountWalletNotification);
    DDAddNotification(@selector(queryAccountByWallet), KQueryAccountWalletNotification);
}

- (void)setData:(UserManager *)userInfo {
    [self.imageHead setImageWithURL:[NSURL URLWithString:userInfo.icon ?:@""] placeholderImage:[Define kDefaultImageHead]];
    
    if (userInfo.sex == 1) {
        self.sexView.image = [UIImage imageNamed:@"gender-m"];
    } else {
        self.sexView.image = [UIImage imageNamed:@"gender-w"];
    }
    
    if ([NSString isBlankString:userInfo.nickname]) {
        self.lblUserName.text = @"学习者";
    } else {
        self.lblUserName.text = userInfo.nickname;
    }
    CGSize size_userName = [self.lblUserName.text sizeWithAttributes:@{NSFontAttributeName:self.lblUserName.font}];
    [self.lblUserName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MIN(floorf(size_userName.width)+1, [Define screenWidth]-kHead_WH-54.0));
    }];
    
    if ([NSString isBlankString:userInfo.sign]) {
        self.lblDescribe.text = @"监督，是一种责任";
    } else {
        self.lblDescribe.text = userInfo.sign;
    }
    
    self.lblWallet.text = [NSString stringWithFormat:@"%.2f",[userInfo.wallet floatValue]];
    self.lblFansNum.text = [NSString stringWithFormat:@"%ld",(long)[userInfo.fansNum integerValue]];
    self.lblFocusNum.text = [NSString stringWithFormat:@"%ld",(long)[userInfo.focusNum integerValue]];
}

- (void)setup {
    WEAK_SELF
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"set_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(clickWithRightBarItem)];
    rightBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    _viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Define screenWidth], 145.0)];
    _viewHead.backgroundColor = [UIColor whiteColor];
    
    UIView *line_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewHead.width, 14.0)];
    line_view.backgroundColor = [Define kColorBackGround];
    _tableViewWM = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableViewWM.backgroundColor = [UIColor clearColor];
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.emptyDataSetSource = self;
    _tableViewWM.emptyDataSetDelegate = self;
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewWM.tableFooterView = line_view;
    _tableViewWM.tableHeaderView = self.viewHead;
    [self.view addSubview:_tableViewWM];
    [_tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(weakSelf.view);
        make.width.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view);
    }];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf queryByUserInfo];
    }];
    
    [self.tableViewWM registerClass:[MemberTableViewCell class] forCellReuseIdentifier:identifier_member];
    [self.tableViewWM registerClass:[MemberHeadViewCell class] forCellReuseIdentifier:identifier_head];
    
    _imageHead = [[UIImageView alloc] init];
    _imageHead.backgroundColor = [Define kColorBackGround];
    _imageHead.layer.cornerRadius = kHead_WH/2.0;
    _imageHead.layer.masksToBounds = YES;
    _imageHead.contentMode = UIViewContentModeScaleAspectFill;
    _imageHead.clipsToBounds = YES;
    _imageHead.userInteractionEnabled = YES;
    [_viewHead addSubview:self.imageHead];
    [self.imageHead mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewHead).offset(20.0);
        make.top.equalTo(weakSelf.viewHead).offset(14.0);
        make.size.mas_equalTo(CGSizeMake(kHead_WH, kHead_WH));
    }];
    _sexView = [[UIImageView alloc] init];
    [_viewHead addSubview:_sexView];
    [_sexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(17);
        make.trailing.bottom.mas_equalTo(_imageHead);
    }];
    
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWithHead)];
    [self.imageHead addGestureRecognizer:tapGr];
   
    _lblUserName = [[UILabel alloc] init];
    _lblUserName.backgroundColor = [UIColor clearColor];
    _lblUserName.textColor = rgb(51, 51, 51);
    _lblUserName.font = [UIFont systemFontOfSize:18.0];
    _lblUserName.textAlignment = NSTextAlignmentLeft;
    _lblUserName.userInteractionEnabled = YES;
    [self.viewHead addSubview:self.lblUserName];
    [self.lblUserName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageHead.mas_right).offset(14.0);
        make.top.mas_equalTo(24);
        make.height.mas_equalTo(20.0);
        make.width.mas_equalTo(60.0);
    }];
    
    _iconWallet = [[UIImageView alloc] init];
    _iconWallet.backgroundColor = [UIColor clearColor];
    _iconWallet.image = [UIImage imageNamed:@"wallet_green_off"];
    _iconWallet.userInteractionEnabled = YES;
    [self.viewHead addSubview:self.iconWallet];
    
    UITapGestureRecognizer *tap_wallet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWithWallet)];
    [self.iconWallet addGestureRecognizer:tap_wallet];
    
    [self.iconWallet mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lblUserName.mas_right).offset(10);
        make.top.equalTo(weakSelf.lblUserName.mas_top);
        make.size.mas_equalTo(CGSizeMake(20.0, 20.0));
    }];
    
    _lblDescribe = [[UILabel alloc] init];
    _lblDescribe.backgroundColor = [UIColor clearColor];
    _lblDescribe.textColor = [Define kColorGray];
    _lblDescribe.font = [UIFont systemFontOfSize:13.0];
    _lblDescribe.textAlignment = NSTextAlignmentLeft;
    _lblDescribe.text = @"监督，是一种责任！";
    [self.viewHead addSubview:self.lblDescribe];
    [self.lblDescribe mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageHead.mas_right).offset(14.0);
        make.top.equalTo(weakSelf.lblUserName.mas_bottom).offset(10.0);
        make.right.equalTo(weakSelf.viewHead).offset(-20.0);
        make.height.mas_equalTo(20);
    }];
    
    UIView *line_head = [[UIView alloc] init];
    line_head.backgroundColor = [Define kColorLine];
    [self.viewHead addSubview:line_head];
    [line_head mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewHead);
        make.width.equalTo(weakSelf.viewHead);
        make.top.mas_equalTo(89.5);
        make.height.mas_equalTo(0.5);
    }];
    
    _view_item = [[UIView alloc] init];
    _view_item.backgroundColor = [UIColor clearColor];
    [self.viewHead addSubview:self.view_item];
    [self.view_item mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.viewHead);
        make.width.equalTo(weakSelf.viewHead);
        make.top.mas_equalTo(90.0);
        make.height.mas_equalTo(55.0);
    }];
    
    NSArray *titles = [NSArray arrayWithObjects:@"钱包",@"关注",@"粉丝", nil];
    UIImage *image_normal = [UIImage imageWithDraw:rgb(247, 247, 247) sizeMake:CGRectMake(0, 0, 20.0, 20.0)];
    image_normal = [image_normal stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    CGFloat origin_x = 0.0f;
    CGFloat size_item_w = [Define screenWidth]/3.0;
    NSInteger item_tag = kItem_Tag;
    for (NSString *itemStr in titles) {
        UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal];
        [itemButton setBackgroundImage:image_normal forState:UIControlStateHighlighted];
        [itemButton setTitle:itemStr forState:UIControlStateNormal];
        [itemButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [itemButton setContentVerticalAlignment:UIControlContentVerticalAlignmentBottom];
        [itemButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 10.0, 0)];
        [itemButton setTitleColor:[Define kColorGray] forState:UIControlStateNormal];
        [itemButton setTitleColor:self.lblDescribe.textColor forState:UIControlStateHighlighted];
        [itemButton addTarget:self action:@selector(onClickWithItem:) forControlEvents:UIControlEventTouchUpInside];
        [itemButton setTag:item_tag];
        [self.view_item addSubview:itemButton];
        [itemButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view_item);
            make.height.equalTo(weakSelf.view_item);
            make.left.mas_equalTo(origin_x);
            make.width.mas_equalTo(size_item_w);
        }];
        
        UILabel *itemLbl = [[UILabel alloc] init];
        itemLbl.backgroundColor = [UIColor clearColor];
        itemLbl.textColor = self.lblUserName.textColor;
        itemLbl.textAlignment = NSTextAlignmentCenter;
        itemLbl.font = [UIFont systemFontOfSize:14.0];
        itemLbl.text = @"23";
        itemLbl.userInteractionEnabled = false;
        [itemButton addSubview:itemLbl];
        [itemLbl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.width.equalTo(itemButton);
            make.top.mas_equalTo(10.0);
            make.height.mas_equalTo(16.0);
        }];
        if (itemButton.tag == kItem_Tag) {
            _lblWallet = itemLbl;
        } else if (itemButton.tag == kItem_Tag+1) {
            _lblFocusNum = itemLbl;
        } else {
            _lblFansNum = itemLbl;
        }
        
        origin_x += size_item_w;
        item_tag += 1;
    }
    
}

- (void)clickWithRightBarItem {
    SetingViewController *controller = [SetingViewController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)clickWithHead {
//    WMUserInfoViewController *controller = [WMUserInfoViewController new];
//    controller.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:controller animated:YES];
    UserManager *info = [UserManager shared];
    if ([NSString isBlankString:info.icon]) {
        return;
    }
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:info.icon];
    photo.srcImageView = self.imageHead;
    
    brower.photos = [NSMutableArray arrayWithObjects:photo, nil];
    brower.currentPhotoIndex = 0;
    [brower show];
}

- (void)clickWithWallet {
    MyWalletViewController *controller = [MyWalletViewController new];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onClickWithItem:(UIButton *)sender {
    NSInteger index = sender.tag%kItem_Tag;
    if (index == 0) {
        [self clickWithWallet];
    } else {
        WMFansAndFocusStyle style = WMFansAndFocusStyleFans;
        if (index == 1) {
            style = WMFansAndFocusStyleFocus;
        }
        WMFansAndFocusController *controller = [[WMFansAndFocusController alloc] initWithStyle:style];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setData:[UserManager shared]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    DDRemoveNotificationObserver();
    DebugLog(@"%@",NSStringFromClass(self.class));
}


#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgb(212.0, 212.0, 212.0)};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"尚未有任何历史记录！" attributes:attribute];
    return string;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UITableViewDelegate Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.arraySupervise.count+1;
    }
    return self.arrayGrow.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [MemberHeadViewCell cellHeight];
    }
    mySuperviseModel *model = nil;
    if (indexPath.section == 0) {
        model = [self.arraySupervise objectAtIndex:indexPath.row-1];
    } else {
        model = [self.arrayGrow objectAtIndex:indexPath.row-1];
    }
    if (model && model.threeDay.count == 0) {
        return 72.0;
    }
    return 190.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MemberHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_head];
        if (indexPath.section == 0) {
            [cell setTitleWithTitle:@"我的历史监督"];
        } else {
            [cell setTitleWithTitle:@"我的历史养成"];
        }
        return cell;
    }
    MemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_member];
    [cell setMemberDelegate:self];
    if (indexPath.section == 0) {
        [cell setModel:self.arraySupervise[indexPath.row-1]];
        [cell setData_Supervision];
    } else {
        [cell setModel:self.arrayGrow[indexPath.row-1]];
        [cell setData];
    }
    if (indexPath.row+1 == [tableView numberOfRowsInSection:indexPath.section]) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    mySuperviseModel *model = nil;
    NSString *control_title = @"";
    UserManager *info = [UserManager shared];
    if (indexPath.section == 0 && self.arraySupervise.count > indexPath.row-1) {
        model = [self.arraySupervise objectAtIndex:indexPath.row-1];
        control_title = [NSString stringWithFormat:@"%@历史监督",info.nickname];
    } else {
        if (self.arrayGrow.count > indexPath.row-1) {
            model = [self.arrayGrow objectAtIndex:indexPath.row-1];
            control_title = [NSString stringWithFormat:@"%@历史养成",info.nickname];
        }
    }
    if (model == nil) {
        return;
    }
    WhipM *whip = [[WhipM alloc] init];
    whip.taskId = model.taskId;
    whip.themeName = model.themeName;
    
    TaskDetailController *controller = [TaskDetailController new];
    controller.navigationItem.title = control_title;
    controller.myWhipM = whip;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"Action - tableView");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _index_delete = indexPath;
        mySuperviseModel *model = nil;
        MyTaskType type = MyTaskTypeZero;
        if (indexPath.section == 0 && self.arraySupervise.count > indexPath.row-1) {
            type = MyTaskTypeOne;
            model = [self.arraySupervise objectAtIndex:indexPath.row-1];
        } else {
            type = MyTaskTypeZero;
            if (self.arrayGrow.count > indexPath.row-1) {
                model = [self.arrayGrow objectAtIndex:indexPath.row-1];
            }
        }
        [self removeTask:model flag:type];
    }
}

#pragma mark - MemberTableCellDelegate
- (void)memberTableViewWithCell:(MemberTableViewCell *)cell threeDay:(NSArray *)threeDay row:(NSInteger)row {
    if (threeDay.count <= row) {
        return;
    }
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    NSMutableArray *arrayPhoto = [NSMutableArray new];
    for (NSInteger i=0; i<threeDay.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MemberCollectionViewCell *colletionCell = (MemberCollectionViewCell *)[cell.collectionViewWM cellForItemAtIndexPath:indexPath];
        threeDayModel *model = [threeDayModel mj_objectWithKeyValues:threeDay[i]];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:model.picture];
        photo.srcImageView = colletionCell.imageIcon;
        [arrayPhoto addObject:photo];
    }
    
    brower.photos = arrayPhoto;
    brower.currentPhotoIndex = row;
    [brower show];
}

- (void)memberTableViewWithCell:(MemberTableViewCell *)cell model:(mySuperviseModel *)model {
    WhipM *whip = [[WhipM alloc] init];
    whip.themeId = model.themeId;
    whip.themeName = model.themeName;
    
    ClassifyController *controller = [ClassifyController new];
    controller.myWhipM = whip;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];

    DebugLog(@"_____%@",model.themeName);
}

#pragma mark - set get
- (NSMutableArray *)arrayGrow {
    if (!_arrayGrow) {
        _arrayGrow = [NSMutableArray array];
    }
    return _arrayGrow;
}

- (NSMutableArray *)arraySupervise {
    if (!_arraySupervise) {
        _arraySupervise = [NSMutableArray array];
    }
    return _arraySupervise;
}

#pragma mark - Network
/** 获取用户账户余额 */
- (void)queryAccountByWallet {
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"userId":user.userId ?: @""};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryAccountById" params:param Success:^(id result) {
        
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            CGFloat float_wallet = [data[@"account"] floatValue];
            UserManager *model = [UserManager shared];
            model.wallet = [NSString stringWithFormat:@"%.2f",float_wallet];
            [weakSelf setData:model];
            
            NSMutableDictionary *dict_value = [model mj_keyValues];
            [UserManager storeUserWithDict:dict_value];
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        
    }];
}

- (void)queryByUserInfo {
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"userId":user.userId ?: @""};
    
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"queryUserInfo" params:param Success:^(id result) {
        DebugLog(@"____result:%@",result);
        [self.tableViewWM.mj_header endRefreshing];
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            NSDictionary *info = [data objectForKey:@"userInfo"];
            UserManager *model = [UserManager shared];
            model.sign = info[@"sign"];
            model.wallet = [NSString stringWithFormat:@"%.2f",[info[@"account"] floatValue]];
            model.fansNum = [NSString stringWithFormat:@"%ld",[info[@"fansNum"] integerValue]];
            model.focusNum = [NSString stringWithFormat:@"%ld",[info[@"focusNum"] integerValue]];
            [weakSelf setData:model];
            
            NSMutableDictionary *dict_value = [model mj_keyValues];
            [UserManager storeUserWithDict:dict_value];
            
            [self.arrayGrow removeAllObjects];
            for (id obj in data[@"myGrow"]) {
                mySuperviseModel *item = [mySuperviseModel mj_objectWithKeyValues:obj];
                [self.arrayGrow addObject:item];
            }
            
            [self.arraySupervise removeAllObjects];
            for (id obj in data[@"mySupervise"]) {
                mySuperviseModel *item = [mySuperviseModel mj_objectWithKeyValues:obj];
                [self.arraySupervise addObject:item];
            }
            [weakSelf.tableViewWM reloadData];
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        [self.tableViewWM.mj_header endRefreshing];
    }];
}

/*taskType : 此任务是（0：历史养成  1：历史监督）*/
- (void)removeTask:(mySuperviseModel *)model flag:(MyTaskType)type {
    if (model == nil) {
        return;
    }
    UserManager *user = [UserManager shared];
    NSDictionary *param = @{@"loginId":user.userId ?: @"",
                            @"taskId":model.taskId ?: @"",
                            @"taskType":[NSString stringWithFormat:@"%ld",(long)type],
                            };
    WEAK_SELF
    [HttpAPIClient APIClientPOST:@"removeTask" params:param Success:^(id result) {
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] intValue] == 0) {
            if (type == MyTaskTypeOne) {
                if (self.arraySupervise.count > self.index_delete.row-1) {
                    [self.arraySupervise removeObjectAtIndex:self.index_delete.row-1];
                }
                UITableViewCell *cell = [weakSelf.tableViewWM cellForRowAtIndexPath:weakSelf.index_delete];
                if (cell && [self.arraySupervise count] > 0) {
                    [weakSelf.tableViewWM deleteRowsAtIndexPaths:@[weakSelf.index_delete] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [weakSelf.tableViewWM reloadData];
                }
            } else {
                if (self.arrayGrow.count > self.index_delete.row-1) {
                    [self.arrayGrow removeObjectAtIndex:self.index_delete.row-1];
                }
                UITableViewCell *cell = [weakSelf.tableViewWM cellForRowAtIndexPath:weakSelf.index_delete];
                if (cell && [self.arrayGrow count] > 0) {
                    [weakSelf.tableViewWM deleteRowsAtIndexPaths:@[weakSelf.index_delete] withRowAnimation:UITableViewRowAnimationFade];
                } else {
                    [weakSelf.tableViewWM reloadData];
                }
            }
        } else {
            if ([NSString isBlankString:data[@"desc"]] == NO) {
                [Tool showHUDTipWithTipStr:[NSString stringWithFormat:@"%@",data[@"desc"]]];
            }
        }
    } Failed:^(NSError *error) {
        
    }];
}

@end
