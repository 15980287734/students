//
//  LoginViewController.h
//  IOSCoachApp
//
//  Created by user on 13-10-29.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate,CLLocationManagerDelegate>
@property (retain,nonatomic)CLLocationManager *locationManager;
@property (retain,nonatomic)CLLocation *checkinLocation;
@property (retain,nonatomic)NSMutableArray *schoolData;
@property (retain,nonatomic)NSMutableArray *usedSchool;
//选择驾校输入框
@property (retain,nonatomic)UITextField *schoolEdit;
//用户名输入框
@property (retain,nonatomic)UITextField *nameEdit;
//密码输入框
@property (retain,nonatomic)UITextField *pwdEdit;

-(void)loginaAgain;//注销
@end
