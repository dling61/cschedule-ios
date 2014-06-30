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
#import "ButtonActionCell.h"

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
    int _picker_selected_row;
}


@synthesize table = _table;
@synthesize editing_schedule = _editing_schedule;
@synthesize picker = _picker;
@synthesize datePicker = _datePicker;
@synthesize pickerContainer = _pickerContainer;
@synthesize datepickerContainer = _datepickerContainer;
@synthesize alert_types = _alert_types;
@synthesize timezone_types = _timezone_types;
@synthesize picker_data = _picker_data;

@synthesize timezone_lbl = _timezone_lbl;
@synthesize alert_lbl = _alert_lbl;
@synthesize mySharedMember=_mySharedMember;
@synthesize current_picker_option = _current_picker_option;
@synthesize isChangeDuty=_isChangeDuty;

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
    _isChangeDuty=NO;
    _datePicker.datePickerMode= UIDatePickerModeDateAndTime;
    
    
}
-(void)checkSharedMember
{
    _mySharedMember=nil;
    NSString *currentUserEmail= [self.dataManager currentUseremail];
    for (SharedMember *memberInfo in _editing_schedule.participants)
    {
        if([memberInfo.member_email isEqualToString:currentUserEmail])
        {
            _mySharedMember= memberInfo;
            break;
        }
        
    }
}

- (void) unpack
{
    _editing_schedule = [self.package valueForKey:SCHEDULE];
    script = [[self.package valueForKey:@"script"] intValue];
    
    [self configTableview];
    
}
-(void)configTableview
{
    [self checkSharedMember];
    if(script ==ADD)
    {
        self.title = ADDSCHEDULEVC;
        self.numberSection= 6;
    }
    else if(script == VIEW){
        self.title = VIEWSCHEDULEVC;
        self.navigationItem.rightBarButtonItem = nil;
        if(_mySharedMember!=nil)
        {
            if(_mySharedMember.confirm==Unknown)
            {
                self.numberSection= 8;
                
            }
            else if(_mySharedMember.confirm==Confirmed ||_mySharedMember.confirm==Denied)
            {
                self.numberSection= 7;
            }
        }
        else{
            self.numberSection= 6;
        }
        
    }
    else{
        self.title = EDITSCHEDULEVC;
        if(_mySharedMember!=nil)
        {
            if(_mySharedMember.confirm==Unknown)
            {
                self.numberSection= 9;
                
            }
            else if(_mySharedMember.confirm==Confirmed ||_mySharedMember.confirm==Denied)
            {
                self.numberSection= 8;
            }
        }
        else{
            self.numberSection= 7;
        }
    }

}

- (void)initProperties
{
    [super initProperties];
    [self unpack];
    
    myActivities = [self.dataManager myActivities];
    _timezone_types = [self.dataManager allSettingTimeZones];
    _alert_types =[self.dataManager allSettingAlerts];
    
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
    
}

- (void) editParticipantsDone: (NSNotification*) note
{
    _isChangeDuty=YES;
    NSArray* participants = [[note userInfo] valueForKey:@"newmembers"];
    // Update list participants
   for (SharedMember *oldMember in _editing_schedule.participants)
   {
       for(SharedMember *sharedMember in participants)
       {
           if(sharedMember.member_id == oldMember.member_id)
           {
               sharedMember.confirm= oldMember.confirm;
           }
       }
   }
    
    _editing_schedule.participants = participants;
    //[self configTableview];
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

- (void)deleteScheduleSuccess:(NSNotification*) note
{
    [self.dataManager deleteSchedule:_editing_schedule.schedule_id Synced:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATESCHEDULESUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteScheduleFail:(NSNotification*) note
{
    [self.dataManager deleteSchedule:_editing_schedule.schedule_id Synced:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATESCHEDULESUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmSharedMemberSuccess: (NSNotification*) note
{
    
    for (SharedMember *memberInfo in _editing_schedule.participants)
    {
        if(memberInfo.member_id ==_mySharedMember.member_id)
        {
            memberInfo.confirm= _mySharedMember.confirm;
            break;
        }
        
    }
    [self.dataManager saveSchedule:_editing_schedule synced:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATESCHEDULESUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];

    
}
- (void)confirmSharedMemberFail: (NSNotification*) note
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
    
    
    [self responde:DELETESCHEDULESUCCESSNOTE by:@selector(deleteScheduleSuccess:)];
    [self responde:DELETESCHEDULEFAILNOTE by:@selector(deleteScheduleFail:)];
    
    [self responde:CONFIRMSTATUSSUCCESSNOTE by:@selector(confirmSharedMemberSuccess:)];
    [self responde:CONFIRMSTATUSFAILNOTE by:@selector(confirmSharedMemberFail:)];

}
-(void) showPickerViewWithOption: (PickerCScheduleOption) option
{
    int picker_selected_index = 0;
    switch (option) {
        case ACTIVITY_OPTION:
            _picker_data = myActivities;
            
            //picker_selected_index = [myActivities indexOfObject:@(_editing_schedule.activity_id)];
            break;
        case TIMEZONE:
            _picker_data = _timezone_types;
            //picker_selected_index = [_timezone_utcoffs indexOfObject:@(_editing_schedule.tzid)];
            break;
        case ALERT:
            _picker_data = _alert_types;
            //picker_selected_index = _editing_schedule.alert;
            break;
        default:
            return;
    }
    if (picker_selected_index == NSNotFound || picker_selected_index < 0) {
        picker_selected_index = 0;
    }
    [_picker reloadAllComponents];
    [_picker selectRow:picker_selected_index inComponent:0 animated:NO];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerContainer.center = CGPointMake(_pickerContainer.center.x, _pickerContainer.center.y - MYPICKERVIEWHEIGHT - TABBARHEIGHT);
        _pickerContainer.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
    [self tableFade];
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
    [self hidePickerContainer];
    switch (_current_picker_option) {
        case ACTIVITY_OPTION:
        {
            Activity* activity = [myActivities objectAtIndex:_picker_selected_row];
            _editing_schedule.activity_id = activity.activity_id;
            [_table reloadData];
        }
            break;
        case TIMEZONE:
        {
            TimeZone* timezone = [_timezone_types objectAtIndex:_picker_selected_row];
            _editing_schedule.tzid = timezone.timezone_id;
        }
            break;
        case ALERT:
        {
            AlertInfo* alertInfo = [_alert_types objectAtIndex:_picker_selected_row];
            _editing_schedule.alert = alertInfo.alert_id;
        }
            break;
        default:
            break;
    }
    
    [self tableOut];
    
   
}

- (IBAction) EditScheduleDone:(id)sender
{
    if(desp_tv.text==nil)
    {
        _editing_schedule.schedule_desp=@"";
    }
    else{
        _editing_schedule.schedule_desp = desp_tv.text;
    }
    
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

-(void)callActionButtonWithType:(ButtonCellType)typeCell
{
    if(_isChangeDuty)
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"The members was changed. Please update the information before you can do this action!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    else{
        switch (typeCell) {
            case DeleteButtonCell:
            {
                [self del];
            }
                break;
            case ConfirmButtonCell:
                _mySharedMember.confirm= Confirmed;
                [[self.syncEngine confirmSharedMember:_mySharedMember.member_id schedule:_editing_schedule.schedule_id confirmType:Confirmed]start];
                break;
            case DenyButtonCell:
                _mySharedMember.confirm= Denied;
                [[self.syncEngine confirmSharedMember:_mySharedMember.member_id schedule:_editing_schedule.schedule_id confirmType:Denied]start];
                break;
                
            default:
                break;
        }

    }
}

-(void) del
{
    [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want to delete this schedule ?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
}

#pragma mark -
#pragma mark UITable Datasource methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.numberSection;
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
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
        case 6:
            return 1;
            break;
        case 7:
            return 1;
            break;
        case 8:
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
            LblCell* timeZonecell = [tableView dequeueReusableCellWithIdentifier:SCHEDULETIMEZONECELL];
            _timezone_lbl = timeZonecell.lbl;
            if([self getTimezoneWithID:_editing_schedule.tzid])
            {
                _timezone_lbl.text = [[self getTimezoneWithID:_editing_schedule.tzid]timezone_name];
            }
            else{
                _timezone_lbl.text=@"";
            }
            cell = timeZonecell;
            break;
        }
        case 3:
        {
            LblCell* alertcell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEALERTCELL];
            _alert_lbl = alertcell.lbl;
            if([self getAlertWithID:_editing_schedule.alert])
            {
               alertcell.lbl.text = [[self getAlertWithID:_editing_schedule.alert]alert_name];
            }
            else{
                alertcell.lbl.text=@"";
            }

            cell = alertcell;
            break;
        }
        case 4:
        {
            LblCell* ondutycell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEONDUTYCELL];
            ondutycell.lbl.text = [self partipant_str];
            cell = ondutycell;
            break;
        }

        case 5:
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
        case 6:
        {
            ButtonActionCell* buttoncell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEBUTTONCELL];
            if(script == VIEW){
                if(_mySharedMember.confirm==Unknown || _mySharedMember.confirm==Denied)
                {
                    [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_confirm.png"]];
                    buttoncell.cellType= ConfirmButtonCell;
                }
                else{
                    [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_deny.png"]];
                    buttoncell.cellType= DenyButtonCell;
                }
                
            }
            else
            {
                [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_delete.png"]];
                buttoncell.cellType= DeleteButtonCell;
            }
            
            cell = buttoncell;
            break;

        }
            break;
        case 7:
        {
            ButtonActionCell* buttoncell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEBUTTONCELL];
             if(script == VIEW){
                 if(_mySharedMember.confirm==Unknown)
                 {
                     [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_deny.png"]];
                     buttoncell.cellType= DenyButtonCell;
                 }
             }
             else
             {
                 if(_mySharedMember.confirm==Unknown ||_mySharedMember.confirm==Denied )
                 {
                     [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_confirm.png"]];
                     buttoncell.cellType= ConfirmButtonCell;
                 }
                 else{
                     [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_deny.png"]];
                     buttoncell.cellType= DenyButtonCell;
                 }
                 
             }
            cell = buttoncell;
            break;
            
        }
            break;
        case 8:
        {
            ButtonActionCell* buttoncell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEBUTTONCELL];
            if(_mySharedMember.confirm==Unknown)
            {
                [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_deny.png"]];
                buttoncell.cellType= DenyButtonCell;
            }
            
            cell = buttoncell;
            break;
            
        }
            break;
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
    switch (indexPath.section) {
        case 0:
            if(script != VIEW)
            {
                _current_picker_option = ACTIVITY_OPTION;
                [self showPickerViewWithOption:_current_picker_option];
            }
            break;
        case 1:
        {
            if(script != VIEW)
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
            }
            
            break;
        }
        case 2:
            if(script != VIEW)
            {
                _current_picker_option = TIMEZONE;
                [self showPickerViewWithOption:_current_picker_option];
                
            }
            
            break;
        case 3:
            if(script != VIEW)
            {
                _current_picker_option = ALERT;
                [self showPickerViewWithOption:_current_picker_option];
            }
            
            break;
        case 4:
            if(script != VIEW)
            {
                [self headto:ONDUTYVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:[self involvedMembers],@"members",@(_editing_schedule.activity_id),ACTIVITY, nil]];
            }
            
            break;
        case 6:
        {
            ButtonActionCell *buttonCell =(ButtonActionCell*)[tableView cellForRowAtIndexPath:indexPath];
            [self callActionButtonWithType:buttonCell.cellType];
        }
            break;
        case 7:
        {
            ButtonActionCell *buttonCell =(ButtonActionCell*)[tableView cellForRowAtIndexPath:indexPath];
            [self callActionButtonWithType:buttonCell.cellType];
        }
            break;
        case 8:
        {
            ButtonActionCell *buttonCell =(ButtonActionCell*)[tableView cellForRowAtIndexPath:indexPath];
            [self callActionButtonWithType:buttonCell.cellType];
        }
            break;
        default:
            break;
    }
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 5) {
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
    return [_picker_data count];
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(_current_picker_option==ACTIVITY_OPTION)
    {
        Activity* activity = [_picker_data objectAtIndex:row];
        return activity.activity_name;
    }
    else if(_current_picker_option==TIMEZONE){
        TimeZone* timezone = [_picker_data objectAtIndex:row];
        return timezone.timezone_name;
    }
    else{
        AlertInfo* alertInfo = [_picker_data objectAtIndex:row];
        return alertInfo.alert_name;
    }
    
}

#pragma mark -
#pragma mark PickerView Delegate method methods

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _picker_selected_row = row;
    switch (_current_picker_option) {
        case ALERT:
        {
            AlertInfo *alertInfo =[_alert_types objectAtIndex:row];
            _alert_lbl.text =alertInfo.alert_name;
        }
            break;
        case ACTIVITY_OPTION:
        {
            Activity* activity = [myActivities objectAtIndex:row];
            activity_lbl.text = activity.activity_name;
            break;
        }
        case TIMEZONE:
        {
            TimeZone *timezone =[_timezone_types objectAtIndex:row];
            _timezone_lbl.text =timezone.timezone_name;
        }
            break;
        default:
            break;
    }

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
        [_table setContentOffset:CGPointMake(0, NAVBARHEIGHT) animated:YES];
    }
    [_table setContentOffset:CGPointMake(0, 200.0) animated:YES];
    //[_table setContentOffset:CGPointMake(0, NAVBARHEIGHT) animated:YES];
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [_table setContentOffset:CGPointMake(0, 200.0) animated:YES];
    if ([textView.text isEqualToString:@"Notes"]) {
        textView.text = @"";
    }
}
#pragma mark -
#pragma mark Popview button Method

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[self.syncEngine deleteSchedule:_editing_schedule.schedule_id] start];
    }
}

- (TimeZone*) getTimezoneWithID:(int)timezone_id
{
    for(TimeZone *timezone in _timezone_types)
    {
        if(timezone.timezone_id == timezone_id)
        {
            return timezone;
        }
    }
    return nil;
    
}
- (AlertInfo*) getAlertWithID:(int)alert_id
{
    for(AlertInfo *alertinfo in _alert_types)
    {
        if(alertinfo.alert_id == alert_id)
        {
            return alertinfo;
        }
    }
    return nil;
}
@end
