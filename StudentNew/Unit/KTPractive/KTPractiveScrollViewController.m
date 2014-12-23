//
//  KTPractiveScrollViewController.m
//  KTOneBrowser
//
//  Created by user on 13-12-9.
//  Copyright 2010 chen Inc. All rights reserved.
//

#import "KTPractiveScrollViewController.h"
#import "KTPractiveDataSource.h"
#import "KTDefineView.h"
//#import "ButtomBarButton.h"
#import "KTToolBars.h"
const CGFloat ktkDefaultPortraitToolbarHeight   = 44;
const CGFloat ktkDefaultLandscapeToolbarHeight  = 33;
const CGFloat ktkDefaultToolbarHeight = 44;


@interface KTPractiveScrollViewController (KTPrivate)
- (void)setCurrentIndex:(NSInteger)newIndex;
- (void)toggleChrome:(BOOL)hide;
- (void)startChromeDisplayTimer;
- (void)cancelChromeDisplayTimer;
- (void)hideChrome;
- (void)showChrome;
- (void)swapCurrentAndNextOnes;
- (void)nextOne;
- (void)previousOne;
- (void)toggleNavButtons;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;

- (void)loadOne:(NSInteger)index;
- (void)unloadOne:(NSInteger)index;
@end


@implementation KTPractiveScrollViewController

@synthesize statusBarStyle = statusBarStyle_;
@synthesize statusbarHidden = statusbarHidden_;


- (void)dealloc 
{
   /*[nextButton_ release], nextButton_ = nil;
   [previousButton_ release], previousButton_ = nil;
   [countButton_ release];countButton_ = nil;
   [secondButton_ release];secondButton_ = nil;
   [thirdButton_ release];thirdButton_ = nil;
    */
   [toolbar_ release], toolbar_ = nil;
   [scrollView_ release], scrollView_ = nil;
   [allViews_ release], allViews_ = nil;
   [dataSource_ release], dataSource_ = nil;  

   [super dealloc];
}

- (id)initWithDataSource:(id <KTPractiveDataSource>)dataSource
             withBarItem:(NSMutableArray *) dItems
 andStartWithViewAtIndex:(NSUInteger)index
{
   if (self = [super init]) {
     startWithIndex_ = index;
     dataSource_ = [dataSource retain];
     
     // Make sure to set wantsFullScreenLayout or the One
     // will not display behind the status bar.
     [self setWantsFullScreenLayout:YES];
       items=[[NSMutableArray alloc]init];
       items=dItems;
     BOOL isStatusbarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
     [self setStatusbarHidden:isStatusbarHidden];
     
     self.hidesBottomBarWhenPushed = YES;
   }
   return self;
}

- (void)loadView 
{
   [super loadView];
    NSLog(@"loadview");
   CGRect scrollFrame = [self frameForPagingScrollView];
   UIScrollView *newView = [[UIScrollView alloc] initWithFrame:scrollFrame];
   [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
   [newView setDelegate:self];
   
   UIColor *backgroundColor = [dataSource_ respondsToSelector:@selector(imageBackgroundColor)] ?
                                [dataSource_ imageBackgroundColor] : [UIColor blackColor];  
   [newView setBackgroundColor:backgroundColor];
   [newView setAutoresizesSubviews:YES];
   [newView setPagingEnabled:YES];
   [newView setShowsVerticalScrollIndicator:NO];
   [newView setShowsHorizontalScrollIndicator:NO];
   
   [[self view] addSubview:newView];
   
   scrollView_ = [newView retain];
   
   [newView release];
   
   
   CGRect screenFrame = [[UIScreen mainScreen] bounds];
   CGRect toolbarFrame = CGRectMake(0, 
                                    screenFrame.size.height-ktkDefaultToolbarHeight,
                                    screenFrame.size.width, 
                                    ktkDefaultToolbarHeight);
   toolbar_ = [[KTToolBars alloc] initWithFrame:toolbarFrame];
   [toolbar_ setDelegate:(id<KTtoolBarDelegate>)self];
   [toolbar_ setToolBarViews:items];
   [[self view] addSubview:toolbar_];

}

- (void)setTitleWithCurrentOneIndex 
{
   NSString *formatString = [NSString stringWithFormat:@"%d/%d",currentIndex_+1,totalCount_];
  
   NSString *title = [NSString stringWithFormat:formatString, currentIndex_ + 1, totalCount_, nil];
   NSLog(@"setTitleWithCurrentOneIndex=%@,%@",formatString,title);
   ButtomBarButton* countButton_=[toolbar_ getToolButton:2];
   [countButton_ setTitle:formatString];
    
}

- (void)scrollToIndex:(NSInteger)index 
{
   CGRect frame = scrollView_.frame;
   frame.origin.x = frame.size.width * index;
   frame.origin.y = 0;
   [scrollView_ scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSize
{
   NSInteger pageCount = totalCount_;
   if (pageCount == 0) {
      pageCount = 1;
   }

   CGSize size = CGSizeMake(scrollView_.frame.size.width * pageCount, 
                            scrollView_.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
   [scrollView_ setContentSize:size];
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
  
   totalCount_ = [dataSource_ numberOfOnes];
 //   NSLog(@"OneCount==%d",totalCount_);
   [self setScrollViewContentSize];
   
   // Setup our One view cache. We only keep 3 views in
   // memory. NSNull is used as a placeholder for the other
   // elements in the view cache array.
   allViews_ = [[NSMutableArray alloc] initWithCapacity:totalCount_];
   for (int i=0; i < totalCount_; i++) {
      [allViews_ addObject:[NSNull null]];
   }
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated 
{
   [super viewWillAppear:animated];
   
   // The first time the view appears, store away the previous controller's values so we can reset on pop.
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   if (!viewDidAppearOnce_) {
      viewDidAppearOnce_ = YES;
      navbarWasTranslucent_ = [navbar isTranslucent];
      statusBarStyle_ = [[UIApplication sharedApplication] statusBarStyle];
   }
   // Then ensure translucency. Without it, the view will appear below rather than under it.  
   [navbar setTranslucent:YES];
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];

   // Set the scroll view's content size, auto-scroll to the stating One,
   // and setup the other display elements.
   [self setScrollViewContentSize];
   [self setCurrentIndex:startWithIndex_];
   [self scrollToIndex:startWithIndex_];

   [self setTitleWithCurrentOneIndex];
   [self toggleNavButtons];
   [self startChromeDisplayTimer];
}

- (void)viewWillDisappear:(BOOL)animated 
{
  // Reset nav bar translucency and status bar style to whatever it was before.
  UINavigationBar *navbar = [[self navigationController] navigationBar];
  [navbar setTranslucent:navbarWasTranslucent_];
  [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle_ animated:NO];
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated 
{
   [self cancelChromeDisplayTimer];
   [super viewDidDisappear:animated];
}


- (void)toggleNavButtons 
{
   ButtomBarButton *previousButton_=[toolbar_ getToolButton:0];
   ButtomBarButton* nextButton_=[toolbar_ getToolButton:4];
   [previousButton_ setEnabled:(currentIndex_ > 0)];
   [nextButton_ setEnabled:(currentIndex_ < totalCount_ - 1)];
}


#pragma mark -
#pragma mark Frame calculations
#define PADDING  20

- (CGRect)frameForPagingScrollView 
{
   CGRect frame = [[UIScreen mainScreen] bounds];
   frame.origin.x -= PADDING;
   frame.size.width += (2 * PADDING);
   return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
   // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
   // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
   // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
   // because it has a rotation transform applied.
   CGRect bounds = [scrollView_ bounds];
   CGRect pageFrame = bounds;
   pageFrame.size.width -= (2 * PADDING);
   pageFrame.origin.x = (bounds.size.width * index) + PADDING;
   return pageFrame;
}


#pragma mark -
#pragma mark One (Page) Management

- (void)loadOne:(NSInteger)index
{
   if (index < 0 || index >= totalCount_) {
       NSLog(@"loadOne %d边缘",index);
      return;
   }
   
   id currentOneView = [allViews_ objectAtIndex:index];
   if (NO == [currentOneView isKindOfClass:[KTDefineView class]]) {
      // Load the One view.
      CGRect frame = [self frameForPageAtIndex:index];
       KTDefineView *OneView = [[KTDefineView alloc] initWithFrame:frame];
      //[OneView setScroller:self];
       [OneView setIndex:index];
      [OneView setBackgroundColor:[UIColor clearColor]];
      // Set the One image.
      if (dataSource_) {
          if ([dataSource_ respondsToSelector:@selector(detailAtIndex:)] == YES) {
               UIView* selfView=[dataSource_ detailAtIndex:index];
              [OneView setScrView:selfView];
              [selfView release];
          }else{
            
        }
      }
      
      [scrollView_ addSubview:OneView];
      [allViews_ replaceObjectAtIndex:index withObject:OneView];
      [OneView release];
   } else {
      // Turn off zooming.
      [currentOneView turnOffZoom];
   }
}

- (void)unloadOne:(NSInteger)index
{
   if (index < 0 || index >= totalCount_) {
      return;
   }
   
   id currentOneView = [allViews_ objectAtIndex:index];
   if ([currentOneView isKindOfClass:[KTDefineView class]]) {
      [currentOneView removeFromSuperview];
      [allViews_ replaceObjectAtIndex:index withObject:[NSNull null]];
   }
}

- (void)setCurrentIndex:(NSInteger)newIndex
{
   currentIndex_ = newIndex;
   
   [self loadOne:currentIndex_];
   [self loadOne:currentIndex_ + 1];
   [self loadOne:currentIndex_ - 1];
   [self unloadOne:currentIndex_ + 2];
   [self unloadOne:currentIndex_ - 2];
   
   [self setTitleWithCurrentOneIndex];
   [self toggleNavButtons];
}


#pragma mark -
#pragma mark Rotation Magic

- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   CGRect toolbarFrame = toolbar_.frame;
   if ((interfaceOrientation) == UIInterfaceOrientationPortrait || (interfaceOrientation) == UIInterfaceOrientationPortraitUpsideDown) {
      toolbarFrame.size.height = ktkDefaultPortraitToolbarHeight;
   } else {
      toolbarFrame.size.height = ktkDefaultLandscapeToolbarHeight+1;
   }
   // NSLog(@"updateToolbarWithOrientation==%@,%@",toolbarFrame.origin.x,toolbarFrame.origin.y);
   toolbarFrame.size.width = self.view.frame.size.width;
   toolbarFrame.origin.y =  self.view.frame.size.height - toolbarFrame.size.height;
   toolbar_.frame = toolbarFrame;
}

- (void)layoutScrollViewSubviews
{
   [self setScrollViewContentSize];

   NSArray *subviews = [scrollView_ subviews];
   
   for (KTDefineView *OneView in subviews) {
      CGPoint restorePoint = [OneView pointToCenterAfterRotation];
      CGFloat restoreScale = [OneView scaleToRestoreAfterRotation];
      [OneView setFrame:[self frameForPageAtIndex:[OneView index]]];
      [OneView setMaxMinZoomScalesForCurrentBounds];
      [OneView restoreCenterPoint:restorePoint scale:restoreScale];
   }
   
   // adjust contentOffset to preserve page location based on values collected prior to location
   CGFloat pageWidth = scrollView_.bounds.size.width;
   CGFloat newOffset = (firstVisiblePageIndexBeforeRotation_ * pageWidth) + (percentScrolledIntoFirstVisiblePage_ * pageWidth);
   scrollView_.contentOffset = CGPointMake(newOffset, 0);
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration 
{
   // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
   // place to calculate the content offset that we will need in the new orientation
   CGFloat offset = scrollView_.contentOffset.x;
   CGFloat pageWidth = scrollView_.bounds.size.width;
   
   if (offset >= 0) {
      firstVisiblePageIndexBeforeRotation_ = floorf(offset / pageWidth);
      percentScrolledIntoFirstVisiblePage_ = (offset - (firstVisiblePageIndexBeforeRotation_ * pageWidth)) / pageWidth;
   } else {
      firstVisiblePageIndexBeforeRotation_ = 0;
      percentScrolledIntoFirstVisiblePage_ = offset / pageWidth;
   }    
   
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration 
{
   [self layoutScrollViewSubviews];
   // Rotate the toolbar.
   [self updateToolbarWithOrientation:toInterfaceOrientation];
   
   // Adjust navigation bar if needed.
   if (isChromeHidden_ && statusbarHidden_ == NO) {
      UINavigationBar *navbar = [[self navigationController] navigationBar];
      CGRect frame = [navbar frame];
      frame.origin.y = 20;
      [navbar setFrame:frame];
   }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
   [self startChromeDisplayTimer];
}

- (UIView *)rotatingFooterView 
{
   return toolbar_;
}


#pragma mark -
#pragma mark Chrome Helpers

- (void)toggleChromeDisplay 
{
   [self toggleChrome:!isChromeHidden_];
    if(currentIndex_<0) return;

}

- (void)toggleChrome:(BOOL)hide 
{
   isChromeHidden_ = hide;
   if (hide) {
      [UIView beginAnimations:nil context:nil];
      [UIView setAnimationDuration:0.4];
    
   }
   
   if ( ! [self isStatusbarHidden] ) {     
     if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
       //[[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:NO];
     } else {  // Deprecated in iOS 3.2+.
       id sharedApp = [UIApplication sharedApplication];  // Get around deprecation warnings.
       [sharedApp setStatusBarHidden:hide animated:NO];
     }
   }

   CGFloat alpha = hide ? 0.0 : 1.0;
   
   // Must set the navigation bar's alpha, otherwise the One
   // view will be pushed until the navigation bar.
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   [navbar setAlpha:alpha];

   [toolbar_ setAlpha:alpha];

   if (hide) {
      [UIView commitAnimations];
   }
   
   if ( ! isChromeHidden_ ) {
      [self startChromeDisplayTimer];
   }
}

- (void)hideChrome 
{
   if (chromeHideTimer_ && [chromeHideTimer_ isValid]) {
      [chromeHideTimer_ invalidate];
      chromeHideTimer_ = nil;
   }
   [self toggleChrome:YES];
    if(currentIndex_<0) return;

    NSLog(@"hide");
}

- (void)showChrome 
{
   [self toggleChrome:NO];
}

- (void)startChromeDisplayTimer 
{
   [self cancelChromeDisplayTimer];
   /*
   chromeHideTimer_ = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                       target:self 
                                                     selector:@selector(hideChrome)
                                                     userInfo:nil
                                                      repeats:NO];
   */
}

- (void)cancelChromeDisplayTimer 
{
   if (chromeHideTimer_) {
      [chromeHideTimer_ invalidate];
      chromeHideTimer_ = nil;
   }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
   CGFloat pageWidth = scrollView.frame.size.width;
   float fractionalPage = scrollView.contentOffset.x / pageWidth;
   NSInteger page = floor(fractionalPage);
	if (page != currentIndex_) {
		[self setCurrentIndex:page];
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
   //[self hideChrome];
}

- (void)nextOne
{
    NSLog(@"OneCount_=%d,currentIndex_=%d",totalCount_,currentIndex_);
    [self scrollToIndex:currentIndex_ + 1];
    [self startChromeDisplayTimer];
}

- (void)previousOne
{
    [self scrollToIndex:currentIndex_ - 1];
    [self startChromeDisplayTimer];
}


#pragma mark -
#pragma mark Toolbar Actions


- (void)didSwitchItem:(id)item
{
  ButtomBarButton *switchBut=(ButtomBarButton *)item;
  if([switchBut tag]==0)
    [self previousOne];
  else if([switchBut tag]==4)
	[self nextOne];
  else if([switchBut tag]==1){
      
    if ([dataSource_ respondsToSelector:@selector(getAnswerAtIndex:withbutton:)])
          [dataSource_ getAnswerAtIndex:currentIndex_+1 withbutton:switchBut];
    //交卷
    if ([dataSource_ respondsToSelector:@selector(submitAtIndex:withbutton:)])
            [dataSource_ submitAtIndex:currentIndex_+1 withbutton:switchBut];
  }
  else if([switchBut tag]==2)
    {
        if ([dataSource_ respondsToSelector:@selector(jumpAtIndex:withbutton:)])
            [dataSource_ jumpAtIndex:currentIndex_+1 withbutton:switchBut];
    }
 else if([switchBut tag]==3)
    {
        if ([dataSource_ respondsToSelector:@selector(restoreQuestionAtIndex:withbutton:)])
            [dataSource_ restoreQuestionAtIndex:currentIndex_+1 withbutton:switchBut];
    
    //未作
        if ([dataSource_ respondsToSelector:@selector(undoAtIndex:withbutton:)])
            [dataSource_ undoAtIndex:currentIndex_+1 withbutton:switchBut];
    }
}



@end
