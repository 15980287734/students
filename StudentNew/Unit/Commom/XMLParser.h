//
//  XMLParse.h
//  IOSCoachApp
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject < NSXMLParserDelegate >{
    /**
     *	@brief	解析后获得的字典对象数组
     */
    NSMutableArray *list;
    /**
     *	@brief	dataSize是服务器查询到的符合条件的数据一共有几条，和list的count不一样
     */
//    int dataSize;
}

@property (assign,nonatomic)int dataSize;
@property (copy,nonatomic)NSString * dataString;

/**
 *	@brief	解析xml
 *
 *	@return	字典数组
 */
-(NSMutableArray *)XMLParse:(NSString *) data;

@end
