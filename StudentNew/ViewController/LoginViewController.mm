//
//  LoginViewController.m
//  IOSCoachApp
//
//  Created by user on 13-10-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "LoginViewController.h"
#import "MD5Encrypt.h"
#import "GetDataHelper.h"
#import "ASIFormDataRequest.h"
#import "XMLParser.h"
#import "WebServiceConstants.h"
//#import "RNBlurModalView.h"
#import "MBProgressHUD.h"
//#import "MainViewController.h"
#import "AppDelegate.h"
#import "RightViewController.h"
#import "NetWork.h"
#import "Toast+UIView.h"
#import "UIButton+Bootstrap.h"
#import "WebSiteToIP.h"
#import "StringUtil.h"
#import "ImageUtil.h"
#import "AdvertionViewController.h"
#import "GetSchoolViewController.h"
#import "JsonTools.h"

#import "SimpleIni.h"

@interface LoginViewController ()

@end

@implementation LoginViewController{
    //登录界面背景
    UIImageView *_loginView;
    //显示头像
    UIImageView *_photoImage;
    //登录按钮
    UIButton *_loginBtn;
    //退出按钮
    UIButton *_logoutBtn;
    //选择驾校弹窗
  //  RNBlurModalView* _modal;
    
    NSUserDefaults *_userDefaults;
    
    BOOL isShowAd;
    BOOL islogout;
    BOOL islogin;
    NSMutableArray *imageArray;
}
-(void)loginaAgain
{
    islogout=YES;
    //_pwdEdit.text=@"";
}
-(id)init{
    self = [super init];
    if (self) {
        _userDefaults=[NSUserDefaults standardUserDefaults];
        isShowAd=YES;
        islogout=NO;
        islogin=NO;
        
        self.schoolData=[[NSMutableArray alloc] init];
        self.usedSchool=[[NSMutableArray alloc] init];
        [self getSchool];
    }
    return self;
}

-(void) dealloc{
    [_locationManager release];
    [_loginView release];
    [_photoImage release];
    [_schoolEdit release];
    [_nameEdit release];
    [_pwdEdit release];
    [_schoolData release];
    [_usedSchool release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if(!islogout  && !isShowAd && !islogin){
        if (![_schoolEdit.text isEqualToString:@""] &&![_nameEdit.text isEqualToString:@""] && ![_pwdEdit.text isEqualToString:@""]) {
            [self login];
            islogin =YES;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *userId=[_userDefaults stringForKey:USER_ID];
    if (userId && isShowAd) {//判断是否登陆过
        //启动异步线程，进行数据加载
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //加载广告图片链接
            
            NSMutableDictionary *group=[[NSMutableDictionary alloc] init];
            [group setValue:@"AD_M1" forKey:@"id"];
            JsonTools *jt = [[JsonTools alloc] init];
            [jt setValue:group forKey:@"group"];
            [group release];
            
            GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:self.view];
            gdh.businessCode=HANDLER_AD_LINK_CODE;
            gdh.startRow=1;
            gdh.pageSize=10;
            gdh.recordText=[jt getJsonString];
            XMLParser *parser=[[XMLParser alloc] init];
            NSMutableArray *linkArray=[parser XMLParse:[gdh getResponseFromUrl]];
            imageArray=[[NSMutableArray alloc] init];
            //加载广告图片
            if (linkArray && [linkArray count] != 0) {
                for (int i=0; i<[linkArray count]; i++) {
                    NSMutableDictionary *dic=[linkArray objectAtIndex:i];
                    NSUserDefaults *usDefault=[NSUserDefaults standardUserDefaults];
                    NSString *url=[NSString stringWithFormat:@"%@%@",[usDefault objectForKey:SCHOOL_URL],[dic objectForKey:@"photoPath"]];
                    [imageArray addObject:url];
                }
                
            }
            [parser release];
            [gdh release];
            [jt release];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (imageArray.count != 0 ) {
                    AdvertionViewController *advc=[[AdvertionViewController alloc] init];
                    advc.imageArray=imageArray;
                    [self.navigationController pushViewController:advc animated:YES];
                    [advc release];
                    [imageArray release];
                }else{
                    if (!islogin) {
                        if (![_schoolEdit.text isEqualToString:@""] &&![_nameEdit.text isEqualToString:@""] && ![_pwdEdit.text isEqualToString:@""]) {
                            [self login];
                            islogin=YES;
                        }
                    }
                }
                isShowAd = NO;
            });
        });
        
    }else{
        
    }
    self.navigationController.navigationBarHidden=YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self setTitle:@"教练员登录"];
    
    //    //获取当前城市
    //    [self getNowPosition];
    
    //设置登录界面背景图片
	_loginView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    //    _loginView.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"background_login" ofType:@"png"]];
    _loginView.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/background_login.png", StrBundle]];//[UIImage imageNamed:@"background_login.png"];
    _loginView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:_loginView];
    
    //设置头像
    int h=0;
    if (ScreenHeight > 480) {
        h=20;
    }
    _photoImage=[[UIImageView alloc] initWithFrame:CGRectMake(120, 40+h*2, 80, 100)];
    
    NSString *nickname=[_userDefaults objectForKey:USER_ID];//从sd卡获取头像
    //    NSLog(@"%@",nickname);
    if (nickname) {
        UIImage *image=[ImageUtil getImageFromSD:nickname];
        if (image) {
            [_photoImage setImage:image];
        }else{
            [_photoImage setImage:[UIImage imageNamed:@"default_photo.png"]];
        }
    }else{
        [_photoImage setImage:[UIImage imageNamed:@"default_photo.png"]];
    }
    _photoImage.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:_photoImage];
    
    //设置输入模块边框
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 160+h*2, 320, 190)];
    view.image=[UIImage imageNamed:@"login_Input_bg.png"];
    [self.view addSubview:view];
    [view release];
    
    //选择驾校输入框标题
    UILabel *schoolLabel=[[UILabel alloc] initWithFrame:CGRectMake(35, 190+h*2, 60, 35)];
    schoolLabel.text=@"驾　校";
    schoolLabel.font=[UIFont fontWithName:@"Arial" size:16.f];
    schoolLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:schoolLabel];
    [schoolLabel release];
    
    //选择驾校输入框
    _schoolEdit=[[UITextField alloc] initWithFrame:CGRectMake(90, 190+h*2, 190, 35)];
    _schoolEdit.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//垂直居中
    _schoolEdit.borderStyle=UITextBorderStyleRoundedRect;
    _schoolEdit.placeholder=@"选择驾校";
    if ([_userDefaults objectForKey:SCHOOL_URL]) {
        _schoolEdit.text=[_userDefaults objectForKey:SCHOOL_NAME];
    }else{
        _schoolEdit.text=@"";
    }
    _schoolEdit.tag=101;
    _schoolEdit.font=[UIFont fontWithName:@"Arial" size:16.f];
    _schoolEdit.delegate=self;
    [self.view addSubview:_schoolEdit];
    
    //    UIButton *addBtn =[UIButton buttonWithType:UIButtonTypeContactAdd];
    //    addBtn.frame=CGRectMake(160, 5, 25, 25);
    //    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [_schoolEdit addSubview:addBtn];
    
    //用户名标题
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(35, 235+h*2, 60, 35)];
    nameLabel.text=@"用户名";
    nameLabel.font=[UIFont fontWithName:@"Arial" size:16.f];
    nameLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:nameLabel];
    [nameLabel release];
    
    //用户名输入框
    _nameEdit=[[UITextField alloc] initWithFrame:CGRectMake(90, 235+h*2, 190, 35)];
    _nameEdit.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//垂直居中
    _nameEdit.borderStyle=UITextBorderStyleRoundedRect;
    _nameEdit.placeholder=@"默认是您的身份证号码";
    
    if ([_userDefaults objectForKey:USER_NAME]) {
        _nameEdit.text=[_userDefaults objectForKey:USER_NAME];//350426199105175541  350626199105071014 500net 13965
    }else{
        _nameEdit.text=@"";
    }
    
    [_nameEdit setClearButtonMode:UITextFieldViewModeWhileEditing];
    [_nameEdit setKeyboardType:UIKeyboardTypeAlphabet];
    [_nameEdit setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_nameEdit setAutocorrectionType:UITextAutocorrectionTypeNo];
    _nameEdit.delegate=self;
    [self.view addSubview:_nameEdit];
    
    //密码输入框标题
    UILabel *pwdLabel=[[UILabel alloc] initWithFrame:CGRectMake(35, 280+h*2, 60, 35)];
    pwdLabel.text=@"密　码";
    pwdLabel.font=[UIFont fontWithName:@"Arial" size:16.f];
    pwdLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:pwdLabel];
    [pwdLabel release];
    
    //密码输入框
    _pwdEdit=[[UITextField alloc] initWithFrame:CGRectMake(90, 280+h*2, 190, 35)];
    _pwdEdit.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;//垂直居中
    _pwdEdit.borderStyle=UITextBorderStyleRoundedRect;
    _pwdEdit.placeholder=@"默认是您的身份证号码";
    
    if ([_userDefaults objectForKey:PASS_WORD]) {
        
        _pwdEdit.text=[_userDefaults objectForKey:PASS_WORD];//fz500net  350426199105175541
    }
    else
    {
        _pwdEdit.text=@"";
    }
    
    [_pwdEdit setSecureTextEntry:YES];
    [_pwdEdit setClearButtonMode:UITextFieldViewModeWhileEditing];
    _pwdEdit.delegate=self;
    [self.view addSubview:_pwdEdit];
    
    //登录按钮
    _loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (ScreenHeight > 480) {
        _loginBtn.frame=CGRectMake(30, 370+h*2, 260, 45);
    }else{
        _loginBtn.frame=CGRectMake(30, 355, 260, 45);
    }
    [_loginBtn successStyle];
    [_loginBtn setTitle:@"登  录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font=[UIFont systemFontOfSize:18.0];
    [_loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    UIButton *phoneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(30, self.view.frame.size.height-40, 260, 30);
    [phoneBtn setTitle:@"技术支持热线：0591-88262303" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:darkGreenColor forState:UIControlStateNormal];
    phoneBtn.titleLabel.font=[UIFont systemFontOfSize:15.0];
    phoneBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [phoneBtn addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
    
    
}

//拨打电话
-(void)callPhone:(UIButton *)callBtn
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSString *phoneNumber=[NSString stringWithFormat:@"tel://%@",[callBtn.titleLabel.text substringFromIndex:7]];
    NSURL *telURL =[NSURL URLWithString:phoneNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    [callWebview release];
}


//获取驾校
-(BOOL)getSchool
{
    NSString *stringURL=[NSString stringWithFormat:@"http://app.51xc.cn/apps/config.ini"];
    NSURL *url=[NSURL URLWithString:stringURL];
    
    NSURLRequest *requrst = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    CSimpleIniA ini;
    ini.SetUnicode();
    
    NSData *data= [NSURLConnection sendSynchronousRequest:requrst returningResponse:nil error:nil];
    if (!data) {
        [self.view makeToast:@"网络连接错误"];
        return NO;
    }
    NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str=[[NSString alloc]initWithData:data encoding:gbkEncoding];
    ini.LoadData([str UTF8String]);
    const char *code=ini.GetValue("city", "code");
    const char *name=ini.GetValue("city", "name");
    [str release];
    if (!code) {
        return NO;
    }
    if (!name) {
        return NO;
    }
    
    ini.SetValue("section", "key", "newvalue");
    
    NSString *cityStr=[NSString stringWithCString:code encoding:NSUTF8StringEncoding];
    
    NSArray *citycode=[cityStr componentsSeparatedByString:@","];
    NSString *cityStr1=[NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    NSArray *cityname=[cityStr1 componentsSeparatedByString:@","];
    //获取所有的Section：
    CSimpleIniA::TNamesDepend sections;
    ini.GetAllSections(sections);
    
    CSimpleIniA::TNamesDepend::const_iterator m;
    for (int i=0; i<citycode.count; i++) {
        for (m = sections.begin(); m != sections.end(); ++m) {
            NSString *tempS=[NSString stringWithCString:m->pItem encoding:NSUTF8StringEncoding];
            if ([citycode[i] isEqualToString:tempS]) {
                //获取Section下面的所有Keys：
                CSimpleIniA::TNamesDepend keys;
                ini.GetAllKeys(m->pItem, keys);
                CSimpleIniA::TNamesDepend::const_iterator j;
                for (j = keys.begin(); j != keys.end(); ++j) {
                    //获取Section下面的所有values：
                    CSimpleIniA::TNamesDepend values;
                    ini.GetAllValues( m->pItem, j->pItem, values);
                    //获得学校代码
                    NSString *schoolCode=[NSString stringWithCString:j->pItem encoding:NSUTF8StringEncoding];
                    CSimpleIniA::TNamesDepend::const_iterator k;
                    for (k = values.begin(); k != values.end(); ++k) {
                        printf("***********VersionSet的value-name = '%s'\n", k->pItem);
                        //学校数据对象
                        NSMutableDictionary *school=[[NSMutableDictionary alloc] init];
                        [school setObject:cityname[i] forKey:CITY_NAME];
                        [school setObject:citycode[i] forKey:CITY_CODE];
                        [school setObject:schoolCode forKey:SCHOOL_CODE];
                        
                        NSString *tempk=[NSString stringWithCString:k->pItem encoding:NSUTF8StringEncoding];
                        NSArray *a=[tempk componentsSeparatedByString:@","];
                        if (a.count>2) {
                            if ([a[2] isEqualToString:@"true"]) {
                                [school setObject:a[0] forKey:SCHOOL_NAME];
                                [school setObject:a[1] forKey:SCHOOL_URL];
                                if (a.count>3) {
                                    [school setObject:a[3] forKey:ISALLOWBB];
                                }else{
                                    [school setObject:@"true" forKey:ISALLOWBB];
                                }
                            }
                        }
                        [_schoolData addObject:school];
                        [school release];
                        break;
                    }
                }
                break;
            }
        }
    }
    [_userDefaults setObject:_schoolData forKey:SCHOOLDATA];
    [_userDefaults synchronize];
    if (_schoolData.count>0) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark --选择驾校点击处理

//拦截选择驾校输入框的键盘弹出事件，改为弹出选择对话框
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.tag == 101 ){
        //隐藏弹出的软键盘
        [_nameEdit resignFirstResponder];
        [_pwdEdit resignFirstResponder];
        if (_schoolData.count > 0) {
            GetSchoolViewController *gsvc=[[GetSchoolViewController alloc] init];
            gsvc.delegate=self;
            gsvc.schoolArray=_schoolData;
            [self.navigationController pushViewController:gsvc animated:YES];
            [gsvc release];
        }else{
            [self.view makeToast:@"驾校数据加载失败，请重试！"];
            [self getSchool];
        }
        return NO;
    }else{
        return YES;
    }
}


#pragma mark --软键盘显示处理

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //    [UIView animateWithDuration:0.3 animations:^{
    self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-80, self.view.frame.size.width, self.view.frame.size.height);
    //    }];
    
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+80, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

#pragma mark --登录和退出按键事件

//登录按键监听
-(void)loginClick:(UIButton *) btn{
    //隐藏弹出的软键盘
    [_nameEdit resignFirstResponder];
    [_pwdEdit resignFirstResponder];
    
    if ([StringUtil isBlank:_schoolEdit.text]) {
        //自定义底部提示对话框
        [self.view makeToast:@"请选择驾校！"];
    }else if ([StringUtil isBlank:_nameEdit.text]){
        //自定义底部提示对话框
        [self.view makeToast:@"请输入用户名！"];
    }else if ([StringUtil isBlank:_pwdEdit.text]){
        //自定义底部提示对话框
        [self.view makeToast:@"请输入密码！"];
    }else{
        [_userDefaults setValue:_nameEdit.text forKey:USER_NAME];
        [_userDefaults setValue:_pwdEdit.text forKey:PASS_WORD];
        [_userDefaults synchronize];//保证数据被写入
        
        [self login];//登录数据请求
    }
}

//登录数据请求
-(void)login{
    NSString *md5=[MD5Encrypt md5:_pwdEdit.text];
    
    //自定义指示器
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"登录中";
    [HUD show:YES];
    
    //启动异步线程，进行数据加载
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![NetWork isWorking]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hide:YES];
                [HUD release];
                [self.view makeToast:@"亲，当前网络不给力，请检查你的手机是否能正常上网！"];
            });
        }else{
            NSString *url=@"";
            for(NSDictionary *dic in _schoolData){
                NSString *sName=[dic objectForKey:SCHOOL_NAME];
                if ([_schoolEdit.text isEqualToString:sName]) {
                    url=[dic objectForKey:SCHOOL_URL];
                }
            }
            
            NSString *loginUrl=[url stringByAppendingString:LOGIN_URL];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:loginUrl]];
            [request setPostValue:_nameEdit.text forKey:@"username"];
            [request setPostValue:md5 forKey:@"password"];
            [request startSynchronous];
            [request setTimeOutSeconds:30];
            [request setValidatesSecureCertificate:NO];
            NSString *key;
            NSError *erro = [request error];
            if (erro) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hide:YES];
                    [HUD release];
                    [self.view makeToast:@"亲，获取数据失败，请检查您的手机是否能正常上网！"];
                });
                return ;
            }else{
                key=[request responseString];
            }
            
            if(key == nil || [@"" isEqualToString:key]){
                //用户名密码出错
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hide:YES];
                    [HUD release];
                    //提示密码出错
                    [self.view makeToast:@"用户名或密码出错！"];
                });
            }else{
                //保存key值
                [_userDefaults setValue:key forKey:KEY];
                [_userDefaults synchronize];
                
                //请求用户对象
                GetDataHelper *gdh=[[GetDataHelper alloc] initWithView:self.view];
                gdh.businessCode=HANDLER_ACCOUNT_CODE;
                NSString *response=[gdh getResponseFromUrl];
                
                //解析字符串为字典数据
                XMLParser *parse=[[XMLParser alloc] init];
                NSMutableArray *user=[parse XMLParse:response];
                if (user.count == 0) {
                    //获取不到user对象
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD hide:YES];
                        [HUD release];
                        
                        [self.view makeToast:@"获取不到用户数据，请检查您的手机是否能正常上网！"];
                    });
                    [gdh release];
                    [parse release];
                    return;
                }
                
                NSDictionary *dic=[user objectAtIndex:0];
                [gdh release];
                [parse release];
                //判断是否是教练员和学员账号,1是管理员，2是学员，3是教练员
                
                if ([[dic objectForKey:@"userType"] intValue] == 1 || [[dic objectForKey:@"userType"] intValue] == 2) {
                    
                    [_userDefaults setValue:[dic objectForKey:@"id"] forKey:USER_ID];
                    [_userDefaults setValue:[dic objectForKey:@"userType"] forKey:USER_TYPE];
                    [_userDefaults setValue:[dic objectForKey:@"nickname"] forKey:USER_NICK_NAME];
                    [_userDefaults setValue:[[dic objectForKey:@"detailInfo"] objectForKey:@"companyId"] forKey:SCHOOL_CODE];//保存当前companyId
                    
                    //创建用户信息，并且保存到本地,key值为驾校Id
                    NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
                    [userInfo setObject:[dic objectForKey:@"id"] forKey:USER_ID];
                    [userInfo setObject:_nameEdit.text forKey:USER_NAME];
                    [userInfo setObject:_pwdEdit.text forKey:PASS_WORD];
                    [userInfo setObject:[_userDefaults objectForKey:KEY] forKey:KEY];
                    [userInfo setObject:[_userDefaults objectForKey:SCHOOL_URL] forKey:SCHOOL_URL];
                    [_userDefaults setValue:userInfo forKey:[[dic objectForKey:@"detailInfo"] objectForKey:@"companyId"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD hide:YES];
                        [HUD release];
                        [self inputLogin];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HUD hide:YES];
                        [HUD release];
                        //提示使用的账号出错
                        [self.view makeToast:@"请使用学员账号登录！"];
                    });
                }
            }
        }
    });
}


//登录到主界面
-(void)inputLogin
{
    //    AppDelegate * delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
   // MainViewController *mainVC=[[MainViewController alloc]init];
    //获取设置视图代理
    //    delegate.rightViewController.mainViewController=mainVC;//获取右侧栏中的代理
    //    mainVC.dMenuViewController=delegate.dMenuViewController;
  //  [self.navigationController pushViewController:mainVC animated:YES];
   // [mainVC release];
}


//获取当前位置
-(void)getNowPosition
{
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    if ([CLLocationManager locationServicesEnabled]) {
        //        NSLog( @"Starting CLLocationManager" );
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 200;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    } else {
        //        NSLog( @"Cannot Starting CLLocationManager" );
    }
    // 开始时时定位
    [self.locationManager startUpdatingLocation];
    
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    //    NSLog(@"%@",error);
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _checkinLocation = locations[0];
    //    NSLog(@"%f..........%f",_checkinLocation.coordinate.longitude,_checkinLocation.coordinate.latitude);
    [manager stopUpdatingLocation];
    //    //------------------位置反编码---5.0之后使用-----------------
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_checkinLocation completionHandler:^(NSArray *placemarks, NSError *error){
        for (CLPlacemark *place in placemarks) {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:USER_CITY]!=nil) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_CITY];
                [[NSUserDefaults standardUserDefaults] setObject:place.locality forKey:USER_CITY];
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:place.locality forKey:USER_CITY];
            }
            
            
        }
    }];
    [geocoder release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
