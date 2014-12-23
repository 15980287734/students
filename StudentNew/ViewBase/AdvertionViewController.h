//
//  AdvertionViewController.h
//  DrivingStudent
//
//  Created by user on 13-12-24.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>

/**
 *	@brief	广告界面
 */
@interface AdvertionViewController : BaseViewController <UIScrollViewDelegate>

@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic,retain) UIView *bgView;
@property (nonatomic,retain) NSMutableArray *imageViews;
@property (nonatomic,assign) NSTimer *timer;
@property (nonatomic,assign) int nowNum;

@end
