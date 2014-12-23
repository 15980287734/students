//
//  ButtomBarButton.m
//  DrivingStudent
//
//  Created by user on 13-12-6.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "ButtomBarButton.h"

/**
 *	@brief	底部栏自定义按钮控件，由图片+底部文字组成
 */
@implementation ButtomBarButton

@synthesize imageView;
@synthesize titleLabel;
@synthesize index;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float height=22;
        float width=frame.size.width;
        float x=(frame.size.width-width)/2;
        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(x, 5, width, height)];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, height+8, frame.size.width, 12)];
        [titleLabel setFont:[UIFont fontWithName:@"Arial" size:10]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:imageView];
        [self addSubview:titleLabel];
     
    }
    return self;
}

-(void)dealloc{
    [imageView release];
    [titleLabel release];
    [super dealloc];
}

-(void)setImage:(UIImage *)image{
    [imageView setImage:image];
}

-(void)setTitle:(NSString *)title{
    [titleLabel setText:title];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
