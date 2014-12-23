//
//  ViewController.m
//  demo
//
//  Created by chen on 14-11-02.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "ViewController.h"

#import "NetDataComRequest.h"
//对应滑动scrollview用到的头文件
#import "KTPractiveScrollViewController.h"
#import "KTDemoSource.h"
//
#import "KTViewController.h"
#import "KTTableDemo.h"
@interface ViewController ()
{
     KTDemoSource *dataSource_;
     
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     
     //初始化数据
    NSArray * TitielArray = [NSArray arrayWithObjects:@"网易", @"新浪", @"腾讯", @"搜狐", @"百度", @"谷歌", @"奇虎",@"阿里",@"火狐",@"天猫", nil];
    //
    UIButton* bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt1.frame=CGRectMake(50, 50, 100, 50);
    [bt1 setTitle:@"scrollview" forState:UIControlStateNormal];
    [bt1 setBackgroundColor:[UIColor blackColor]];
    [bt1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *bt= [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame=CGRectMake(50, 110, 100, 50);
    [bt setTitle:@"通信" forState:UIControlStateNormal];
    bt.backgroundColor=[UIColor blackColor];
    [bt addTarget:self action:@selector(bt1Click:) forControlEvents:UIControlEventTouchUpInside];
    //
    UIButton *bt3= [UIButton buttonWithType:UIButtonTypeCustom];
    bt3.frame=CGRectMake(50, 170, 100, 50);
    [bt3 setTitle:@"tabview" forState:UIControlStateNormal];
    bt3.backgroundColor=[UIColor blackColor];
    [bt3 addTarget:self action:@selector(bt3Click:) forControlEvents:UIControlEventTouchUpInside];
    

    [self.view addSubview:bt];
    [bt release];
    [self.view addSubview:bt1];
    [bt1 release];
    [self.view addSubview:bt3];
    [bt3 release];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onRecvdone:(NSString *)msg
{
    NSLog(@"onRecvdone==%@",msg);

}
-(void)onRecverr:(NSString *)msg
{


}
-(void)bt1Click:(NSString *)msg
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *group=[[NSMutableDictionary alloc]init];
    [group setValue:@"AD_M1" forKey:@"id"];
    [dic setValue:group forKeyPath:@"group"];
    
    NetDataComRequest *demo=[[NetDataComRequest alloc]init];
    [demo setCode:HANDLER_AD_LINK_CODE];
    [demo setMacKey:@"00000000"];
    [demo setHead:@"adfe788f3fa011e499cdf36da2be9d8c" forName:@"userId"];
    [demo setHead:@"1393" forName:@"userName"];
    [demo setMsgData:dic forRow:0];
    [demo setPagingRow:1 withPage:10];
    // NSString *res=[demo getResponseFromUrl:@"http://115.29.10.98:5171/comm/busService"];
    // NSMutableArray *rsd=[demo getADataResponse:@"http://115.29.10.98:5171/comm/busService"];
    //  NSLog(@"===%@",rsd);
    demo.delegate=self;
    [demo getAsynResponseFromUrl:@"http://115.29.10.98:5171/comm/busService" withPostAction:@"downloadXMLData" withAction:@"query"];

}
-(void)BtnClick:(NSString *)msg
{
    NSMutableArray *btD=[[NSMutableArray alloc] initWithObjects:
                         [NSMutableArray arrayWithObjects:@"practice_left_arrows.png", @"上一题", @"101",nil],
                         [NSMutableArray arrayWithObjects:@"practice_show_answer.png", @"查看答案", @"102",nil],
                         [NSMutableArray arrayWithObjects:@"practice_setting.png", @"0/0", @"103",nil],
                         [NSMutableArray arrayWithObjects:@"practice_show_answer.png", @"收藏", @"104",nil],
                         [NSMutableArray arrayWithObjects:@"practice_right_arrows.png", @"下一题", @"105",nil],
                         
                         nil];
    dataSource_=[[KTDemoSource alloc]init];
    KTPractiveScrollViewController *views=[[KTPractiveScrollViewController alloc]initWithDataSource:dataSource_ withBarItem:btD andStartWithViewAtIndex:0];
   
    [self.navigationController pushViewController:views animated:YES];
     [views release];
}
-(void)bt3Click:(NSString *)msg
{
    KTTableDemo *views=[[KTTableDemo alloc]init];
    [self.navigationController pushViewController:views animated:YES];
    [views release];
}
@end
