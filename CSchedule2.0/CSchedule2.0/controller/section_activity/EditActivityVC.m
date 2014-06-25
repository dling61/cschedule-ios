//
//  EditActivityVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/31/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "EditActivityVC.h"
#import "TFCell.h"
#import "TVCell.h"
#import "LblCell.h"

@interface EditActivityVC ()

@end

@implementation EditActivityVC
{
    int _script;
    int _picker_selected_row;
}
@synthesize editing_activity = _editing_activity;
@synthesize table = _table;
@synthesize pickerContainerView = _pickerContainerView;
@synthesize picker = _picker;
@synthesize alert_types = _alert_types;
@synthesize repeart_types = _repeart_types;
@synthesize timezone_types = _timezone_types;
@synthesize timezone_utcoffs = _timezone_utcoffs;
@synthesize picker_data = _picker_data;
@synthesize current_picker_option = _current_picker_option;
@synthesize name_tf = _name_tf;
@synthesize timezone_lbl = _timezone_lbl;
@synthesize repeat_lbl = _repeat_lbl;
@synthesize alert_lbl = _alert_lbl;
@synthesize desp_tv = _desp_tv;
@synthesize recognizer = _tapRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) unpack
{
    _editing_activity = (Activity*)[self.package valueForKey:ACTIVITY];
    _script = [[self.package valueForKey:@"script"] intValue];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self unpack];
    self.title = EDITACTIVITYVC;
}

- (void)postActivitySuccess: (NSNotification*) note
{
    [self.dataManager saveActivity:_editing_activity synced:YES];
    [self.dataManager saveNextActivityid:_editing_activity.activity_id + 1];
    [self headto:SHAREMEMBERVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:@(_editing_activity.activity_id),ACTIVITY,@(ADD),@"script", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void)postActivityFail: (NSNotification*) note
{
    [self.dataManager saveActivity:_editing_activity synced:NO];
    [self.dataManager saveNextActivityid:_editing_activity.activity_id + 1];
    //it's not really success
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void) updateActivitySuccess: (NSNotification*) note
{
    [self.dataManager saveActivity:_editing_activity synced:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void)updateActivityFail: (NSNotification*) note
{
    [self.dataManager saveActivity:_editing_activity synced:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void)registerForNotifications
{
    [super registerForNotifications];
    [self responde:POSTACTIVITYSUCCESSNOTE by:@selector(postActivitySuccess:)];
    [self responde:POSTACTIVITYFAILNOTE by:@selector(postActivityFail:)];
    [self responde:PUTACTIVITYSUCCESSNOTE by:@selector(updateActivitySuccess:)];
}

- (void) initAppearance
{
    [super initAppearance];
    /*the picker container view is hidden*/
    [_pickerContainerView setFrame:CGRectMake(0, self.view.bounds.size.height, 320.0, MYPICKERVIEWHEIGHT)];
    [self.view addSubview:_pickerContainerView];
    _pickerContainerView.alpha = 0.0f;
}

-(void) viewSignleTapped
{
    _editing_activity.activity_name = _name_tf.text;
    [_table setUserInteractionEnabled:YES];
    [_name_tf resignFirstResponder];
    [self.view removeGestureRecognizer:_tapRecognizer];
}

- (void) initProperties
{
    [super initProperties];
    _pickerContainerView = [[[NSBundle mainBundle] loadNibNamed:@"MyPickerView" owner:self options:nil] objectAtIndex:0];
    self.table.contentSize = CGSizeMake(320.0f, 1500.0f);
    _alert_types = @[@"None",@"5 minutes before",@"15 minutes before",@"30 minutes before",@"1 hour before",@"2 hours before",@"1 day before",@"2 days before",@"3 days before",@"7 days before"];
    _repeart_types = @[@"None",@"Every day",@"Every week",@"Every 2 weeks",@"Every month",@"Every year"];
    _timezone_types = @[@"US/Samoa",@"US/Hawaii",@"US/Alaska",@"US/Pacific",@"US/Arizona & US/Mountain",@"US/Central",@"US/Eastern & US/East-Indiana",@"Canada/Atlantic",@"Canada/Newfoundland"];
    _timezone_utcoffs = @[@(-36900),@(-36000),@(-32400),@(-28800),@(-25200),@(-21600),@(-18000),@(-14400),@(-12600)];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSignleTapped)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) pickDone:(id)sender
{
    [self hidePickerView];
    switch (_current_picker_option) {
        case TIMEZONE:
            _editing_activity.utcoffset = [[_timezone_utcoffs objectAtIndex:_picker_selected_row] intValue];
            break;
        case REPEAT:
            _editing_activity.repeat = _picker_selected_row;
            break;
        case ALERT:
            _editing_activity.alert = _picker_selected_row;
            break;
        default:
            break;
    }
}

-(IBAction) pickCancel:(id)sender
{
    [self hidePickerView];
    [_table reloadData];
}

-(IBAction) EditActivityDone:(id)sender
{
    _editing_activity.activity_name = _name_tf.text;
    _editing_activity.activity_description = _desp_tv.text;
    
    if (_editing_activity.activity_name == nil || _editing_activity.activity_name.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"An activity name is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    if (_script == ADD) {
        [[self.syncEngine postActivity:_editing_activity] start];
    }
    else if (_script == EDIT)
    {
        [[self.syncEngine updateActivity:_editing_activity] start];
    }
}

-(void) showPickerViewWithOption: (PickerOption) option
{
    int picker_selected_index = 0;
    switch (option) {
        case 1:
            if (_script == EDIT) {
                return;
            }
            _picker_data = _timezone_types;
            picker_selected_index = [_timezone_utcoffs indexOfObject:@(_editing_activity.utcoffset)];
            break;
        case 2:
            _picker_data = _alert_types;
            picker_selected_index = _editing_activity.alert;
            break;
        case 3:
            _picker_data = _repeart_types;
            picker_selected_index = _editing_activity.repeat;
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
        _pickerContainerView.center = CGPointMake(_pickerContainerView.center.x, _pickerContainerView.center.y - MYPICKERVIEWHEIGHT - TABBARHEIGHT);
        _pickerContainerView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        
    }];
}

-(void) hidePickerView
{
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerContainerView.center = CGPointMake(_pickerContainerView.center.x, _pickerContainerView.center.y + MYPICKERVIEWHEIGHT + TABBARHEIGHT);
        _pickerContainerView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -
#pragma mark UITableView Datasource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            TFCell* namecell = [tableView dequeueReusableCellWithIdentifier:ACTNAMECELL];
            _name_tf = namecell.tf;
            namecell.tf.text = _editing_activity.activity_name;
            cell = namecell;
            break;
        }
        case 1:
        {
            LblCell* timezonecell = [tableView dequeueReusableCellWithIdentifier:ACTTIMEZONECELL];
            _timezone_lbl = timezonecell.lbl;
            int zone_index = [_timezone_utcoffs indexOfObject:@(_editing_activity.utcoffset)];
            if (zone_index == NSNotFound)
                zone_index = 0;
            _timezone_lbl.text = _timezone_types[zone_index];
            cell = timezonecell;
            break;
        }
        case 2:
        {
            LblCell* alertcell = [tableView dequeueReusableCellWithIdentifier:ACTALERTCELL];
            _alert_lbl = alertcell.lbl;
            alertcell.lbl.text = _alert_types[_editing_activity.alert];
            cell = alertcell;
            break;
        }
        case 3:
        {
            LblCell* repeatcell = [tableView dequeueReusableCellWithIdentifier:ACTREPEATCELL];
            _repeat_lbl = repeatcell.lbl;
            repeatcell.lbl.text = _repeart_types[_editing_activity.repeat];
            cell = repeatcell;
            break;
        }
        case 4:
        {
            TVCell* notecell = [tableView dequeueReusableCellWithIdentifier:ACTDESPCELL];
            _desp_tv = notecell.txt_area;
            if (_editing_activity.activity_description.length > 0) {
                notecell.txt_area.text = _editing_activity.activity_description;
            }
            else
            {
                notecell.txt_area.text = @"Notes";
            }
            cell = notecell;
            break;
        }
        default:
            break;
    }
    return cell;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        return 120.0f;
    }
    return 44.0f;
}


#pragma mark -
#pragma mark UITableView Delegate Methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _current_picker_option = indexPath.section;
    [self showPickerViewWithOption:indexPath.section];
    if (indexPath.section > 2) {
        [_table setContentOffset:CGPointMake(0.0f, 30.0f) animated:YES];
    }
}

#pragma mark -
#pragma mark UIPickerView Datasource methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _picker_data.count;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _picker_data[row];
}

#pragma mark -
#pragma mark UIPickerView Delegate methods

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _picker_selected_row = row;
    switch (_current_picker_option) {
        case ALERT:
            _alert_lbl.text = [_picker_data objectAtIndex:row];
            break;
        case REPEAT:
            _repeat_lbl.text = [_picker_data objectAtIndex:row];
            break;
        case TIMEZONE:
            _timezone_lbl.text = [_picker_data objectAtIndex:row];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma makr UITextField Datasource methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _editing_activity.activity_name = textField.text;
    [self.view removeGestureRecognizer:_tapRecognizer];
    [_table setUserInteractionEnabled:YES];
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view addGestureRecognizer:_tapRecognizer];
    [_table setUserInteractionEnabled:NO];
    return YES;
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
