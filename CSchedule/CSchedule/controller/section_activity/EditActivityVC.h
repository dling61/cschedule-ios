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

@interface EditActivityVC : MyVC < UITextFieldDelegate, UITextViewDelegate,UIAlertViewDelegate>

STRONG Activity* editing_activity;
WEAK IBOutlet UITextField* name_tf;
WEAK IBOutlet UITextView* desp_tv;
WEAK IBOutlet UIButton *deleteButton;
WEAK IBOutlet UIButton *addParticipantButton;
WEAK IBOutlet UIBarButtonItem *saveButton;

-(IBAction) EditActivityDone: (id)sender;
-(IBAction) touchOnDeleteActivity:(id)sender;
-(IBAction) touchOnAddParticipantButton:(id)sender;
@end
