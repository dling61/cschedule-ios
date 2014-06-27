//
//  EditContactVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/4/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "EditContactVC.h"
#import "TFCell.h"

@interface EditContactVC ()

@end

@implementation EditContactVC

@synthesize editing_contact = _editing_contact;
@synthesize table = _table;
@synthesize name_tf = _name_tf;
@synthesize email_tf = _email_tf;
@synthesize mobile_tf = _mobile_tf;
@synthesize script = _script;
@synthesize deleteButton=_deleteButton;

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
    _script = [[self.package valueForKey:@"script"] intValue];
    _editing_contact = [self.package valueForKey:CONTACT];
    
    if (_script == ADD) {
        _deleteButton.hidden=YES;
        self.title =ADDCONTACTVC;
    }
    else{
        self.title = EDITCONTACTVC;
        _deleteButton.hidden=NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self unpack];
}


- (void)addContactSuccess: (NSNotification*) note
{
    [self.dataManager saveContact:_editing_contact synced:YES];
    [self.dataManager saveNextMemberid:_editing_contact.contact_id + 1];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDCONTACTSUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateContactSuccess: (NSNotification*) note
{
    [self.dataManager saveContact:_editing_contact synced:YES];
    [self.dataManager changeSharedmemberByContact:_editing_contact];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATECONTACTSUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addContactFail: (NSNotification*) note
{
    [self.dataManager saveContact:_editing_contact synced:NO];
    [self.dataManager saveNextMemberid:_editing_contact.contact_id + 1];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDCONTACTSUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateContactFail: (NSNotification*) note
{
    [self.dataManager saveContact:_editing_contact synced:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATECONTACTSUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) deleteContactSuccess: (NSNotification*) note
{
    [self.dataManager deleteContact:_editing_contact.contact_id Synced:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATECONTACTSUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) deleteContactFail: (NSNotification*) note
{
    [self.dataManager deleteContact:_editing_contact.contact_id Synced:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATECONTACTSUCCESSNOTE object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) registerForNotifications
{
    [super registerForNotifications];
    [self responde:POSTCONTACTSUCCESSNOTE by:@selector(addContactSuccess:)];
    [self responde:PUTCONTACTSUCCESSNOTE by:@selector(updateContactSuccess:)];
    [self responde:POSTCONTACTFAILNOTE by:@selector(addContactFail:)];
    [self responde:PUTCONTACTFAILNOTE by:@selector(updateContactFail:)];
    
    [self responde:DELETECONTACTSUCCESSNOTE by:@selector(deleteContactSuccess:)];
    [self responde:DELETECONTACTFAILNOTE by:@selector(deleteContactFail:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) EditContactDone:(id)sender
{
    _editing_contact.contact_name = _name_tf.text;
    _editing_contact.contact_email = _email_tf.text;
    _editing_contact.contact_mobile = _mobile_tf.text;
    
    if (_editing_contact.contact_email == nil || _editing_contact.contact_email.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Both an email and user name are required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (_editing_contact.contact_name == nil || _editing_contact.contact_name.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Both an email and user name are required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    if (_script == ADD) {
        [[self.syncEngine postContact:_editing_contact] start];
    }
    else
    {
        [[self.syncEngine updateContact:_editing_contact] start];
    }
}
-(IBAction) touchOnDeleteContact:(id)sender;
{
    [self del];
}


#pragma mark -
#pragma mark UITableView Datasource methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFCell* cell = (TFCell*) [tableView dequeueReusableCellWithIdentifier:TFCELL];
    switch (indexPath.row) {
        case 0:
            cell.tf.placeholder = @"Name";
            cell.tf.text = _editing_contact.contact_name;
            _name_tf = cell.tf;
            break;
        case 1:
            cell.tf.placeholder = @"Email";
            cell.tf.text = _editing_contact.contact_email;
            _email_tf = cell.tf;
            break;
        case 2:
             cell.tf.placeholder = @"Mobile";
            cell.tf.text = _editing_contact.contact_mobile;
            _mobile_tf = cell.tf;
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark UITextField Delegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void) del
{
    if ([self.dataManager IsParticipatedinSchedules:_editing_contact.contact_id]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"This contact is currently participated in some schedules!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:[NSString stringWithFormat:@"Are you sure you want to delete contact %@", _editing_contact.contact_name] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
    }
}

#pragma mark -
#pragma mark Alert view delegate Method

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[self.syncEngine deleteContact:_editing_contact.contact_id] start];
    }
}
@end
