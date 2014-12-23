//
//  BaseNavigationVController.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "BaseNavigationVController.h"

@interface BaseNavigationVController ()

@end

@implementation BaseNavigationVController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 5.0)
    {
        UIImage * image = [UIImage imageNamed:@"nav_bg.png"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        self.navigationBar.backgroundColor=[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    }
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
