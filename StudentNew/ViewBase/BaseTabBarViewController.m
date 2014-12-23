//
//  BaseTabBarViewController.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-19.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "BaseTabBarViewController.h"

@interface BaseTabBarViewController ()

@end

@implementation BaseTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    //    NSLog(@"5ess");
//    return UIStatusBarStyleLightContent;
//}
//-(BOOL)prefersStatusBarHidden
//{
//    //    NSLog(@"sdfdsf");
//    return NO;
//}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [super viewWillAppear:animated];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden=NO;
//    [super viewWillDisappear:animated];
//}
-(void)loadView
{
    [super loadView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tabBar.barStyle=UIBarStyleBlackOpaque;
    UIImage * image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/nav_bg.png", StrBundle]];
    [self.tabBar setBackgroundImage:image];
    [self.tabBar setTintColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    //    NSLog(@"5ess");
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden
{
    //    NSLog(@"sdfdsf");
    return NO;
}
@end
