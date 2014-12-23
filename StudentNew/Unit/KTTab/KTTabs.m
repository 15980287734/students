//
//  KTTabs.m
//  demo
//
//  Created by chen on 14-12-05.
//  Copyright (c) 2014 chen. All rights reserved.
//

#import "KTTabs.h"
#import <QuartzCore/QuartzCore.h>
#import "ButtomBarButton.h"

#define KTCOLOR_TAB_TITLE [UIColor colorWithRed:1 green:1 blue:1 alpha:1] /*#ffffff*/
#define KTCOLOR_TAB_TITLE_SHADOW [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] /*#ffffff*/
#define KTCOLOR_TAB_TITLE_ACTIVE [UIColor colorWithRed:0.424 green:0.349 blue:0.239 alpha:1] /*#6c593d*/
#define KTCOLOR_TAB_TITLE_ACTIVE_SHADOW [UIColor colorWithRed:1 green:1 blue:1 alpha:0.55] /*#ffffff*/
#define KTFONT_TAB_TITLE [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]
#define KTFONT_TAB_TITLE_ACTIVE [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]

@implementation KTTabs

@synthesize tabbedBar, shadowView, tabbedView;
@synthesize leftCanc, rightCanc;
@synthesize tabViews, buttonViews;
@synthesize activeBarIndex, activeViewIndex;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
				
		tabbedBar = [[UIScrollView alloc] initWithFrame:self.bounds];
		
		[tabbedBar setBackgroundColor:[UIColor clearColor]];
		[tabbedBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		[tabbedBar setClipsToBounds:YES];
		[tabbedBar setAlwaysBounceHorizontal:YES];
        [tabbedBar setShowsVerticalScrollIndicator:NO];
        [tabbedBar setShowsHorizontalScrollIndicator:NO];
		
		CGRect rect = tabbedBar.frame;
        rect.origin.y = rect.size.height-33;
		rect.size.height = 33;
		tabbedBar.frame = rect;
		
		shadowView = [[UIView alloc] initWithFrame:rect];
		[shadowView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
		
        rect = shadowView.bounds;
        rect.size.width = 1024;
		UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:rect];
		shadowView.layer.masksToBounds = NO;
		shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
		shadowView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
		shadowView.layer.shadowOpacity = 0.5f;
		shadowView.layer.shadowRadius = 6.0f;
		shadowView.layer.shadowPath = shadowPath.CGPath;
		
		tabbedView = [[UIView alloc] initWithFrame:CGRectZero];
		[tabbedView addSubview:[[UIView alloc] init]];
		
		rect = self.bounds;
		rect.size.height -= 33;
		//rect.origin.y = 33;
		tabbedView.frame = rect;
		
		[tabbedView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		
		[self addSubview:tabbedView];
		//[self addSubview:shadowView];
		[self addSubview:tabbedBar];
		
		activeBarIndex = 0;
    }
    return self;
}

#pragma mark - KTTabbedView methods
- (NSMutableArray *)tabViews {
	return _tabViews;
}

- (void)setTabViews:(NSMutableArray *)_views {
	_tabViews = _views;
	
	self.buttonViews = [[NSMutableArray alloc] init];

	NSInteger index = 0;
	
	for (KTDefineView *v in self.tabViews) {
		[v setFrame:tabbedView.bounds];
		[v setIndex:index];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		
		CGSize size = [v.name sizeWithFont:[UIFont boldSystemFontOfSize:12]];
		CGFloat lastButtonViewMaxX = 0;	
		
		if ([buttonViews count])
			lastButtonViewMaxX = CGRectGetMaxX([[buttonViews lastObject] frame]);
		
		UIView *buttonView = [[UIView alloc] init];
		if (index == 0)
			[buttonView setFrame:CGRectMake(lastButtonViewMaxX, 0, size.width + 45, 44)];
		else
			[buttonView setFrame:CGRectMake(lastButtonViewMaxX + 45, 0, size.width + 45, 44)];
		
		[tabbedBar addSubview:buttonView];
		[buttonViews addObject:buttonView];
		
		
		ButtomBarButton *titleButton = [ButtomBarButton buttonWithType:UIButtonTypeCustom];
		[titleButton setFrame:CGRectMake(1, 1, size.width + 16, 44)];
		[titleButton setIndex:index];
		
		[titleButton.titleLabel setFont:KTFONT_TAB_TITLE_ACTIVE];
		//[titleButton setTitleColor:KTCOLOR_TAB_TITLE_ACTIVE forState:UIControlStateNormal];
		//[titleButton setTitleShadowColor:KTCOLOR_TAB_TITLE_ACTIVE_SHADOW forState:UIControlStateNormal];
		[titleButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
		
		
         [titleButton setTitle:v.name];
		//[titleButton setTitle:v.name forState:UIControlStateNormal];
		
		[titleButton addTarget:self action:@selector(selectButtonAtIndex:) forControlEvents:UIControlEventTouchUpInside];
		[buttonView addSubview:titleButton];

		index++;
		
		size = tabbedBar.contentSize; //= 
		size.width = CGRectGetMaxX(buttonView.frame);
		tabbedBar.contentSize = size;
		
		
	}
	
	
	
	
}

- (void)setActiveBarIndex:(NSInteger)_activeBarIndex {
	activeBarIndex = _activeBarIndex;
	UIView *buttonView = (UIView *)[buttonViews objectAtIndex:activeBarIndex];
	
	for (UIView *view in buttonViews) {
	
		UIButton *titleButton = [[view subviews] objectAtIndex:0];
		//[titleButton setTitleColor:KTCOLOR_TAB_TITLE forState:UIControlStateNormal];
		//[titleButton setTitleShadowColor:KTCOLOR_TAB_TITLE_SHADOW forState:UIControlStateNormal];
	}
	
	
	ButtomBarButton *titleButton = [[buttonView subviews] objectAtIndex:0];
	//[titleButton setTitleColor:KTCOLOR_TAB_TITLE_ACTIVE forState:UIControlStateNormal];
	//[titleButton setTitleShadowColor:KTCOLOR_TAB_TITLE_ACTIVE_SHADOW forState:UIControlStateNormal];
	
	
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	
	[UIView commitAnimations];
	
	
		
}

- (void)setActiveViewIndex:(NSInteger)_activeViewIndex {
	activeViewIndex = _activeViewIndex;
    NSLog(@"%d",activeBarIndex);
	[[self.tabViews objectAtIndex:activeViewIndex] setAlpha:0];
	[tabbedView addSubview:[self.tabViews objectAtIndex:activeViewIndex]];
    [[self.tabViews objectAtIndex:activeViewIndex] setFrame:tabbedView.bounds];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[[[tabbedView subviews] objectAtIndex:0] setAlpha:0];
	[[[tabbedView subviews] objectAtIndex:1] setAlpha:1];
	
	[UIView commitAnimations];
	
	[[[tabbedView subviews] objectAtIndex:0] removeFromSuperview];
	
}

#pragma mark - KTTabbedView actions

- (void)selectButtonAtIndex:(id)sender {
	if (activeBarIndex != [(ButtomBarButton *)sender index]) {
		[self setActiveBarIndex:[(ButtomBarButton *)sender index]];
		[self setActiveViewIndex:[(ButtomBarButton *)sender index]];
	}
	
	if (delegate && [delegate respondsToSelector:@selector(tabs:didSwitchItem:)])
		[delegate tabs:self didSwitchItem:nil];
}

- (KTDefineView *)activeTabView {
	return [[self tabViews] objectAtIndex:activeBarIndex];
}

@end
