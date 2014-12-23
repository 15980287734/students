//
//  ASFTableViewCell.h
//  Patient Care
//
//  Created by Asif Mujteba on 01/02/2014.
//  Copyright (c) 2014 Asif Mujteba. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import <UIKit/UIKit.h>

#define kDEFAULT_MIN_HEIGHT  44.0f
#define kDEFAULT_FONT_SIZE   14.0f

@interface ASFTableViewCell : UITableViewCell

@property (nonatomic, retain) NSObject *rowId;
@property (nonatomic, assign) int minHeight;

- (void)setColumns:(NSArray *)aArr Options:(NSDictionary *)aOptions IsInnerRow:(BOOL)isInnerRow;

@end
