#import "CoreAddressBookVC.h"
#import "JXAddressBook.h"

@interface CoreAddressBookVC () <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

@property (nonatomic, weak  ) JXPersonInfo *selectedPersonInfo;
@property (nonatomic, assign) BOOL isShowErrorMsg;
@property (nonatomic, assign) BOOL canReadAddressBook;

@property (nonatomic, strong) UITableView *tableViewHK;
@property (nonatomic, strong) UISearchController *searchControl;

@property (nonatomic, strong) NSMutableArray *arrayContent;
@property (nonatomic, strong) NSMutableArray *arraySearch;

@end

@implementation CoreAddressBookVC

- (instancetype)initWithDelegate:(id<CoreAddressBookVCDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //基本配置
    [self basicPrepare];
    
    if(!self.canReadAddressBook) return;
    
    [self setup];
    [self refreshPersonInfoTableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if(self.canReadAddressBook) return;
    
    if(self.isShowErrorMsg) return;
    
    [self showMsgLabel];
    
    self.isShowErrorMsg = YES;
}

- (void)dealloc {
    self.delegate = nil;
}

/** 基本配置 */
- (void)basicPrepare {
    [self.navigationController.navigationBar setTranslucent:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"通讯录";
    
//    if (self.navigationController.viewControllers.count > 1) {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:kBackImage style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
//    } else {
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
//    }
    
    if(!self.canReadAddressBook) return;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAddressBook:)];
}

- (void)setup
{
    WEAK_SELF
    _tableViewHK = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableViewHK.backgroundColor = [UIColor clearColor];
    _tableViewHK.delegate = self;
    _tableViewHK.dataSource = self;
    _tableViewHK.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableViewHK.tableFooterView = [UIView new];
    [self.view addSubview:self.tableViewHK];
    [self.tableViewHK mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [self.tableViewHK setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    _searchControl = [[UISearchController alloc] initWithSearchResultsController:nil];
    [_searchControl.view setBackgroundColor:[UIColor clearColor]];
    _searchControl.searchResultsUpdater = self;
    _searchControl.dimsBackgroundDuringPresentation = NO;
    _searchControl.hidesNavigationBarDuringPresentation = YES;
    
    [self.searchControl.searchBar setDelegate:self];
    [self.searchControl.searchBar sizeToFit];
    
    self.tableViewHK.tableHeaderView = self.searchControl.searchBar;
    self.definesPresentationContext = YES;
    
    UITextField *searchField = [self.searchControl.searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor blackColor];
    searchField.font = [UIFont systemFontOfSize:14.0];
    searchField.placeholder = @"搜索联系人";
    
}

#pragma mark - Method Demo
- (void)refreshPersonInfoTableView {
    WEAK_SELF
    [JXAddressBook getPersonInfo:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 对获取数据进行排序
            [weakSelf.arrayContent removeAllObjects];
            NSArray *dataLists = [JXAddressBook sortPersonInfos:personInfos];
            for (NSArray *obj in dataLists) {
                [weakSelf.arrayContent addObject:obj];
            }
            [weakSelf.tableViewHK reloadData];
        });
    }];
}

- (void)refreshSearchTableView:(NSString *)searchText {
    WEAK_SELF
    [JXAddressBook searchPersonInfo:searchText addressBookBlock:^(NSArray *personInfos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 直接获取数据
            [weakSelf.arraySearch removeAllObjects];
            for (JXPersonInfo *obj in personInfos) {
                [weakSelf.arraySearch addObject:obj];
            }
            [weakSelf.tableViewHK reloadData];
        });
    }];
}

- (void)refreshAddressBook:(id)sender {
    [self refreshPersonInfoTableView];
}

- (void)showMsgLabel {
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
    NSMutableAttributedString *strA = [[NSMutableAttributedString alloc] initWithString:@"通讯录禁止访问\n\n\n\n 请打开“设置”-“隐私”-“通讯录”允许程序访问"];
    [strA addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0, 7)];
    msgLabel.attributedText = strA;
    msgLabel.backgroundColor = [UIColor whiteColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.numberOfLines = 0;
    [self.view addSubview:msgLabel];
}

- (void)dismiss {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchControl.active) {
        return 1;
    }
    return self.arrayContent.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchControl.active) {
        return self.arraySearch.count;
    }
    return ((NSArray *)[self.arrayContent objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellId];
    }
    
    JXPersonInfo *personInfo = nil;
    if (self.searchControl.active) {
        personInfo = [self.arraySearch objectAtIndex:indexPath.row];
    } else {
        NSArray *subArr = [self.arrayContent objectAtIndex:indexPath.section];
        personInfo = [subArr objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = personInfo.fullName;
    cell.detailTextLabel.text = personInfo.showAllPhoneNO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    JXPersonInfo *personInfo = nil;
    if (self.searchControl.active) {
        personInfo = [self.arraySearch objectAtIndex:indexPath.row];
    } else {
        NSArray *subArr = [self.arrayContent objectAtIndex:indexPath.section];
        personInfo = [subArr objectAtIndex:indexPath.row];
    }
    
    //单个或无联系人
    if(personInfo.phone.count <= 1) {
        if(personInfo.phone.count != 0) {
            personInfo.selectedPhoneNO = ((NSDictionary *)personInfo.phone.firstObject).allValues.firstObject;
        }
        [self selectedPerson:personInfo];
    } else {
        //多个联系人
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@" 【 %@ 】 共有%@个号码，请选择其中的1个号码",personInfo.fullName,@(personInfo.phone.count)] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        //添加其他标题
        NSArray *otherButtonTitles = [personInfo.showAllPhoneNO componentsSeparatedByString:@","];
        if(otherButtonTitles != nil && otherButtonTitles.count != 0) {
            for (NSString *otherButtonTitle in otherButtonTitles) {
                [sheet addButtonWithTitle:[NSString stringWithFormat:@"%@", otherButtonTitle]];
            }
        }
        sheet.delegate = self;
        [sheet showInView:self.view.window];
        self.selectedPersonInfo = personInfo;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchControl.active) {
        return @"";
    }
    return [JXSpellFromIndex((int)section) uppercaseString];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.searchControl.active) {
        return 0;
    }
    
    if (((NSArray *)[self.arrayContent objectAtIndex:section]).count==0) {
        return 0;
    }
    return 30;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchControl.active) {
        return @[];
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 27; i++) {
        [arr addObject:[JXSpellFromIndex(i) uppercaseString]];
    }
    return arr;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex != 0) {
        self.selectedPersonInfo.selectedPhoneNO = [self.selectedPersonInfo.phone[buttonIndex - 1] allValues].firstObject;
        [self selectedPerson:self.selectedPersonInfo];
    }
    /** 清空 */
    self.selectedPersonInfo = nil;
}

- (void)selectedPerson:(JXPersonInfo *)personInfo {
    
    if(self.delegate == nil) return;
    if(![self.delegate respondsToSelector:@selector(addressBookVCSelectedContact:)]) return;
    
    [self.delegate addressBookVCSelectedContact:personInfo];
    [self dismiss];
}

#pragma mark - SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self refreshSearchTableView:searchText];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel = (UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
   
}

#pragma mark - set get 
- (NSMutableArray *)arrayContent {
    if (_arrayContent == nil) {
        _arrayContent = [NSMutableArray array];
    }
    return _arrayContent;
}

- (NSMutableArray *)arraySearch {
    if (_arraySearch == nil) {
        _arraySearch = [NSMutableArray array];
    }
    return _arraySearch;
}

- (BOOL)canReadAddressBook {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    return status != kABAuthorizationStatusDenied;
}

@end
