//
//  PhoneCodeButton.m
//  BlackCard
//
//  Created by Mr.song on 16/5/24.
//  Copyright © 2016年 冒险元素. All rights reserved.
//

#import "PhoneCodeButton.h"
#import "WhipMe-Swift.h"

@interface PhoneCodeButton ()
@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval durationToValidity;

@end

@implementation PhoneCodeButton

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self setValue:@(enabled) forKey:kShow];

    if (enabled) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setBackgroundColor:[Define kColorYellow]];
    }else if ([self.titleLabel.text isEqualToString:@"获取验证码"]){
        [self setTitle:@"正在发送..." forState:UIControlStateNormal];
        [self setBackgroundColor:[Define kColorGray]];
    }
}

- (void)startUpTimer {
    _durationToValidity = 60;
    if (self.isEnabled) {
        self.enabled = NO;
    }
    [self setTitle:[NSString stringWithFormat:@"重新获取(%.0f)", _durationToValidity] forState:UIControlStateNormal];
    if (self.timer) {
        [self.timer invalidate], self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(redrawTimer:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)invalidateTimer{
    if (!self.isEnabled) {
        self.enabled = YES;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)redrawTimer:(NSTimer *)timer {
    _durationToValidity--;
    if (_durationToValidity > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"重新获取(%.0f)", _durationToValidity];//防止 button_title 闪烁
        [self setTitle:[NSString stringWithFormat:@"重新获取(%.0f)", _durationToValidity] forState:UIControlStateNormal];
    }else{
        [self invalidateTimer];
    }
}

@end
