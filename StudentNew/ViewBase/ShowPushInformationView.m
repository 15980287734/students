//
//  ShowPushInformationView.m
//  StudentApp
//
//  Created by 陈主祥 on 14-1-11.
//  Copyright (c) 2014年 陈主祥. All rights reserved.
//

#import "ShowPushInformationView.h"
#import "PushAlertView.h"
#import "JsonTools.h"
#import "MyRequestData.h"
#import "DataBaseHelper.h"
#import "ChoicButton.h"
#import "Toast+UIView.h"

@implementation ShowPushInformationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        _DicActionType=[[NSDictionary alloc]initWithObjectsAndKeys:@"无",@"none",@"是",@"yes",@"否",@"no",@"确定",@"ok",@"取消",@"cancel",@"同意",@"agree",@"不同意",@"disagree",@"接受",@"accept",@"拒绝",@"refuse",@"忽略",@"ignore",@"自定义",@"Custom", nil];
        _DicActionType1=[[NSDictionary alloc]initWithObjectsAndKeys:@"none",@"无",@"yes",@"是",@"no",@"否",@"ok",@"确定",@"cancel",@"取消",@"agree",@"同意",@"disagree",@"不同意",@"accept",@"接受",@"refuse",@"拒绝",@"ignore",@"忽略",@"Custom",@"自定义", nil];
        _pushDictionary=[[NSMutableDictionary alloc]initWithCapacity:1];
        
        self.backgroundColor=[UIColor clearColor];
        UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bg.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/pushView_bg.png", StrBundle]];
        self.bg=bg;
        [self addSubview:bg];
        [bg release];
        UIImageView *logoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(-5, -15, 50, 50)];
        logoImageView.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/qiu.png", StrBundle]];
        [self addSubview:logoImageView];
        [logoImageView release];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2.0 -50, 10, 100, 30)];
        label.font=[UIFont systemFontOfSize:15.0];
        label.text=@"【消息提醒】";
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=NSTextAlignmentCenter;
        [self addSubview:label];
        [label release];
        UITextView *outputView=[[UITextView alloc]initWithFrame:CGRectMake(10, 40,self.frame.size.width-20, 40)];
        outputView.editable=NO;
        outputView.backgroundColor=[UIColor clearColor];
        outputView.text=@"";
        outputView.delegate=self;
        self.outputView=outputView;
        outputView.font=Font1;
        [self addSubview:outputView];
        [outputView release];
       
        
        
        
        
    }
    return self;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y-100, self.frame.size.width, self.frame.size.height);
    }];
    
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y+100, self.frame.size.width, self.frame.size.height);
    }];
    
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UILabel *label=(UILabel *)[self viewWithTag:6030];
    label.text=[NSString stringWithFormat:@"%d/200",textView.text.length];
    if (text.length>=200)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}

-(void)addInputTextView:(NSMutableDictionary *)dic
{
    [_pushDictionary setDictionary:dic];
    if ([[dic valueForKey:@"flag"] isEqualToString:@"REPLY"]) {//判断是否  回复或者发送
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+55);
        self.bg.frame=CGRectMake(self.bg.frame.origin.x, self.bg.frame.origin.y, self.frame.size.width, self.frame.size.height);
        UIButton *sure=[UIButton buttonWithType:UIButtonTypeCustom];
        sure.frame=CGRectMake(8, self.frame.size.height-50, self.frame.size.width-16, 40);
        //            cancel.layer.borderWidth=0.2;
        //        sure.titleLabel.textColor=[UIColor blueColor];
        [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sure];
    }
    else
    {
    CGSize size = CGSizeMake(self.frame.size.width-20, 1000.0f);
    CGSize lsize = [self.outputView.text sizeWithFont:Font1 constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.outputView.frame=CGRectMake(10, 40,self.frame.size.width-20, lsize.height+10);
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, lsize.height+10+40);
    if ([dic valueForKey:@"actType"]!=nil) {
       
    if (![[dic valueForKey:@"actType"] isEqualToString:@""] ) {
        BOOL yesOrNo=[self addActionTypeButton:[dic valueForKey:@"actType"]];
        int h=0;
        if (yesOrNo) {
            h=60;
        }
        self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+130);
        self.bg.frame=CGRectMake(self.bg.frame.origin.x, self.bg.frame.origin.y, self.frame.size.width, self.frame.size.height);
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20,self.outputView.frame.size.height+40+h, 80, 30)];
        label.font=[UIFont systemFontOfSize:12.0];
        label.text=@"补充说明:";
        label.backgroundColor=[UIColor clearColor];
        label.textColor=[UIColor grayColor];
        [self addSubview:label];
        [label release];
        UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width-80,self.outputView.frame.size.height+40+h, 60, 30)];
        label1.tag=6030;
        label1.font=[UIFont systemFontOfSize:12.0];
        label1.textAlignment=NSTextAlignmentRight;
        label1.text=@"0/200";
        label1.backgroundColor=[UIColor clearColor];
        label1.textColor=[UIColor grayColor];
        [self addSubview:label1];
        [label1 release];

        UITextView *inputView=[[UITextView alloc]initWithFrame:CGRectMake(20, self.outputView.frame.size.height+40+30-3+h,self.frame.size.width-40, 50)];
        inputView.backgroundColor=[UIColor clearColor];
        inputView.layer.borderWidth=0.5;
        inputView.delegate=self;
        inputView.editable=YES;
        self.inputView=inputView;
        inputView.font=[UIFont fontWithName:@"Arial" size:15.0];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelKeyboard)];
        [self.pushAlertView.rootViewController.view addGestureRecognizer:tap];
        [tap release];
        [self addSubview:inputView];
        [inputView release];
        
        
        
        UIButton *sure=[UIButton buttonWithType:UIButtonTypeCustom];
        sure.frame=CGRectMake(8, self.frame.size.height-50, self.frame.size.width-16, 40);
        //            cancel.layer.borderWidth=0.2;
//        sure.titleLabel.textColor=[UIColor blueColor];
        [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(replyPushNews:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sure];

        
    }
    else
    {
        [self addActionTypeButton:nil];
        UIButton *sure=[UIButton buttonWithType:UIButtonTypeCustom];
        sure.frame=CGRectMake(8, self.frame.size.height-50, self.frame.size.width-16, 40);
        //            cancel.layer.borderWidth=0.2;
        //        sure.titleLabel.textColor=[UIColor blueColor];
        [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sure];
    }
    }
    else
    {
        [self addActionTypeButton:nil];
        UIButton *sure=[UIButton buttonWithType:UIButtonTypeCustom];
        sure.frame=CGRectMake(8, self.frame.size.height-50, self.frame.size.width-16, 40);
        //            cancel.layer.borderWidth=0.2;
        //        sure.titleLabel.textColor=[UIColor blueColor];
        [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        [sure addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sure];
    }
    }
}

-(BOOL)addActionTypeButton:(NSString *)string
{
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+55);
    self.bg.frame=CGRectMake(self.bg.frame.origin.x, self.bg.frame.origin.y, self.frame.size.width, self.frame.size.height);
    if (string!=nil) {
        UILabel *label2=[[UILabel alloc]initWithFrame:CGRectMake(20,self.outputView.frame.size.height+40+10, 80, 30)];
        label2.font=[UIFont systemFontOfSize:12.0];
        label2.text=@"回复内容:";
        label2.backgroundColor=[UIColor clearColor];
        label2.textColor=[UIColor grayColor];
        [self addSubview:label2];
        [label2 release];
        
        NSArray *buttons=[string componentsSeparatedByString:@","];
        
        int count=buttons.count;
        
        for (int i=0; i<count; i++) {
            
//            if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
//                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//                btn.frame=CGRectMake((self.frame.size.width/count)*i, self.frame.size.height-44, self.frame.size.width/count, 35);
//                [btn setTitle:[_DicActionType valueForKey:[buttons objectAtIndex:i] ] forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(replyPushNews:) forControlEvents:UIControlEventTouchUpInside];
//                btn.titleLabel.textColor=[UIColor blueColor];
//                [self addSubview:btn];
//            }
//            {
                NSRange range = [buttons[i] rangeOfString:@"="];
                ChoicButton *btn=nil;
                if (range.location==NSNotFound) {
                    btn=[[ChoicButton alloc]initWithFrame:CGRectMake(20+80*i, self.outputView.frame.size.height+40+10+30, self.frame.size.width/count, 35) withName:[_DicActionType valueForKey:[buttons objectAtIndex:i]]];
                }
                else
                {
                    NSArray *tempA=[buttons[i] componentsSeparatedByString:@","];
                    btn=[[ChoicButton alloc]initWithFrame:CGRectMake(10+80*i, self.outputView.frame.size.height+10+40+30, self.frame.size.width/count, 35) withName:tempA[1]];
                }

//                UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//                btn.frame=CGRectMake((self.frame.size.width/count)*i, self.frame.size.height-44, self.frame.size.width/count, 35);
//                [btn setTitle:[_DicActionType valueForKey:[buttons objectAtIndex:i] ] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:btn];
                [btn release];
            }
           
//        }
        return YES;
    }
    else
    {
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue]<7.0) {
//            UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
//            cancel.frame=CGRectMake(8, self.frame.size.height-44, self.frame.size.width-16, 40);
////            cancel.layer.borderWidth=0.2;
//            cancel.titleLabel.textColor=[UIColor blueColor];
//            [cancel setTitle:@"确定" forState:UIControlStateNormal];
//            [cancel addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:cancel];
//        }
//        {
//            UIButton *cancel=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//            cancel.frame=CGRectMake(8, self.frame.size.height-44, self.frame.size.width-16, 40);
////            cancel.layer.borderWidth=0.2;
//            [cancel setTitle:@"确定" forState:UIControlStateNormal];
//            [cancel addTarget:self action:@selector(cancelAlert) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:cancel];
//        }

        return NO;
    }
    
}
-(void)selectedButton:(ChoicButton *)button
{
    if (!_choicButton) {
        _choicButton=button;
        button.selectedImageView.image=[UIImage imageNamed:@"xuanzhong_pressed.png"];
    }
    else
    {
        _choicButton.selectedImageView.image=[UIImage imageNamed:@"xuanzhong_normal.png"];
        button.selectedImageView.image=[UIImage imageNamed:@"xuanzhong_pressed.png"];
        _choicButton=button;
    }
}
-(void)cancelKeyboard
{
    [self.inputView resignFirstResponder];
}
-(void)cancelAlert
{
    [self.pushAlertView dismiss];
}
-(void)replyPushNews:(UIButton *)button
{
    if (!_choicButton) {
        [self.superview makeToast:@"请选择回复内容"];
    }
    else{
    //获取时间
    NSDate* now = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit| NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now];
    int y = [dd year];
    int m = [dd month];
    int d = [dd day];
    int h=[dd hour];
    int minute=[dd minute];
    int second=[dd second];
    
    NSString *mm;
    NSString *day;
    NSString *hh;
    NSString *mimi;
    NSString *sese;
    if (m < 10) {
        mm=[NSString stringWithFormat:@"0%d",m];
    }else{
        mm=[NSString stringWithFormat:@"%d",m];
    }
    
    if (d < 10) {
        day=[NSString stringWithFormat:@"0%d",d];
    }else{
        day=[NSString stringWithFormat:@"%d",d];
    }
    
    if (h < 10) {
        hh=[NSString stringWithFormat:@"0%d",h];
    }else{
        hh=[NSString stringWithFormat:@"%d",h];
    }
    
    if (minute < 10) {
        mimi=[NSString stringWithFormat:@"0%d",minute];
    }else{
        mimi=[NSString stringWithFormat:@"%d",minute];
    }
    
    if (second < 10) {
        sese=[NSString stringWithFormat:@"0%d",second];
    }else{
        sese=[NSString stringWithFormat:@"%d",second];
    }
    
    NSString *time=[NSString stringWithFormat:@"%d-%@-%@ %@:%@:%@",y,mm,day,hh,mimi,sese];
    
    JsonTools *jt=[[JsonTools alloc]init];
    [jt setValue:[_pushDictionary valueForKey:@"id"] forKey:@"messageId"];
    [jt setValue:[_DicActionType1 valueForKey:button.titleLabel.text] forKey:@"actionType"];
    [jt setValue:[NSString stringWithFormat:@"【%@】%@",_choicButton.typeName,self.inputView.text] forKey:@"content"];
    [jt setValue:[_pushDictionary valueForKey:@"contentType"] forKey:@"contentType"];
    [jt setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USER_ID] forKey:@"receiverId"];
    [jt setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME] forKey:@"receiverName"];
    [jt setValue:time forKey:@"receiveTime"];
    
    if ([MyRequestData replyPushInformation:self andRecord:[jt getJsonString]]) {
        NSMutableDictionary *temp=[NSMutableDictionary dictionaryWithCapacity:1];
        NSString *userId=[[NSUserDefaults standardUserDefaults] objectForKey:USER_ID];
        [temp setObject:userId forKey:@"senderId"];
        [temp setObject:@"REPLY" forKey:@"flag"];
        [temp setObject:@"SNS" forKey:@"msgType"];
        [temp setObject:@"TXT" forKey:@"contentType"];
        [temp setObject:@"BATCH" forKey:@"range"];
        [temp setObject:[NSString stringWithFormat:@"【%@】%@",[_DicActionType1 valueForKey:button.titleLabel.text],self.inputView.text ] forKey:@"content"];
        [temp setObject:time forKey:@"sendTime"];
        [temp setObject:[_pushDictionary valueForKey:@"id"] forKey:@"sourceId"];
        [temp setObject:[[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME] forKey:@"senderName"];
        
        DataBaseHelper *dbh=[[DataBaseHelper alloc]init];
        if ([dbh savePushInformation:temp andReceiverId:[_pushDictionary valueForKey:@"senderId"]]) {
            NSLog(@"推送信息状态修改成功，回复");
            //            NSLog(@"%@",[dbh getPushInformations]);
        }
        [dbh release];
        NSLog(@"回复成功");
    }
    [jt release];
    [self.pushAlertView dismiss];
    }
}

-(void)dealloc
{
    [_bg release];
    [_pushDictionary release];
    [_outputView release];
    [_DicActionType release];
    [_DicActionType1 release];
    [_inputView release];
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
