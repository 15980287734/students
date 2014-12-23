//
//  ShowPushInformationView.h
//  StudentApp
//
//  Created by 陈主祥 on 14-1-11.
//  Copyright (c) 2014年 陈主祥. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PushAlertView;
@class ChoicButton;
@interface ShowPushInformationView : UIView<UITextViewDelegate>
{
    NSDictionary *_DicActionType;
    NSDictionary *_DicActionType1;
    NSMutableDictionary *_pushDictionary;
    ChoicButton *_choicButton;
}

@property (retain,nonatomic)UITextView * outputView;
@property (retain,nonatomic)UITextView *inputView;
@property (assign,nonatomic)PushAlertView *pushAlertView;
@property (retain,nonatomic)UIImageView *bg;
-(void)addInputTextView:(NSMutableDictionary *)dic;
-(BOOL)addActionTypeButton:(NSString *)string;
@end
