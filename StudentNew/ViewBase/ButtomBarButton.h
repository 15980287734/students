//
//  ButtomBarButton.h
//  DrivingStudent
//
//  Created by user on 13-12-6.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtomBarButton : UIButton

@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic) NSInteger index;

-(void)setImage:(UIImage *)image;
-(void)setTitle:(NSString *)title;

@end
