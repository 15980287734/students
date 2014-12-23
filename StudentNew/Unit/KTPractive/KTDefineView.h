//
//  KTDefineView.h
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface KTDefineView : UIScrollView <UIScrollViewDelegate>
{
   NSInteger index_;
   UIScrollView *backgroundView_;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *name;
- (void)turnOffZoom;
- (CGPoint)pointToCenterAfterRotation;
- (CGFloat)scaleToRestoreAfterRotation;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

- (void)setIndexData:(NSMutableArray *)data;
- (void)setScrView:(UIView *)backv;
@end
