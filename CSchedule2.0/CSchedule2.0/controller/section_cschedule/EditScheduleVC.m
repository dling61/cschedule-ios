//
//  EditScheduleVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/6/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "EditScheduleVC.h"
#import "LblCell.h"
#import "TVCell.h"

@interface EditScheduleVC ()

@end

@implementation EditScheduleVC
{
    int script;
    int startorend;
    NSArray* myActivities;
    UITextView* desp_tv;
    UILabel* activity_lbl;
    UILabel* start_lbl;
    UILabel* end_lbl;
    int selectedrow;
}

@synthesize table = _table;
@synthesize editing_schedule = _editing_schedule;
@synthesize picker = _picker;
@synthesize datePicker = _datePicker;
@synthesize pickerContainer = _pickerContainer;
@synthesize datepickerContainer = _datepickerContainer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = EDITSCHEDULEVC;
}

- (void)initProperties
{
    [super initProperties];
    [self unpack];
    myActivities = [self.dataManager myActivities];
    _pickerContainer = [[[NSBundle mainBundle] loadNibNamed:@"ActivityPickerView" owner:self options:nil] objectAtIndex:0];
    _datepickerContainer = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:self options:nil] objectAtIndex:0];
}

- (void)initAppearance
{
    [super initAppearance];
    [_pickerContainer setFrame:CGRectMake(0, self.view.bounds.size.height, 320.0, MYPICKERVIEWHEIGHT)];
    [self.view addSubview:_pickerContainer];
    _pickerContainer.alpha = 0.0f;
    [_datepickerContainer setFrame:CGRectMake(0, self.view.bounds.size.height, 320.0, MYPICKERVIEWHEIGHT)];
    [self.view addSubview:_datepickerContainer];
    _datepickerContainer.alpha = 0.0f;
    if (script == VIEW) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) editParticipantsDone: (NSNotification*) note
{
    NSArray* participants = [[note userInfo] valueForKey:@"newmembers"];
    _editing_schedule.participants = participants;
    [_table reloadData];
}

- (void) postScheduleSuccess: (NSNotification*) note
{
    [self.dataManager saveSchedule:_editing_schedule synced:YES];
    [self.dataManager saveNextScheduleid:_editing_schedule.schedule_id + 1];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDSCHEDULESUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) postScheduleFail: (NSNotification*) note
{
    [self.dataManager saveSchedule:_editing_schedule synced:NO];
    [self.dataManager saveNextScheduleid:_editing_schedule.schedule_id + 1];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDSCHEDULESUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) putScheduleSuccess: (NSNotification*) note
{
    [self.dataManager saveSchedule:_editing_schedule synced:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATESCHEDULESUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) putScheduleFail: (NSNotification*) note
{
    [self.dataManager saveSchedule:_editing_schedule synced:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATESCHEDULESUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerForNotifications
{
    [super registerForNotifications];
    [self responde:EDITPARTICIPANTSDONE by:@selector(editParticipantsDone:)];
    [self responde:POSTSCHEDULESUCCESSNOTE by:@selector(postScheduleSuccess:)];
    [self responde:POSTSCHEDULEFAILNOTE by:@selector(postScheduleFail:)];
    [self responde:PUTSCHEDULESUCCESSNOTE by:@selector(putScheduleSuccess:)];
    [self responde:PUTSCHEDULEFAILNOTE by:@selector(putScheduleFail:)];
}

- (void) showPickerContainer
{
    [_picker reloadAllComponents];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerContainer.center = CGPointMake(_pickerContainer.center.x, _pickerContainer.center.y - MYPICKERVIEWHEIGHT - TABBARHEIGHT);
        _pickerContainer.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hidePickerContainer
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerContainer.center = CGPointMake(_pickerContainer.center.x, _pickerContainer.center.y + MYPICKERVIEWHEIGHT + TABBARHEIGHT);
        _pickerContainer.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) showDatePickerContainer
{
    [_picker reloadAllComponents];
    if (startorend == 0) {
        _datePicker.date = _editing_schedule.schedule_start;
    }
    else
    {
        _datePicker.date = _editing_schedule.schedule_end;
    }
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _datepickerContainer.center = CGPointMake(_datepickerContainer.center.x, _datepickerContainer.center.y - MYPICKERVIEWHEIGHT - TABBARHEIGHT);
        _datepickerContainer.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) hideDatePickerContainer
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _datepickerContainer.center = CGPointMake(_datepickerContainer.center.x, _datepickerContainer.center.y + MYPICKERVIEWHEIGHT + TABBARHEIGHT);
        _datepickerContainer.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) tableFade
{
    [_table setUserInteractionEnabled:NO];
    _table.alpha = 0.8f;
}

- (void) tableOut
{
    [_table setUserInteractionEnabled:YES];
    _table.alpha = 1.0f;
}

- (void) initUserInterationOfCell: (UITableViewCell*) cell
{
    if (_editing_schedule.activity_id == -1) {
        cell.alpha = 0.8f;
        cell.userInteractionEnabled = NO;
    }
    else
    {
        cell.alpha = 1.0f;
        cell.userInteractionEnabled = YES;
    }
}

- (void) unpack
{
    _editing_schedule = [self.package valueForKey:SCHEDULE];
    script = [[self.package valueForKey:@"script"] intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) datepickerCancel: (id)sender
{
    [self hideDatePickerContainer];
    [_table reloadData];
    [self tableOut];
}

- (IBAction) datepickerDone: (id)sender
{
    if (startorend == 0) {
        _editing_schedule.schedule_start = _datePicker.date;
        if ([_editing_schedule.schedule_start timeIntervalSinceDate:_editing_schedule.schedule_end] >= 0) {
            _editing_schedule.schedule_end = [NSDate dateWithTimeInterval:3600 sinceDate:_editing_schedule.schedule_start];
        }
    }
    else
    {
        _editing_schedule.schedule_end = _datePicker.date;
    }
    [self hideDatePickerContainer];
    [_table reloadData];
    [self tableOut];
}

- (IBAction) datePickerValueChanged
{
    if (startorend == 0) {
        start_lbl.text = [NSString stringWithFormat:@"%@ %@",
                         [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle2:_datePicker.date andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]],
                         [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle3:_datePicker.date andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]]];
    }
    else
    {
        end_lbl.text = [NSString stringWithFormat:@"%@ %@",
                        [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle2:_datePicker.date andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]],
                        [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle3:_datePicker.date andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]]];
    }
}

- (IBAction) pickerCancel: (id)sender
{
    [_table reloadData];
    [self hidePickerContainer];
    [self tableOut];
}

- (IBAction) pickerDone: (id)sender
{
    Activity* activity = [myActivities objectAtIndex:selectedrow];
    _editing_schedule.activity_id = activity.activity_id;
    _editing_schedule.utcoff = activity.utcoffset;
//    [_datePicker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:_editing_schedule.utcoff]];
    [_table reloadData];
    [self hidePickerContainer];
    [self tableOut];
}

- (IBAction) EditScheduleDone:(id)sender
{
    _editing_schedule.schedule_desp = desp_tv.text;
    if (script == ADD) {
        [[self.syncEngine postSchedule:_editing_schedule] start];
    }
    else
    {
        [[self.syncEngine updateSchedule:_editing_schedule] start];
    }
}

- (NSString*) partipant_str
{
    NSMutableString* str = [[NSMutableString alloc] init];
    int cnt = 0;
    for (SharedMember* sm in _editing_schedule.participants) {
        if (cnt == 0) {
            [str appendString:sm.member_name];
        }
        else
        {
            [str appendFormat:@", %@",sm.member_name];
        }
        cnt++;
    }
    if (str.length == 0) {
        [str appendString:@"No participants yet"];
    }
    return str;
}

-(NSArray*) involvedMembers
{
    NSMutableArray* participantids = [[NSMutableArray alloc] init];
    for (SharedMember* sm in _editing_schedule.participants) {
        [participantids addObject:@(sm.member_id)];
    }
    return participantids;
}


#pragma mark -
#pragma mark UITable Datasource methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            LblCell* activitycell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEACTIVITYCELL];
            activity_lbl = activitycell.lbl;
            if (_editing_schedule.activity_id == -1) {
                activitycell.lbl.text = @"Tap to select activity";
            }
            else
            {
                activitycell.lbl.text = [[self.dataManager getActivityWithID:_editing_schedule.activity_id] activity_name];
            }
            cell = activitycell;
            cell.tag = SCHEDULEACTIVITYCELLTAG;
            break;
        }
        case 1:
        {
            if (indexPath.row == 0) {
                LblCell* startcell = [tableView dequeueReusableCellWithIdentifier:SCHEDULESTARTCELL];
                start_lbl = startcell.lbl;
                startcell.lbl.text = [NSString stringWithFormat:@"%@ %@",
                                      [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle2:_editing_schedule.schedule_start andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]],
                                      [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle3:_editing_schedule.schedule_start andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]]];
                cell = startcell;

            }
            else
            {
                LblCell* endcell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEENDCELL];
                end_lbl = endcell.lbl;
                endcell.lbl.text = [NSString stringWithFormat:@"%@ %@",
                                      [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle2:_editing_schedule.schedule_end andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]],
                                      [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle3:_editing_schedule.schedule_end andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]]];
                cell = endcell;
            }
            break;
        }
        case 2:
        {
            LblCell* ondutycell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEONDUTYCELL];
            ondutycell.lbl.text = [self partipant_str];
            cell = ondutycell;
            break;
        }

        case 3:
        {
            TVCell* notecell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEDESPCELL];
            desp_tv = notecell.txt_area;
            if (script == VIEW) {
                desp_tv.editable = NO;
            }
            desp_tv.delegate = self;
            NSString* text = [_editing_schedule schedule_desp];
            if (text == nil || text.length == 0) {
                text = @"Notes";
            }
            notecell.txt_area.text = text;
            cell = notecell;
            break;
        }
        default:
            break;
    }
    if (cell.tag != SCHEDULEACTIVITYCELLTAG) {
        [self initUserInterationOfCell:cell];
    }
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (script == VIEW) {
        return;
    }
    switch (indexPath.section) {
        case 0:
            [self showPickerContainer];
            [self tableFade];
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                startorend = 0;
            }
            else
            {
                startorend = 1;
            }
            [self showDatePickerContainer];
            [self tableFade];
            break;
        }
        case 2:
            [self headto:ONDUTYVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:[self involvedMembers],@"members",@(_editing_schedule.activity_id),ACTIVITY, nil]];
            break;
            
        default:
            break;
    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 120.0f;
    }
    return 50.0f;
}

#pragma mark -
#pragma mark PickerView Datasource methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [myActivities count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Activity* activity = [myActivities objectAtIndex:row];
    return activity.activity_name;
}

#pragma mark -
#pragma mark PickerView Delegate method methods

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Activity* activity = [myActivities objectAtIndex:row];
    selectedrow = row;
    activity_lbl.text = activity.activity_name;
}

#pragma mark -
#pragma mark UITextView Datasource methods

- (BOOL)textView:(UITextView *)textView
shouldChangeTextInRange:(NSRange)rang
 replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        if (textView.text.length == 0) {
            textView.text = @"Notes";
        }
    }
    [_table setContentOffset:CGPointMake(0, NAVBARHEIGHT) animated:YES];
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [_table setContentOffset:CGPointMake(0, 150.0) animated:YES];
    if ([textView.text isEqualToString:@"Notes"]) {
        textView.text = @"";
    }
}


@end
