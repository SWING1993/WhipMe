//
//  JCHATSendMessageViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATConversationViewController.h"

#import "JCHATStringUtils.h"
#import "JCHATFileManager.h"
#import "JCHATSendMsgManager.h"
#import "UIImage+ResizeMagick.h"

#import "JCHATShowTimeCell.h"
#import "JCHATLoadMessageTableViewCell.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <JMessage/JMSGConversation.h>
#import <UIKit/UIPrintInfo.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface JCHATConversationViewController ()

/** 缓存所有的message model */
@property (nonatomic, strong) NSMutableDictionary *allMessageDic;
/** 按序缓存后有的messageId， 于allMessage 一起使用 */
@property (nonatomic, strong) NSMutableArray *allmessageIdArr;

@property (nonatomic, strong) NSMutableArray *imgDataArr;
@property (nonatomic, strong) NSMutableArray *userArr;
@property (nonatomic, assign) NSInteger messageOffset;
@property (nonatomic, assign) BOOL isNoOtherMessage;

@property (nonatomic, strong) UIButton *rightBtn;

@end


@implementation JCHATConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _allMessageDic = @{}.mutableCopy;
    _allmessageIdArr = @[].mutableCopy;
    _imgDataArr = @[].mutableCopy;
//    self.navigationItem.title = _conversation.title;
    [self setupView];
    [self addNotification];
    [self addDelegate];
    [self getGroupMemberListWithGetMessageFlag:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    
    [_conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        [self.navigationController setNavigationBarHidden:NO];
        // 禁用 iOS7 返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
        if (self.conversation.conversationType == kJMSGConversationTypeGroup) {
            [self updateGroupConversationTittle:nil];
        } else {
            self.navigationItem.title = [resultObject title];
        }
        [_messageTableView reloadData];
    }];
}

- (void)updateGroupConversationTittle:(JMSGGroup *)newGroup {
    JMSGGroup *group;
    if (newGroup == nil) {
        group = self.conversation.target;
    } else {
        group = newGroup;
    }
    
    if ([group.name isEqualToString:@""]) {
        self.navigationItem.title = @"群聊";
    } else {
        self.navigationItem.title = group.name;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%lu)",self.navigationItem.title,(unsigned long)[group.memberArray count]];
    [self getGroupMemberListWithGetMessageFlag:NO];
    if (self.isConversationChange) {
        [self cleanMessageCache];
        [self getPageMessage];
        self.isConversationChange = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_conversation clearUnreadCount];
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}

- (void)setupView {
    [self setupNavigation];
    [self setupComponentView];
}

- (void)addtoolbar {
    self.toolBarContainer.toolbar.frame = CGRectMake(0, 0, [Define screenWidth], 45);
    [self.toolBarContainer addSubview:self.toolBarContainer.toolbar];
}

- (void)setupComponentView {
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(tapClick:)];
    [self.view addGestureRecognizer:gesture];
    [self.view setBackgroundColor:[UIColor clearColor]];
    _toolBarContainer.toolbar.delegate = self;
    [_toolBarContainer.toolbar setUserInteractionEnabled:YES];
    self.toolBarContainer.toolbar.textView.text = [[JCHATSendMsgManager ins] draftStringWithConversation:_conversation];
    _messageTableView.userInteractionEnabled = YES;
    _messageTableView.showsVerticalScrollIndicator = NO;
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.backgroundColor = messageTableColor;
    
    _moreViewContainer.moreView.delegate = self;
    _moreViewContainer.moreView.backgroundColor = messageTableColor;
}

- (void)setupNavigation {
    [_conversation clearUnreadCount];
    
//    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_rightBtn setFrame:navigationRightButtonRect];
//    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
//        [_rightBtn setImage:[UIImage imageNamed:@"userDetail"] forState:UIControlStateNormal];
//    } else {
//        [self updateGroupConversationTittle:nil];
//        if ([((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
//            [_rightBtn setImage:[UIImage imageNamed:@"groupDetail"] forState:UIControlStateNormal];
//        } else _rightBtn.hidden = YES;
//    }
    
//    [_rightBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];//为导航栏添加右侧按钮
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(backClick)];
    [leftBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
    if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
        JMSGGroup *group = nil;
        group = self.conversation.target;
        _userArr = [NSMutableArray arrayWithArray:[group memberArray]];
        [self isContantMeWithUserArr:_userArr];
        if (getMesageFlag) {
            [self getPageMessage];
        }
    } else {
        if (getMesageFlag) {
            [self getPageMessage];
        }
        [self hidenDetailBtn:NO];
    }
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
    BOOL hideFlag = YES;
    for (NSInteger i =0; i< [userArr count]; i++) {
        JMSGUser *user = [userArr objectAtIndex:i];
        if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
            hideFlag = NO;
            break;
        }
    }
    [self hidenDetailBtn:hideFlag];
}

- (void)hidenDetailBtn:(BOOL)flag {
    [_rightBtn setHidden:flag];
}

#pragma mark - JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
    [self relayoutTableCellWithMsgId:message.msgId];
    
    if (message != nil) {
        DebugLog(@"发送的 Message:  %@",message);
    }
    
    if (error != nil) {
        [_conversation clearUnreadCount];
        NSString *alert = [JCHATStringUtils errorAlert:error];
        if (alert == nil) {
            alert = [error description];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Tool showHUDTipWithTipStr:alert];
        return;
    }
    JCHATChatModel *model = _allMessageDic[message.msgId];
    if (!model) {
        return;
    }
}

- (void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error {
    if (message != nil) {
        DebugLog(@"收到的message: %@",message);
    }
    if (error != nil) {
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setErrorMessageChatModelWithError:error];
        [self addMessage:model];
        return;
    }
    
    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }
    
    if (message.contentType == kJMSGContentTypeCustom) {
        return;
    }
    
    JCHATMAINTHREAD((^{
        if (!message) {
            DebugLog(@"get the nil message .");
            return;
        }
        
        if (_allMessageDic[message.msgId] != nil) {
            DebugLog(@"该条消息已加载");
            return;
        }
        
        if (message.contentType == kJMSGContentTypeEventNotification) {
            if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers
                && ![((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
                [self setupNavigation];
            }
        }
        
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
            return;
        }
        
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        [self addmessageShowTimeData:message.timestamp];
        [self addMessage:model];
    }));
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }
    
    JCHATMAINTHREAD((^{
        if (!message) {
            DebugLog(@"get the nil message .");
            return;
        }
        
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
            return;
        }
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        [self addmessageShowTimeData:message.timestamp];
        [self addMessage:model];
    }));
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    [self updateGroupConversationTittle:group];
}

- (void)relayoutTableCellWithMsgId:(NSString *) messageId{
    if ([messageId isEqualToString:@""]) {
        return;
    }
    NSInteger index = [_allmessageIdArr indexOfObject:messageId];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    JCHATMessageTableViewCell *tableviewcell = [_messageTableView cellForRowAtIndexPath:indexPath];
    [tableviewcell layoutAllView];
}

#pragma mark - 获取对应消息的索引
- (NSInteger )getIndexWithMessageId:(NSString *)messageID {
    for (NSInteger i=0; i< [_allmessageIdArr count]; i++) {
        NSString *getMessageID = _allmessageIdArr[i];
        if ([getMessageID isEqualToString:messageID]) {
            return i;
        }
    }
    return 0;
}

- (bool)checkDevice:(NSString *)name {
    NSString *deviceType = [UIDevice currentDevice].model;
    NSRange range = [deviceType rangeOfString:name];
    return range.location != NSNotFound;
}

#pragma mark -  清空消息缓存
- (void)cleanMessageCache {
    [_allMessageDic removeAllObjects];
    [_allmessageIdArr removeAllObjects];
    [self.messageTableView reloadData];
}

#pragma mark - 添加message
- (void)addMessage:(JCHATChatModel *)model {
    if (model.isTime) {
        [_allMessageDic setObject:model forKey:model.timeId];
        [_allmessageIdArr addObject:model.timeId];
        [self addCellToTabel];
        return;
    }
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr addObject:model.message.msgId];
    [self addCellToTabel];
}

NSInteger sortMessageType(id object1,id object2,void *cha) {
    JMSGMessage *message1 = (JMSGMessage *)object1;
    JMSGMessage *message2 = (JMSGMessage *)object2;
    if([message1.timestamp integerValue] > [message2.timestamp integerValue]) {
        return NSOrderedDescending;
    } else if([message1.timestamp integerValue] < [message2.timestamp integerValue]) {
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}

- (void)AlertToSendImage:(NSNotification *)notification {
    UIImage *img = notification.object;
    [self prepareImageMessage:img];
}

- (void)deleteMessage:(NSNotification *)notification {
    JMSGMessage *message = notification.object;
    [_conversation deleteMessageWithMessageId:message.msgId];
    [_allMessageDic removeObjectForKey:message.msgId];
    [_allmessageIdArr removeObject:message.msgId];
    [_messageTableView loadMoreMessage];
}

#pragma mark - 排序conversation
- (NSMutableArray *)sortMessage:(NSMutableArray *)messageArr {
    NSArray *sortResultArr = [messageArr sortedArrayUsingFunction:sortMessageType context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)getPageMessage {
    [self cleanMessageCache];
    NSMutableArray * arrList = [[NSMutableArray alloc] init];
    [_allmessageIdArr addObject:[[NSObject alloc] init]];
    
    _messageOffset = messagefristPageNumber;
    [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(_messageOffset)] reverseObjectEnumerator] allObjects]];
    if ([arrList count] < messagefristPageNumber) {
        _isNoOtherMessage = YES;
        [_allmessageIdArr removeObjectAtIndex:0];
        
    }
    
    for (NSInteger i=0; i< [arrList count]; i++) {
        JMSGMessage *message = [arrList objectAtIndex:i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
            model.photoIndex = [_imgDataArr count] - 1;
        }
        
        [self dataMessageShowTime:message.timestamp];
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr addObject:model.message.msgId];
    }
    [_messageTableView reloadData];
    [self scrollToBottomAnimated:NO];
}

- (void)flashToLoadMessage {
    NSMutableArray * arrList = @[].mutableCopy;
    NSArray *newMessageArr = [_conversation messageArrayFromNewestWithOffset:@(_messageOffset) limit:@(messagePageNumber)];
    [arrList addObjectsFromArray:newMessageArr];
    if ([arrList count] < messagePageNumber) {// 判断还有没有新数据
        _isNoOtherMessage = YES;
        [_allmessageIdArr removeObjectAtIndex:0];
    }
    
    _messageOffset += messagePageNumber;
    for (NSInteger i = 0; i < [arrList count]; i++) {
        JMSGMessage *message = arrList[i];
        JCHATChatModel *model = [[JCHATChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr insertObject:model atIndex:0];
            model.photoIndex = [_imgDataArr count] - 1;
        }
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr insertObject:model.message.msgId atIndex: _isNoOtherMessage?0:1];
        [self dataMessageShowTimeToTop:message.timestamp];// FIXME:
    }
    
    [_messageTableView loadMoreMessage];
}

- (JMSGUser *)getAvatarWithTargetId:(NSString *)targetId {
    for (NSInteger i=0; i<[_userArr count]; i++) {
        JMSGUser *user = [_userArr objectAtIndex:i];
        if ([user.username isEqualToString:targetId]) {
            return user;
        }
    }
    return nil;
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        WEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            DebugLog(@"已经达到最大限制时间了，进入下一步的提示");
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf finishRecorded];
        };
        
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

- (void)backClick {
    if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
        [[JCHATAudioPlayerHelper shareInstance] stopAudio];
    }
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)pressVoiceBtnToHideKeyBoard {///!!!
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    _toolBarHeightConstrait.constant = 45;
    [self dropToolBar];
}

- (void)switchToTextInputMode {
    JCHATMessageTextView *inputview = self.toolBarContainer.toolbar.textView;
    [inputview becomeFirstResponder];
    [self layoutAndAnimateMessageInputTextView:inputview];
}

#pragma mark - 增加朋友
- (void)addFriends
{
    //    JCHATGroupDetailViewController *groupDetailCtl = [[JCHATGroupDetailViewController alloc] init];
    //    groupDetailCtl.hidesBottomBarWhenPushed = YES;
    //    groupDetailCtl.conversation = _conversation;
    //    groupDetailCtl.sendMessageCtl = self;
    //    [self.navigationController pushViewController:groupDetailCtl animated:YES];
}

#pragma mark - AddBtnDelegate 调用相册 / 调用相机
- (void)photoClick {
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)cameraClick {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
        [picker setMediaTypes:arrMediaTypes];
        picker.showsCameraControls = YES;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.editing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    if (assets.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSMutableArray *tempArr = [NSMutableArray new];
    for (int x = 0; x < assets.count; x ++) {
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
        requestOptions.synchronous = YES;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        PHImageManager *manager = [PHImageManager defaultManager];
        CGSize targetSize = CGSizeMake(1080, 1920);
        PHAsset *asset = assets[x];
        [manager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:requestOptions resultHandler:^(UIImage *result, NSDictionary *info) {
            [tempArr addObject:result];
            if (assets.count == tempArr.count) {
                for (id obj in tempArr) {
                    [self prepareImageMessage:obj];
                }
            }
        }];
    }
    [self qb_imagePickerControllerDidCancel:imagePickerController];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dropToolBarNoAnimate];
}

#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [Tool showHUDTipWithTipStr:@"不支持视频发送"];
        return;
    }
    UIImage *image;
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self prepareImageMessage:image];
    [self dropToolBarNoAnimate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 发送图片
- (void)prepareImageMessage:(UIImage *)img {
    img = [img resizedImageByWidth:upLoadImgWidth];
    
    JMSGMessage* message = nil;
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
    if (imageContent) {
        message = [_conversation createMessageWithContent:imageContent];
        [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
        [self addmessageShowTimeData:message.timestamp];
        [model setChatModelWith:message conversationType:_conversation];
        [_imgDataArr addObject:model];
        model.photoIndex = [_imgDataArr count] - 1;
        [model setupImageSize];
        [self addMessage:model];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - add Delegate
- (void)addDelegate {
    [JMessage addDelegate:self withConversation:self.conversation];
}

#pragma mark - 加载通知
- (void)addNotification{
    //给键盘注册通知
    DDAddNotification(@selector(inputKeyboardWillShow:), UIKeyboardWillShowNotification);
    DDAddNotification(@selector(inputKeyboardWillHide:), UIKeyboardWillHideNotification);
    
    DDAddNotification(@selector(cleanMessageCache), kDeleteAllMessage);
    DDAddNotification(@selector(AlertToSendImage:), kAlertToSendImage);
    DDAddNotification(@selector(deleteMessage:), kDeleteMessage);
    
    [self.toolBarContainer.toolbar.textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    self.toolBarContainer.toolbar.textView.delegate = self;
}

- (void)inputKeyboardWillShow:(NSNotification *)notification {
    _barBottomFlag=NO;
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        _moreViewHeight.constant = keyBoardFrame.size.height;
        [self.view layoutIfNeeded];
    }];
    [self scrollToEnd];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        _moreViewHeight.constant = 0;
        [self.view layoutIfNeeded];
    }];
    [self scrollToBottomAnimated:NO];
}

#pragma mark - 发送文本
- (void)sendText:(NSString *)text {
    [self prepareTextMessage:text];
}

- (void)perform {
    _moreViewHeight.constant = 0;
    _toolBarToBottomConstrait.constant = 0;
}

#pragma mark - 返回下面的位置
- (void)dropToolBar {
    _barBottomFlag =YES;
    _previousTextViewContentHeight = 31;
    _toolBarContainer.toolbar.addButton.selected = NO;
    [_messageTableView reloadData];
    [UIView animateWithDuration:0.3 animations:^{
        _toolBarToBottomConstrait.constant = 0;
        _moreViewHeight.constant = 0;
    }];
}

- (void)dropToolBarNoAnimate {
    _barBottomFlag =YES;
    _previousTextViewContentHeight = 31;
    _toolBarContainer.toolbar.addButton.selected = NO;
    [_messageTableView reloadData];
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 0;
}

#pragma mark - 按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
    _barBottomFlag=NO;
    [_toolBarContainer.toolbar.textView resignFirstResponder];
    
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 227;
    [_messageTableView setNeedsDisplay];
    [_moreViewContainer setNeedsLayout];
    [_toolBarContainer setNeedsLayout];
    [UIView animateWithDuration:0.25 animations:^{
        _toolBarToBottomConstrait.constant = 0;
        _moreViewHeight.constant = 227;
        [_messageTableView layoutIfNeeded];
        [_toolBarContainer layoutIfNeeded];
        [_moreViewContainer layoutIfNeeded];
    }];
    [_toolBarContainer.toolbar switchToolbarToTextMode];
    [self scrollToBottomAnimated:NO];
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
    [_toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark - 发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    JMSGMessage *message = nil;
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    
    message = [_conversation createMessageWithContent:textContent];
    [_conversation sendMessage:message];
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
}

#pragma mark - 刷新对应的
- (void)addCellToTabel {
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
    [_messageTableView beginUpdates];
    [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [_messageTableView endUpdates];
    [self scrollToEnd];
}

#pragma mark - 比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
    NSString *messageId = [_allmessageIdArr lastObject];
    JCHATChatModel *lastModel = _allMessageDic[messageId];
    NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
    // 时间为毫秒时，转换成秒
    if (timeInterVal > 1999999999) {
        timeInterVal = floor(timeInterVal / 1000);
    }
    if ([lastModel.messageTime longLongValue] > 1999999999) {
        lastModel.messageTime = [NSNumber numberWithLongLong:floor([lastModel.messageTime longLongValue] / 1000)];
    }
    if ([_allmessageIdArr count] > 0 && lastModel.isTime == NO) {
        
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > kInterval) {
            [self addTimeData:timeInterVal];
        }
    } else if ([_allmessageIdArr count] == 0) {//首条消息显示时间
        [self addTimeData:timeInterVal];
    } else {
        DebugLog(@"不用显示时间");
    }
}

#pragma mark - 比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
    NSString *messageId = [_allmessageIdArr lastObject];
    JCHATChatModel *lastModel = _allMessageDic[messageId];
    NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
    // 时间为毫秒时，转换成秒
    if (timeInterVal > 1999999999) {
        timeInterVal = floor(timeInterVal / 1000);
    }
    if ([lastModel.messageTime longLongValue] > 1999999999) {
        lastModel.messageTime = [NSNumber numberWithLongLong:floor([lastModel.messageTime longLongValue] / 1000)];
    }
    if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > kInterval) {
            JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
            timeModel.timeId = [self getTimeId];
            timeModel.isTime = YES;
            timeModel.messageTime = @(timeInterVal);
            timeModel.contentHeight = [timeModel getTextHeight];//!
            [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
            [_allmessageIdArr addObject:timeModel.timeId];
        }
    } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
        JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
        timeModel.timeId = [self getTimeId];
        timeModel.isTime = YES;
        timeModel.messageTime = @(timeInterVal);
        timeModel.contentHeight = [timeModel getTextHeight];//!
        [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
        [_allmessageIdArr addObject:timeModel.timeId];
    } else {
        DebugLog(@"不用显示时间");
    }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
    NSString *messageId = [_allmessageIdArr lastObject];
    JCHATChatModel *lastModel = _allMessageDic[messageId];
    NSTimeInterval timeInterVal = [timeNumber longLongValue];
    if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
        NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
        NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
        NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
        if (fabs(timeBetween) > kInterval) {
            JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
            timeModel.timeId = [self getTimeId];
            timeModel.isTime = YES;
            timeModel.messageTime = @(timeInterVal);
            timeModel.contentHeight = [timeModel getTextHeight];
            [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
            [_allmessageIdArr insertObject:timeModel.timeId atIndex: _isNoOtherMessage?0:1];
        }
    } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
        JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
        timeModel.timeId = [self getTimeId];
        timeModel.isTime = YES;
        timeModel.messageTime = @(timeInterVal);
        timeModel.contentHeight = [timeModel getTextHeight];
        [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
        [_allmessageIdArr insertObject:timeModel.timeId atIndex: _isNoOtherMessage?0:1];
    } else {
        DebugLog(@"不用显示时间");
        
    }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [self addMessage:timeModel];
}

- (NSString *)getTimeId {
    NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
    return timeId;
}

#pragma mark - 滑动至尾端
- (void)scrollToEnd {
    if ([_allmessageIdArr count] != 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];//!UITableViewScrollPositionBottom
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isNoOtherMessage) {
        if (indexPath.row == 0) { //这个是第 0 行 用于刷新
            return 40;
        }
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    JCHATChatModel *model = _allMessageDic[messageId ];
    if (model.isTime == YES) {
        return 31;
    }
    
    if (model.message.contentType == kJMSGContentTypeEventNotification) {
        return model.contentHeight + 17;
    }
    
    if (model.message.contentType == kJMSGContentTypeText) {
        return model.contentHeight + 17;
    } else if (model.message.contentType == kJMSGContentTypeImage) {
        
        if (model.imageSize.height == 0) {
            [model setupImageSize];
        }
        return model.imageSize.height < 44?59:model.imageSize.height + 14;
        
    } else if (model.message.contentType == kJMSGContentTypeVoice) {
        return 69;
    } else {
        return 49;
    }
}

#pragma mark - 释放内存
- (void)dealloc {
    DDRemoveNotificationObserver();
    [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
    [JMessage removeDelegate:self withConversation:_conversation];
}

- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    [self dropToolBar];
}

#pragma mark - UITableViewDelegate / Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_allmessageIdArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_isNoOtherMessage) {
        if (indexPath.row == 0) {
            static NSString *cellLoadIdentifier = @"loadCell"; //name
            JCHATLoadMessageTableViewCell *cell = (JCHATLoadMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellLoadIdentifier];
            
            if (cell == nil) {
                cell = [[JCHATLoadMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadIdentifier];
            }
            [cell startLoading];
            [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
            return cell;
        }
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    if (!messageId) {
        DebugLog(@"messageId is nil%@",messageId);
        return nil;
    }
    
    JCHATChatModel *model = _allMessageDic[messageId];
    if (!model) {
        DebugLog(@"JCHATChatModel is nil%@", messageId);
        return nil;
    }
    
    if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
        static NSString *cellIdentifier = @"timeCell";
        JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (model.isErrorMessage) {
            cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,model.messageError.code];
            return cell;
        }
        
        if (model.message.contentType == kJMSGContentTypeEventNotification) {
            cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
        } else {
            cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
        }
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"MessageCell";
        JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[JCHATMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.conversation = _conversation;
        }
        
        [cell setCellData:model delegate:self indexPath:indexPath];
        return cell;
    }
}

#pragma mark - PlayVoiceDelegate

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([_allmessageIdArr count] - 1 > indexPath.row) {
        NSString *messageId = _allmessageIdArr[indexPath.row + 1];
        JCHATChatModel *model = _allMessageDic[ messageId];
        
        if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
            JCHATMessageTableViewCell *voiceCell =(JCHATMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
            [voiceCell playVoice];
        }
    }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
    [_allMessageDic removeObjectForKey:(*chatModel).message.msgId];
    [_allMessageDic setObject:*chatModel forKey:message.msgId];
    
    if ([_allmessageIdArr count] > index) {
        [_allmessageIdArr removeObjectAtIndex:index];
        [_allmessageIdArr insertObject:message.msgId atIndex:index];
    }
}

- (void)selectHeadView:(JCHATChatModel *)model {
    if (!model.message.fromUser) {
        [Tool showHUDTipWithTipStr:@"该用户为API用户"];
        return;
    }
    
    if (![model.message isReceived]) {
        //    JCHATPersonViewController *personCtl =[[JCHATPersonViewController alloc] init];
        //    personCtl.hidesBottomBarWhenPushed = YES;
        //    [self.navigationController pushViewController:personCtl animated:YES];
    } else {
        //    JCHATFriendDetailViewController *friendCtl = [[JCHATFriendDetailViewController alloc]initWithNibName:@"JCHATFriendDetailViewController" bundle:nil];
        //    if (self.conversation.conversationType == kJMSGConversationTypeSingle) {
        //      friendCtl.userInfo = model.message.fromUser;
        //      friendCtl.isGroupFlag = NO;
        //    } else {
        //      friendCtl.userInfo = model.message.fromUser;
        //      friendCtl.isGroupFlag = YES;
        //    }
        //
        //    [self.navigationController pushViewController:friendCtl animated:YES];
    }
}

#pragma mark - 连续播放语音
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
    JCHATMessageTableViewCell *tempCell = (JCHATMessageTableViewCell *) cell;
    if ([_allmessageIdArr count] - 1 > indexPath.row) {
        NSString *messageId = _allmessageIdArr[indexPath.row + 1];
        JCHATChatModel *model = _allMessageDic[ messageId];
        if (model.message.contentType == kJMSGContentTypeVoice && [model.message.flag isEqualToNumber:@(0)] && [model.message isReceived]) {
            if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
                tempCell.continuePlayer = YES;
            }else {
                tempCell.continuePlayer = NO;
            }
        }
    }
}

#pragma mark - 预览图片 PictureDelegate
//PictureDelegate
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
    NSInteger count = _imgDataArr.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.message = messageObject;
        photo.srcImageView = tapView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
    //  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.conversation =_conversation;
    [browser show];
}

#pragma mark - 获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
    NSMutableArray *urlArr =[NSMutableArray array];
    for (NSInteger i=0; i<[_allmessageIdArr count]; i++) {
        NSString *messageId = _allmessageIdArr[i];
        JCHATChatModel *model = _allMessageDic[messageId];
        if (model.message.contentType == kJMSGContentTypeImage) {
            [urlArr addObject:((JMSGImageContent *)model.message.content)];
        }
    }
    return urlArr;
}

#pragma mark - SendMessageDelegate
- (void)didStartRecordingVoiceAction {
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
    [self finishRecorded];
}

- (void)didDragOutsideAction {
    [self resumeRecord];
}

- (void)didDragInsideAction {
    [self pauseRecord];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    WEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
    }];
}

- (void)finishRecorded {
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
                           voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
    }];
}

#pragma mark - 发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration {
    
    if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
        if ([voiceDuration integerValue]<0.5) {
            DebugLog(@"录音时长小于 0.5s");
        } else {
            DebugLog(@"录音时长大于 60s");
        }
        return;
    }
    
    JMSGMessage *voiceMessage = nil;
    JCHATChatModel *model =[[JCHATChatModel alloc] init];
    JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                   voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
    
    voiceMessage = [_conversation createMessageWithContent:voiceContent];
    [_conversation sendMessage:voiceMessage];
    [model setChatModelWith:voiceMessage conversationType:_conversation];
    [JCHATFileManager deleteFile:voicePath];
    [self addMessage:model];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.barBottomFlag) {
        return;
    }
    if (object == self.toolBarContainer.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method

//计算input textfield 的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [JCHATToolBar maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < _previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
    }
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:_messageTableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     _previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [_toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     self.previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        JCHATMessageTextView *textview =_toolBarContainer.toolbar.textView;
        CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:textview.text withWidthLimit:textView.frame.size.width withFont:[UIFont systemFontOfSize:st_toolBarTextSize]];
        CGFloat textHeight = textSize.height > maxHeight?maxHeight:textSize.height;
        _toolBarHeightConstrait.constant = textHeight + 16;//!
        self.previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)inputTextViewDidChange:(JCHATMessageTextView *)messageInputTextView {
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:messageInputTextView.text];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if (![self shouldAllowScroll]) return;
    
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
    //      if (self.isUserScrolling) {
    //          if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
    //              && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
    //              return NO;
    //          }
    //      }
    
    return YES;
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
    //    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    //    self.messageTableView.contentInset = insets;
    //    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = 64;
    }
    insets.bottom = bottom;
    return insets;
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)allMessageDic {
    if (!_allMessageDic) {
        _allMessageDic = [NSMutableDictionary dictionary];
    }
    return _allMessageDic;
}

- (NSMutableArray *)allmessageIdArr {
    if (!_allmessageIdArr) {
        _allmessageIdArr = [NSMutableArray array];
    }
    return _allmessageIdArr;
}

- (NSMutableArray *)userArr {
    if (!_userArr) {
        _userArr = [NSMutableArray array];
    }
    return _userArr;
}

- (NSMutableArray *)imgDataArr {
    if (!_imgDataArr) {
        _imgDataArr = [NSMutableArray array];
    }
    return _imgDataArr;
}


@end
