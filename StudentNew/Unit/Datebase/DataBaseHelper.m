//
//  DataBaseHelper.m
//  IOSStudentApp
//
//  Created by user on 13-11-22.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "DataBaseHelper.h"
#import <sqlite3.h>
#import "QuestionPojo.h"
#import "JsonTools.h"

// 数据库名称
#define DB_NAME (@"driving.db")
// 数据表名称
#define QUESTION_BANK_TABLE_NAME  (@"question_bank")// 题目表
#define QUESTION_ANSWER_TABLE_NAME  (@"question_answer")// 选项ID表
#define QUESTION_LIBRARY_TABLE_NAME  (@"question_library")// 题库名称表
#define QUESTION_SUBJECT_TABLE_NAME  (@"question_subject")// 题型章节
#define QUESTION_MARK_TABLE_NAME  (@"question_mark")// 题目标记（错题、收藏等）
#define EXAM_STAT_TABLE_NAME  (@"exam_stat")// 做题记录（对、错、正确率）
#define CMN_MESSAGE_SENDER (@"cmn_message_sender")//联系人记录
#define QUESTION_BANK_INDEX_NAME  (@"index_question_bank")// 在题库建立索引subject_id
#define SCOPE_ON_SUBJECT_INDEX_NAME  (@"index_subject_scope")// 在题库建立索引scope

//弃用了的表
#define TEST_HISTORY_TABLE_NAME  (@"test_history")// 测试历史
#define USER_PREFERENCES_TABLE_NAME  (@"user_preferences")// 用户信息设置
#define CREATE_TABLE_MESSAGE_SENDER (@"CREATE TABLE IF NOT EXISTS cmn_message_sender (userId VARCHAR, senderId VARCHAR, senderName VARCHAR, lastContent VARCHAR, senderTime VARCHAR, notReadNum INTEGER default 0, photo VARCHAR, PRIMARY KEY(userId, senderId) )")

// 数据库版本
#define DB_VERSION  17;

#define CREATE_INDEX_1 [NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS %@ ON %@(subject_id,label)",QUESTION_BANK_INDEX_NAME,QUESTION_BANK_TABLE_NAME]

#define CREATE_INDEX_2 [NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS %@ ON %@(scope)",SCOPE_ON_SUBJECT_INDEX_NAME,QUESTION_SUBJECT_TABLE_NAME]

// 用户偏好
/**
 * 用户当前使用的题库
 */
#define PREFERENCES_USED_LIBRARY_ID  (@"UsedLibraryId")//String

/**
 *	@brief	数据库操作帮助类
 */
@implementation DataBaseHelper{
    sqlite3 *database;
    NSString *_user_id;
    NSString *currentPath;
}

-(id)init{
    if (self=[super init]) {
        currentPath=[[self getDatabasePath] retain];
        [self copyFileDatabase];
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        _user_id=[[NSString alloc] initWithString:[userDefaults objectForKey:USER_ID]];
    }
    return self;
}

-(void)dealloc{
    [_user_id release];
    [currentPath release];
    [super dealloc];
}

/**
 *	@brief	将外部的db文件复制到Document中
 */
-(void)copyFileDatabase

{
    NSString *documentLibraryFolderPath = currentPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentLibraryFolderPath]) {
        //NSLog(@"文件已经存在了");
    }else {
        //复制数据库到沙盒中
        NSString *resourceFolderPath =
        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"driving.db"];
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath];
        [[NSFileManager defaultManager] createFileAtPath:documentLibraryFolderPath contents:mainBundleFile attributes:nil];
    }
}
/**
 *	@brief	重置数据库文件
 */
-(void)reBuildDatabase{
    NSString *documentLibraryFolderPath = currentPath;
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentLibraryFolderPath]) {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:documentLibraryFolderPath];//沙盒中数据库是否存在
        if (bRet) {
            //删除数据库
            NSError *err;
            [fileMgr removeItemAtPath:documentLibraryFolderPath error:&err];
        }
        
        NSString *resourceFolderPath =
        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"driving.db"];
        NSData *mainBundleFile = [NSData dataWithContentsOfFile:resourceFolderPath];
        [fileMgr createFileAtPath:documentLibraryFolderPath contents:mainBundleFile attributes:nil];
    }
}


/**
 *	@brief	重置数据库文件
 */
-(BOOL)resetDatabase
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 打开删除推送信息open database error.");
        return NO;
    }
    NSString *sql1 =[NSString stringWithFormat:@"DELETE FROM %@",QUESTION_LIBRARY_TABLE_NAME];
    NSString *sql2 =[NSString stringWithFormat:@"DELETE FROM %@",QUESTION_SUBJECT_TABLE_NAME];
    NSString *sql3 =[NSString stringWithFormat:@"DELETE FROM %@",QUESTION_ANSWER_TABLE_NAME];
    NSString *sql4 =[NSString stringWithFormat:@"DELETE FROM %@",QUESTION_BANK_TABLE_NAME];
    NSArray *array=[NSArray arrayWithObjects:sql1,sql2,sql3,sql4, nil];
    for(NSString *sql in array){
        sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 删除推送信息failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }
        sqlite3_step(statement);
    }
    //执行成功后依然要关闭数据库
    sqlite3_close(database);
    return YES;
    
}

/**
 *	@brief	获得数据库存储路径，即系统Document目录下
 *
 *	@return	路径字符串
 */
-(NSString *)getDatabasePath
{
    NSArray *fullPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [fullPath objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:DB_NAME];
}

/*
 *保存推送信息
 */
-(BOOL)savePushInformation:(NSDictionary *)item andReceiverId:(NSString *)receiverId
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 打开保存推送信息open database error.");
        return NO;
    }
    NSString *sql =[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);", @"cmn_message",@"push_id", @"deviceType", @"actType", @"contentType", @"content", @"source", @"dueDate", @"sendTime",@"flag",@"range",@"target",@"msgType",@"bizType",@"showMode",@"nextStep",@"senderId",@"senderName",@"sourceId",@"status",@"receiverId",@"replyContent",@"replyTime"];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: 保存推送信息failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return NO;
    }else {
        //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
        //绑定text类型的数据库数据
        sqlite3_bind_text(statement, 1, [[item objectForKey:@"id"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[item objectForKey:@"deviceType"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [[item objectForKey:@"actType"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [[item objectForKey:@"contentType"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [[item objectForKey:@"content"] UTF8String], -1, SQLITE_TRANSIENT);
        //            sqlite3_bind_text(statement, 6, [[item objectForKey:@"readStatus"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 6, [[item objectForKey:@"source"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 7, [[item objectForKey:@"dueDate"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 8, [[item objectForKey:@"sendTime"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 9, [[item objectForKey:@"flag"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 10, [[item objectForKey:@"range"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 11, [[item objectForKey:@"target"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 12, [[item objectForKey:@"msgType"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 13, [[item objectForKey:@"bizType"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 14, [[item objectForKey:@"showMode"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 15, [[item objectForKey:@"nextStep"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 16, [[item objectForKey:@"senderId"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 17, [[item objectForKey:@"senderName"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 18, [[item objectForKey:@"sourceId"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 19, [[item objectForKey:@"status"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 20, [receiverId UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 21, [[item objectForKey:@"replyContent"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 22, [[item objectForKey:@"replyTime"] UTF8String], -1, SQLITE_TRANSIENT);
        
        //执行SQL语句。这里是更新数据库
        BOOL success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: 保存推送信息failed to update the database with message.");
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
    }
    //执行成功后依然要关闭数据库
    sqlite3_close(database);
    //    NSLog(@"%@",[self getPushInformations]);
    return YES;
}
/*
 *删除推送信息
 */
-(BOOL)deletePushInformation:(NSString *)push_id
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 打开删除推送信息open database error.");
        return NO;
    }
    NSString *sql =[NSString stringWithFormat:@"DELETE FROM cmn_message WHERE push_id=%@",push_id];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: 删除推送信息failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return NO;
    }
    return YES;
}
/*
 *获取推送信息
 */
-(NSMutableArray *)getPushInformations:(NSString *)senderId
{
    NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 打开获取推送信息open database error.");
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM cmn_message where (senderId = '%@' and receiverId = '%@') or (senderId = '%@' and receiverId = '%@')", _user_id, senderId, senderId, _user_id];
    
    //    NSLog(@"%@",sql);
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: 获取推送信息failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return nil;
    }else {
        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:1];
            
            if (sqlite3_column_text(statement, 0)!=NULL) {
                //                push_id=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"push_id"];
            }
            else
            {
                [dic setObject:@"" forKey:@"push_id"];
            }
            
            if (sqlite3_column_text(statement, 1)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"deviceType"];
            }
            else
            {
                [dic setObject:@"" forKey:@"deviceType"];
            }
            if (sqlite3_column_text(statement, 2)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"actType"];
            }
            else
            {
                [dic setObject:@"" forKey:@"actType"];
            }
            if (sqlite3_column_text(statement, 3)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"contentType"];
            }
            else
            {
                [dic setObject:@"" forKey:@"contentType"];
            }
            if (sqlite3_column_text(statement, 4)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"content"];
            }
            else
            {
                [dic setObject:@"" forKey:@"content"];
            }
            if (sqlite3_column_text(statement, 5)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] forKey:@"readStatus"];
            }
            else
            {
                [dic setObject:@"" forKey:@"readStatus"];
            }
            if (sqlite3_column_text(statement, 6)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"source"];
            }
            else
            {
                [dic setObject:@"" forKey:@"source"];
            }
            if (sqlite3_column_text(statement, 7)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] forKey:@"dueDate"];
            }
            else
            {
                [dic setObject:@"" forKey:@"dueDate"];
            }
            if (sqlite3_column_text(statement, 8)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)] forKey:@"sendTime"];
            }
            else
            {
                [dic setObject:@"" forKey:@"sendTime"];
            }
            if (sqlite3_column_text(statement, 9)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)] forKey:@"flag"];
            }
            else
            {
                [dic setObject:@"" forKey:@"flag"];
            }
            if (sqlite3_column_text(statement, 10)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)] forKey:@"range"];
            }
            else
            {
                [dic setObject:@"" forKey:@"range"];
            } if (sqlite3_column_text(statement, 11)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)] forKey:@"target"];
            }
            else
            {
                [dic setObject:@"" forKey:@"target"];
            }
            if (sqlite3_column_text(statement, 12)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)] forKey:@"msgType"];
            }
            else
            {
                [dic setObject:@"" forKey:@"msgType"];
            } if (sqlite3_column_text(statement, 13)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)] forKey:@"bizType"];
            }
            else
            {
                [dic setObject:@"" forKey:@"bizType"];
            }
            if (sqlite3_column_text(statement, 14)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)] forKey:@"showMode"];
            }
            else
            {
                [dic setObject:@"" forKey:@"showMode"];
            } if (sqlite3_column_text(statement, 15)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)] forKey:@"nextStep"];
            }
            else
            {
                [dic setObject:@"" forKey:@"nextStep"];
            } if (sqlite3_column_text(statement, 16)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)] forKey:@"senderId"];
            }
            else
            {
                [dic setObject:@"" forKey:@"senderId"];
            } if (sqlite3_column_text(statement, 17)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)] forKey:@"senderName"];
            }
            else
            {
                [dic setObject:@"" forKey:@"senderName"];
            } if (sqlite3_column_text(statement, 18)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)] forKey:@"sourceId"];
            }
            else
            {
                [dic setObject:@"" forKey:@"sourceId"];
            } if (sqlite3_column_text(statement, 19)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)] forKey:@"status"];
            }
            else
            {
                [dic setObject:@"" forKey:@"status"];
            }
            if (sqlite3_column_text(statement, 20)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)] forKey:@"receiverId"];
            }
            else
            {
                [dic setObject:@"" forKey:@"receiverId"];
            }
            if (sqlite3_column_text(statement, 21)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)] forKey:@"replyContent"];
            }
            else
            {
                [dic setObject:@"" forKey:@"replyContent"];
            }
            if (sqlite3_column_text(statement, 22)!=NULL) {
                [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)] forKey:@"replyTime"];
            }
            else
            {
                [dic setObject:@"" forKey:@"replyTime"];
            }
            [resultArray addObject:dic];
            [dic release];
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return resultArray;
}

-(BOOL)saveSender:(NSDictionary *)item{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 保存联系人open database error.");
        return NO;
    }
    if (![self execSql:CREATE_TABLE_MESSAGE_SENDER]) {
        return NO;
    }
    NSString *sql =[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ ('%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?);", @"cmn_message_sender",@"userId", @"senderId", @"senderName", @"lastContent", @"senderTime", @"notReadNum", @"photo"];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: 保存联系人failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return NO;
    }else {
        //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
        //绑定text类型的数据库数据
        sqlite3_bind_text(statement, 1, [[item objectForKey:@"userId"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 2, [[item objectForKey:@"senderId"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [[item objectForKey:@"senderName"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 4, [[item objectForKey:@"lastContent"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 5, [[item objectForKey:@"senderTime"] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 6, [[item objectForKey:@"notReadNum"] integerValue]);
        if ([item objectForKey:@"photo"]) {
            sqlite3_bind_text(statement, 7, [[item objectForKey:@"photo"] UTF8String], -1, SQLITE_TRANSIENT);
        }
        //执行SQL语句。这里是更新数据库
        BOOL success = sqlite3_step(statement);
        //释放statement
        sqlite3_finalize(statement);
        //如果执行失败
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: 保存联系人failed to update the database with message.");
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
    }
    //执行成功后依然要关闭数据库
    sqlite3_close(database);
    return YES;
}

-(NSMutableArray *)getSenders{
    NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 打开获取推送信息open database error.");
        return nil;
    }
    if (![self execSql:CREATE_TABLE_MESSAGE_SENDER]) {
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM cmn_message_sender where userId = '%@'",_user_id];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: 获取推送信息failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return nil;
    }else {
        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithCapacity:1];
            if (sqlite3_column_text(statement, 0) != NULL) {
                [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] forKey:@"userId"];
            }
            
            if (sqlite3_column_text(statement, 1) != NULL) {
                [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] forKey:@"senderId"];
            }
            
            if (sqlite3_column_text(statement, 2) != NULL) {
                [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] forKey:@"senderName"];
            }
            
            if (sqlite3_column_text(statement, 3) != NULL) {
                [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] forKey:@"lastContent"];
            }
            if (sqlite3_column_text(statement, 4) != NULL) {
                [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] forKey:@"senderTime"];
            }
            
            int notReadNum=sqlite3_column_int(statement, 5);
            [dic setValue:[NSNumber numberWithInt:notReadNum] forKey:@"notReadNum"];
            if (sqlite3_column_text(statement, 6) != NULL) {
                [dic setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] forKey:@"photo"];
            }
            [resultArray addObject:dic];
            [dic release];
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return resultArray;
}

-(int)getNotReadNum{
    int num=0;
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 获取未读信息数目open database error.");
        return num;
    }
    if (![self execSql:CREATE_TABLE_MESSAGE_SENDER]) {
        return num;
    }
    NSString *sql=[NSString stringWithFormat:@"select notReadNum from cmn_message_sender where userId ='%@'",_user_id];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: 获取未读信息数目failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return num;
    }else {
        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
        while (sqlite3_step(statement) == SQLITE_ROW) {
            num=num + sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return num;
}


-(int)getNotReadNum:(NSString *)senderId{
    int num=0;
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 获取未读信息数目open database error.");
        return num;
    }
    if (![self execSql:CREATE_TABLE_MESSAGE_SENDER]) {
        return num;
    }
    NSString *sql=[NSString stringWithFormat:@"select * from cmn_message_sender where userId ='%@' and senderId = '%@'",_user_id, senderId];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"Error: 获取未读信息数目failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return num;
    }else {
        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
        while (sqlite3_step(statement) == SQLITE_ROW) {
            num=sqlite3_column_int(statement, 5);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return num;
}

-(BOOL)setNotReadNum:(NSString *)senderId andNum:(int)notReadNum{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        NSLog(@"Error: 打开获取推送信息open database error.");
        return NO;
    }
    NSString *sql=[NSString stringWithFormat:@"update cmn_message_sender set notReadNum = '%d' where senderId = '%@'", notReadNum, senderId];
    BOOL y=[self execSql:sql];
    sqlite3_close(database);
    return y;
}

/**
 *	@brief	数据库操作,执行非查询的sql语句
 *
 *	@param 	sql 	操作语句
 */
-(BOOL)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(database);
        //NSLog(@"数据库操作数据失败!");
        return NO;
    }
    return YES;
}

#pragma mark --设置登录用户使用的题库ID

/**
 *	@brief	设置登录用户使用的题库ID
 */
-(BOOL)saveUsedLibraryId:(NSString *)usedLibraryId
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 设置登录用户使用的题库ID open database error.");
        return NO;
    }
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSString *uer_id=[userDefaults objectForKey:_user_id];
    NSString *sql1 = [NSString stringWithFormat:
                      @"INSERT INTO '%@' ('%@', '%@', '%@') VALUES ('%@', '%@', '%@')",
                      USER_PREFERENCES_TABLE_NAME, @"user_id", @"key", @"value", uer_id, PREFERENCES_USED_LIBRARY_ID, usedLibraryId];
    BOOL b=[self execSql:sql1];
    sqlite3_close(database);
    return b;
}

#pragma mark --获取题库信息
/**
 *	@brief	获取题库信息
 */
-(NSMutableArray *)getLibrary
{
    NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 获取题库信息 open database error.");
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",QUESTION_LIBRARY_TABLE_NAME];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        //NSLog(@"Error: 获取题库信息 failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return nil;
    }else {
        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *lib_id=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *name=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *type=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *desc=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *num=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:lib_id, @"id", name, @"name", type, @"type", desc, @"desc", num, @"question_num", nil];
            [resultArray addObject:dic];
            [dic release];
            [lib_id release];
            [name release];
            [type release];
            [desc release];
            [num release];
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return resultArray;
}

#pragma mark --获取章节信息
/**
 *	@brief	获取章节信息
 *
 *	@param 	usedLibraryId 	题库id，为空时获取全部章节
 *
 *	@return	字典数组
 */
-(NSMutableArray *)getSubject:(NSString *)usedLibraryId
{
    NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 获取章节信息open database error.");
        return nil;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@  WHERE library_id = '%@' AND scope like '%%%@%%'",QUESTION_SUBJECT_TABLE_NAME, usedLibraryId, [[NSUserDefaults standardUserDefaults] stringForKey:CARTYPE]];

    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        //NSLog(@"Error: 获取章节信息failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return nil;
    }else {
        //查询结果集中一条一条的遍历所有的记录，这里的数字对应的是列值,注意这里的列值，跟上面sqlite3_bind_text绑定的列值不一样！一定要分开，不然会crash，只有这一处的列号不同，注意！
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *sub_id=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSString *lib_id=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *name=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *scope=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            NSString *num=[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:sub_id, @"id", lib_id, @"library_id", name, @"name", scope, @"scope", num, @"question_num", nil];
            [resultArray addObject:dic];
            [dic release];
            [sub_id release];
            [lib_id release];
            [name release];
            [scope release];
            [num release];
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return resultArray;
}

#pragma mark --保存章节信息
/**
 *	@brief	保存章节信息
 *
 *	@param 	dataArray 	数据
 *	@param 	usedLibraryId 	题库id
 *
 *	@return
 */
-(BOOL)saveSubject:(NSMutableArray *)dataArray andId:(NSString *)usedLibraryId
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 保存章节信息open database error.");
        return NO;
    }
    
    NSString *sql =[NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?);", QUESTION_SUBJECT_TABLE_NAME, @"name", @"library_id", @"question_num", @"id",@"scope"];
    
    for (NSDictionary *item in dataArray) {
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 保存章节信息failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }else {
            //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
            //绑定text类型的数据库数据
            
            sqlite3_bind_text(statement, 1, [[item objectForKey:@"name"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [usedLibraryId UTF8String], -1, SQLITE_TRANSIENT);
            int question_num=[[item objectForKey:@"question_num"] integerValue] ;
            sqlite3_bind_int(statement, 3, question_num); 
            sqlite3_bind_text(statement, 4, [[item objectForKey:@"id"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [[item objectForKey:@"scope"] UTF8String], -1, SQLITE_TRANSIENT);
            
            //执行SQL语句。这里是更新数据库
            BOOL success = sqlite3_step(statement);
            //释放statement
            sqlite3_finalize(statement);
            //如果执行失败
            if (success == SQLITE_ERROR) {
                //NSLog(@"Error: 保存章节信息failed to update the database with message.");
                //关闭数据库
                sqlite3_close(database);
                return NO;
            }
        }
    }
    //执行成功后依然要关闭数据库
    sqlite3_close(database);
    return YES;
}

#pragma mark --保存题库信息
/**
 *	@brief	保存题库信息
 *
 *	@param 	dataArray
 *
 *	@return
 */
-(BOOL)saveLibrary:(NSMutableArray *)dataArray

{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 保存题库信息open database error.");
        return NO;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?);", QUESTION_LIBRARY_TABLE_NAME, @"name", @"desc", @"type", @"question_num", @"id"];
    
    for (NSDictionary *item in dataArray) {
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 保存题库信息出错");
            sqlite3_close(database);
            return NO;
        }else {
            //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
            //绑定text类型的数据库数据
            sqlite3_bind_text(statement, 1, [[item objectForKey:@"name"] UTF8String], -1,
                              SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [[item objectForKey:@"desc"] UTF8String], -1, SQLITE_TRANSIENT);
            int type=[[item objectForKey:@"type"] integerValue];
            sqlite3_bind_int(statement, 3, type);
            int question_num=[[item objectForKey:@"question_num"] integerValue];
            sqlite3_bind_int(statement, 4, question_num);
            sqlite3_bind_text(statement, 5, [[item objectForKey:@"id"] UTF8String], -1, SQLITE_TRANSIENT);
            //执行SQL语句。这里是更新数据库
            BOOL success = sqlite3_step(statement);
            //释放statement
            sqlite3_finalize(statement);
            //如果执行失败
            if (success == SQLITE_ERROR) {
                //NSLog(@"Error: 保存题库信息failed to update the database with message.");
                //关闭数据库
                sqlite3_close(database);
                return NO;
            }
        }
    }
    //执行成功后依然要关闭数据库
    sqlite3_close(database);
    return YES;
}

/**
 *	@brief	功能：去掉所有的<*>标记,去除html标签
 *
 *	@param 	html
 *
 *	@return
 */
-(NSString *)removeTagFromText:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    html = [html stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return html;
}

#pragma mark --保存题目信息
/**
 *	@brief	保存题目信息
 *
 *	@param 	dataArray
 *
 *	@return
 */
-(BOOL)saveProblem:(NSMutableArray *)dataArray
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        return NO;
    }
    
    NSString *sql1 = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);", QUESTION_BANK_TABLE_NAME, @"library_id", @"subject_id", @"scope", @"question", @"option_a", @"option_b", @"option_c", @"option_d", @"key", @"explain", @"rating" ,@"type", @"img_path", @"ultimedia", @"label", @"id"];
    
    NSString *sql2 = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?);", QUESTION_ANSWER_TABLE_NAME, @"option_a_id", @"option_b_id", @"option_c_id", @"option_d_id", @"id"];
    
    
    for (NSDictionary *item in dataArray) {
        sqlite3_stmt *statement1;
        sqlite3_stmt *statement2;
        
        if (sqlite3_prepare_v2(database, [sql1 UTF8String], -1, &statement1, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 保存题目信息 failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }else if(sqlite3_prepare_v2(database, [sql2 UTF8String], -1, &statement2, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 保存答案信息 failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }else{
            
            //这里的数字1，2，3代表第几个问号。这里只有1个问号，这是一个相对比较简单的数据库操作，真正的项目中会远远比这个复杂
            //绑定题目信息的statement1数据
            sqlite3_bind_text(statement1, 1, [[[[item objectForKey:@"subject"] objectForKey:@"library"] objectForKey:@"id"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 2, [[[item objectForKey:@"subject"] objectForKey:@"id" ] UTF8String], -1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 3, [[item objectForKey:@"scope"] UTF8String], -1,SQLITE_TRANSIENT);
            
            NSString *title=[self removeTagFromText:[item objectForKey:@"title"]];
            switch ([[item objectForKey:@"type"] integerValue]) {
                case problem_type_jedge:
                    title=[title stringByAppendingString:@" [判断题] "];
                    break;
                case problem_type_single_choice:
                    title=[title stringByAppendingString:@" [单选题] "];
                    
                    break;
                case problem_type_multi_choice:
                    title=[title stringByAppendingString:@" [多选题] "];
                    break;
                case problem_type_fill_blank:
                    title=[title stringByAppendingString:@" [填空题] "];
                    break;
                case problem_type_question_answer:
                    title=[title stringByAppendingString:@" [简答题] "];
                    break;
                case problem_type_mind:
                    title=[title stringByAppendingString:@" [心理题] "];
                    break;
                default:
                    break;
			}
            sqlite3_bind_text(statement1, 4, [title UTF8String], -1, SQLITE_TRANSIENT);
            
            
            int key=0;
            NSMutableArray *answerArray=[item objectForKey:@"answerList"];
            for (int i=0;i<[answerArray count];i++) {
                NSDictionary *answer=[answerArray objectAtIndex:i];
                sqlite3_bind_text(statement1, i+5, [[self removeTagFromText:[answer objectForKey:@"name"]] UTF8String], -1,SQLITE_TRANSIENT);
                
                if ([[answer objectForKey:@"setAnswer" ]  integerValue] == 1) {
					if ([[item objectForKey:@"type"] integerValue] == problem_type_multi_choice) {
						key = key * 10 + i + 1;// 多选题
					} else {
						key = i + 1;
					}
				}
                //保存答案信息
                sqlite3_bind_text(statement2, i+1, [[answer objectForKey:@"id" ] UTF8String], -1,SQLITE_TRANSIENT);
                
            }
            //保存答案id
            sqlite3_bind_text(statement2, 5, [[item objectForKey:@"id" ] UTF8String], -1,SQLITE_TRANSIENT);
            
            
            sqlite3_bind_int(statement1, 9, key);
            if ([@"" isEqualToString:[item objectForKey:@"comment"]]) {
                sqlite3_bind_text(statement1, 10, [@"暂无详解" UTF8String], -1,SQLITE_TRANSIENT);
			} else {
                sqlite3_bind_text(statement1, 10, [[item objectForKey:@"comment"] UTF8String], -1,SQLITE_TRANSIENT);
			}
            
            sqlite3_bind_int(statement1, 11, [[item objectForKey:@"level"] integerValue]);
            sqlite3_bind_int(statement1, 12, [[item objectForKey:@"type"] integerValue]);
            sqlite3_bind_text(statement1, 13, [[item objectForKey:@"image"] UTF8String], -1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 14, [[item objectForKey:@"ultimedia"] UTF8String], -1,SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 15, [[item objectForKey:@"label"] UTF8String], -1,SQLITE_TRANSIENT);
            
            sqlite3_bind_text(statement1, 16, [[item objectForKey:@"id" ] UTF8String], -1,SQLITE_TRANSIENT);
            
            //执行SQL语句。这里是更新数据库
            BOOL success = sqlite3_step(statement1);
            //释放statement
            sqlite3_finalize(statement1);
            //如果执行失败
            if (success == SQLITE_ERROR) {
                ////NSLog(@"Error: 保存题目信息failed to update the database with message.");
                //关闭数据库
                sqlite3_close(database);
                return NO;
            }
            
            //执行SQL语句。这里是更新数据库
            BOOL success2 = sqlite3_step(statement2);
            //释放statement
            sqlite3_finalize(statement2);
            //如果执行失败
            if (success2 == SQLITE_ERROR) {
                ////NSLog(@"Error: 保存答案信息failed to update the database with message.");
                //关闭数据库
                sqlite3_close(database);
                return NO;
            }
        }
    }
    
    //执行成功后依然要关闭数据库
    sqlite3_close(database);
    return YES;
}

#pragma mark --获取题目信息
/**
 *	@brief	获取题目信息
 *
 *	@param 	sql
 *
 *	@return
 */
-(NSMutableArray *)queryProblem:(NSString *)sql
{
    NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        ////NSLog(@"Error: 获取题目信息 open database error.");
        return nil;
    }
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        ////NSLog(@"Error: 获取题目信息 failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return nil;
    }else {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            QuestionPojo *questionPojo=[[QuestionPojo alloc] init];
            
            NSString *problemId=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            questionPojo.ID=problemId;
            [problemId release];
            
            NSString *library_id=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            questionPojo.library_id=library_id;
            [library_id release];
            
            NSString *subject_id=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            questionPojo.subject_id=subject_id;
            [subject_id release];
            
            NSString *scope=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            questionPojo.scope=scope;
            [scope release];
            
            NSString *question=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            questionPojo.question=question;
            [question release];
            
            NSString *option_a=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            questionPojo.option_a=option_a;
            [option_a release];
            
            NSString *option_b=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
            questionPojo.option_b=option_b;
            [option_b release];
            
            
            if(sqlite3_column_text(statement, 7) != nil){
                NSString *option_c = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                questionPojo.option_c=option_c;
                [option_c release];
                
            }
            
            
            if (sqlite3_column_text(statement, 8) != nil){
                NSString *option_d=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                questionPojo.option_d=option_d;
                [option_d release];
            }
            
            
            int key = sqlite3_column_int(statement, 9);
            questionPojo.key=key;
            
            NSString *explain=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
            questionPojo.explain=explain;
            [explain release];
            
            int rating = sqlite3_column_int(statement, 11);
            questionPojo.rating=rating;
            
            int type = sqlite3_column_int(statement, 12);
            questionPojo.type=type;
            
            NSString *imgPath=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
            questionPojo.imgPath=imgPath;
            [imgPath release];
            
            NSString *ultimedia=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
            questionPojo.ultimedia=ultimedia;
            [ultimedia release];
            
            NSString *label=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
            questionPojo.label=label;
            [label release];
            
            // 获取题目是否收藏
			NSString *sql_f = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_id='%@' AND question_id='%@' AND mark_type = %d", QUESTION_MARK_TABLE_NAME, _user_id ,problemId , QUESTION_MARK_FAVORITE];
            sqlite3_stmt *statement2 = nil;
            if (sqlite3_prepare_v2(database, [sql_f UTF8String], -1, &statement2, NULL) != SQLITE_OK) {
                ////NSLog(@"Error: 获取题目信息 failed to prepare statement with message:get testValue.");
            }else {
                int i=0;
                while (sqlite3_step(statement2) == SQLITE_ROW) {
                    i++;
                }
                if (i==0) {
                    questionPojo.favorite=0;
                }else{
                    questionPojo.favorite=1;
                }
            }
            //释放statement2
            sqlite3_finalize(statement2);
            
            // 获得题目记录
			NSString *sql_stat = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_id='%@' AND question_id='%@'", EXAM_STAT_TABLE_NAME, _user_id ,problemId];
            sqlite3_stmt *statement3 = nil;
            if (sqlite3_prepare_v2(database, [sql_stat UTF8String], -1, &statement3, NULL) != SQLITE_OK) {
                ////NSLog(@"Error: 获取题目信息 failed to prepare statement with message:get testValue.");
            }else {
                while (sqlite3_step(statement3) == SQLITE_ROW) {
                    int right = sqlite3_column_int(statement3, 4) + sqlite3_column_int(statement3, 6) + sqlite3_column_int(statement3, 8);;// WEB+移动端+新增
                    int wrong = sqlite3_column_int(statement3, 5)+sqlite3_column_int(statement3, 7) + sqlite3_column_int(statement3, 9);// WEB+移动端+新增
                    questionPojo.right=right;
                    questionPojo.wrong=wrong;
                    questionPojo.new_right=sqlite3_column_int(statement3, 8);
                    questionPojo.new_wrong=sqlite3_column_int(statement3, 9);
                }
            }
            //释放statement3
            sqlite3_finalize(statement3);
            
            [resultArray addObject:questionPojo];
            [questionPojo release];
        }
    }
    //释放statement
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return resultArray;
}

#pragma mark --获得数量
/**
 *	@brief	获得数量
 *
 *	@param 	sql
 *
 *	@return
 */
-(int)getCount:(NSString *)sql

{
    int count=0;
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        ////NSLog(@"Error: 获得数量 open database error.");
        return -1;
    }
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
        ////NSLog(@"Error: 获得数量 failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return -1;
    }else {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //count=sqlite3_column_int(statement, 0);
            count++;
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return count;
}

#pragma mark --保存标记
/**
 *	@brief	保存标记
 *
 *	@param 	questionIds
 *	@param 	markType
 *
 *	@return
 */
-(BOOL)saveProblemMark:(NSArray *)questionIds andType:(int)markType

{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        ////NSLog(@"Error: 保存标记 open database error.");
        return NO;
    }
    for (NSString *item in questionIds) {
        NSString *sql=[NSString stringWithFormat:@"SELECT subject_id FROM %@ WHERE question_id = '%@'", QUESTION_BANK_TABLE_NAME, item];
        sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK)
        {
            ////NSLog(@"Error: 保存标记 failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }else
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *sql2 = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@')VALUES(?,?,?,?);", QUESTION_MARK_TABLE_NAME, @"subject_id", @"mark_type", @"user_id", @"question_id" ];
                
                sqlite3_stmt *statement2;
                if(sqlite3_prepare_v2(database, [sql2 UTF8String], -1, &statement2, NULL) != SQLITE_OK) {
                    //NSLog(@"Error: 保存标记 failed to prepare statement with message:get testValue.");
                    sqlite3_close(database);
                    return NO;
                }else{
                    //绑定题目信息的statement1数据
                    sqlite3_bind_text(statement2, 1, (char *)sqlite3_column_text(statement, 0), -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(statement2, 2, markType);
                    sqlite3_bind_text(statement2, 3, [_user_id UTF8String], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(statement2, 4, [item UTF8String], -1, SQLITE_TRANSIENT);
                    BOOL success = sqlite3_step(statement2);
                    //释放statement
                    sqlite3_finalize(statement2);
                    //如果执行失败
                    if (success == SQLITE_ERROR) {
                        //NSLog(@"Error: 保存标记 failed to update the database with message.");
                        //关闭数据库
                        sqlite3_close(database);
                        return NO;
                    }
                }
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    return YES;
}



#pragma mark --保存题目标记到DB
/**
 *	@brief	保存题目标记到DB
 *
 *	@param 	markType 	收藏/错题
 *	@param 	questionPojo
 *
 *	@return
 */

-(BOOL)saveProblemMark:(int)markType andQuestion:(QuestionPojo *)questionPojo
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 保存题目标记到DB open database error.");
        return NO;
    }
    if ((markType == QUESTION_MARK_WRONG && questionPojo.wrongquestion == 1)||
        (markType == QUESTION_MARK_FAVORITE && questionPojo.favorite== 1)) {
        
        NSString *sql1 = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@')VALUES(?,?,?,?);", QUESTION_MARK_TABLE_NAME, @"subject_id", @"mark_type", @"user_id", @"question_id"];
        sqlite3_stmt *statement1;
        if(sqlite3_prepare_v2(database, [sql1 UTF8String], -1, &statement1, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 保存题目标记到DB failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }else{
            //绑定题目信息的statement1数据
            sqlite3_bind_text(statement1, 1, [questionPojo.subject_id UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement1, 2, markType);
            sqlite3_bind_text(statement1, 3, [_user_id UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 4, [questionPojo.ID UTF8String], -1, SQLITE_TRANSIENT);
            BOOL success = sqlite3_step(statement1);
            //释放statement
            sqlite3_finalize(statement1);
            //如果执行失败
            if (success == SQLITE_ERROR) {
                //NSLog(@"Error: 保存题目标记到DB failed to update the database with message.");
                //关闭数据库
                sqlite3_close(database);
                return NO;
            }
        }
    }else{
        sqlite3_stmt *statement2;
        //组织SQL语句
        NSString *sql2 =[NSString stringWithFormat:@"DELETE FROM %@  WHERE user_id = ? and question_id = ? and mark_type = ?",QUESTION_MARK_TABLE_NAME];
        //将SQL语句放入sqlite3_stmt中
        int success = sqlite3_prepare_v2(database, [sql2 UTF8String], -1, &statement2, NULL);
        if (success != SQLITE_OK) {
            //NSLog(@"Error: failed to delete:testTable");
            sqlite3_close(database);
            return NO;
        }
        sqlite3_bind_text(statement2, 1, [_user_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement2, 2, [questionPojo.ID UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement2, 3, markType);
        
        //执行SQL语句。这里是更新数据库
        success = sqlite3_step(statement2);
        //释放statement
        sqlite3_finalize(statement2);
        //如果执行失败
        if (success == SQLITE_ERROR) {
            //NSLog(@"Error: failed to delete the database with message.");
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
    }
    sqlite3_close(database);
    return YES;
}


/**
 *	@brief	<#Description#>
 *
 *	@param 	markType 	<#markType description#>
 *	@param 	questionPojo 	<#questionPojo description#>
 *
 *	@return	<#return value description#>
 */
-(BOOL)deleteProblemMark:(int)markType andQuestion:(QuestionPojo *)questionPojo
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 保存题目标记到DB open database error.");
        return NO;
    }
    sqlite3_stmt *statement2;
    //组织SQL语句
    NSString *sql2 =[NSString stringWithFormat:@"DELETE FROM %@  WHERE user_id = ? and question_id = ? and mark_type = ?",QUESTION_MARK_TABLE_NAME];
    //将SQL语句放入sqlite3_stmt中
    int success = sqlite3_prepare_v2(database, [sql2 UTF8String], -1, &statement2, NULL);
    if (success != SQLITE_OK) {
        //NSLog(@"Error: failed to delete:testTable");
        sqlite3_close(database);
        return NO;
    }
    sqlite3_bind_text(statement2, 1, [_user_id UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement2, 2, [questionPojo.ID UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(statement2, 3, markType);
    
    //执行SQL语句。这里是更新数据库
    success = sqlite3_step(statement2);
    //释放statement
    sqlite3_finalize(statement2);
    //如果执行失败
    if (success == SQLITE_ERROR) {
        //NSLog(@"Error: failed to delete the database with message.");
        //关闭数据库
        sqlite3_close(database);
        return NO;
    }
    sqlite3_close(database);
    return YES;
}

#pragma mark --获得标记题目的ID
/**
 *	@brief	获得标记题目的ID
 *
 *	@param 	markType
 *	@param 	SybjectId
 *
 *	@return
 */
-(NSMutableArray *)getMarkProblemIds:(int)markType andSubjectId:(NSString *)subjectId

{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 获得标记题目的ID open database error.");
        return nil;
    }
    NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_id = '%@' AND subject_id ='%@' AND mark_type = %d", QUESTION_MARK_TABLE_NAME, _user_id, subjectId, markType];
    sqlite3_stmt *statement = nil;
    if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK)
    {
        //NSLog(@"Error: 获得标记题目的ID failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return nil;
    }
    
    while (sqlite3_step(statement) == SQLITE_ROW)
    {
        NSString *problemId=[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = '%@'",QUESTION_BANK_TABLE_NAME,problemId];
        [resultArray addObject:[[self queryProblem:sql] objectAtIndex:0]];
        [problemId release];
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return resultArray;
}

#pragma mark --保存做题记录
/**
 *	@brief	保存做题记录
 *
 *	@param 	dataArray
 *
 *	@return
 */
-(BOOL)saveStudentExamStat:(NSMutableArray *)dataArray

{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 保存做题记录 open database error.");
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@','%@','%@','%@','%@')VALUES(?,?,?,?,?,?,?,?);", EXAM_STAT_TABLE_NAME, @"id", @"user_id", @"question_id", @"library_id", @"mobile_right_number", @"mobile_wrong_number", @"web_right_number", @"web_wrong_number"];
    for(NSDictionary *item in dataArray) {
        sqlite3_stmt *statement1;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement1, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 保存做题记录 failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }else{
            //绑定题目信息的statement1数据
            sqlite3_bind_text(statement1, 1, [[item objectForKey:@"id"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 2, [[item objectForKey:@"userId"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 3, [[[item objectForKey:@"problem"] objectForKey:@"id"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement1, 4, [[item objectForKey:@"library"] UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(statement1, 5, [[item objectForKey:@"mobileRightNumber"] integerValue]);
            sqlite3_bind_int(statement1, 6, [[item objectForKey:@"mobileWrongNumber"] integerValue]);
            sqlite3_bind_int(statement1, 7, [[item objectForKey:@"webRightNumber"] integerValue]);
            sqlite3_bind_int(statement1, 8, [[item objectForKey:@"webWrongNumber"] integerValue]);
            
            BOOL success = sqlite3_step(statement1);
            //释放statement
            sqlite3_finalize(statement1);
            //如果执行失败
            if (success == SQLITE_ERROR) {
                //NSLog(@"Error: 保存做题记录 failed to update the database with message.");
                //关闭数据库
                sqlite3_close(database);
                return NO;
            }
        }
    }
    sqlite3_close(database);
    return YES;
}


#pragma mark --保存单题做题记录
/**
 *	@brief	保存单题做题记录
 *
 *	@param 	questionPojo
 *
 *	@return
 */
-(BOOL)saveStudentExamStatForSigle:(QuestionPojo *)questionPojo
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 保存单题做题记录open database error.");
        return NO;
    }
    /*
     NSString *sql_0=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_id='%@' AND question_id ='%@'", EXAM_STAT_TABLE_NAME, _user_id, questionPojo.ID];
     sqlite3_stmt *statement0;
     if(sqlite3_prepare_v2(database, [sql_0 UTF8String], -1, &statement0, NULL) != SQLITE_OK) {
     //NSLog(@"Error: 保存答案信息 failed to prepare statement with message:get testValue.");
     sqlite3_close(database);
     return NO;
     }else{
     int count=0;
     while (sqlite3_step(statement0) == SQLITE_ROW)
     {
     count++;
     }
     NSString *sql;
     if (count == 0) {
     sql=[NSString stringWithFormat:@""];
     }else{
     sql=[NSString stringWithFormat:@""];
     }
     
     
     }
     */
    
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@('%@','%@','%@','%@','%@')VALUES(?,?,?,?,?);", EXAM_STAT_TABLE_NAME, @"new_right_number", @"new_wrong_number", @"question_id", @"user_id", @"library_id"];
    sqlite3_stmt *statement1;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement1, NULL) != SQLITE_OK) {
        //NSLog(@"Error: 保存单题做题记录 failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return NO;
    }else{
        //绑定题目信息的statement1数据
        sqlite3_bind_int(statement1, 1, questionPojo.new_right);
        sqlite3_bind_int(statement1, 2, questionPojo.new_wrong);
        sqlite3_bind_text(statement1, 3, [questionPojo.ID UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement1, 4, [_user_id UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement1, 5, [questionPojo.library_id UTF8String], -1, SQLITE_TRANSIENT);
        
        BOOL success = sqlite3_step(statement1);
        //释放statement
        sqlite3_finalize(statement1);
        //如果执行失败
        if (success == SQLITE_ERROR) {
            //NSLog(@"Error: 保存单题做题记录 failed to update the database with message.");
            //关闭数据库
            sqlite3_close(database);
            return NO;
        }
    }
    sqlite3_close(database);
    return YES;
}

#pragma mark --更改做题记录
/**
 *	@brief	更改做题记录
 *
 *	@return
 */
-(NSMutableArray *)updateStudentExamStat

{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 更改做题记录open database error.");
        return nil;
    }
    NSMutableArray *resultArray=[[[NSMutableArray alloc] init] autorelease];
    NSString *sql1=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE user_id ='%@' AND (new_right_number > 0 or new_wrong_number >0)", EXAM_STAT_TABLE_NAME, _user_id];
    sqlite3_stmt *statement1;
    if(sqlite3_prepare_v2(database, [sql1 UTF8String], -1, &statement1, NULL) != SQLITE_OK) {
        //NSLog(@"Error: 更改做题记录 failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return nil;
    }else{
        while (sqlite3_step(statement1) == SQLITE_ROW)
        {
            int mobileRightNumber = sqlite3_column_int(statement1, 6)+sqlite3_column_int(statement1, 8);
            int mobileWrongNumber = sqlite3_column_int(statement1, 7)+sqlite3_column_int(statement1, 9);
            NSString *userId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 1)];
            NSString *library=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 3)];
            NSString *problemId=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement1, 2)];
            NSDictionary *problem=[NSDictionary dictionaryWithObjectsAndKeys:problemId, @"id", nil];
            JsonTools *jt=[[JsonTools alloc] init];
            [jt setValue:[NSNumber numberWithInt:mobileRightNumber] forKey:@"mobileRightNumber"];
            [jt setValue:[NSNumber numberWithInt:mobileWrongNumber] forKey:@"mobileWrongNumber"];
            [jt setValue:userId forKey:@"userId"];
            [jt setValue:library forKey:@"library"];
            [jt setValue:problem forKey:@"problem"];
            [resultArray addObject:[jt getJsonString]];
            [jt release];
            
            NSString *sql2=[NSString stringWithFormat:@"UPDATE %@ SET new_right_number='%d' AND new_wrong_number='%d' AND mobile_right_number='%d' AND mobile_wrong_number='%d' WHERE user_id='%@' AND question_id='%@'", EXAM_STAT_TABLE_NAME, 0, 0, mobileRightNumber, mobileWrongNumber, _user_id, problemId];
            sqlite3_stmt *statement2;
            if(sqlite3_prepare_v2(database, [sql2 UTF8String], -1, &statement2, NULL) != SQLITE_OK) {
                //NSLog(@"Error: 更改做题记录 failed to prepare statement with message:get testValue.");
                sqlite3_close(database);
                return NO;
            }
            BOOL success= sqlite3_step(statement2);
            sqlite3_finalize(statement2);
            if (success == SQLITE_ERROR) {
                //NSLog(@"Error: 更改做题记录 failed to update the database with message.");
                //关闭数据库
                sqlite3_close(database);
                return nil;
            }
        }
        sqlite3_finalize(statement1);
    }
    
    sqlite3_close(database);
    return resultArray;
}

#pragma mark --获取答案ID
/**
 *	@brief	获取答案ID
 *
 *	@param 	problemId
 *	@param 	answer
 *
 *	@return
 */
-(NSString *)getAnswerIds:(NSString *)problemId andAnswer:(int)answer

{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 获取答案ID open database error.");
        return nil;
    }
    NSString *result=@"";
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id='%@'",QUESTION_ANSWER_TABLE_NAME, problemId];
    sqlite3_stmt *statement1;
    if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement1, NULL) != SQLITE_OK) {
        //NSLog(@"Error: 获取答案ID failed to prepare statement with message:get testValue.");
        sqlite3_close(database);
        return NO;
    }
    while (sqlite3_step(statement1) == SQLITE_ROW)
    {
        while (answer > 0) {
            int x = answer % 10;
            answer = answer / 10;
            result=[NSString stringWithFormat:@"%@,%d", result, sqlite3_column_int(statement1, x)];
        }
    }
    sqlite3_finalize(statement1);
    sqlite3_close(database);
    if ([result length] != 0) {
        result=[result substringFromIndex:1];
    }
    return result;
}


#pragma mark --获取题库中不存在的题目ID
/**
 *	@brief	获取题库中不存在的题目ID
 *
 *	@param 	problemIdS
 *
 *	@return
 */
-(NSString *)getNotExistIds:(NSMutableArray *)problemIdS
{
    if (sqlite3_open([currentPath UTF8String], &database) !=SQLITE_OK) {//如果打开数据库失败
        sqlite3_close(database);
        //NSLog(@"Error: 获取题库中不存在的题目ID open database error.");
        return nil;
    }
    NSMutableArray *resultIds=[[[NSMutableArray alloc] initWithArray:problemIdS] autorelease];
    NSString *result=@"";
    for(int i=0; i < [problemIdS count]; i++){
        NSString *item=[problemIdS objectAtIndex:i];
        NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id='%@'",QUESTION_BANK_TABLE_NAME, item];
        sqlite3_stmt * statement;
        if(sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            //NSLog(@"Error: 获取题库中不存在的题目ID failed to prepare statement with message:get testValue.");
            sqlite3_close(database);
            return NO;
        }
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            [resultIds removeObject:item];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    for (int i=0; i<[resultIds count]; i++) {
        result=[NSString stringWithFormat:@"%@,%@",result,[resultIds objectAtIndex:i]];
    }
    if ([result length]!=0) {
        result=[result substringFromIndex:1];
    }
    return result;
}









@end