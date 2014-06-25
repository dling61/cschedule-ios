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

@interface EditActivityVC : MyVC <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>

STRONG Activity* editing_activity;

WEAK IBOutlet UITableView* table;

STRONG UIView* pickerContainerView;
WEAK IBOutlet UIPickerView* picker;
STRONG UITextField* name_tf;
STRONG UILabel* timezone_lbl;
STRONG UILabel* repeat_lbl;
STRONG UILabel* alert_lbl;
STRONG UITextView* desp_tv;

STRONG NSArray* alert_types;
STRONG NSArray* repeart_types;
STRONG NSArray* timezone_types;
STRONG NSArray* timezone_utcoffs;
STRONG NSArray* picker_data;

NOPOINTER PickerOption current_picker_option;
STRONG UITapGestureRecognizer* recognizer;

-(IBAction) pickDone:(id)sender;
-(IBAction) pickCancel:(id)sender;

-(IBAction) EditActivityDone: (id)sender;

-(void) showPickerViewWithOption: (PickerOption) option;

@end
