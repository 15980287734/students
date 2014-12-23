//
//  PushAlertView.h
//  StudentApp
//
//  Created by 陈主祥 on 14-1-13.
//  Copyright (c) 2014年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShowPushInformationView;

@interface PushAlertView : UIWindow

@property (retain,nonatomic)ShowPushInformationView *myView;
@property (retain,nonatomic)NSMutableDictionary * pushDictionary;
-(void)show;
-(void)dismiss;

@end
