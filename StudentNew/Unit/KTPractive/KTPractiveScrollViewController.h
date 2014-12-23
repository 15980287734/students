//
//  KTPractiveScrollViewController.h
//  KTOneBrowser
//
//  Created by user on 13-12-9.
//  Copyright 2010 chen Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ButtomBarButton;
@protocol KTPractiveDataSource;
@class KTToolBars;

@interface KTPractiveScrollViewController : UIViewController<UIScrollViewDelegate> 
{
   id <KTPractiveDataSource> dataSource_;
   UIScrollView *scrollView_;
    
   NSUInteger startWithIndex_;
   NSInteger currentIndex_;
   NSInteger totalCount_;
   
   NSMutableArray *allViews_;
    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
   int firstVisiblePageIndexBeforeRotation_;
   CGFloat percentScrolledIntoFirstVisiblePage_;
   
   UIStatusBarStyle statusBarStyle_;

   BOOL statusbarHidden_; // Determines if statusbar is hidden at initial load. In other words, statusbar remains hidden when toggling chrome.
   BOOL isChromeHidden_;
   BOOL rotationInProgress_;
  
   BOOL viewDidAppearOnce_;
   BOOL navbarWasTranslucent_;
   
   NSTimer *chromeHideTimer_;
  // UIToolbar *toolbar_;
    KTToolBars *toolbar_;
   NSMutableArray *items;
   /*公用
   ButtomBarButton *nextButton_;
   ButtomBarButton *previousButton_;
   ButtomBarButton *countButton_;
   //特殊
   ButtomBarButton *secondButton_;
   ButtomBarButton *thirdButton_;
    */
}

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign, getter=isStatusbarHidden) BOOL statusbarHidden;

- (id)initWithDataSource:(id <KTPractiveDataSource>)dataSource
             withBarItem:(NSMutableArray *) dItems
 andStartWithViewAtIndex:(NSUInteger)index;
- (void)toggleChromeDisplay;
- (void)hideChrome;

@end
