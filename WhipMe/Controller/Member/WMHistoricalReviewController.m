//
//  WMHistoricalReviewController.m
//  WhipMe
//
//  Created by anve on 17/1/10.
//  Copyright © 2017年 -. All rights reserved.
//  历史回顾

#import "WMHistoricalReviewController.h"

@interface WMHistoricalReviewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UICollectionView *collectionViewWM;

@end

static NSString *identifier_collect = @"historicalReviewCell";

@implementation WMHistoricalReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"历史回顾";
    self.view.backgroundColor = [Define kColorBackGround];
    
    [self setup];
}

- (void)setup {
    WEAK_SELF
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5;
    
    _collectionViewWM = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionViewWM.backgroundColor = [UIColor clearColor];
    _collectionViewWM.dataSource = self;
    _collectionViewWM.delegate = self;
    _collectionViewWM.showsHorizontalScrollIndicator = false;
    _collectionViewWM.showsVerticalScrollIndicator = false;
    _collectionViewWM.emptyDataSetSource = self;
    _collectionViewWM.emptyDataSetDelegate = self;
    [self.view addSubview:_collectionViewWM];
    [self.collectionViewWM mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.collectionViewWM registerClass:[HistoricalReviewCollectionCell class] forCellWithReuseIdentifier:identifier_collect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    DebugLog(@"%@",NSStringFromClass(self.class));
}

#pragma mark - DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"nilTouSu"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:rgb(212.0, 212.0, 212.0)};
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:attribute];
    return string;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayContent.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HistoricalReviewCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier_collect forIndexPath:indexPath];
    
    //    mySuperviseModel *model = [self.arrayContent objectAtIndex:indexPath.row];
    //    [cell setCountWithTitle:[NSString stringWithFormat:@"%ld",(long)[model.recordNum integerValue]]];
    //    [cell.imageIcon setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[Define kDefaultImageHead]];
    
    [cell setCountWithTitle:@"4"];
    [cell setLikeWithTitle:@"64"];
    [cell setMessageWithTitle:@"54"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(([Define screenWidth]-32.0)/2.0, [HistoricalReviewCollectionCell cellHeight]);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 13, 10, 13);
}

#pragma mark - set get
- (NSMutableArray *)arrayContent {
    if (!_arrayContent) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

#pragma mark - Network
- (void)queryByHistorical {
    //    UserManager *user = [UserManager shared];
    //    NSDictionary *param = @{@"userId":user.userId ?: @""};
    //
    //
    //    [HttpAPIClient APIClientPOST:@"" params:param Success:^(id result) {
    //        DebugLog(@"______result:%@",result);
    //
    //
    //    } Failed:^(NSError *error) {
    //        DebugLog(@"%@",error);
    //    }];
}

- (void)deleteTask {
    UserManager *user = [UserManager shared];
    NSString *login_id = [NSString stringWithFormat:@"%@",user.userId];
    NSString *union_id = [NSString stringWithFormat:@"taskId"];
    NSString *taskType = @"0"; //（0：历史养成  1：历史监督）
    
    NSDictionary *param = @{@"loginId":login_id,@"taskId":union_id,@"taskType":taskType};
    [HttpAPIClient APIClientPOST:@"removeTask" params:param Success:^(id result) {
        DebugLog(@"______result:%@",result);
        NSDictionary *data = [[result objectForKey:@"data"] objectAtIndex:0];
        if ([data[@"ret"] integerValue] == 0) {
            [Tool showHUDTipWithTipStr:@"删除成功！"];
        } else {
            [Tool showHUDTipWithTipStr:data[@"desc"]];
        }
    } Failed:^(NSError *error) {
        DebugLog(@"%@",error);
    }];
}

@end
