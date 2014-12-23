//
//  AppDelegate.m
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationVController.h"
//#import "LoginViewController.h"
#import "BPush.h"
#import "DataBaseContstants.h"
#import "SystemContants.h"
#import "Dconfig.h"
/*#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
*/
#import "MyRequestData.h"
#import "DataBaseHelper.h"
#import "PushAlertView.h"
#import "MobClick.h"
#import "ViewController.h"
@implementation AppDelegate

@synthesize push_delegate;

-(void)dealloc
{
    [_window release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window =window;
    [window release];
    
    [application setApplicationIconBadgeNumber:0];
    
    self.window.backgroundColor = [UIColor whiteColor];
   // LoginViewController *lvc=[[LoginViewController alloc]init];
    //self.loginViewController=lvc;
    ViewController *lvc=[[ViewController alloc]init];
    [NdUncaughtExceptionHandler setDefaultHandler];
    BaseNavigationVController * bnv=[[BaseNavigationVController alloc]initWithRootViewController:lvc];
    [lvc release];
    self.window.rootViewController=bnv;
    [bnv release];
    [self.window makeKeyAndVisible];
    
    [BPush setupChannel:launchOptions]; // 必须
    
    [BPush setDelegate:self]; // 必须。参数对象必须实现onMethod: response:方法，本示例中为self
    
    // [BPush setAccessToken:@"3.ad0c16fa2c6aa378f450f54adb08039.2592000.1367133742.282335-602025"];  // 可选。api key绑定时不需要，也可在其它时机调用
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert
     | UIRemoteNotificationTypeBadge
     | UIRemoteNotificationTypeSound];
    
//    UIRemoteNotificationType types = UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert;
//    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
 /*
    //sharesdk设置
    [ShareSDK registerApp:@"1106f7f43764"];     //参数为ShareSDK官网中添加应用后得到的AppKey
    
    //导入微信需要的外部库类型，如果不需要微信分享可以不调用此方法
    [ShareSDK importWeChatClass:[WXApi class]];
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"2271568829"
                               appSecret:@"63d7d3b115050b1fd33b1bba37befe86"
                             redirectUri:@"http://51xc.cn/apps/wap.html"];
    //添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:@"101005337"                 //该参数填入申请的QQ AppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"101005337"
                           appSecret:@"1216cfb56d1df85c540be04b1cba97a9"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信好友分享
    [ShareSDK connectWeChatSessionWithAppId:@"wxfb3843c5dbec6283" wechatCls:[WXApi class]];
    
    //添加朋友圈
    [ShareSDK connectWeChatTimelineWithAppId:@"wxfb3843c5dbec6283" wechatCls:[WXApi class]];
    
    //短信
    [ShareSDK connectSMS];
    */
    //友盟统计
//    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，取消注释此行
//    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick startWithAppkey:@"53bd059956240bb136023f60" reportPolicy:SEND_ON_EXIT   channelId:@"Web"];
    
    
    //是否更换数据库
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:USER_ID] && ![ReBuildDbDate isEqualToString:[userDefault objectForKey:DbBuildDate]]) {
        DataBaseHelper *dbh=[[DataBaseHelper alloc]init];
        [dbh reBuildDatabase];//重载数据库文件
        [userDefault setObject:ReBuildDbDate forKey:DbBuildDate];
    }
    return YES;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //NSLog(@"error:%@",[error localizedDescription]);
}

-(void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    [BPush registerDeviceToken:deviceToken]; // 必须
    
    [BPush bindChannel]; // 必须。可以在其它时机调用，只有在该方法返回（通过onMethod:response:回调）绑定成功时，app才能接收到Push消息。一个app绑定成功至少一次即可（如果access token变更请重新绑定）。
}
// 必须，如果正确调用了setDelegate，在bindChannel之后，结果在这个回调中返回。
// 若绑定失败，请进行重新绑定，确保至少绑定成功一次
- (void) onMethod:(NSString*)method response:(NSDictionary*)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method])
    {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"device_userid"]==nil) {
            NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
//          NSString *appid = [res valueForKey:BPushRequestAppIdKey];
            NSString *userid = [res valueForKey:BPushRequestUserIdKey];
            NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
            [[NSUserDefaults standardUserDefaults] setObject:userid forKey:@"device_userid"];
            [[NSUserDefaults standardUserDefaults] setObject:channelid forKey:@"device_channelid"];
            [res release];
        }
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *companyId=[userInfo objectForKey:@"companyId"];
    NSString *target=[userInfo objectForKey:@"target"];
    
    NSString *userID=[[userDefault objectForKey:companyId] objectForKey:USER_ID];//该驾校当前账号的用户ID
    if (![userID isEqualToString:target]) {
        //不是该驾校当前保存的账号的消息，则不做任何处理
        return;
    }
    NSString *MyCompanyId=[userDefault objectForKey:SCHOOL_CODE];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        DataBaseHelper *dbh=[[DataBaseHelper alloc]init];
        NSMutableArray *pushNews=[[NSMutableArray alloc]initWithCapacity:1];
        NSString *userId;
        if ([MyCompanyId isEqualToString:companyId]) {//是当前账户所在的驾校发过来的信息
            [pushNews addObjectsFromArray:[MyRequestData getPushInformations:self.window.rootViewController.view]];
            userId=[userDefault objectForKey:USER_ID];
        }else{
            NSDictionary *info=[userDefault objectForKey:companyId];
            
            NSString *url=[NSString stringWithFormat:@"%@%@",[info objectForKey:SCHOOL_URL],SERVICE_URL];
            userId=[info objectForKey:USER_ID];
            NSString *key=[info objectForKey:KEY];
            
            [pushNews addObjectsFromArray:[MyRequestData getOtherSchoolPushInformations:self.window.rootViewController.view andUrl:url andUserId:userId andKey:key]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *dic in pushNews) {
                
                NSMutableDictionary *temp=[[NSMutableDictionary alloc]initWithDictionary:dic];
                NSMutableDictionary *sender=[[NSMutableDictionary alloc] init];
                [sender setObject:[temp objectForKey:@"senderId"] forKey:@"senderId"];
                [sender setObject:[temp objectForKey:@"senderName"] forKey:@"senderName"];
                [sender setObject:[temp objectForKey:@"content"] forKey:@"lastContent"];
                [sender setObject:[temp objectForKey:@"sendTime"] forKey:@"senderTime"];
                
                int num=[dbh getNotReadNum:[temp objectForKey:@"senderId"]];
                [sender setObject:[NSNumber numberWithInt:(num+1)] forKey:@"notReadNum"];
                [sender setObject:userId forKey:@"userId"];
                [sender setObject:[temp objectForKey:@"companyId"] forKey:@"companyId"];
                [dbh savePushInformation:temp andReceiverId:userId];
                [dbh saveSender:sender];
                
                if ([MyCompanyId isEqualToString:companyId]) {//是当前账户所在的驾校发过来的信息
                    if ([@"popup" isEqualToString:[dic valueForKey:@"showMode"]]) {
                        PushAlertView * alertView=[[PushAlertView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                        alertView.pushDictionary=temp;
                        [alertView show];
                    }
                }else{
                    if (![[dic valueForKey:@"msgType"] isEqualToString:@"CMD"]) {
                        PushAlertView * alertView=[[PushAlertView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                        alertView.pushDictionary=temp;
                        [alertView show];
                    }
                }
                
                BOOL isSoundOff=[userDefault boolForKey:ISSOUNDOFF];
                if (!isSoundOff && ![[dic valueForKey:@"showMode"] isEqualToString:@"silent"] ) {
                    AudioServicesPlaySystemSound(1106);
                }
                [sender release];
                [temp release];
            }
            
            [push_delegate getPushMessage];
            [pushNews release];
            [dbh release];
        });
    });
    [application setApplicationIconBadgeNumber:0];
    [BPush handleNotification:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
   // return [ShareSDK handleOpenURL:url   wxDelegate:self];
    return false;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
/*    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
 */
    return false;
}

@end
