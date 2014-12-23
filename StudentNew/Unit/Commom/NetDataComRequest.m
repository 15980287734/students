//
//  NetDataComPro.m
//  StudentNew
//
//  Created by chenlei on 14-11-3.
//  Copyright (c) 2014年 wubainet.wyapps. All rights reserved.
//

#import "NetDataComRequest.h"
#import "MAC.h"
#import "NetWork.h"
#import "XMLParser.h"
@implementation NetDataComRequest
{
    //head节点
    NSMutableDictionary *_headNotes;
    //record节点
    NSMutableArray *_bodyNotes;
    //从第几个数据开始，分页查询必用
    int _startRow;
    //每次加载几个数据，分页查询必用
    int _pageSize;
    //用于md5加密key
    NSString *_key;
    //
    UIProgressView *progressView;
}
-(id)init
{
    [self initXml];
    return [super init];
}
-(void) initXml
{
     _startRow=0;
     _pageSize=0;
     //_postAction=[[NSString alloc] initWithFormat:@"%@", @""];
    _headNotes= [NSMutableDictionary dictionaryWithCapacity:15];
    _bodyNotes=[[NSMutableArray alloc]init];
     NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //变量初始化向词典中动态添加数据
    _key = [[NSString alloc] initWithFormat:@"%@", [userDefaults objectForKey:KEY]];
    [_headNotes setObject:@"" forKey:@"company"];
    //客户端类型，教练为coachApp，学员为studentApp
    [_headNotes setObject:@"studentApp" forKey:@"application"];
    //手机类型，默认为iphone
    [_headNotes setObject:@"iphone" forKey:@"terminal"];
    [_headNotes setObject:@"1.0" forKey:@"branchId"];
    [_headNotes setObject:@"" forKey:@"version"];
    if ([userDefaults valueForKey:USER_ID] != nil) {
     [_headNotes setObject:[userDefaults valueForKey:USER_ID] forKey:@"userId"];
    }else{
      [_headNotes setObject:@"" forKey:@"userId"];
    }
    if ([userDefaults valueForKey:USER_NAME] != nil) {
     [_headNotes setObject:[userDefaults valueForKey:USER_NAME] forKey:@"userName"];
    }else{
      [_headNotes setObject:@"" forKey:@"userName"];
    }
    [_headNotes setObject:@"" forKey:@"businessCode"];
    //操作类型(query/insert/update/delete，要删除时必须指定为delete)，默认为query
    [_headNotes setObject:@"query" forKey:@"action"];
    //上传值的类型，默认为JSON
    [_headNotes setObject:@"JSON" forKey:@"dataFormat"];
    [_headNotes setObject:@"_NULL" forKey:@"messageId"];
    [_headNotes setObject:@"" forKey:@"param"];
    //模拟考试时用到
    [_headNotes setObject:@"_NULL" forKey:@"libraryType"];
    [_headNotes setObject:@"_NULL" forKey:@"subjectScope"];
    progressView=NULL;
    
}
-(BOOL) setHead:(NSString *) value
        forName:(NSString *) name
{
    //head里面的key值除了默认的之外,有可能会新添加一些key值
    BOOL iRet=true;
//    if([_headNotes objectForKey:name]!=NULL){
//      iRet=true;
//      [_headNotes setObject:value forKey:name];
//    }
    [_headNotes setObject:value forKey:name];
    return iRet;
}
-(BOOL) setMsgData:(NSMutableDictionary *)dic
       forRow:(int) row
{
    NSString *record;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] != 0 && error == nil){
        record = [[[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding] autorelease];
        
    }
    if(_bodyNotes!=nil){
        if(row<[_bodyNotes count])
           [_bodyNotes replaceObjectAtIndex:row withObject:record];
        else
           [_bodyNotes addObject:record];
    }
    
    [record release];
    return true;

}
//设置发送给服务端交易码
-(BOOL) setCode:(NSString *) business_code
{
    return [self setHead:business_code forName:@"businessCode"];
}

-(BOOL) setMacKey:(NSString *)mk
{
    _key=mk;
    return true;
}

-(BOOL) setPagingRow:(int) row
            withPage:(int) page
{
    _startRow=row;
    _pageSize=page;
    return true;
}

-(void)dealloc
{
    [_key release];
    [_headNotes removeAllObjects];
    [_headNotes release];
    [_bodyNotes release];
    [super dealloc];
}
/**
 *	@brief	生成xml中element
 *
 *	@param 	tag   键值
 *	@param 	value 	键值对中的value
 *
 *	@return	<tag>value</tag>
 */
-(NSString *)writeElement:(NSString *)tag andValue:(NSString *)value

{
    NSString *content=[[[[[[@"<" stringByAppendingString:tag]stringByAppendingString:@">"] stringByAppendingString:value] stringByAppendingString:@"</"] stringByAppendingString:tag] stringByAppendingString:@">\n"];
    return content;
}
/**
 *	@brief	生成xml字符串，上传请求参数
 *
 *	@return	xml字符串
 */
-(NSString *)writeXML
{
    NSString *xmlContent=@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n";
    xmlContent=[xmlContent stringByAppendingString:@"<Root>\n<head>\n"];
    NSLog(@"%@",_headNotes);
    for(NSString * akey in _headNotes){
       NSString * val=[_headNotes objectForKey:akey];
       if([val isEqualToString:@"_NULL"]) continue;
       xmlContent=[xmlContent stringByAppendingString:[self writeElement:akey andValue:val]];
    }
    if(_startRow !=0 ){
        NSString *str=[[[[@"<query startRow=" stringByAppendingString:[NSString stringWithFormat:@"\"%d\"",_startRow]] stringByAppendingString:@" pageSize="] stringByAppendingString:[NSString stringWithFormat:@"\"%d\"",_pageSize]] stringByAppendingString:@"></query>\n"];
        xmlContent=[xmlContent stringByAppendingString:str];
    }  
     
    xmlContent=[xmlContent stringByAppendingString:@"</head>\n<body>\n<dataset>\n"];
    //
    for (int i=0; i<[_bodyNotes count]; i++){
       xmlContent=[xmlContent stringByAppendingString:[self writeElement:@"record" andValue:[_bodyNotes objectAtIndex:i]]];
    }
   
    xmlContent=[xmlContent stringByAppendingString:@"</dataset>\n</body>\n</Root>\n"];
    
    NSLog(@"+++++++>%@",xmlContent);
    return xmlContent;
}
-(NSMutableArray *)getADataResponse
{
    NSString *response=[self getDataResponse];
    XMLParser *parse=[[XMLParser alloc] init];
    NSMutableArray *array=[parse XMLParse:response];
    return array;
}
-(NSMutableArray *)getADataResponse:(NSString *) url
{
    NSString *response=[self getResponseFromUrl:url];
    XMLParser *parse=[[XMLParser alloc] init];
    NSMutableArray *array=[parse XMLParse:response];
    return array;
}
-(NSString *)getDataResponse
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *url= [[userDefaults objectForKey:SCHOOL_URL] stringByAppendingString:SERVICE_URL];
    return [self getResponseFromUrl:url];
}

-(NSString *)getResponseFromUrl:(NSString *) url
{
    //判断是上传操作还是下载操作，默认为downloadXMLData,上传数据时为uploadXMLData
    return [self getResponseFromUrl:url withPostAction:@"downloadXMLData" withAction:@"query"];
}
	
-(NSString *)insertDateToUrl:(NSString *) url
{
     return [self getResponseFromUrl:url withPostAction:@"uploadXMLData" withAction:@"insert"];
}
		
-(NSString *)updateDateToUrl:(NSString *) url
{
    return [self getResponseFromUrl:url withPostAction:@"uploadXMLData" withAction:@"update"];
}
//同步  
-(NSString *)getResponseFromUrl:(NSString *) url
                 withPostAction:(NSString *) postAction
                     withAction:(NSString *) action
{
    @synchronized(self){
        
        if ([NetWork isWorking]) {
            [self setHead:action forName:@"action"];
            NSString *content=[self writeXML];
            NSString *macVal=[MAC calculateMacByASCII:content andKey:_key];
            NSLog(@"url[%@]===%@[%@]",_key,url,[_headNotes objectForKey:@"userName"] );
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:postAction forKey:@"action"];
            [request setPostValue:[_headNotes objectForKey:@"userName"] forKey:@"username"];
            [request setPostValue:macVal forKey:@"checkCode"];
            [request setPostValue:content forKey:@"content"];
            [request setStringEncoding:NSUTF8StringEncoding];
            request.timeOutSeconds = 30;       //设置网络延迟时间
           // return nil;
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            [request setStringEncoding:enc];
            //添加显示下载进度的进度条
            if (progressView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [request setShowAccurateProgress:YES];
                    [request setDownloadProgressDelegate:progressView];
                });
            }
            [request startSynchronous];
            NSError *erro = [request error];
            if (erro) {             //没有错误信息时，返回的是null
                [erro localizedDescription];
                dispatch_async(dispatch_get_main_queue(), ^{
                  //  [_view makeToast:@"亲，获取数据出错，请检查您的手机是否能正常上网!"];
                });
                return nil;
            }else{
                NSString *strResult = [request responseString];
                return strResult;
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
             //   [_view makeToast:@"亲，当前网络不给力，请检查您的手机是否能正常上网！"];
            });
            return nil;
        }
    }


}
//异步
-(NSString *)getAsynResponseFromUrl:(NSString *) url
                 withPostAction:(NSString *) postAction
                     withAction:(NSString *) action
{
    @synchronized(self){
        
        if ([NetWork isWorking]) {
            [self setHead:action forName:@"action"];
            NSString *content=[self writeXML];
            NSString *macVal=[MAC calculateMacByASCII:content andKey:_key];
            NSLog(@"url[%@]===%@[%@]",_key,url,[_headNotes objectForKey:@"userName"] );
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
            [request setPostValue:postAction forKey:@"action"];
            [request setPostValue:[_headNotes objectForKey:@"userName"] forKey:@"username"];
            [request setPostValue:macVal forKey:@"checkCode"];
            [request setPostValue:content forKey:@"content"];
            [request setStringEncoding:NSUTF8StringEncoding];
            request.timeOutSeconds = 30;       //设置网络延迟时间
            [request setDelegate:self];
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
            [request setStringEncoding:enc];
            //添加显示下载进度的进度条
            if (progressView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [request setShowAccurateProgress:YES];
                    [request setDownloadProgressDelegate:progressView];
                });
            }
            [request startAsynchronous];
            NSError *erro = [request error];
            if (erro) {             //没有错误信息时，返回的是null
                [erro localizedDescription];
                dispatch_async(dispatch_get_main_queue(), ^{
                  //  [_view makeToast:@"亲，获取数据出错，请检查您的手机是否能正常上网!"];
                });
                return nil;
            }else{
                NSString *strResult = [request responseString];
                return strResult;
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
             //   [_view makeToast:@"亲，当前网络不给力，请检查您的手机是否能正常上网！"];
            });
            return nil;
        }
    }


}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // 当以文本形式读取返回内容时用这个方法
   NSString *responseString = [request responseString];
   // 当以二进制形式读取返回内容时用这个方法
   //  NSData *responseData = [request responseData];
    [_delegate onRecvdone:responseString];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{

   NSError *error = [request error];
    [_delegate onRecverr:@""];

}

@end
