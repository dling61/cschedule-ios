//
//  EditScheduleVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/6/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface EditScheduleVC : MyVC <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITextViewDelegate>

WEAK IBOutlet UITableView* table;
WEAK IBOutlet UIPickerView* picker;
WEAK IBOutlet UIDatePicker* datePicker;
STRONG UIView* datepickerContainer;
STRONG UIView* pickerContainer;
STRONG Schedule* editing_schedule;

- (IBAction) datepickerCancel: (id)sender;
- (IBAction) datepickerDone: (id)sender;
- (IBAction) pickerCancel: (id)sender;
- (IBAction) pickerDone: (id)sender;
- (IBAction) datePickerValueChanged;

@end
