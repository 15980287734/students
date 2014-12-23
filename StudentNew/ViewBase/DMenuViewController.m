//
//  DMenuViewController.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "DMenuViewController.h"
#import "MobClick.h"

@interface DMenuViewController ()

@end

@implementation DMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(id)initWithRootViewController:(UIViewController *)rootViewController
         andRightViewController:(UIViewController *)rightViewController
{
    
    _isRightMove=NO;
    if(self = [super init])
    {
        self.rootViewController = rootViewController;
        self.rootViewController.view.frame = CGRectMake(self.view.frame.origin.x,
                                                        0,
                                                        self.view.frame.size.width,
                                                        self.view.frame.size.height);
        [self.view addSubview:self.rootViewController.view];
        
        self.rightViewController = rightViewController;
        self.rightViewController.view.frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width,
                                                         0,
                                                         WIDTH,
                                                         self.view.frame.size.height);
        [self.view addSubview:self.rightViewController.view];
    }
    return self;
}

-(void)moveRightWithNoAnimate
{
    if (!_isRightMove) {
        
            self.rootViewController.view.frame=CGRectMake(self.rootViewController.view.frame.origin.x-WIDTH, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
            self.rightViewController.view.frame=CGRectMake(self.rightViewController.view.frame.origin.x-WIDTH, self.rightViewController.view.frame.origin.y, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
        
        _isRightMove=!_isRightMove;
    }
    else
    {
            self.rootViewController.view.frame=CGRectMake(self.rootViewController.view.frame.origin.x+WIDTH, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
            self.rightViewController.view.frame=CGRectMake(self.rightViewController.view.frame.origin.x+WIDTH, self.rightViewController.view.frame.origin.y, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
        
        _isRightMove=!_isRightMove;
    }
}

-(void)moveRightController
{
    
    if (!_isRightMove) {
        [UIView animateWithDuration:0.4 animations:^{
            self.rootViewController.view.frame=CGRectMake(self.rootViewController.view.frame.origin.x-WIDTH, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
            self.rightViewController.view.frame=CGRectMake(self.rightViewController.view.frame.origin.x-WIDTH, self.rightViewController.view.frame.origin.y, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
        }];
        _isRightMove=!_isRightMove;
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.rootViewController.view.frame=CGRectMake(self.rootViewController.view.frame.origin.x+WIDTH, self.rootViewController.view.frame.origin.y, self.rootViewController.view.frame.size.width, self.rootViewController.view.frame.size.height);
            self.rightViewController.view.frame=CGRectMake(self.rightViewController.view.frame.origin.x+WIDTH, self.rightViewController.view.frame.origin.y, self.rightViewController.view.frame.size.width, self.rightViewController.view.frame.size.height);
            }];
        _isRightMove=!_isRightMove;
    }
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
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor=[UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [_rightViewController release];
    [_rootViewController release];
    [super dealloc];
}
@end
