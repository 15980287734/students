//
//  ChoicButton.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-13.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "ChoicButton.h"

@implementation ChoicButton

//-(id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//    }
//    return self;
//}
-(id)initWithFrame:(CGRect)frame withName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if (self) {
        self.typeName=name;
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 23)];
        imageView.image=[UIImage imageNamed:@"xuanzhong_normal.png"];
        self.selectedImageView=imageView;
        [self addSubview:imageView];
        [imageView release];
        
        UILabel * title1=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, 30, 20)];
        title1.text=name;
        title1.font=[UIFont systemFontOfSize:13.0];
        title1.backgroundColor=[UIColor clearColor];
        [self addSubview:title1];
        [title1 release];
    }
    return self;
}

-(void)dealloc
{
    [_selectedImageView release];
    [_typeName release];
    [super dealloc];
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
