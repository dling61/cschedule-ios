//
//  SigninVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/19/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface SigninVC : MyVC <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

STRONG UITextField* email_tf;
STRONG UITextField* passwd_tf;

-(IBAction) signin :(id)sender;

@end
