//
//  RegisterVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/8/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface RegisterVC : MyVC <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

STRONG IBOutlet UITableView* table;

STRONG UITextField* email_tf;
STRONG UITextField* name_tf;
STRONG UITextField* password_tf;
STRONG UITextField* mobile_tf;

-(IBAction) create:(id)sender;

@end
