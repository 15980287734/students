//
//  EditPasswordViewController.h
//  DrivingStudent
//
//  Created by 陈主祥 on 13-11-12.
//  Copyright (c) 2013年 陈主祥. All rights reserved.
//

#import "BaseViewController.h"
@class MainViewController;
@interface EditPasswordViewController : BaseViewController<UITextFieldDelegate>

@property (retain,nonatomic)UITextField *_oldPasswordText;
@property (retain,nonatomic)UITextField *_MyNewPassword1Text;
@property (retain,nonatomic)UITextField *_MyNewPassword2Text;

@end
