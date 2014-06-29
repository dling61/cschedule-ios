//
//  ActivityVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/25/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "ActivityVC.h"
#import "ActivityCell.h"

@interface ActivityVC ()

@end

@implementation ActivityVC
{
    Activity* selected_activity;
    BOOL IsFirstTime;
}
@synthesize activities_ontable = _activities_ontable;
@synthesize table = _table;
@synthesize popview = _popview;
@synthesize tapRecognizer = _tapRecognizer;

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
    self.title = ACTIVITYVC;
    if ([self.dataManager IsFirsttimeOpen]) {
        [self refreshTable];
    }
    else
    {
        self.acitiveIndicator.hidden = NO;
        [self.acitiveIndicator show: YES];
        [[self.syncEngine getActivities] start];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self restoreState];
}

- (void)getActivitiesSuccess: (NSNotification*) note
{
    [self.dataManager processActivityInfo:[note userInfo]];
    _activities_ontable = [self.dataManager allSortedActivities];
//    [_table reloadData];
    NSMutableArray* ops = [[NSMutableArray alloc] init];
    for (Activity* activity in _activities_ontable) {
        [ops addObject:[self.syncEngine getSharedMembersForActivity:activity.activity_id]];
    }
    [self.syncEngine handleMutilpleRequests:ops withCompletionNotification:GETALLSHAREDMEMBERSNOTE];
}

- (void) refreshTable
{
    _activities_ontable = [self.dataManager allSortedActivities];
    [_table reloadData];
//    [self.acitiveIndicator show:NO];
}

- (void)addActivitySuccess: (NSNotification*) note
{
    [self refreshTable];
}

- (void)updateActivitySuccess: (NSNotification*) note
{
    [self refreshTable];
}

- (void)getSharedMembersDone: (NSNotification*) note
{
    [self.dataManager processSharedmemberInfo:[note userInfo]];
}


- (void)getAllsharedMembersDone: (NSNotification*) note
{
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
    [self refreshTable];
}

- (void)registerForNotifications
{
    [super registerForNotifications];
    [self responde:GETACTIVITYSUCCESSNOTE by:@selector(getActivitiesSuccess:)];
    [self responde:ADDACTIVITYSUCCESSNOTE by:@selector(addActivitySuccess:)];
    [self responde:UPDATEACTIVITYSUCCESSNOTE by:@selector(updateActivitySuccess:)];
    [self responde:GETSHAREDMEMBERSUCCESSNOTE by:@selector(getSharedMembersDone:)];
    [self responde:GETALLSHAREDMEMBERSNOTE by:@selector(getAllsharedMembersDone:)];
    
}

- (void)initAppearance
{
    [super initAppearance];
    self.navigationItem.leftBarButtonItem = nil;
    if (!IS_IPHONE_5) {
        [self.table setFrame:CGRectMake(_table.frame.origin.x, _table.frame.origin.y, 320.0f, 480.0f)];
    }
}

-(void) viewSignleTapped
{
    [self restoreState];
}

-(void) restoreState
{
    [_popview removeFromSuperview];
    [_table setUserInteractionEnabled:YES];
    [self.view removeGestureRecognizer:_tapRecognizer];
}

- (void)initProperties
{
    [super initProperties];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSignleTapped)];
    IsFirstTime = [self.dataManager IsFirsttimeOpen];
}

- (IBAction) addActivity:(id)sender
{
    Activity* newActivity = [[Activity alloc] initWithId:[self.dataManager loadNextActivityid] name:@"" desp:@"" role:0 owner:[self.dataManager currentUserid] start:[NSDate date] end:[NSDate date]];
    [self headto:EDITACTIVITYVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:newActivity, ACTIVITY, @(ADD),@"script",nil]];
}

-(void) PositionPopView: (PopView*) popview in: (UIView*) view byframeY: (CGFloat) Y
{
    CGFloat XinView;
    CGFloat YinView;
    if (Y + popview.bounds.size.height > view.bounds.size.height)
        YinView = Y - popview.bounds.size.height;
    else
        YinView = Y;
    XinView = view.bounds.size.width - popview.bounds.size.width - 20.0f;
    popview.frame = CGRectMake(XinView, YinView, popview.bounds.size.width, popview.bounds.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Tableview Datasource Delegate

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _activities_ontable.count;
}
    
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell* cell = (ActivityCell*)[tableView dequeueReusableCellWithIdentifier:ACTIVITYCELL];
    UIView* desp_lbl = [cell.contentView viewWithTag:ACTIVITY_DESP_LBL];
    if (desp_lbl) {
        [desp_lbl removeFromSuperview];
    }
    Activity* activity = [_activities_ontable objectAtIndex:indexPath.row];
    cell.activity_name_lbl.text = activity.activity_name;
    NSString* text = activity.activity_description;
    if (text == nil || text.length == 0) {
        text = @"No description";
    }
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(300.0, 70.0)
                                                        lineBreakMode:NSLineBreakByTruncatingTail];
    UILabel* new_desp_lbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 30.0, labelSize.width, labelSize.height)];
    new_desp_lbl.font = font;
    new_desp_lbl.textColor = [UIColor grayColor];
    new_desp_lbl.text = text;//activity.activity_description;
    new_desp_lbl.tag = ACTIVITY_DESP_LBL;
    new_desp_lbl.numberOfLines = 5;
    [cell.contentView addSubview:new_desp_lbl];
//    }
    return cell;
}

#pragma mark -
#pragma mark Tableview Delegate Method

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Activity* activity = [_activities_ontable objectAtIndex:indexPath.row];
    int height = 35.0f;
    NSString* text = activity.activity_description;
    if (text == nil || text.length == 0) {
        text = @"No description";
    }
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    CGSize labelSize = [text.description sizeWithFont:font
                                    constrainedToSize:CGSizeMake(300.0, 70.0)
                                        lineBreakMode:NSLineBreakByTruncatingTail];
    height += labelSize.height;
    return height;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Activity* activity = [_activities_ontable objectAtIndex:indexPath.row];
    if (activity.shared_role <= PARTICIPANT) {
        selected_activity = activity;
        [self edit];
    }
    
    /*
    if (activity.shared_role <= PARTICIPANT) {
        selected_activity = activity;
        UIActionSheet* sheet = nil;
        if (activity.shared_role == OWNER) {
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Share",@"Mail",@"Delete", nil];
            sheet.destructiveButtonIndex = 3;
        }
        else if (activity.shared_role == ORGANIZER)
        {
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Share",@"Mail", nil];
        }
        else
        {
            sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Mail", nil];
        }
        [sheet showInView:self.view];
    }
     */
}


#pragma mark -
#pragma mark Popview button Method

-(void) edit
{
    [self headto:EDITACTIVITYVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:selected_activity, ACTIVITY, @(EDIT),@"script",nil]];
}


-(void) share
{
    [self headto:SHAREMEMBERVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:@(selected_activity.activity_id),ACTIVITY,@(EDIT),@"script", nil]];
}

-(void) mail
{
    NSMutableArray* participants = [[NSMutableArray alloc] init];
    NSArray* sharedMembers = [self.dataManager allSortedSharedmembersForActivityid:selected_activity.activity_id];
    for (SharedMember* sm in sharedMembers) {
        [participants addObject:sm.member_email];
    }
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    [[picker navigationBar] setTintColor:[UIColor whiteColor]];
	picker.mailComposeDelegate = self;
	[picker setSubject:selected_activity.activity_name];
	NSArray *toRecipients = [NSArray arrayWithArray:participants];
	[picker setToRecipients:toRecipients];
    NSString *emailBody = [NSString stringWithFormat:@"%@<br><br><br>Download from<br><a href=\"http://itunes.com/apps/CSchedule\">itunes.com/apps/CSchedule</a><br>to check more",selected_activity.activity_description];
	[picker setMessageBody:emailBody isHTML:YES];
	[self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(void) del
{
//    [self restoreState];
    [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Are you sure you want to delete this activity and related schedules" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Yes", nil] show];
}

#pragma mark -
#pragma mark Delete button Method

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[self.syncEngine deleteActivity:selected_activity.activity_id] start];
    }
//    [self refreshTable];
}

#pragma mark -
#pragma mark MFMailComposer Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
            
			break;
		case MFMailComposeResultSaved:
            
			break;
		case MFMailComposeResultSent:
			
			break;
		case MFMailComposeResultFailed:
			
			break;
		default:
            
			break;
	}
	[self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark Delete button Method

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"button index is: %ld", (long)buttonIndex);
    switch (buttonIndex) {
        case 0:
            if (selected_activity.shared_role == PARTICIPANT) {
                [self mail];
            }
            else
            {
                [self edit];
            }
            break;
        case 1:
            [self share];
            break;
        case 2:
            [self mail];
            break;
        case 3:
            [self del];
            break;
        default:
            break;
    }
}


@end
