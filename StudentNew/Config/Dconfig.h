//
//  Dconfig.h
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-11.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#ifndef DrivingStudent_Dconfig_h
#define DrivingStudent_Dconfig_h

#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height

#define Font [UIFont fontWithName:@"Arial" size:12.0]
#define Font1 [UIFont fontWithName:@"Arial" size:13.0]
#define Font2 [UIFont fontWithName:@"Arial" size:15.0]
#define Font_SC [UIFont fontWithName:@"Heiti SC" size:15]
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define APPVERSION  (@"10")  //自定义App版本号

#define ScreenViewHeight ([UIScreen mainScreen].bounds.size.height-64)

#define WIDTH 210    //右边侧滑栏宽度
#define ReportStudentSearchBtnTag 110   //报备记录搜索按钮tag值
#define remarksTextTag 121   //备注文本框tag值

#define StrBundle [[NSBundle mainBundle] bundlePath]
//#define ChoicButtonTag 121 //单选按钮sex
//#define ChoicButtonTag1 122

#define  HANDLER_DICT_TYPE_CODE  (@"0001")   //字典类型处理器
#define  HANDLER_DICTIONARY_CODE  (@"0002")    //字典数据处理器

#pragma mark  --学员信息
#define  HANDLER_CARD_PUBLISH_CODE  (@"0003")  //学员发卡处理器
#define  HANDLER_BAOMING_CODE  (@"0007")  //学员报名信息处理器
#define  HANDLER_CHARGE_BOOK_CODE  (@"0009")  //收费流水账信息处理器
#define  HANDLER_STUDENT_PHOTO_CODE  (@"0010") //学员照片处理器

#pragma mark  --人事部分
#define  HANDLER_HUMAN_CODE  (@"0020")       //员工信息处理器

#pragma mark  --培训部分
#define  HANDLER_TRAIN_PLAN_CODE  (@"0031")    //培训计划信息处理器
#define  HANDLER_TRAIN_RESERVE_CODE  (@"0032") //培训预约信息处理器
#define  HANDLER_TRAIN_ENTRY_CODE  (@"0033")   //培训登记信息处理器
#define  HANDLER_TRAIN_DEVICE_CODE  (@"0034")  //培训设备数据处理器
#define  HANDLER_TRAIN_CHECKIN_CODE  (@"0035") //培训签到数据处理器
#define  HANDLER_TRAIN_PHOTO_CODE  (@"0036") //培训照片数据处理器
#define  HANDLER_STUDENT_TRAIN_PROGRESS_CODE  (@"0037") //学员培训进度数据处理器

#pragma mark  --客户管理部分
#define  HANDLER_CUSTOMER_CODE  (@"0041")      //客户信息
#define  HANDLER_CUSTOMER_IMPORT_CODE  (@"0042") //客户信息批量导入

#pragma mark  --考试管理部分
#define  HANDLER_EXAM_RESERVE_CODE  (@"0060")    //考试预约
#define  HANDLER_EXAM_RESERVE_ITEM_CODE (@"0061")  //考试预约项目
#define  HANDLER_EXAM_ARRANGE_CODE  (@"0062")     //考试安排
#define  HANDLER_EXAM_SCORE_CODE  (@"0063")       //考试成绩
#define  HANDLER_OPERATION_PRE_EXAM_CODE  (@"0064") //实操预考成绩信息处理器
#define  HANDLER_EXAM_MISS_CODE  (@"0065")        //考试失误

#pragma mark  --理论培训
#define  HANDLER_ONLINE_EXAM_LIBRARY_CODE  (@"0501") //预考题库处理器
#define  HANDLER_ONLINE_EXAM_SUBJECT_CODE  (@"0502") //预考章节处理器
#define  HANDLER_ONLINE_EXAM_PROBLEM_CODE  (@"0503") //预考题目处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_PAPER_CODE  (@"0504")//学员考卷处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_PAPER_ANSWER_CODE (@"0505")//学员考卷答案处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_STAT_CODE (@"0506") //学员统计处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_EXAM_STAT_CODE (@"0507") //学员答题统计处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_FAVORITE_CODE (@"0508") //考生收藏夹处理器
#define  HANDLER_ONLINE_EXAM_STUDENT_TRASH_CODE (@"0509") //考生垃圾桶处理器
#define  HANDLER_ONLINE_EXAM_SCORE_TOP_CODE (@"0510") //考生排行榜处理器

#pragma mark  --报表部分
#define  HANDLER_COACH_EXAM_REPORT_CODE  (@"0091")//教练月考试报表
#define  HANDLER_COACH_EXAM_ENROLLMENT_REPORT_CODE  (@"0092")	//教练月考试招生报表

#pragma mark  --系统部分
#define  HANDLER_USER_CODE  (@"1002");                //用户数据处理器
#define  HANDLER_FRIEND_APPLY_CODE (@"1024");//添加好友数据处理器
#define  HANDLER_MY_FRIEND_CODE  (@"1020")   //我的好友数据处理器
#define  HANDLER_DEVICE_ACTIVATION_CODE  (@"1000") //设备激活数据处理器
#define  HANDLER_ACCOUNT_CODE  (@"1001")          //帐户数据处理器
#define  HANDLER_LEAVE_WORD_CODE  (@"1011")      //客户留言数据处理器
#define  HANDLER_MESSAGE_SEND_CODE  (@"1021")  //消息发送数据处理器
#define  HANDLER_MESSAGE_RECEIVE_CODE  (@"1022")      //消息接收数据处理器
#define  HANDLER_MESSAGE_REPLY_CODE  (@"1023")      //消息接收数据处理器
#define  HANDLER_METHOD_MONITOR_CODE  (@"1099") //方法执行监控数据处理器
#define HANDLER_DEVICE_REPORT_CODE  (@"1009")     //设备问题反馈数据处理器


#pragma mark  --广告图片链接
#define  HANDLER_AD_LINK_CODE  (@"1051")		//全屏广告链接
#define  HANDLER_AD_LINK_CODE2  (@"1052")		//横幅广告链接


#pragma mark --常用请求参数
#define POST_ACTION_TYPE_UPLOADXMLDATA  (@"uploadXMLData")
#define POST_ACTION_TYPE_UPLOADXMLZIPDATA  (@"uploadXMLZipData")
#define POST_ACTION_TYPE_DOWNLOADXMLDATA (@"downloadXMLData")
#define POST_ACTION_TYPE_DOWNLOADXMLZIPDATA (@"downloadXMLZipData")

#define ACTION_TYPE_QUERY (@"query")
#define ACTION_TYPE_INSERT (@"insert")
#define ACTION_TYPE_UPDATE (@"update")
#define ACTION_TYPE_DELETE (@"delete")

#pragma mark --常用的url
#define LOGIN_URL  (@"/comm/busLogin")  //登录接口后缀
#define SERVICE_URL (@"/comm/busService")  //服务接口后缀
#define UPDATE_URL (@"http://www.smyfjx.com:7777/apps/android/coach/update.properties")  //更新文件网址
#define USER_CITY  (@"user_city")


#pragma mark -- 抽奖
#define HANDLER_LOTTERY_ACTIVITY_CODE (@"1611") //抽奖活动信息处理器
#define HANDLER_LOTTERY_WINNING_RECORD_CODE (@"1612")  //抽奖中奖记录处理器

#endif

