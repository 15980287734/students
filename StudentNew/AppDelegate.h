//
//  AppDelegate.h
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ShareSDK/ShareSDK.h>
#import "NdUncaughtExceptionHandler.h"
#import <AudioToolbox/AudioToolbox.h>

@class LoginViewController;

#pragma mark--代理，用于告诉viewcontroller，收到新消息
@protocol GetPushMessageDelegate <NSObject>

- (void) getPushMessage;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (retain, nonatomic) UIWindow *window;
@property (assign,nonatomic) LoginViewController *loginViewController;
@property (nonatomic,assign) id<GetPushMessageDelegate> push_delegate;


@end
