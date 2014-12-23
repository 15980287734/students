//
//  KTTabs.h
//  demo
//
//  Created by chen on 14-12-05.
//  Copyright (c) 2014 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDefineView.h"

@class KTTabs;

@protocol KTTabsDelegate  <NSObject>

- (void)tabs:(KTTabs *)tabs didSwitchItem:(id)object;


@end

@interface KTTabs : UIView {
	NSMutableArray *_tabViews;
}

@property (nonatomic, strong) NSMutableArray *tabViews, *buttonViews;
@property (nonatomic, strong) UIScrollView *tabbedBar;
@property (nonatomic, strong) UIView *shadowView, *tabbedView;
@property (nonatomic, strong) UIImageView *leftCanc, *rightCanc;
@property (nonatomic) NSInteger activeBarIndex, activeViewIndex;
@property (nonatomic, assign) id <KTTabsDelegate> delegate;

- (void)selectButtonAtIndex:(id)sender;
- (KTDefineView *)activeTabView;

@end
