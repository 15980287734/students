//
//  RightViewController.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "RightViewController.h"
#import "AppDelegate.h"
#import "DMenuViewController.h"
#import "EditPasswordViewController.h"
#import "MainViewController.h"
#import "BaseNavigationVController.h"
#import "CarTypeViewController.h"
#import "QuestionsDatabaseViewController.h"
#import "OffLineDataDownload.h"
#import "RNBlurModalView.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "JiuGongButton.h"
#import "DrawLooteryViewController.h"
#import "RNBlurModalView.h"
#import "NetWork.h"
#import "FTWCache.h"


@interface RightViewController ()

@end

@implementation RightViewController{
    OffLineDataDownload *offLoad;
    RNBlurModalView *_handupModal;
    RNBlurModalView *alertModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, ScreenHeight)];
    self.view=view;
    [view release];
}
//复写setTitle方法,设置标题
-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = title;
    [titleLabel sizeToFit];
    
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"个人中心"];
    //self.view.backgroundColor=lightBlueColor;
    UIImageView *bg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, ScreenHeight)];
    bg.image=[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/zixun_bg.png", StrBundle]];
    [self.view addSubview:bg];
    [bg release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight-20-44)];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    
    float width=320/3.0;
    float height=width;
    JiuGongButton *btn01=[[JiuGongButton alloc] initWithFrame:CGRectMake(0, 0, width, height) andImage:@"selectCarType_cell.png" andName:@"选择车型"];
    [btn01 addTarget:self action:@selector(pushCarTypeView) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn01];
    [btn01 release];
    
    JiuGongButton *btn02=[[JiuGongButton alloc] initWithFrame:CGRectMake(width, 0, width, height) andImage:@"mydownload_cell.png" andName:@"选择题库"];
    [btn02 addTarget:self action:@selector(pushQuestionsDatabaseView) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn02];
    [btn02 release];
    
    JiuGongButton *btn03=[[JiuGongButton alloc] initWithFrame:CGRectMake(width*2, 0, width, height) andImage:@"loadTest_cell.png" andName:@"加载题库"];
    [btn03 addTarget:self action:@selector(downloadOffLineData) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn03];
    [btn03 release];
    
    JiuGongButton *btn04=[[JiuGongButton alloc] initWithFrame:CGRectMake(0, height, width, height) andImage:@"wage.png" andName:@"我要抽奖"];
    [btn04 addTarget:self action:@selector(luckyDraw) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn04];
    [btn04 release];
    
    JiuGongButton *btn05=[[JiuGongButton alloc] initWithFrame:CGRectMake(width, height, width, height) andImage:@"fenxiang.png" andName:@"分享"];
    [btn05 addTarget:self action:@selector(shareInfo) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn05];
    [btn05 release];
    
    JiuGongButton *btn06=[[JiuGongButton alloc] initWithFrame:CGRectMake(width*2, height, width, height) andImage:@"xgmm_cell.png" andName:@"修改密码"];
    [btn06 addTarget:self action:@selector(updatePassword) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn06];
    [btn06 release];
    
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    BOOL isSoundOFF=[user boolForKey:ISSOUNDOFF];
    if (isSoundOFF) {//为真就是声音关闭
        JiuGongButton *btn07=[[JiuGongButton alloc] initWithFrame:CGRectMake(0, height*2, width, height) andImage:@"off_sound.png" andName:@"消息提示音"];
        [btn07 addTarget:self action:@selector(soundChange:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn07];
        [btn07 release];
    }else{
        JiuGongButton *btn07=[[JiuGongButton alloc] initWithFrame:CGRectMake(0, height*2, width, height) andImage:@"on_sound.png" andName:@"消息提示音"];
        [btn07 addTarget:self action:@selector(soundChange:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn07];
        [btn07 release];
    }

    
    JiuGongButton *btn08=[[JiuGongButton alloc] initWithFrame:CGRectMake(width, height*2, width, height) andImage:@"us_cell.png" andName:@"关于我们"];
    [btn08 addTarget:self action:@selector(aboutUs) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn08];
    [btn08 release];
    
    JiuGongButton *btn09=[[JiuGongButton alloc] initWithFrame:CGRectMake(width*2, height*2, width, height) andImage:@"exit.png" andName:@"注销登录"];
    [btn09 addTarget:self action:@selector(setReboot) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn09];
    [btn09 release];
    
    scrollView.contentSize=CGSizeMake(320, height*4);
    [self.view addSubview:scrollView];
    [scrollView release];
    
}

//注销
-(void)setReboot
{
    if (_handupModal == nil || [_handupModal isHidden]) {
        _handupModal = [[RNBlurModalView alloc] initWithViewController:self title:@"注销账号" message:[NSString stringWithFormat:@"确定要注销账号吗？"]];
        _handupModal.positiveBtn.tag=101;
        [_handupModal.positiveBtn addTarget:self action:@selector(positiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _handupModal.negativeBtn.tag=101;
        [_handupModal.negativeBtn addTarget:self action:@selector(negativeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_handupModal show];
    }
}

-(void)positiveBtnClick:(UIButton *)btn{
    if (btn.tag == 101) {
        [FTWCache resetCache];
        [_handupModal hide];
        LoginViewController *lvc=(LoginViewController *)[self.navigationController.viewControllers objectAtIndex:0];
        [lvc loginaAgain];
        [self.mainViewController.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [alertModel hide];
        offLoad=[[OffLineDataDownload alloc] initWithViewControl:self];
        offLoad.isReset=YES;
        [offLoad loadOffLineData];
    }
}

-(void)negativeBtnClick:(UIButton *)btn{
    if (btn.tag == 101) {
        [_handupModal hide];
    }else{
        [alertModel hide];
    }
    
}

-(void)soundChange:(JiuGongButton *)btn{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    BOOL isSoundOFF=[user boolForKey:ISSOUNDOFF];
    if (isSoundOFF) {
        btn.myImage.image=[UIImage imageNamed:@"on_sound.png"];
        [user setBool:NO forKey:ISSOUNDOFF];
    }else{
        btn.myImage.image=[UIImage imageNamed:@"off_sound.png"];
        [user setBool:YES forKey:ISSOUNDOFF];
    }
    [user synchronize];//保证数据被写入
}


//修改密码
-(void)updatePassword
{
    EditPasswordViewController *epvc=[[EditPasswordViewController alloc]init];
    [self.navigationController pushViewController:epvc animated:YES];
    [epvc release];
}

/**
 *	@brief	离线数据加载
 */
-(void)downloadOffLineData
{
    NSUserDefaults *usDefault=[NSUserDefaults standardUserDefaults];
    NSString *libraryid=[usDefault stringForKey:USEDLIBRARY];
    NSString *usedCarType=[usDefault stringForKey:CARTYPE];
    if (!usedCarType) {
        CarTypeViewController *ctvc=[[CarTypeViewController alloc] init];
        [self.navigationController pushViewController:ctvc animated:YES];
        [ctvc release];
    }else if (!libraryid) {//是否选择题库
        QuestionsDatabaseViewController *qdvc=[[QuestionsDatabaseViewController alloc] init];
        [self.navigationController pushViewController:qdvc animated:YES];
        [qdvc release];
    }else{
        if ([NetWork isWifi]) {
            offLoad=[[OffLineDataDownload alloc] initWithViewControl:self];
            offLoad.isReset=YES;
            [offLoad loadOffLineData];
        }else{
            alertModel=[[RNBlurModalView alloc] initWithViewController:self title:@"题库加载确认" message:@"您当前使用的是非Wifi网络，加载题库将耗费较多流量，是否确定下载？"];
            [alertModel.positiveBtn addTarget:self action:@selector(positiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertModel.positiveBtn setTag:102];
            [alertModel.negativeBtn addTarget:self action:@selector(negativeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [alertModel.negativeBtn setTag:102];
            [alertModel show];
        }
    }
}

//车型选择
-(void)pushCarTypeView
{
    CarTypeViewController *ctvc=[[CarTypeViewController alloc]init];
    [self.mainViewController.navigationController pushViewController:ctvc animated:YES];
    [ctvc release];
}

//选择题库
-(void)pushQuestionsDatabaseView
{
    QuestionsDatabaseViewController *qdvc=[[QuestionsDatabaseViewController alloc]init];
    [self.mainViewController.navigationController pushViewController:qdvc animated:YES];
    [qdvc release];
}

-(void)aboutUs{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 120)];
    UIColor *whiteColor = [UIColor colorWithRed:0.816 green:0.788 blue:0.788 alpha:1.000];
    view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8f];
    view.layer.borderColor = whiteColor.CGColor;
    view.layer.borderWidth = 2.f;
    view.layer.cornerRadius = 10.f;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 120)];
    textLabel.font=[UIFont fontWithName:@"Arial" size:15];
    textLabel.text=[NSString stringWithFormat:@"福州市五佰网络科技有限公司\n联系电话:0591-88262303\nQQ交流群:115708779\n当前应用版本:%@",appCurVersion];
    textLabel.textColor=[UIColor whiteColor];
    textLabel.textAlignment=NSTextAlignmentCenter;
    textLabel.numberOfLines=0;
    textLabel.backgroundColor=[UIColor clearColor];
    [view addSubview:textLabel];
    [textLabel release];
    
    RNBlurModalView *_modal = [[RNBlurModalView alloc] initWithViewController:self view:view];
    [view release];
    [_modal show];
    [_modal release];
}

//抽奖
-(void)luckyDraw
{
    DrawLooteryViewController *dlvc=[[DrawLooteryViewController alloc]init];
    [self.navigationController pushViewController:dlvc animated:YES];
    [dlvc release];
}

/**
 *	@brief	分享
 */
-(void)shareInfo
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share_ic"  ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"#51学车网#51学车助手手机端应用隆重推出，这是一款专为合作驾校学员定制的应用软件，功能简洁易用，赶紧来下载体验吧！http://www.51xc.cn/apps/wap.html"
                                       defaultContent:@"#51学车网#51学车助手手机端应用隆重推出，这是一款专为合作驾校学员定制的应用软件，功能简洁易用，赶紧来下载体验吧！http://www.51xc.cn/apps/wap.html"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"51学车助手手机端应用隆重推出"
                                                  url:@"http://www.51xc.cn/apps/wap.html"
                                          description:@"#51学车网#51学车助手手机端应用隆重推出，这是一款专为合作驾校学员定制的应用软件，功能简洁易用，赶紧来下载体验吧！http://www.51xc.cn/apps/wap.html"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //定制QQ空间分享
    [publishContent addQQSpaceUnitWithTitle:@"51学车助手手机端应用隆重推出!"
                                        url:INHERIT_VALUE
                                       site:nil
                                    fromUrl:@"http://www.51xc.cn/apps/wap.html"
                                    comment:INHERIT_VALUE
                                    summary:INHERIT_VALUE
                                      image:INHERIT_VALUE
                                       type:INHERIT_VALUE
                                    playUrl:nil
                                       nswb:[NSNumber numberWithInteger:1]];
    
    //定制微信好友内容
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:@"#51学车网#51学车助手手机端应用隆重推出，这是一款专为合作驾校学员定制的应用软件，功能简洁易用，赶紧来下载体验吧！http://www.51xc.cn/apps/wap.html"
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:INHERIT_VALUE
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈内容
    [publishContent addWeixinTimelineUnitWithType:INHERIT_VALUE
                                          content:@"#51学车网#51学车助手手机端应用隆重推出，这是一款专为合作驾校学员定制的应用软件，功能简洁易用，赶紧来下载体验吧！http://www.51xc.cn/apps/wap.html"
                                            title:INHERIT_VALUE
                                              url:INHERIT_VALUE
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制QQ分享内容
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:INHERIT_VALUE
                                title:INHERIT_VALUE
                                  url:INHERIT_VALUE
                                image:INHERIT_VALUE];
    
    
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}
//检查更新
-(void)checkVersion{
    NSString *appStoreLink = @"https://itunes.apple.com/cn/app/51xue-che-zhu-shou/id789260884?mt=8";
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appStoreLink]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    if (offLoad) {
        [offLoad release];
    }
    //    if (_handupModal) {
    //        [_handupModal release];
    //    }
    [super dealloc];
}

@end
