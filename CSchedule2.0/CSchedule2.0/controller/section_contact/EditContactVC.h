//
//  EditContactVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/4/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface EditContactVC : MyVC <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

STRONG Contact* editing_contact;

WEAK IBOutlet UITableView* table;
STRONG UITextField* name_tf;
STRONG UITextField* email_tf;
STRONG UITextField* mobile_tf;

NOPOINTER int script;

-(IBAction) EditContactDone:(id)sender;

@end
