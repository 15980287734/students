//
//  KTDemoView.h
//  demo
//
//  Created by chen on 14-12-02.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTDefineView.h"

//答题界面搬过来
@interface KTDemoView : KTDefineView
{
   UIImageView *imageView_;
   UILabel *imageTitle_;
  
}

- (void)setIndexData:(NSMutableArray *)data;
	


@end
