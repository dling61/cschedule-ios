//
//  ResetPasswdVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/13/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface ResetPasswdVC : MyVC <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

WEAK IBOutlet UITableView* table;

-(IBAction) reset:(id)sender;

@end
