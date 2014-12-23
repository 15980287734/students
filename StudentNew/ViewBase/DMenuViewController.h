//
//  DMenuViewController.h
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMenuViewController : UIViewController
{
    //右边视图是否出现
    BOOL _isRightMove;
}
//根视图控制器
@property (retain, nonatomic) UIViewController * rootViewController;

//右视图控制器
@property (retain, nonatomic) UIViewController * rightViewController;
@property (assign,readonly,nonatomic)BOOL isRightMove;

//以左视图控制器和右视图控制器和根视图控制器初始化
-(id)initWithRootViewController:(UIViewController *)rootViewController andRightViewController:(UIViewController *)rightViewController;

//点击右按钮触发的事件
-(void)moveRightController;
-(void)moveRightWithNoAnimate;
@end
