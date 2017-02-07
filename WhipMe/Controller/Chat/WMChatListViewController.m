//
//  WMChatListViewController.m
//  WhipMe
//
//  Created by anve on 17/1/11.
//  Copyright © 2017年 -. All rights reserved.
//

#import "WMChatListViewController.h"
#import "JCHATConversationViewController.h"

@interface WMChatListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSMutableArray<JMSGConversation *> *arrayContent;
@property (nonatomic, strong) UITableView *tableViewWM;

@end

static NSString *identifier_cell = @"ChatConversationListCell";
@implementation WMChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[Define kColorBackGround]];
    
    DDRemoveNotificationWithName(kAllConversationsNotification);
    DDAddNotification(@selector(getConversationList), kAllConversationsNotification);
    
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getConversationList];
    
    [[ChatMessage shareChat] loginJMessage];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    DDRemoveNotificationObserver();
    DebugLog(@"%@",NSStringFromClass(self.class));
}

- (void)setup {
    
    WEAK_SELF
    _tableViewWM = [UITableView new];
    _tableViewWM.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableViewWM.separatorColor = [Define kColorLine];
    _tableViewWM.layoutMargins = UIEdgeInsetsZero;
    _tableViewWM.separatorInset = UIEdgeInsetsZero;
    _tableViewWM.backgroundColor = [UIColor clearColor];
    _tableViewWM.delegate = self;
    _tableViewWM.dataSource = self;
    _tableViewWM.emptyDataSetSource = self;
    _tableViewWM.emptyDataSetDelegate = self;
    _tableViewWM.tableFooterView = [UIView new];
    [self.view addSubview:self.tableViewWM];
    [self.tableViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(weakSelf.view);
        make.width.mas_equalTo([Define screenWidth]);
        make.height.mas_equalTo([Define screenHeight]-64.0 - 49.0);
    }];
    [self.tableViewWM registerClass:[ChatConversationListCell class] forCellReuseIdentifier:identifier_cell];
    self.tableViewWM.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getConversationList];
    }];
}

#pragma mark - Action
- (void)getConversationList {
    WEAK_SELF
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        [weakSelf.tableViewWM.mj_header endRefreshing];
        
        if (error == nil) {
            [weakSelf.arrayContent removeAllObjects];
            weakSelf.arrayContent = [weakSelf sortConversation:resultObject];
            NSInteger _unreadCount = 0;
            for (JMSGConversation *conversation in weakSelf.arrayContent) {
                _unreadCount += [conversation.unreadCount integerValue];
            }
            
            [self saveBadge:_unreadCount];
        } else {
            [weakSelf.arrayContent removeAllObjects];
        }
        [weakSelf.tableViewWM reloadData];
    }];
}

- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr
{
    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
}

NSInteger sortType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

- (void)saveBadge:(NSInteger)badge
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSString stringWithFormat:@"%ld",(long)badge] forKey:[Define kBADGE]];
    [userDefault synchronize];
}

- (void)updateBadge:(NSInteger)badge {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger _unreadCount = [[userDefault objectForKey:[Define kBADGE]] integerValue];
    NSInteger _newCount = _unreadCount - badge;
    
    [userDefault setObject:[NSString stringWithFormat:@"%ld",(long)_newCount] forKey:[Define kBADGE]];
    [userDefault synchronize];
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"no_data"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgb(212.0, 212.0, 212.0)};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"尚无任何私信！" attributes:attribute];
    return string;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UITableViewDelegate and Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatConversationListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_cell];
    [cell setCellWithModel:self.arrayContent[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JMSGConversation *conversation = [self.arrayContent objectAtIndex:indexPath.row];
    [self updateBadge:[conversation.unreadCount integerValue]];
    
    JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    sendMessageCtl.superViewController = self;
    sendMessageCtl.conversation = conversation;
    [self.navigationController pushViewController:sendMessageCtl animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"Action - tableView");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        JMSGConversation *conversation = [self.arrayContent objectAtIndex:indexPath.row];
        
        if (conversation.conversationType == kJMSGConversationTypeSingle) {
            [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username appKey:[Define appKeyJMessage]
             ];
        } else {
            [JMSGConversation deleteGroupConversationWithGroupId:((JMSGGroup *)conversation.target).gid];
        }
        [self.arrayContent removeObjectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell && [self.arrayContent count] > 0) {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView reloadData];
        }
    }
}

#pragma mark - JMessageDelegate


#pragma mark - set get
- (NSMutableArray<JMSGConversation *> *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}
#pragma mark - network
- (void)queryByNotification {
    
}


@end
