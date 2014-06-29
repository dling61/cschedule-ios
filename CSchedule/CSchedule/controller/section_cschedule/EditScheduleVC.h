//
//  EditScheduleVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/6/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"
typedef enum
{
    ACTIVITY_OPTION =1,
    TIMEZONE,
    ALERT,
} PickerCScheduleOption;

@interface EditScheduleVC : MyVC <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITextViewDelegate,UIAlertViewDelegate>

WEAK IBOutlet UITableView* table;
WEAK IBOutlet UIPickerView* picker;
WEAK IBOutlet UIDatePicker* datePicker;
STRONG UIView* datepickerContainer;
STRONG UIView* pickerContainer;
STRONG Schedule* editing_schedule;
STRONG UILabel* timezone_lbl;
STRONG UILabel* alert_lbl;
STRONG NSArray* alert_types;
STRONG NSArray* timezone_types;
STRONG NSArray* picker_data;
NOPOINTER (assign,nonatomic) int numberSection;
NOPOINTER PickerCScheduleOption current_picker_option;

- (IBAction) datepickerCancel: (id)sender;
- (IBAction) datepickerDone: (id)sender;
- (IBAction) pickerCancel: (id)sender;
- (IBAction) pickerDone: (id)sender;
- (IBAction) datePickerValueChanged;

@end
