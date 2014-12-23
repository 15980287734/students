//
//  BaseViewController.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "BaseViewController.h"
#import "MobClick.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)loadView
{
    [super loadView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor clearColor];
   
    UIButton * back=[UIButton buttonWithType:UIButtonTypeCustom];
    back.frame=CGRectMake(0, 0, 60, 44);
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
        back.frame=CGRectMake(0, 0, 80, 44);
    }
    [back setImage:[UIImage imageNamed:@"back_btn3.png"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"back_pressed3.png"] forState:UIControlStateHighlighted];
    [back addTarget:self action:@selector(setBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -17;
    UIBarButtonItem * backItem=[[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:negativeSpacer, backItem, nil];
    [negativeSpacer release];
    [backItem release];
    
}
//复写setTitle方法,设置标题
-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}

-(void)setBackAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
