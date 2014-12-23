//
//  KTToolBars.m
//  StudentNew
//
//  Created by chenlei on 14-11-19.
//  Copyright (c) 2014年 wubainet.wyapps. All rights reserved.
//

#import "KTToolBars.h"

@implementation KTToolBars
//最底层是个view 然后加上toolbar
@synthesize toolbedBar;
//存放多个按钮的数组 、按钮相关数据
@synthesize barViews, buttonViews;
//背景 需要的话
@synthesize backgroundView;
@synthesize activeBarIndex, activeViewIndex;
@synthesize delegate;

- (void)dealloc
{
    [barViews_ release], barViews_ = nil;
    [buttonViews release], buttonViews = nil;
    [toolbedBar release], toolbedBar = nil;
    [backgroundView release], backgroundView = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
      toolbedBar = [[UIToolbar alloc] initWithFrame:self.bounds];
      [toolbedBar setBackgroundColor:[UIColor clearColor]];
      toolbedBar.clearsContextBeforeDrawing=YES;
      toolbedBar.alpha=0.5;
      toolbedBar.opaque=NO;
      [toolbedBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin];
     // [self setBackgroundColor:[UIColor redColor]];
      [self addSubview:toolbedBar];
        
      activeBarIndex = 0;
    }
    return self;
}
-(id) setColoms:(NSInteger)index
     withArry:(NSMutableArray *)cols
{
    UIButton *item=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, self.bounds.size.height)];
   
    [item setTitle:[cols objectAtIndex:1] forState:UIControlStateNormal];
    //[item setIndex:index];
  //  int tag=[[cols objectAtIndex:2] intValue];
    [item setTag:index];

    return item;
}
- (void)setToolBarViews:(NSMutableArray *)_views {
    
	barViews_ = _views;
	
	self.buttonViews = [[NSMutableArray alloc] init];
    NSInteger index=0;
    NSInteger count = [_views count];
	NSMutableArray *toolbarItems = [[NSMutableArray alloc] initWithCapacity:count*2];
	UIBarItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
	for (int i=0;i<count;i++) {
    NSMutableArray *lists = [barViews_ objectAtIndex:i];
    id item=[self setColoms:index withArry:lists];
    if([item isKindOfClass:[UIButton class]])
     [item addTarget:self action:@selector(selectButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonViews addObject:item];
    UIBarButtonItem *items =[[UIBarButtonItem alloc] initWithCustomView:item];
    [toolbarItems addObject:items];
    [items release];
    [item release];
    [toolbarItems addObject:space]; 
    index++;
  }
  [space release];
  [toolbedBar setItems:toolbarItems];
  [toolbarItems release];
				
}
	
	
- (id)getToolButton:(NSInteger) acIndex {
    if(buttonViews)
        return [[self buttonViews] objectAtIndex:acIndex];
    else
        return  nil;
}

#pragma mark - KTToolBars actions

- (void)selectButtonAtIndex:(id)sender {
	
    activeBarIndex= [(UIButton *)sender tag];//[(ButtomBarButton *)sender index];
  NSLog(@"==点击%d",activeBarIndex);
	
  if (delegate && [delegate respondsToSelector:@selector(didSwitchItem:)])
        [delegate didSwitchItem:[self getToolButton:activeBarIndex]];
}

@end
