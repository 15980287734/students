//
//  AdvertionViewController.m
//  DrivingStudent
//
//  Created by user on 13-12-24.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "AdvertionViewController.h"
#import "UIButton+Bootstrap.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

@interface AdvertionViewController ()

@end

@implementation AdvertionViewController

@synthesize imageArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageViews=[[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    [_imageViews release];
    [imageArray release];
    [_bgView release];
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    self.nowNum=imageArray.count-1;
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, ScreenHeight)];
    self.bgView = view;
    
    
    for (int i = imageArray.count-1; i >= 0; i--) {
        UIImageView *imageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight-20)];
        [imageview setImageWithURL:[imageArray objectAtIndex:i]];
        imageview.tag=i;
        imageview.contentMode=UIViewContentModeScaleToFill;
        [_imageViews addObject:imageview];
        [view addSubview:imageview];
        [imageview release];
    }
    
    [self.view addSubview:view];
    [view release];
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame=CGRectMake(260, ScreenHeight/2-25, 50, 50);
    [backBtn setImage:[UIImage imageNamed:@"back_point.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:4
                                            target:self
                                          selector:@selector(showAnimation)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)showAnimation{
    if (_nowNum == 0) {
        [_timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIImageView *aView=[_imageViews objectAtIndex:_nowNum];
    UIImageView *bView=[_imageViews objectAtIndex:(_nowNum-1)];
    
    [UIView animateWithDuration:0.5 animations:^{
        aView.alpha = 0.0;
    } completion:^(BOOL finished){
        bView.alpha = 1.0;
        _nowNum--;
    }];
}

-(void)btnClick:(UIButton *)btn{
    [_timer invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
