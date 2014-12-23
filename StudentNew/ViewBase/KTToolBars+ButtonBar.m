//
//  KTToolBars+ButtonBar.m
//  StudentNew
//
//  Created by chenlei on 14-12-19.
//  Copyright (c) 2014年 wubainet.wyapps. All rights reserved.
//

#import "KTToolBars+ButtonBar.h"
#import "ButtomBarButton.h"
@implementation KTToolBars (ButtonBar)

-(id) setColoms:(NSInteger)index
       withArry:(NSMutableArray *)cols
{
    NSLog(@"KTToolBars+ButtonBar");
    ButtomBarButton *item=[[ButtomBarButton alloc] initWithFrame:CGRectMake(0, 0, 40, self.bounds.size.height)];
    [item setImage:[UIImage imageNamed:[cols objectAtIndex:0]]];
    [item setTitle:[cols objectAtIndex:1]];
    [item setTag:index];//固定
    int tag=[[cols objectAtIndex:2] intValue];
    [item setIndex:tag];
    
    return item;
}

@end
