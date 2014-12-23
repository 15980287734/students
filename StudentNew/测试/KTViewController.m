//
//  KTViewController.h
//  demo
//
//  Created by chen on 14-12-08.
//  Copyright (c) 2014 chen. All rights reserved.
//


#import "KTViewController.h"
#import "KTTabs.h"
#import "KTDefineView.h"

@implementation KTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	KTDefineView *tabView1 = [[KTDefineView alloc] initWithFrame:self.view.bounds];
	[tabView1 setBackgroundColor:[UIColor purpleColor]];
	[tabView1 setIndex:0];
	[tabView1 setName:@"tabView1"];
	
	KTDefineView *tabView2 = [[KTDefineView alloc] initWithFrame:self.view.bounds];
	[tabView2 setBackgroundColor:[UIColor greenColor]];
	[tabView2 setIndex:1];
	[tabView2 setName:@"tabView2"];
	
	KTDefineView *tabView3 = [[KTDefineView alloc] initWithFrame:self.view.bounds];
	[tabView3 setBackgroundColor:[UIColor redColor]];
	[tabView3 setIndex:2];
	[tabView3 setName:@"tabView3"];
    
    KTDefineView *tabView4 = [[KTDefineView alloc] initWithFrame:self.view.bounds];
	[tabView4 setBackgroundColor:[UIColor yellowColor]];
	[tabView4 setIndex:3];
	[tabView4 setName:@"tabView4"];
    
  KTDefineView *tabView5 = [[KTDefineView alloc] initWithFrame:self.view.bounds];
	[tabView5 setBackgroundColor:[UIColor blueColor]];
	[tabView5 setIndex:4];
	[tabView5 setName:@"tabView5"];
	
	NSMutableArray *tabViews = [NSMutableArray arrayWithObjects:tabView1, tabView2, tabView3, tabView4,tabView5,nil];
	
	KTTabs *tabs = [[KTTabs alloc] initWithFrame:self.view.bounds];
	[tabs setDelegate:(id<KTTabsDelegate>)self];
	
	[tabs setTabViews:tabViews];
	[tabs setActiveBarIndex:0];
	[tabs setActiveViewIndex:0];
    NSLog(@"ktview");
	[self.view addSubview:tabs];
}

#pragma mark - KTTabsDelegate

- (void)tabs:(KTTabs *)tabs didSwitchItem:(id)item
{
    NSLog(@"select");
}

- (void)tabs:(KTTabs *)tabs didCloseItem:(id)item
{
	
}

@end
