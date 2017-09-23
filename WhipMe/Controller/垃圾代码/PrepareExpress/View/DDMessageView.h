//
//  DDMessageView.h
//  DDExpressClient
//
//  Created by SongGang on 3/10/16.
//  Copyright © 2016 NS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDMessageViewDelegate <NSObject>
@optional
- (void)messageCancelAction;
- (void)messageOKAction: (NSString *)messageString;

@end

@interface DDMessageView : UIView

- (instancetype)init;

@property (nonatomic, weak) id<DDMessageViewDelegate> delegate;
@property (nonatomic, copy) NSString *messageString;

@end
