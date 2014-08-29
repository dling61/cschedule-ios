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
#import "ButtonActionCell.h"
#import "LblBtnCell.h"
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
@synthesize saveButton=_saveButton;
@synthesize former_sharedmembers = _former_sharedmembers;
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
    
    if (_script == ADD) {
        self.title =ADDACTIVITYVC;
        self.numberSection= 2;
    }
    else{
        
        self.title = EDITACTIVITYVC;
        _former_sharedmembers = [self.dataManager allSortedSharedmembersForActivityid:_editing_activity.activity_id];
        
        if (_editing_activity.shared_role == OWNER) {
            
            if(_former_sharedmembers.count>0)
            {
                self.numberSection= 5;
            }
            else{
                self.numberSection= 4;
            }
            
        }
        else{
            //can't edit && delete
            if(_former_sharedmembers.count>0)
            {
                self.numberSection= 3;
            }
            else{
                self.numberSection= 2;
            }
            
            self.navigationItem.rightBarButtonItems =nil;
            [_desp_tv setEditable:NO];
            [_name_tf setEnabled:NO];
        }
        [self showDataEditMode];
    }
    [self.table reloadData];

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
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:ADDING_NEW_ACTIVITY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.dataManager saveActivity:_editing_activity synced:YES];
    [self.dataManager saveNextActivityid:_editing_activity.activity_id + 1];
    [self headto:SHAREMEMBERVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:@(_editing_activity.activity_id),ACTIVITY,@(ADD),@"script", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
    
}

- (void)postActivityFail: (NSNotification*) note
{
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
    
    [self.dataManager saveActivity:_editing_activity synced:NO];
    [self.dataManager saveNextActivityid:_editing_activity.activity_id + 1];
    //it's not really success
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void) updateActivitySuccess: (NSNotification*) note
{
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
    
    [self.dataManager saveActivity:_editing_activity synced:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}

- (void)updateActivityFail: (NSNotification*) note
{
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
    
    [self.dataManager saveActivity:_editing_activity synced:NO];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}
- (void)deleteActivitySuccess: (NSNotification*)note
{
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
    [self.dataManager deleteActivityAndRelatedSchedules:_editing_activity.activity_id Synced:YES];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_editing_activity,ACTIVITY, nil]];
}
- (void)deleteActivityFail: (NSNotification*)note
{
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
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
-(NSMutableAttributedString*) customMemberLabelWithMemberName:(NSString*)memberName isOwer:(BOOL)isOwer
{
    //const CGFloat fontSize = 14;
    UIFont *boldFont = [UIFont boldSystemFontOfSize:17];
    UIFont *regularFont = [UIFont systemFontOfSize:14];
    UIColor *foregroundColor = [UIColor darkTextColor];
    
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           boldFont, NSFontAttributeName,
                           foregroundColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              regularFont, NSFontAttributeName, nil];
    const NSRange range = NSMakeRange((memberName.length+1),9);
    
    // Create the attributed string (text + attributes)
    NSString * text=[NSString stringWithFormat:@"%@ (Creator) ",memberName];
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    // Set it in our UILabel and we are done!
    return attributedText;
}

-(IBAction) EditActivityDone:(id)sender
{
    _editing_activity.activity_name = _name_tf.text;
    _editing_activity.activity_description = _desp_tv.text;
    self.acitiveIndicator.hidden = NO;
    [self.acitiveIndicator show: YES];
    if (_editing_activity.activity_name == nil || _editing_activity.activity_name.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:ACTIVITY_NAME_EMPTY_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    if (_script == ADD) {
        
        [self.acitiveIndicator setLabelText:@"Adding..."];
        [[self.syncEngine postActivity:_editing_activity] start];
    }
    else if (_script == EDIT)
    {
         [self.acitiveIndicator setLabelText:@"Updating..."];
        [[self.syncEngine updateActivity:_editing_activity] start];
    }
}

#pragma mark -
#pragma mark UITableView Datasource Methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
   return self.numberSection;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==2)
    {
        if(_former_sharedmembers.count>0)
            return _former_sharedmembers.count;
        else return 1;
    
    }
    else
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
            namecell.tf.delegate=self;
            _name_tf = namecell.tf;
            namecell.tf.text = _editing_activity.activity_name;
            cell = namecell;
            break;
        }
        case 1:
        {
            TVCell* notecell = [tableView dequeueReusableCellWithIdentifier:ACTDESPCELL];
            notecell.txt_area.delegate=self;
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
        case 2:
            
            if(_former_sharedmembers.count>0)
            {
                LblBtnCell* sharedmembercell = (LblBtnCell*) [tableView dequeueReusableCellWithIdentifier:SHAREMEMBERCELL];
                SharedMember* sharedmember = [_former_sharedmembers objectAtIndex:indexPath.row];
                
                if(sharedmember.shared_role==OWNER)
                {
                    
                    [sharedmembercell.lbl setAttributedText:[self customMemberLabelWithMemberName:sharedmember.member_name isOwer:YES]];
                    //sharedmembercell.lbl.text =[NSString stringWithFormat:@"%@ - Creator",sharedmember.member_name]  ;
                }
                else{
                    //[sharedmembercell.lbl setAttributedText:[self customMemberLabelWithMemberName:sharedmember.member_name isOwer:NO]];
                   sharedmembercell.lbl.text = sharedmember.member_name;
                }
                
                cell= sharedmembercell;
            }
            else{
                ButtonActionCell* buttoncell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEBUTTONCELL];
                [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_add_participant.png"]];
                buttoncell.cellType= AddParticiantButtonCell;
                cell = buttoncell;
            }
            break;
        case 3:
        {
            if(_former_sharedmembers.count>0)
            {
                ButtonActionCell* buttoncell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEBUTTONCELL];
                [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_add_participant.png"]];
                buttoncell.cellType= AddParticiantButtonCell;
                cell = buttoncell;
            }
            else{
                ButtonActionCell* buttoncell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEBUTTONCELL];
                [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_delete.png"]];
                buttoncell.cellType= DeleteButtonCell;
                cell = buttoncell;
            }
            
        }
            break;
        case 4:
        {
            ButtonActionCell* buttoncell = [tableView dequeueReusableCellWithIdentifier:SCHEDULEBUTTONCELL];
            [buttoncell.buttonImage setImage:[UIImage imageNamed:@"btn_delete.png"]];
            buttoncell.cellType= DeleteButtonCell;
            cell = buttoncell;
        }
            break;
        default:
            break;
    }
    return cell;
}

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 120.0f;
    }
    if(indexPath.section==2)
    {
        if(_former_sharedmembers.count>0)
            return 44.0f;
        else
            return 50.0f;
    }
    return 50.0f;
}



-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==2)
    {
        if(_former_sharedmembers.count>0)
            return @"Participant";
        else
            return nil;
    }
    else
     return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
            
        case 2:
        {
            if(_former_sharedmembers.count==0)
            {
               [self share];
            }
            
        }
            break;
        case 3:
        {
            if(_former_sharedmembers.count >0)
            {
                [self share];
            }
            else{
                [[[UIAlertView alloc] initWithTitle:@"Warning" message:ACTIVITY_DELETE_MESSAGE delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil] show];
            }
        }
            break;
        case 4:
        {
            [[[UIAlertView alloc] initWithTitle:@"Warning" message:ACTIVITY_DELETE_MESSAGE delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil] show];
        }
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
        self.acitiveIndicator.hidden = NO;
        [self.acitiveIndicator show: YES];
        [self.acitiveIndicator setLabelText:@"Deleting..."];
        [[self.syncEngine deleteActivity:_editing_activity.activity_id] start];
    }
}
@end
