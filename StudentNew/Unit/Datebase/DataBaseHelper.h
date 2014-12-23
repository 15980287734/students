//
//  DataBaseHelper.h
//  IOSStudentApp
//
//  Created by user on 13-11-22.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionPojo.h"

@interface DataBaseHelper : NSObject

/*
 *推送 信息 操作
 *
 */
-(BOOL)savePushInformation:(NSDictionary *)item andReceiverId:(NSString *)receiverId ;
-(NSMutableArray *)getPushInformations:(NSString *)senderId;
-(BOOL)deletePushInformation:(NSString *)push_id;

/**
 *保存联系人
 */
-(BOOL)saveSender:(NSDictionary *)item;
//获取联系人
-(NSMutableArray *)getSenders;
//获取未读信息总数
-(int)getNotReadNum;
//获取未读信息数目
-(int)getNotReadNum:(NSString *)senderId;
//设置未读信息数目
-(BOOL)setNotReadNum:(NSString *)senderId andNum:(int)notReadNum;

/**
 *  @brief	重置数据库文件
 */
-(void)reBuildDatabase;
/**
 *	@brief	题库加载时，删除题库数据
 */
-(BOOL)resetDatabase;

/**
 *	@brief	获得数据库存储路径，即系统Document目录下
 *
 *	@return	路径字符串
 */
-(NSString *)getDatabasePath;

/**
 *	@brief	设置登录用户使用的题库ID
 */
-(BOOL)saveUsedLibraryId:(NSString *)usedLibraryId;

/**
 *	@brief	获取题库信息
 */
-(NSMutableArray *)getLibrary;

/**
 *	@brief	获取章节信息
 *
 *	@param 	usedLibraryId 	题库id，为空时获取全部章节
 *
 *	@return	字典数组
 */
-(NSMutableArray *)getSubject:(NSString *)usedLibraryId;

/**
 *	@brief	保存章节信息
 *
 *	@param 	dataArray 	数据
 *	@param 	usedLibraryId 	题库id
 *
 *	@return
 */
-(BOOL)saveSubject:(NSMutableArray *)dataArray andId:(NSString *)usedLibraryId;
/**
 *	@brief	保存题库信息
 *
 *	@param 	dataArray
 *
 *	@return
 */
-(BOOL)saveLibrary:(NSMutableArray *)dataArray;

/**
 *	@brief	保存题目信息
 *
 *	@param 	dataArray
 *
 *	@return
 */
-(BOOL)saveProblem:(NSMutableArray *)dataArray;
/**
 *	@brief	获取题目信息
 *
 *	@param 	sql
 *
 *	@return
 */
-(NSMutableArray *)queryProblem:(NSString *)sql;

/**
 *	@brief	获得数量
 *
 *	@param 	sql
 *
 *	@return
 */
-(int)getCount:(NSString *)sql;

/**
 *	@brief	保存标记
 *
 *	@param 	questionIds
 *	@param 	markType
 *
 *	@return
 */
-(BOOL)saveProblemMark:(NSArray *)questionIds andType:(int)markType;

/**
 *	@brief	保存题目标记到DB
 *
 *	@param 	markType 	收藏/错题
 *	@param 	questionPojo
 *
 *	@return
 */
-(BOOL)saveProblemMark:(int)markType andQuestion:(QuestionPojo *)questionPojo;
/**
 *	@brief	删除题目标记
 *
 *	@param 	markType 	<#markType description#>
 *	@param 	questionPojo 	<#questionPojo description#>
 *
 *	@return	<#return value description#>
 */

-(BOOL)deleteProblemMark:(int)markType andQuestion:(QuestionPojo *)questionPojo
;

/**
 *	@brief	获得标记题目的ID
 *
 *	@param 	markType
 *	@param 	SybjectId
 *
 *	@return
 */
-(NSMutableArray *)getMarkProblemIds:(int)markType andSubjectId:(NSString *)subjectId;

/**
 *	@brief	保存做题记录
 *
 *	@param 	dataArray
 *
 *	@return
 */
-(BOOL)saveStudentExamStat:(NSMutableArray *)dataArray;
/**
 *	@brief	保存单题做题记录
 *
 *	@param 	questionPojo
 *
 *	@return
 */
-(BOOL)saveStudentExamStatForSigle:(QuestionPojo *)questionPojo;

/**
 *	@brief	更改做题记录
 *
 *	@return
 */
-(NSMutableArray *)updateStudentExamStat;

/**
 *	@brief	获取答案ID
 *
 *	@param 	problemId
 *	@param 	answer
 *
 *	@return
 */
-(NSString *)getAnswerIds:(NSString *)problemId andAnswer:(int)answer;

/**
 *	@brief	获取题库中不存在的题目ID
 *
 *	@param 	problemIdS
 *
 *	@return
 */
-(NSString *)getNotExistIds:(NSMutableArray *)problemIdS;


@end
