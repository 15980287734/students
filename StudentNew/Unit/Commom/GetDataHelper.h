//
//  GetDataHelper.h
//  IOSCoachApp
//
//  Created by user on 13-11-7.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
//#import "ASIProgressDelegate.h"


@interface GetDataHelper : NSObject<ASIHTTPRequestDelegate,ASIProgressDelegate>{
    //当前界面对象
    UIView *_view;
    /*
     判断是上传操作还是下载操作，默认为downloadXMLData,上传数据时为uploadXMLData
     */
    NSString *_postAction;
    //公司代码，暂时可以为空
    NSString *_company;
    //客户端类型，教练为coachApp，学员为studentApp
    NSString *_application;
    //手机类型，默认为iphone
    NSString *_terminal;
    //网点代码，暂时默认为1.0
    NSString *_branchId;
    //版本号
    NSString *_version;
    //用户id
    NSString *_userId;
    //用户名
    NSString *_userName;
    //业务代码，每次使用之前必须设置值，默认为“”
    NSString *_businessCode;
    //操作类型(query/insert/update/delete，要删除时必须指定为delete)，默认为query
    NSString *_action;
    //上传值的类型，默认为JSON
    NSString *_dataFormat;
    //从第几个数据开始，分页查询必用
    int _startRow;
    //每次加载几个数据，分页查询必用
    int _pageSize;
    //用于获得指定对象时传入具体对象的ID值，置于param中
    NSString * _paramId;
    //上传数据时，用于存放JSON数据的字符串
    NSString *_recordText;
    
    //推送消息接收回复
    NSString *_messageId;
    
    //批量上传
    NSMutableArray *_recordTextList;
    
    
}

@property (copy,nonatomic) NSString * url;
@property (copy,nonatomic) NSString * key;
@property (copy,nonatomic) NSString * postAction;
@property (copy,nonatomic) NSString * company;
@property (copy,nonatomic) NSString * application;
@property (copy,nonatomic) NSString * terminal;
@property (copy,nonatomic) NSString * branchId;
@property (copy,nonatomic) NSString * version;
@property (copy,nonatomic) NSString * userId;
@property (copy,nonatomic) NSString * userName;
@property (copy,nonatomic) NSString * businessCode;
@property (copy,nonatomic) NSString * action;
@property (copy,nonatomic) NSString * dataFormat;
@property (assign,nonatomic) int startRow;
@property (assign,nonatomic) int pageSize;
@property (copy,nonatomic) NSString * paramId;
@property (copy,nonatomic) NSString *libraryType;//只在模拟考试请求的时候用到
@property (copy,nonatomic) NSString *subjectScope;
@property (copy,nonatomic) NSString * recordText;
@property (retain,nonatomic) NSMutableArray * recordTextList;
@property (retain,nonatomic) UIProgressView *progressView;//显示用的下载进度条
@property (retain,nonatomic)NSString *messageId;

-(id)initWithView:(UIView *)view;
-(NSString *)getResponseFromUrl;

@end
