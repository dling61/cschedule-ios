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
@synthesize name_tf = _name_tf;
@synthesize desp_tv = _desp_tv;
@synthesize deleteButton=_deleteButton;
@synthesize saveButton=_saveButton;
@synthesize addParticipantButton=_addParticipantButton;
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
    
    [_desp_tv setEditable:YES];
    [_name_tf setEnabled:YES];
    _deleteButton.hidden=YES;
    _addParticipantButton.hidden=YES;
    
    if (_script == ADD) {
        self.title =ADDACTIVITYVC;
    }
    else{
        
        self.title = EDITACTIVITYVC;
        if (_editing_activity.shared_role == OWNER) {
            _deleteButton.hidden=NO;
            _addParticipantButton.hidden=NO;
        }
        else{
            //can't edit && delete
            self.navigationItem.rightBarButtonItems =nil;
            [_desp_tv setEditable:NO];
            [_name_tf setEnabled:NO];
        }
        [self showDataEditMode];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self unpack];
    
    }

-(void)showDataEditMode
{
    _name_tf.text= _editing_activity.activity_name;
    
    if (_editing_activity.activity_description.length > 0) {
        _desp_tv.text = _editing_activity.activity_description;
    }
    else
    {
        _desp_tv.text = @"Notes";
    }
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
- (void)deleteActivitySuccess: (NSNotification*)note
{
    [self.dataManager deleteActivityAndRelatedSchedules:_editing_activity.activity_id Synced:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void)deleteActivityFail: (NSNotification*)note
{
    [self.dataManager deleteActivityAndRelatedSchedules:_editing_activity.activity_id Synced:NO];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void)registerForNotifications
{
    [super registerForNotifications];
    [self responde:POSTACTIVITYSUCCESSNOTE by:@selector(postActivitySuccess:)];
    [self responde:POSTACTIVITYFAILNOTE by:@selector(postActivityFail:)];
    [self responde:PUTACTIVITYSUCCESSNOTE by:@selector(updateActivitySuccess:)];
    
    [self responde:DELETEACTIVITYSUCCESSNOTE by:@selector(deleteActivitySuccess:)];
    [self responde:DELETEACTIVITYFAILNOTE by:@selector(deleteActivityFail:)];
}

- (void) initAppearance
{
    [super initAppearance];
    /*the picker container view is hidden*/
}

- (void) initProperties
{
    [super initProperties];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) share
{
    [self headto:SHAREMEMBERVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:@(_editing_activity.activity_id),ACTIVITY,@(EDIT),@"script", nil]];
}

-(IBAction) EditActivityDone:(id)sender
{
    _editing_activity.activity_name = _name_tf.text;
    _editing_activity.activity_description = _desp_tv.text;
    
    if (_editing_activity.activity_name == nil || _editing_activity.activity_name.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:ACTIVITY_NAME_EMPTY_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
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
-(IBAction) touchOnDeleteActivity:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Warning" message:ACTIVITY_DELETE_MESSAGE delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil] show];
}
-(IBAction) touchOnAddParticipantButton:(id)sender
{
    [self share];
}
#pragma mark -
#pragma makr UITextField Datasource methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    _editing_activity.activity_name = textField.text;
    return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
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
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Notes"]) {
        textView.text = @"";
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[self.syncEngine deleteActivity:_editing_activity.activity_id] start];
    }
}
@end
