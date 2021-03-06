//
//  JCHATMessageTableViewCell.m
//  JChat
//
//  Created by HuminiOS on 15/7/13.
//  Copyright (c) 2015年 HXHG. All rights reserved.
//

#import "JCHATMessageTableViewCell.h"
#import "ChatBubbleLayer.h"
#import "JCHATSendMsgManager.h"

//#define ReceivedBubbleColor UIColorFromRGB(0xd3fab4)
//#define sendedBubbleColor [UIColor whiteColor]

static NSInteger const headHeight = 46;
static NSInteger const gapWidth = 5;
static NSInteger const chatBgViewHeight = 50;
static NSInteger const readViewRadius = 4;

@implementation JCHATMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self setup];
        [self addGestureForAllView];
    }
    return self;
}

- (void)setup {
    _headView = [UIImageView new];
    [_headView setBackgroundColor:[UIColor clearColor]];
    [_headView setImage:[Define kDefaultImageHead]];
    [_headView.layer setCornerRadius:headHeight/2];
    [_headView.layer setMasksToBounds:YES];
    [_headView setContentMode:UIViewContentModeScaleAspectFill];
    [_headView setClipsToBounds:YES];
    [self addSubview:_headView];
    
    _messageContent = [[JCHATMessageContentView alloc] init];
    [_messageContent setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_messageContent];
    
    _readView = [UIView new];
    [_readView setBackgroundColor:[UIColor redColor]];
    [_readView.layer setCornerRadius:readViewRadius];
    [_readView.layer setMasksToBounds:YES];
    [self addSubview:self.readView];
    self.continuePlayer = NO;
    
    self.sendFailView = [UIImageView new];
    [self.sendFailView setUserInteractionEnabled:YES];
    [self.sendFailView setImage:[UIImage imageNamed:@"fail05"]];
    [self addSubview:self.sendFailView];
    
    _circleView = [UIActivityIndicatorView new];
    [_circleView setBackgroundColor:[UIColor clearColor]];
    [_circleView setHidden:NO];
    [_circleView setHidesWhenStopped:YES];
    [self addSubview:_circleView];
    
    _voiceTimeLabel = [UILabel new];
    _voiceTimeLabel.backgroundColor = [UIColor clearColor];
    _voiceTimeLabel.font = [UIFont systemFontOfSize:18];
    [self addSubview:_voiceTimeLabel];
    
    _percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, chatBgViewHeight, chatBgViewHeight)];
    _percentLabel.backgroundColor = [UIColor clearColor];
    _percentLabel.hidden = NO;
    _percentLabel.font = [UIFont systemFontOfSize:18];
    _percentLabel.textAlignment=NSTextAlignmentCenter;
    _percentLabel.textColor=[UIColor whiteColor];
    [_messageContent addSubview:_percentLabel];
}

- (void)addGestureForAllView {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContent:)];
    [_messageContent addGestureRecognizer:gesture];
    [_messageContent setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapHeadGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushPersonInfoCtlClick)];
    [_headView addGestureRecognizer:tapHeadGesture];
    [_headView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapFailViewGesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reSendMessage)];
    [_sendFailView addGestureRecognizer:tapFailViewGesture];
    [_sendFailView setUserInteractionEnabled:YES];
}

- (void)setCellData:(JCHATChatModel *)model delegate:(id <playVoiceDelegate>)delegate indexPath:(NSIndexPath *)indexPath {
    _model = model;
    _indexPath = indexPath;
    _delegate = delegate;
    
    [model.message.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil) {
            JMSGUser *user = ((JMSGUser *)self.model.message.fromUser);
            if ([objectId isEqualToString:user.username]) {
                if (data != nil) {
                    [self.headView setImage:[UIImage imageWithData:data]];
                } else {
                    [self.headView setImage:[Define kDefaultImageHead]];
                }
            } else {
                DebugLog(@"该头像是异步乱序的头像");
            }
        } else {
            [self.headView setImage:[Define kDefaultImageHead]];
        }
    }];
    
    if ([self.model.message.flag isEqualToNumber:@1] || ![self.model.message isReceived]) {
        [self.readView setHidden:YES];
    } else {
        [self.readView setHidden:NO];
    }
    
    [self updateFrameWithContentFrame:model.contentSize];
    [self layoutAllView];
}

- (void)layoutAllView {
    if (self.model.message.status == kJMSGMessageStatusSending || self.model.message.status == kJMSGMessageStatusSendDraft) {
        [self.circleView startAnimating];
        [self.sendFailView setHidden:YES];
        [self.percentLabel setHidden:NO];
        if (self.model.message.contentType == kJMSGContentTypeImage) {
            self.messageContent.alpha = 0.5;
        } else {
            self.messageContent.alpha = 1;
        }
        [self addUpLoadHandler];
        
    } else if (self.model.message.status == kJMSGMessageStatusSendFailed ||
               self.model.message.status == kJMSGMessageStatusSendUploadFailed ||
               self.model.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
        [self.circleView stopAnimating];
        if ([self.model.message isReceived]) {
            [self.sendFailView setHidden:YES];
        } else {
            [self.sendFailView setHidden:NO];
        }
        
        self.messageContent.alpha = 1;
    } else {
        self.messageContent.alpha = 1;
        [self.circleView stopAnimating];
        [self.sendFailView setHidden:YES];
        [self.percentLabel setHidden:YES];
    }
    
    if (self.model.message.contentType != kJMSGContentTypeVoice) {
        self.readView.hidden = YES;
    }
    
    switch (self.model.message.contentType) {
        case kJMSGContentTypeUnknown:
            self.messageContent.backgroundColor = [UIColor redColor];
            self.messageContent.textContent.text = st_receiveUnknowMessageDes;
            break;
        case kJMSGContentTypeText:
            self.percentLabel.hidden = YES;
            self.readView.hidden = YES;
            self.voiceTimeLabel.hidden = YES;
            break;
        case kJMSGContentTypeImage:
            self.readView.hidden = YES;
            self.voiceTimeLabel.hidden = YES;
            break;
        case kJMSGContentTypeVoice:
            self.percentLabel.hidden = YES;
            self.voiceTimeLabel.hidden = NO;
            self.voiceTimeLabel.text = [NSString stringWithFormat:@"%@''",((JMSGVoiceContent *)self.model.message.content).duration];
            if (self.model.message.isReceived) {
                self.voiceTimeLabel.textAlignment = NSTextAlignmentLeft;
            } else {
                self.voiceTimeLabel.textAlignment = NSTextAlignmentRight;
            }
            break;
        case kJMSGContentTypeCustom:
            break;
        case kJMSGContentTypeEventNotification:
            break;
        default:
            break;
    }
}

- (void)addUpLoadHandler {
    if (self.model.message.contentType != kJMSGContentTypeImage) {
        return;
    }
    __weak __typeof(self)weakSelfUpload = self;
    ((JMSGImageContent *)_model.message.content).uploadHandler = ^(float percent, NSString *msgId) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelfUpload)strongSelfUpload = weakSelfUpload;
            if ([strongSelfUpload.model.message.msgId isEqualToString:msgId]) {
                NSString *percentString = [NSString stringWithFormat:@"%d%%", (int)(percent * 100)];
                strongSelfUpload.percentLabel.text = percentString;
            }
        });
    };
}

- (void)updateFrameWithContentFrame:(CGSize)contentSize {
    BOOL isRecive = [self.model.message isReceived];
    if (isRecive) {
        [self.headView setFrame:CGRectMake(gapWidth, 0, headHeight, headHeight)];
        
        [self.messageContent setFrame:CGRectMake(headHeight + 5, 0, floorf(contentSize.width+1.0), floorf(contentSize.height+1.0))];
        [self.readView setFrame:CGRectMake(self.messageContent.frame.origin.x + self.messageContent.frame.size.width + 10, 5, 2 * readViewRadius, 2 * readViewRadius)];
        
        [self.voiceTimeLabel setFrame:CGRectMake(_messageContent.frame.origin.x + _messageContent.frame.size.width + 10, _messageContent.frame.size.height/2 - 8, 35, 17)];
        
    } else {
        [self.headView setFrame:CGRectMake([Define screenWidth] - headHeight - gapWidth, 0, headHeight, headHeight)];//头像位置
        [self.messageContent setFrame:CGRectMake([Define screenWidth] - headHeight - 5 - floorf(contentSize.width+1.0), 0, floorf(contentSize.width+1.0), floorf(contentSize.height+1.0))];
        [self.readView setFrame:CGRectMake(self.messageContent.frame.origin.x - 10, 5, 8, 8)];
        
        [self.voiceTimeLabel setFrame:CGRectMake(self.messageContent.frame.origin.x - 45, self.messageContent.frame.size.height/2 - 8, 35, 17)];
    }
    [self.messageContent setMessageContentWith:self.model.message];
    
    if (self.model.message.contentType != kJMSGContentTypeVoice) {
        if (isRecive) {
            self.voiceTimeLabel.frame =  CGRectMake(self.messageContent.frame.origin.x + self.messageContent.frame.size.width + 5, self.messageContent.frame.size.height/2 - 8, 35, 17);
        } else {
            self.voiceTimeLabel.frame = CGRectMake(self.messageContent.frame.origin.x, self.messageContent.frame.size.height/2 - 8, 35, 17);
        }
    }
    if (isRecive) {
        [self.circleView setFrame:CGRectMake(self.voiceTimeLabel.frame.origin.x + 5, self.messageContent.frame.size.height/2 - 8, 17, 15)];
        [self.sendFailView setFrame:CGRectMake(self.voiceTimeLabel.frame.origin.x + 5, self.messageContent.frame.size.height/2 - 8, 17, 15)];
        [self.percentLabel setCenter:CGPointMake(self.messageContent.frame.size.width/2 + crossgrap/2, self.messageContent.frame.size.height/2)];
    } else {
        [self.circleView setFrame:CGRectMake(self.voiceTimeLabel.frame.origin.x - 20, self.messageContent.frame.size.height/2 - 8, 17, 15)];
        [self.sendFailView setFrame:CGRectMake(self.voiceTimeLabel.frame.origin.x - 20, self.messageContent.frame.size.height/2 - 8, 17, 15)];
        [self.percentLabel setCenter:CGPointMake(self.messageContent.frame.size.width/2 - crossgrap/2, self.messageContent.frame.size.height/2)];
    }
}

- (void)tapContent:(UIGestureRecognizer *)gesture {
    if (self.model.message.contentType == kJMSGContentTypeVoice) {
        [self playVoice];
    }
    if (self.model.message.contentType == kJMSGContentTypeImage) {
        if (self.model.message.status == kJMSGMessageStatusReceiveDownloadFailed) {
            [self.circleView startAnimating];
        } else {
            if (self.delegate && [(id<PictureDelegate>)self.delegate respondsToSelector:@selector(tapPicture:tapView:tableViewCell:)]) {
                [(id<PictureDelegate>)self.delegate tapPicture:self.indexPath tapView:(UIImageView *)gesture.view tableViewCell:self];
            }
        }
    }
}

#pragma mark - gesture
- (void)pushPersonInfoCtlClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectHeadView:)]) {
        [self.delegate selectHeadView:self.model];
    }
}

/** 重发消息 */
- (void)reSendMessage {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:nil message:@"是否重新发送消息" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.sendFailView setHidden:YES];
        [self.circleView setHidden:NO];
        [self.circleView startAnimating];
        if (self.model.message.contentType == kJMSGContentTypeImage) {
            self.messageContent.alpha = 0.5;
        } else {
            self.messageContent.alpha = 1;
        }
        __weak typeof(self)weakSelf = self;
        if (_model.message.contentType == kJMSGContentTypeImage) {
            JMSGImageContent *imgContent = ((JMSGImageContent *)_model.message.content);
            imgContent.uploadHandler = ^(float percent, NSString *msgID){
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                if ([strongSelf.model.message.msgId isEqualToString:msgID]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        strongSelf.percentLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
                    });
                }
            };
            [[JCHATSendMsgManager ins] addMessage:weakSelf.model.message withConversation:_conversation];
        } else {
            [weakSelf.conversation sendMessage:weakSelf.model.message];
            [weakSelf layoutAllView];
        }
    }
}

#pragma mark --连续播放语音
- (void)playVoice {
    __block NSString *status = nil;
    
    self.continuePlayer = NO;
    if ([(id<playVoiceDelegate>)(self.delegate) respondsToSelector:@selector(getContinuePlay:indexPath:)]) {
        [(id<playVoiceDelegate>)(self.delegate) getContinuePlay:self indexPath:self.indexPath];
    }
    [self.readView setHidden:YES];
    
    if (![self.model.message.flag isEqual: @1]) {
        [self.model.message updateFlag:@1];
    }
    [((JMSGVoiceContent *)_model.message.content) voiceData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil) {
            if (data != nil) {
                status =  @"下载语音成功";
                self.index = 0;
                
                if (!_isPlaying) {
                    if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
                        [[JCHATAudioPlayerHelper shareInstance] stopAudio];
                        [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
                    }
                    [[JCHATAudioPlayerHelper shareInstance] setDelegate:(id) self];
                    _isPlaying = YES;
                } else {
                    _isPlaying = NO;
                    self.continuePlayer = NO;
                    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
                    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
                }
                [[JCHATAudioPlayerHelper shareInstance] managerAudioWithData:data toplay:YES];
                [self changeVoiceImage];
            }
        } else {
            [Tool showHUDTipWithTipStr:@"下载语音数据失败"];
            status = @"获取消息失败。。。";
        }
    }];
    return;
}

- (void)changeVoiceImage {
    if (!_isPlaying) {
        return;
    }
    
    NSString *voiceImagePreStr = @"";
    if ([_model.message isReceived]) {
        voiceImagePreStr = @"ReceiverVoiceNodePlaying00";
    } else {
        voiceImagePreStr = @"SenderVoiceNodePlaying00";
    }
    _messageContent.voiceConent.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%zd", voiceImagePreStr, self.index % 4]];
    if (_isPlaying) {
        self.index++;
        [self performSelector:@selector(changeVoiceImage) withObject:nil afterDelay:0.25];
    }
}

- (void)prepare {
    [(id<playVoiceDelegate>)self.delegate successionalPlayVoice:self indexPath:self.indexPath];
}

#pragma mark - 播放完成后
- (void)didAudioPlayerStopPlay:(AVAudioPlayer *)audioPlayer {
    [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
    _isPlaying = NO;
    self.index = 0;
    if ([_model.message isReceived]) {
        [_messageContent.voiceConent setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"]];
    } else {
        [_messageContent.voiceConent setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
    }
    if (self.continuePlayer) {
        self.continuePlayer = NO;
        if ([self.delegate respondsToSelector:@selector(successionalPlayVoice:indexPath:)]) {
            [self performSelector:@selector(prepare) withObject:nil afterDelay:0.5];
        }
    }
}

#pragma mark - 发送消息响应

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
