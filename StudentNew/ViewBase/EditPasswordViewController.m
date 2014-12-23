//
//  EditPasswordViewController.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-12.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "EditPasswordViewController.h"
#import "MD5Encrypt.h"
#import "JsonTools.h"
#import "UpdateUserPasswordData.h"
//#import "MainViewController.h"
//#import "UIButton+Bootstrap.h"
//#import "Toast+UIView.h"

@interface EditPasswordViewController ()

@end

@implementation EditPasswordViewController

@synthesize _oldPasswordText;
@synthesize _MyNewPassword1Text;
@synthesize _MyNewPassword2Text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [_MyNewPassword1Text release];
    [_oldPasswordText release];
    [_MyNewPassword2Text release];
    [super dealloc];
}
-(void)loadView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ScreenHeight)];
    self.view=view;
    [view release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"修改密码"];
    UIImageView * bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    bg.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/zixun_bg.png", StrBundle]];
    [self.view addSubview:bg];
    [bg release];
    
    //旧密码
    UIImageView *img_bg=[[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 250, 35)];
    img_bg.image=[UIImage imageNamed:@"input_bg.png"];
    [self.view addSubview:img_bg];
    [img_bg release];
    UILabel *oldLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 32, 60, 30)];
    oldLabel.text=@"旧 密 码 :";
    oldLabel.font=Font1;
    [self.view addSubview:oldLabel];
    [oldLabel release];
    UITextField * oldText=[[UITextField alloc]initWithFrame:CGRectMake(95, 33, 160, 30)];
    oldText.delegate=self;
    self._oldPasswordText=oldText;
    [self.view addSubview:oldText];
    [oldText release];
    
    //新密码
    UIImageView *img_bg1=[[UIImageView alloc]initWithFrame:CGRectMake(30, 85, 250, 35)];
    img_bg1.image=[UIImage imageNamed:@"input_bg.png"];
    [self.view addSubview:img_bg1];
    [img_bg1 release];
    UILabel *new1Label=[[UILabel alloc]initWithFrame:CGRectMake(35, 87, 60, 30)];
    new1Label.text=@"新 密 码 :";
    new1Label.font=Font1;
    [self.view addSubview:new1Label];
    [new1Label release];
    UITextField * new1Text=[[UITextField alloc]initWithFrame:CGRectMake(95, 88, 160, 30)];
    new1Text.delegate=self;
    self._MyNewPassword1Text=new1Text;
    [self.view addSubview:new1Text];
    [new1Text release];
    
    //再次输入
    UIImageView *img_bg2=[[UIImageView alloc]initWithFrame:CGRectMake(30, 140, 250, 35)];
    img_bg2.image=[UIImage imageNamed:@"input_bg.png"];
    [self.view addSubview:img_bg2];
    [img_bg2 release];
    UILabel *new2Label=[[UILabel alloc]initWithFrame:CGRectMake(35, 142, 60, 30)];
    new2Label.text=@"再次输入 :";
    new2Label.font=Font1;
    [self.view addSubview:new2Label];
    [new2Label release];
    UITextField * new2Text=[[UITextField alloc]initWithFrame:CGRectMake(95, 143, 160, 30)];
    new2Text.delegate=self;
    self._MyNewPassword2Text=new2Text;
    [self.view addSubview:new2Text];
    [new2Text release];
    
    UILabel *infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(30, 180, 250, 30)];
    infoLabel.text=@"PS：密码不能包含空格！";
    infoLabel.textColor=[UIColor redColor];
    infoLabel.font=[UIFont fontWithName:@"Arial" size:17.f];
    [self.view addSubview:infoLabel];
    [infoLabel release];
    
    UIButton * sure=[UIButton buttonWithType:UIButtonTypeCustom];
    sure.frame=CGRectMake(60, 220, 200, 40);
    [sure setTitle:@"确 定" forState:UIControlStateNormal];
    [sure successStyle];
    [sure addTarget:self action:@selector(updatePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    
}
//修改密码
-(void)updatePassword
{
    //隐藏弹出的软键盘
    [_oldPasswordText resignFirstResponder];
    [_MyNewPassword1Text resignFirstResponder];
    [_MyNewPassword2Text resignFirstResponder];

    if (self._oldPasswordText.text.length == 0) {
        [self.view makeToast:@"请输入旧密码！"];
        return;
    }
    
    if (_MyNewPassword1Text.text.length == 0) {
        [self.view makeToast:@"请输入新密码！"];
        return;
    }
    
    if (_MyNewPassword2Text.text.length == 0) {
        [self.view makeToast:@"请再次输入新密码！"];
        return;
    }
    
    
    if (![self._oldPasswordText.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:PASS_WORD]]) {
        [self.view makeToast:@"旧密码输入错误！"];
        return;
    }
    
    if (![_MyNewPassword1Text.text isEqualToString:_MyNewPassword2Text.text]) {
        [self.view makeToast:@"两次输入的密码不相同！"];
        return;
    }
    
    NSRange range = [_MyNewPassword1Text.text rangeOfString:@" "];//判断字符串是否包含
    if (range.length >0)//包含
    {
        [self.view makeToast:@"新密码不能包含空格！"];
        return;
    }
    
    if ([UpdateUserPasswordData changeUserPassword:self.view andRecordText:[self getRecordTextDataFromPassword]]) {
        [[NSUserDefaults standardUserDefaults] setObject:_MyNewPassword1Text.text forKey:PASS_WORD];
        [self.view makeToast:@"密码修改成功！"];
        _oldPasswordText.text=@"";
        _MyNewPassword1Text.text=@"";
        _MyNewPassword2Text.text=@"";
    }else{
        [self.view makeToast:@"密码修改失败！"];
    }
}
//获取要提交的信息
-(NSString *)getRecordTextDataFromPassword
{
    JsonTools *jt=[[[JsonTools alloc]init] autorelease];
    [jt setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USER_ID] forKey:@"id"];
    [jt setValue:_MyNewPassword1Text.text forKey:@"password"];
    return [jt getJsonString];
}
-(void)move
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
