//
//  EditActivityVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/31/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

typedef enum
{
    TIMEZONE = 1,
    ALERT,
    REPEAT
} PickerOption;

@interface EditActivityVC : MyVC <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate,UIAlertViewDelegate>

STRONG Activity* editing_activity;
WEAK IBOutlet UITableView* table;

STRONG IBOutlet UITextField* name_tf;
STRONG IBOutlet UITextView* desp_tv;
STRONG NSArray* former_sharedmembers;
WEAK IBOutlet UIBarButtonItem *saveButton;

NOPOINTER (assign,nonatomic) int numberSection;

-(IBAction) EditActivityDone: (id)sender;
@end
