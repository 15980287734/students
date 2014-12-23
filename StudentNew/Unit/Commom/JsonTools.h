//
//  JsonTools.h
//  IOSCoachApp
//
//  Created by user on 13-11-8.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *	@brief	字典生成json工具，主要用于查询
 */
@interface JsonTools : NSObject
{
    NSMutableDictionary *_dic;
}

@property (nonatomic,copy)NSString *jsonString;
//@property (nonatomic,retain) NSMutableDictionary *dic;

/**
 *	@brief	设置查询条件的值
 *
 *	@param 	value 查询值
 *	@param 	key 	查询条件
 */
-(void)setValue:(id)value forKey:(NSString *)key;
-(NSMutableDictionary *)getDictionary;
-(void)setDictionary:(NSDictionary *)dic;
/**
 *	@brief	获得设置完查询条件值的json字符串
 *
 *	@return	json字符串
 */
-(NSString *)getJsonString;




@end
