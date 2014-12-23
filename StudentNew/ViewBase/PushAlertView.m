//
//  PushAlertView.m
//  StudentApp
//
//  Created by 陈主祥 on 14-1-13.
//  Copyright (c) 2014年 陈主祥. All rights reserved.
//

#import "PushAlertView.h"
#import "ShowPushInformationView.h"
#import "BaseViewController.h"

@implementation PushAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor clearColor];
        UIView *view=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        view.backgroundColor=[UIColor blackColor];
        view.alpha=0.4;
        [self addSubview:view];
        [view release];
        self.windowLevel = UIWindowLevelAlert;
        ShowPushInformationView * myView = [[ShowPushInformationView alloc]initWithFrame:CGRectMake(20, 120, 280, 80)];
        myView.center=self.center;
        myView.pushAlertView=self;
        self.myView=myView;
        myView.backgroundColor = [UIColor clearColor];
        [myView release];
        self.rootViewController=[[[BaseViewController alloc]init] autorelease];
        
    }
    return self;
}
-(void)show{
    
    self.myView.outputView.text=[NSString stringWithFormat:@"%@:%@",[_pushDictionary valueForKey:@"senderName"],[_pushDictionary valueForKey:@"content"]];
    if ([self.myView.outputView.text isEqualToString:@""]) {
    }
    [self.myView addInputTextView:_pushDictionary];
    self.myView.center=self.center;
    
    [self.rootViewController.view addSubview:self.myView];
    [self makeKeyAndVisible];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.myView.layer addAnimation:popAnimation forKey:nil];
    
}

-(void)dismiss{
    
    
    [self removeFromSuperview];
    [self makeKeyAndVisible];
    self.hidden=YES;
    
    [self release];
    
    
}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self removeFromSuperview];
//    [self makeKeyAndVisible];
//    self.hidden=YES;
//
//    [self release];
//}
-(void)dealloc
{
    [_myView release];
    [_pushDictionary release];
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
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden
{
    return NO;
}
@end
