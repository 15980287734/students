//
//  KTToolBars.h
//  StudentNew
//
//  Created by chenlei on 14-11-19.
//  Copyright (c) 2014年 wubainet.wyapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTtoolBarDelegate  <NSObject>

- (void)didSwitchItem:(id)object ;


@end

@interface KTToolBars :  UIView {
	NSMutableArray *barViews_;
}

@property (nonatomic, strong) NSMutableArray *barViews, *buttonViews;
@property (nonatomic, strong) UIToolbar *toolbedBar;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic) NSInteger activeBarIndex, activeViewIndex;
@property (nonatomic, assign) id <KTtoolBarDelegate> delegate;

- (void)selectButtonAtIndex:(id)sender;
- (id)getToolButton:(NSInteger) acIndex;
- (void)setToolBarViews:(NSMutableArray *)_views ;
@end
