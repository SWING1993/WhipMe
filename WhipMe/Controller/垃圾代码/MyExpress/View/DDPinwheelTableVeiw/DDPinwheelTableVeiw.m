//
//  DDPinwheelTableVeiw.m
//  DuDu Courier
//
//  Created by yangg on 16/3/31.
//  Copyright © 2016年 yangg. All rights reserved.
//
/**
 大风车表格视图，解决左右滑动表格视图（新闻类表格效果）,无下拉刷新
 */
#define KPage_Size 20

#import "DDPinwheelTableVeiw.h"
#import "DDParcelTableViewCell.h"

#import "Constant.h"
#import "MJRefresh.h"
#import "UITableView+DefaultPage.h"

@interface DDPinwheelTableVeiw () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    /** 状态 (0:左边没有,1:右边没有，2:左右都有界面)*/
    DDPinwheelViewStyle _currentPinwheel;
    /** 界面总数 */
    NSInteger _totalCount;
    /** 当前界面下标 */
    NSInteger _nowIndex;
    /** 下一个界面下标 */
    NSInteger _newIndex;
    
    CGFloat KPAGE_WIDTH;
}
@property (nonatomic, strong) UIScrollView *detailScroll;

/** 表格数组 */
@property (nonatomic, strong) NSMutableArray *arrayFirst;
@property (nonatomic, strong) NSMutableArray *arraySecond;
@property (nonatomic, strong) NSMutableArray *arrayThird;

/** 表格视图 */
@property (nonatomic, strong) UITableView  *viewFirst;
@property (nonatomic, strong) UITableView  *viewSecond;
@property (nonatomic, strong) UITableView  *viewThird;

/** UITableViewDelegate UITableViewDataSource 表格协议 */
@property (nonatomic, assign) id delegate;

@end

@implementation DDPinwheelTableVeiw

#pragma mark - 初始化UI
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        _totalCount = 0;
        _nowIndex = 0;
        _currentPinwheel = DDPinwheelLeftNo;
        
        KPAGE_WIDTH = [UIScreen mainScreen].bounds.size.width;
        
        [self setup];
    }
    return self;
}

#pragma mark - 初始化界面布局
- (void)setup
{
    [self.detailScroll setFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    [self addSubview:self.detailScroll];
    
    /** 第一个表格 */
    for (NSInteger i=0; i<3; i++) {
        UIView *viewItem = [[UIView alloc] initWithFrame:CGRectMake(KPAGE_WIDTH*i, 0, KPAGE_WIDTH, CGRectGetHeight(self.detailScroll.frame))];
        [viewItem setBackgroundColor:[UIColor whiteColor]];
        
        if (i == 0) {
            [self.viewFirst setFrame:viewItem.bounds];
            [viewItem addSubview:self.viewFirst];
        } else if (i == 1) {
            [self.viewSecond setFrame:viewItem.bounds];
            [viewItem addSubview:self.viewSecond];
        } else {
            [self.viewThird setFrame:viewItem.bounds];
            [viewItem addSubview:self.viewThird];
        }
        
        [self.detailScroll addSubview:viewItem];
    }
    [self.detailScroll setContentSize:CGSizeMake(KPAGE_WIDTH*3.0f, CGRectGetHeight(self.detailScroll.frame))];
    
    [self tableViewRefresh:self.viewFirst];
    [self tableViewRefresh:self.viewSecond];
    [self tableViewRefresh:self.viewThird];
    
    [self setDelegate:self];
}

- (void)tableViewRefresh:(UITableView *)tableView
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self tableViewHeaderRefresh];
    }];
    [header setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    header.stateLabel.font = kTimeFont;
    header.lastUpdatedTimeLabel.font = kTimeFont;
    header.stateLabel.textColor = KPlaceholderColor;
    header.lastUpdatedTimeLabel.textColor = KPlaceholderColor;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self tableViewFoorterRefresh];
    }];
    [footer setTitle:@"上拉可以刷新" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在刷新数据中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = kTimeFont;
    footer.stateLabel.textColor = KPlaceholderColor;
    tableView.mj_footer = footer;
    tableView.mj_header = header;
    
}

- (void)setDelegate:(id)delegate
{
    [self.viewFirst setDelegate:delegate];
    [self.viewFirst setDataSource:delegate];
    
    [self.viewSecond setDelegate:delegate];
    [self.viewSecond setDataSource:delegate];
    
    [self.viewThird setDelegate:delegate];
    [self.viewThird setDataSource:delegate];
}

/** 表格数据为空时的提示消息 */
- (void)resultWithImage:(NSString *)imageName withContent:(NSString *)contentText withButtonTitle:(NSString *)titleButton
{
    if (self.viewFirst.defaultPageView || self.viewSecond.defaultPageView || self.viewThird.defaultPageView) {
        [self.viewFirst setDefaultPageWithImageName:imageName andTitle:contentText andSubTitle:nil andBtnImage:nil andbtnTitle:titleButton andBtnAction:@selector(notResultView) withTarget:self];
        [self.viewSecond setDefaultPageWithImageName:imageName andTitle:contentText andSubTitle:nil andBtnImage:nil andbtnTitle:titleButton andBtnAction:@selector(notResultView) withTarget:self];
        [self.viewThird setDefaultPageWithImageName:imageName andTitle:contentText andSubTitle:nil andBtnImage:nil andbtnTitle:titleButton andBtnAction:@selector(notResultView) withTarget:self];
    } else {
        [self.viewFirst addDefaultPageWithImageName:imageName andTitle:contentText andSubTitle:nil andBtnImage:nil andbtnTitle:titleButton andBtnAction:@selector(notResultView) withTarget:self];
        [self.viewSecond addDefaultPageWithImageName:imageName andTitle:contentText andSubTitle:nil andBtnImage:nil andbtnTitle:titleButton andBtnAction:@selector(notResultView) withTarget:self];
        [self.viewThird addDefaultPageWithImageName:imageName andTitle:contentText andSubTitle:nil andBtnImage:nil andbtnTitle:titleButton andBtnAction:@selector(notResultView) withTarget:self];
    }
}

- (void)endRefreshingPinwheel
{
    [self.viewFirst.mj_header endRefreshing];
    [self.viewSecond.mj_header endRefreshing];
    [self.viewThird.mj_header endRefreshing];
    
    [self.viewFirst.mj_footer endRefreshing];
    [self.viewSecond.mj_footer endRefreshing];
    [self.viewThird.mj_footer endRefreshing];
}

#pragma mark - Action Index

- (void)tableViewFoorterRefresh
{
    if ([self.pinwheelDelegate respondsToSelector:@selector(foorterRefreshWithPinwheelTableView)]) {
        [self.pinwheelDelegate foorterRefreshWithPinwheelTableView];
    }
}

- (void)tableViewHeaderRefresh
{
    if ([self.pinwheelDelegate respondsToSelector:@selector(headerRefreshWithPinwheelTableView)]) {
        [self.pinwheelDelegate headerRefreshWithPinwheelTableView];
    }
}

/** 刷新表格 */
- (void)reloadDataDDPinwheelTableVeiw:(DDPinwheelViewStyle)pinwheelViewStyle
{
    [self.viewFirst reloadData];
    [self.viewSecond reloadData];
    [self.viewThird reloadData];
    
    if (DDPinwheelOnlyOne == pinwheelViewStyle) {
        BOOL flagFirst = [self.arrayFirst count] > 0 ? true : false;
        [self.viewFirst.defaultPageView setHidden:flagFirst];
        
        if ([self.arrayFirst count] == 0) {
            [self.viewFirst.mj_footer setHidden:true];
        } else {
            BOOL footFirst = [self.arrayFirst count]%KPage_Size > 0 ? true : false;
            [self.viewFirst.mj_footer setHidden:footFirst];
        }
    } else if (DDPinwheelLeftNo == pinwheelViewStyle || DDPinwheelRightNo == pinwheelViewStyle) {
        BOOL flagFirst  = [self.arrayFirst count] > 0 ? true : false;
        BOOL flagSecond = [self.arraySecond count] > 0 ? true : false;
        [self.viewFirst.defaultPageView  setHidden:flagFirst];
        [self.viewSecond.defaultPageView setHidden:flagSecond];
        
        if ([self.arrayFirst count] == 0) {
            [self.viewFirst.mj_footer setHidden:true];
        } else {
            BOOL footFirst = [self.arrayFirst count]%KPage_Size > 0 ? true : false;
            [self.viewFirst.mj_footer setHidden:footFirst];
        }
        
        if ([self.arraySecond count] == 0) {
            [self.viewSecond.mj_footer setHidden:true];
        } else {
            BOOL footSecond = [self.arraySecond count]%KPage_Size > 0 ? true : false;
            [self.viewSecond.mj_footer setHidden:footSecond];
        }
        
     } else {
        BOOL flagFirst  = [self.arrayFirst count] > 0 ? true : false;
        BOOL flagSecond = [self.arraySecond count] > 0 ? true : false;
        BOOL flagThird  = [self.arrayThird count] > 0 ? true : false;
        [self.viewFirst.defaultPageView  setHidden:flagFirst];
        [self.viewSecond.defaultPageView setHidden:flagSecond];
        [self.viewThird.defaultPageView  setHidden:flagThird];
         
        if ([self.arrayFirst count] == 0) {
            [self.viewFirst.mj_footer setHidden:true];
        } else {
            BOOL footFirst = [self.arrayFirst count]%KPage_Size > 0 ? true : false;
            [self.viewFirst.mj_footer setHidden:footFirst];
        }

        if ([self.arraySecond count] == 0) {
            [self.viewSecond.mj_footer setHidden:true];
        } else {
            BOOL footSecond = [self.arraySecond count]%KPage_Size > 0 ? true : false;
            [self.viewSecond.mj_footer setHidden:footSecond];
        }

        if ([self.arrayThird count] == 0) {
            [self.viewThird.mj_footer setHidden:true];
        } else {
            BOOL footSecond = [self.arrayThird count]%KPage_Size > 0 ? true : false;
            [self.viewThird.mj_footer setHidden:footSecond];
        }
    }
}

- (void)setSelectPinwheelView:(NSInteger)selectPinwheelView
{
    _newIndex = selectPinwheelView;
    
    if (_totalCount == 0)
    {
        _newIndex = 0;
        [self createOnlyOneView];
    } else {
        if (_newIndex == 0) {
            //显示第一个数据
            [self createFirstView];
        } else if (_newIndex == _totalCount - 1) {
            //显示最后一个数据
            [self createLastView];
        } else {
            //左右都有数据时
            [self createIndexView];
        }
    }
    _nowIndex = _newIndex;
    [self onClickWithItem:_nowIndex];
}

- (void)onClickWithItem:(NSInteger)index;
{
    if ([self.pinwheelDelegate respondsToSelector:@selector(selectPinwheelWithPinwheelIndex:withStyle:)]) {
        [self.pinwheelDelegate selectPinwheelWithPinwheelIndex:index withStyle:_currentPinwheel];
    }
    if (_totalCount == 0) {
        if ([self.pinwheelDelegate respondsToSelector:@selector(pinwheelTableVeiw:withPinwheelIndex:)]) {
            //获取相对于的数组
            self.arrayFirst = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index] mutableCopy];
        }
    } else {
        if (index == 0) {
            //显示第一个数据
            if ([self.pinwheelDelegate respondsToSelector:@selector(pinwheelTableVeiw:withPinwheelIndex:)]) {
                self.arrayFirst = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index] mutableCopy];
                self.arraySecond = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index+1] mutableCopy];
            }
        } else if (index == _totalCount - 1) {
            //显示最后一个数据
            if ([self.pinwheelDelegate respondsToSelector:@selector(pinwheelTableVeiw:withPinwheelIndex:)]) {
                self.arrayFirst = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index-1] mutableCopy];
                self.arraySecond = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index] mutableCopy];
            }
        } else {
            //左右都有数据时
            if ([self.pinwheelDelegate respondsToSelector:@selector(pinwheelTableVeiw:withPinwheelIndex:)]) {
                self.arrayFirst = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index-1] mutableCopy];
                self.arraySecond = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index] mutableCopy];
                self.arrayThird = [[self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:index+1] mutableCopy];
            }
        }
    }
    /** 刷新表格 */
    [self reloadDataDDPinwheelTableVeiw:_currentPinwheel];
}

- (void)notResultView
{
    if ([self.pinwheelDelegate respondsToSelector:@selector(notResultViewWithPinwheelIndex:withStyle:)]) {
        [self.pinwheelDelegate notResultViewWithPinwheelIndex:_nowIndex withStyle:_currentPinwheel];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.detailScroll) {
        return;
    }
    int pageIndex = floor((scrollView.contentOffset.x - KPAGE_WIDTH/2)/KPAGE_WIDTH) + 1;
    
    switch (_currentPinwheel)
    {
        case DDPinwheelLeftNo:
        {
            _newIndex = _nowIndex + pageIndex;
            if (pageIndex == 1)
            {
                [self createIndexView];
            }
            break;
        }
        case DDPinwheelRightNo:
        {
            _newIndex = _nowIndex + pageIndex - 1;
            if (pageIndex == 0)
            {
                [self createIndexView];
            }
            break;
        }
        case DDPinwheelOnlyOne:
        {
            [self createOnlyOneView];
            break;
        }
        case DDPinwheelAboutInterface:
        {
            _newIndex = _nowIndex + pageIndex - 1;
            if (_newIndex == 0) {
                [self createFirstView];
            } else if (_newIndex == _totalCount - 1) {
                [self createLastView];
            } else {
                [self createIndexView];
            }
            break;
        }
        default:
            break;
    }
    [scrollView setUserInteractionEnabled:YES];
    
    _nowIndex = _newIndex;
    [self onClickWithItem:_nowIndex];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.detailScroll) {
        [scrollView setUserInteractionEnabled:NO];
    }
}

#pragma mark - DDPinwheelTableVeiw  分页表格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.viewFirst) {
        return [self.arrayFirst count];
    } else if (tableView == self.viewSecond) {
        return [self.arraySecond count];
    } else {
        return [self.arrayThird count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KMyExpressCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"parcelTableViewCell";
    DDParcelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[DDParcelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    if (tableView == self.viewFirst) {
        [cell setCellForMyExpress:self.arrayFirst[indexPath.row]];
    } else if (tableView == self.viewSecond) {
        [cell setCellForMyExpress:self.arraySecond[indexPath.row]];
    } else {
        [cell setCellForMyExpress:self.arrayThird[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if ([self.pinwheelDelegate respondsToSelector:@selector(pinwheelTableVeiw:withPinwheelIndex:withStyle:withIndexPath:)])
    {
        [self.pinwheelDelegate pinwheelTableVeiw:self withPinwheelIndex:_nowIndex withStyle:_currentPinwheel withIndexPath:indexPath];
    }
}


#pragma mark - DDPageView 大风车显示状态
/** 只有一个 */
- (void)createOnlyOneView
{
    [self.viewFirst setHidden:false];
    [self.viewSecond setHidden:true];
    [self.viewThird setHidden:true];
    
    [self.detailScroll setContentSize:CGSizeMake(CGRectGetWidth(self.detailScroll.frame), CGRectGetHeight(self.detailScroll.frame))];
    [self.detailScroll scrollRectToVisible:self.detailScroll.bounds animated:NO];
    _currentPinwheel = DDPinwheelOnlyOne;
}

/** 左边没有 */
- (void)createFirstView
{
    [self.viewFirst setHidden:false];
    [self.viewSecond setHidden:false];
    [self.viewThird setHidden:true];
    
    [self.detailScroll setContentSize:CGSizeMake(CGRectGetWidth(self.detailScroll.frame)*2.0f, CGRectGetHeight(self.detailScroll.frame))];
    [self.detailScroll scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(self.detailScroll.frame), CGRectGetHeight(self.detailScroll.frame)) animated:false];
    _currentPinwheel = DDPinwheelLeftNo;
}

/** 右边没有 */
- (void)createLastView
{
    [self.viewFirst setHidden:false];
    [self.viewSecond setHidden:false];
    [self.viewThird setHidden:true];
    
    [self.detailScroll setContentSize:CGSizeMake(CGRectGetWidth(self.detailScroll.frame)*2.0f, CGRectGetHeight(self.detailScroll.frame))];
    [self.detailScroll scrollRectToVisible:CGRectMake(CGRectGetWidth(self.detailScroll.frame), 0, CGRectGetWidth(self.detailScroll.frame), CGRectGetHeight(self.detailScroll.frame)) animated:false];
    _currentPinwheel = DDPinwheelRightNo;
}

/** 左右都有界面 */
- (void)createIndexView
{
    [self.viewFirst setHidden:false];
    [self.viewSecond setHidden:false];
    [self.viewThird setHidden:false];
    
    [self.detailScroll setContentSize:CGSizeMake(CGRectGetWidth(self.detailScroll.frame)*3.0f, CGRectGetHeight(self.detailScroll.frame))];
    [self.detailScroll scrollRectToVisible:CGRectMake(CGRectGetWidth(self.detailScroll.frame), 0, CGRectGetWidth(self.detailScroll.frame), CGRectGetHeight(self.detailScroll.frame)) animated:false];
    _currentPinwheel = DDPinwheelAboutInterface;
}

#pragma mark - 初始化控件对象
- (UIScrollView *)detailScroll
{
    if (!_detailScroll) {
        _detailScroll = [[UIScrollView alloc] init];
        [_detailScroll setBackgroundColor:[UIColor clearColor]];
        [_detailScroll setShowsHorizontalScrollIndicator:false];
        [_detailScroll setShowsVerticalScrollIndicator:false];
        [_detailScroll setUserInteractionEnabled:true];
        [_detailScroll setPagingEnabled:true];
        [_detailScroll setBounces:false];
        [_detailScroll setDelegate:self];
    }
    return _detailScroll;
}

- (UITableView *)viewFirst
{
    if (!_viewFirst) {
        _viewFirst = [[UITableView alloc] init];
        [_viewFirst setBackgroundColor:[UIColor clearColor]];
        [_viewFirst setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_viewFirst setShowsHorizontalScrollIndicator:false];
        [_viewFirst setShowsVerticalScrollIndicator:true];
    }
    return _viewFirst;
}

- (UITableView *)viewSecond
{
    if (!_viewSecond) {
        _viewSecond = [[UITableView alloc] init];
        [_viewSecond setBackgroundColor:[UIColor clearColor]];
        [_viewSecond setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_viewSecond setShowsHorizontalScrollIndicator:false];
        [_viewSecond setShowsVerticalScrollIndicator:true];
    }
    return _viewSecond;
}

- (UITableView *)viewThird
{
    if (!_viewThird) {
        _viewThird = [[UITableView alloc] init];
        [_viewThird setBackgroundColor:[UIColor clearColor]];
        [_viewThird setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_viewThird setShowsHorizontalScrollIndicator:false];
        [_viewThird setShowsVerticalScrollIndicator:true];
    }
    return _viewThird;
}

- (NSMutableArray *)arrayFirst
{
    if (!_arrayFirst) {
        _arrayFirst = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayFirst;
}
- (NSMutableArray *)arraySecond
{
    if (!_arraySecond) {
        _arraySecond = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arraySecond;
}
- (NSMutableArray *)arrayThird
{
    if (!_arrayThird) {
        _arrayThird = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _arrayThird;
}

- (void)setContentNumber:(NSInteger)contentNumber
{
    _totalCount = contentNumber;
}


@end
