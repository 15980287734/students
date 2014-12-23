//
//  KTDemoView.m
//  demo
//
//  Created by chen on 14-12-02.
//  Copyright (c) 2014 chen. All rights reserved.
//


#import "KTDemoView.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>


@implementation KTDemoView


- (void)dealloc 
{
   [imageView_ release], imageView_ = nil;
   [imageTitle_ release], imageTitle_ = nil;
   [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      [self setDelegate:self];
      [self setMaximumZoomScale:5.0];
      [self setShowsHorizontalScrollIndicator:NO];
      [self setShowsVerticalScrollIndicator:NO];
       imageView_ = [[UIImageView alloc] initWithFrame:frame];
       [imageView_ setContentMode:UIViewContentModeScaleAspectFit];
       imageView_.backgroundColor=[UIColor redColor];
       imageTitle_=[[UILabel alloc]initWithFrame:CGRectMake(20, 90, 200, 80)];
       
       [imageView_ addSubview:imageTitle_];
       [self addSubview:imageView_];

   }
   return self;
}



- (void)setImage:(UIImage *)newImage 
{
    NSLog(@"setImage");
   [imageView_ setImage:newImage];
}

- (void)setImageText:(NSString *)text
{
   NSLog(@"setImageText");
   [imageTitle_ setText:text];
}

- (void)setIndexData:(NSMutableArray *)data
{
    NSLog(@"%@",data);
    NSString *url = [data objectAtIndex:0];
    NSLog(@"imageAtIndex=%@",url);
//异步加载
   // UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
   // UIImage *img= [ImageUtil getImageWithUrl:url andSaveName:url];
   // [self setImage:img];
     [imageView_ setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_photo.png"]];
    [self setImageText:url];


}
- (void)layoutSubviews
{
   [super layoutSubviews];

}

@end
