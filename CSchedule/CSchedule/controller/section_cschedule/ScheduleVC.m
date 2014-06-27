//
//  ScheduleVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/5/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "ScheduleVC.h"
#import "ScheduleCell.h"

@interface ScheduleVC ()

@end

@implementation ScheduleVC
{
    Schedule* selected_schedule;
    SharedMember* selected_sharedmember;
    int segmentIndex;
}
@synthesize table = _table;
@synthesize today_barbtn = _today_barbtn;
@synthesize groupedSchedules_ontable = _groupedSchedules_ontable;
@synthesize table_headers = _table_headers;
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
    self.title = SCHEDULEVC;
    [self.acitiveIndicator show:YES];
    [self.acitiveIndicator setHidden:NO];
    if ([self.dataManager IsFirsttimeOpen]) {
        [[self.syncEngine getActivities] start];
    }
    else
    {
        [self.syncEngine getAllSchedulesForActivities:[self.dataManager allSortedActivities]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSArray* myactivities = [self.dataManager myActivities];
    if (myactivities.count > 0) {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    }
    [self refreshTable];
}

- (void) viewWillDisappear:(BOOL)animated
{
//    [self restoreInitialState];
}

- (void) initAppearance
{
    [super initAppearance];
    self.navigationItem.leftBarButtonItem = nil;
    [_today_barbtn setBackgroundImage:nil forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    if ([self.dataManager IsFirsttimeOpen]) {
        [self.acitiveIndicator setLabelText:@"Initializing Data..."];
    }
}

- (void) restoreInitialState
{
    [_popview removeFromSuperview];
    [_table setUserInteractionEnabled:YES];
    [self.view removeGestureRecognizer:_tapRecognizer];
}

-(void) viewSignleTapped
{
    [self restoreInitialState];
}

- (void) initProperties
{
    [super initProperties];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSignleTapped)];
    segmentIndex = 0;
}

- (void)getActivitiesSuccess: (NSNotification*) note
{
    [self.dataManager processActivityInfo:[note userInfo]];
    NSArray* _activities = [self.dataManager allSortedActivities];
    //    [_table reloadData];
    NSMutableArray* ops = [[NSMutableArray alloc] init];
    for (Activity* activity in _activities) {
        [ops addObject:[self.syncEngine getSharedMembersForActivity:activity.activity_id]];
    }
    [self.syncEngine handleMutilpleRequests:ops withCompletionNotification:GETALLSHAREDMEMBERSNOTE];
}

- (void) getSchedulesDone:(NSNotification*) note
{
    [self.dataManager processScheduleInfo:[note userInfo]];
}

- (void) getAllSchedulesDone:(NSNotification*) note
{
    [self refreshTable];
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
    [self today:nil];
}

- (void)getSharedMembersDone: (NSNotification*) note
{
    [self.dataManager processSharedmemberInfo:[note userInfo]];
}

- (void)getContactsSuccess: (NSNotification*) note
{
    [self.dataManager processContactInfo:[note userInfo]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GETCONTACTSUCCESSNOTE object:nil];
    [self.acitiveIndicator setLabelText:@"Loading..."];
    [self.syncEngine getAllSchedulesForActivities:[self.dataManager allSortedActivities]];
}

- (void)getAllsharedMembersDone: (NSNotification*) note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GETACTIVITYSUCCESSNOTE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GETALLSHAREDMEMBERSNOTE object:nil];
    [[self.syncEngine getContacts] start];
}

- (void) refreshTable
{
    NSArray* schedules = nil;
    if (segmentIndex == 0) {
        schedules = [self.dataManager allSortedSchedules];
    }
    else
    {
        schedules = [self.dataManager mySortedSchedules];
    }
    NSArray* groups = [self.dataManager groupedSchedules:schedules];
    _groupedSchedules_ontable = groups;
    _table_headers = [[NSMutableArray alloc] init];
    for (NSArray* arr in groups) {
        Schedule* s = [arr objectAtIndex:0];
        [_table_headers addObject:[self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle2:s.schedule_start andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]]];
    }
    [_table reloadData];
}

- (void)registerForNotifications
{
    [super registerForNotifications];
    [self responde:GETSCHEDULESUCCESSNOTE by:@selector(getSchedulesDone:)];
    [self responde:GETALLSCHEDULESNOTE by:@selector(getAllSchedulesDone:)];
    [self responde:ADDSCHEDULESUCCESSNOTE by:@selector(getAllSchedulesDone:)];
    [self responde:UPDATESCHEDULESUCCESSNOTE by:@selector(getAllSchedulesDone:)];
        
    [self responde:GETACTIVITYSUCCESSNOTE by:@selector(getActivitiesSuccess:)];
    [self responde:GETSHAREDMEMBERSUCCESSNOTE by:@selector(getSharedMembersDone:)];
    [self responde:GETALLSHAREDMEMBERSNOTE by:@selector(getAllsharedMembersDone:)];
    [self responde:GETCONTACTSUCCESSNOTE by:@selector(getContactsSuccess:)];
}

-(IBAction) today: (id)sender
{
    NSDate* today = [NSDate date];
    int minIndex = 0;
    int min = 9999999;
    int count = 0;
    for (NSArray* schedules in _groupedSchedules_ontable) {
        Schedule* schedule = [schedules objectAtIndex:0];
        NSDate* start = schedule.schedule_start;
        int gap = abs([start timeIntervalSinceDate:today]);
        if (gap < min) {
            min = gap;
            minIndex = count;
        }
        count++;
    
    }
    if(_table_headers.count)
    {
        [_table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:minIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }

}

-(IBAction) allme: (id)sender
{
    UISegmentedControl* seg = (UISegmentedControl*) sender;
    segmentIndex = seg.selectedSegmentIndex;
    [self refreshTable];
}

-(IBAction) refresh:(id)sender
{
    [self.acitiveIndicator show:YES];
    self.acitiveIndicator.hidden = NO;
    [self.syncEngine getAllSchedulesForActivities:[self.dataManager allSortedActivities]];
}

-(IBAction) addSchedule:(id)sender
{
    Schedule* newschedule = [[Schedule alloc] initWithScheduleID:[self.dataManager loadNextScheduleid] andActivityid:-1 andDescription:@"" andStart:[NSDate date] andEnd:[NSDate dateWithTimeInterval:3600 sinceDate:[NSDate date]] andParticipants:[[NSArray alloc] init] andCreatorid:[self.dataManager currentUserid] andUtcoff:0];
    [self headto:EDITSCHEDULEVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:newschedule,SCHEDULE,@(ADD),@"script", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) smClicked: (id)sender
{
    UIButton* btn = (UIButton*) sender;
    int member_id = btn.tag;
    int activity_id = btn.titleLabel.tag;
    SharedMember* sm = [self.dataManager getSharedMemberWithID:member_id andActivityID:activity_id];
    selected_sharedmember = sm;
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call",@"Mail",@"SMS",nil];
    sheet.tag = 10;
    [sheet showInView:self.view];
}

-(NSArray*) createBtnsForSMs :(NSArray*) smembers
{
    NSMutableArray* btns = [[NSMutableArray alloc] init];
    float beginXoffset = 0.0f;
    for (SharedMember* sm in smembers) {
        CGSize size = [sm.member_name sizeWithFont:[UIFont systemFontOfSize:14.0f]];
        UIButton* btn1 = [[UIButton alloc] initWithFrame:CGRectMake(beginXoffset, 0, size.width + 20, size.height + 6)];
        [btn1 setTitle:sm.member_name forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[[UIImage imageNamed:@"participant-btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        btn1.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(smClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn1.tag = sm.member_id;
        btn1.titleLabel.tag = sm.activity_id;
        beginXoffset += btn1.frame.size.width + 5.0f;
        [btns addObject:btn1];
    }
    return btns;
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

#pragma mark -
#pragma mark UITableView Datasource methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _table_headers.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* schedules = [_groupedSchedules_ontable objectAtIndex:section];
    return schedules.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCell* schedulecell = (ScheduleCell*) [tableView dequeueReusableCellWithIdentifier:SCHEDULECELL];
    [[schedulecell viewWithTag:10] removeFromSuperview];
    Schedule* schedule = [[_groupedSchedules_ontable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    Activity* activity = [self.dataManager getActivityWithID:schedule.activity_id];
    UIFont* font = [UIFont boldSystemFontOfSize:17.0f];
    CGSize labelSize = [activity.activity_name sizeWithFont:font
                                                 constrainedToSize:CGSizeMake(150.0, 50.0)
                                                     lineBreakMode:NSLineBreakByTruncatingTail];
    [schedulecell.name_lbl setFrame:CGRectMake(10.0, 5.0, labelSize.width, labelSize.height)];
    schedulecell.name_lbl.text = activity.activity_name;
    schedulecell.time_lbl.text = [NSString stringWithFormat:@"%@ to %@",
                                  [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle3:schedule.schedule_start andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]],
                                  [self.datetimeHelper GMTDateToSpecificTimeZoneInStringStyle3:schedule.schedule_end andUtcoff:[[NSTimeZone defaultTimeZone] secondsFromGMT]]];
    NSArray* smbtns = [self createBtnsForSMs:schedule.participants];
    float totallength = 0.0f;
    for (UIButton* btn in smbtns)
        totallength += btn.frame.size.width;
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 50, 280, 30)];
    scroll.tag = 10;
    scroll.contentSize = CGSizeMake(totallength, 30);
    for (UIButton* btn in smbtns)
        [scroll addSubview:btn];
    [schedulecell.contentView addSubview:scroll];
    return schedulecell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_table_headers objectAtIndex:section];
}

#pragma mark -
#pragma mark UITableView Delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Schedule* schedule = [[_groupedSchedules_ontable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    selected_schedule = schedule;
    Activity* activity = [self.dataManager getActivityWithID:schedule.activity_id];
    if (activity.shared_role == OWNER || activity.shared_role == ORGANIZER ) {
        [self headto:EDITSCHEDULEVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:selected_schedule, SCHEDULE, @(EDIT),@"script",nil]];
    }
    else {
        [self headto:EDITSCHEDULEVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:selected_schedule, SCHEDULE, @(VIEW),@"script",nil]];
    }
    
    /*
     
    //Activity* activity = [self.dataManager getActivityWithID:schedule.activity_id];
    UIActionSheet* sheet = nil;
    if (activity.shared_role == OWNER) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit",@"Delete", nil];
        sheet.destructiveButtonIndex = 1;
        sheet.tag = 20;
    }
    else if (activity.shared_role == ORGANIZER)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", nil];
        sheet.tag = 20;
        
    }
    else
    {
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View", nil];
        sheet.tag = 30;
    }
    [sheet showInView:self.view];
     */
}
#pragma mark -
#pragma mark UIActionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10) {
        switch (buttonIndex) {
            case 0:
            {
                NSString* call = [NSString stringWithFormat:@"tel://%@",selected_sharedmember.member_mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call]];
                break;
            }
            case 1:
            {
                MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
                [[picker navigationBar] setTintColor:[UIColor whiteColor]];
                picker.mailComposeDelegate = self;
                [picker setSubject:@"CSchedule"];
                // Set up recipients
                NSArray *toRecipients = [NSArray arrayWithObject:selected_sharedmember.member_email];
                [picker setToRecipients:toRecipients];
                /*        NSString *emailBody = [NSString stringWithFormat:@"%@<br><br><br>Download from<br><a href=\"http://itunes.com/apps/CSchedule\">itunes.com/apps/CSchedule</a><br>to check more",HighlightedService.desc];
                 [picker setMessageBody:emailBody isHTML:YES];*/
                [self presentViewController:picker animated:YES completion:^{
                    
                }];
                break;
            }
            case 2:
            {
                [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
                [[UINavigationBar appearance] setTitleTextAttributes:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  [UIColor blueColor],
                  NSForegroundColorAttributeName,
                  [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                  NSBaselineOffsetAttributeName,
                  [UIFont fontWithName:@"Arial-Bold" size:0.0],
                  NSFontAttributeName,
                  nil]];
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
                if([MFMessageComposeViewController canSendText])
                {
                    controller.body = @"";
                    controller.recipients = @[selected_sharedmember.member_mobile];
                    controller.messageComposeDelegate = self;
//                    self.view.hidden = YES;
                    [self presentViewController:controller animated:YES completion:^{
                        
                    }];
                }
            }
            default:
                break;
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                if (actionSheet.tag == 20) {
                    [self edit];
                }
                else
                {
                    [self inspect];
                }
                break;
            case 1:
                [self del];
                break;
            default:
                break;
        }
    }
    
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


-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"bkg_navigation_bar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      NSBaselineOffsetAttributeName,
      [UIFont fontWithName:@"Arial-Bold" size:0.0],
      NSFontAttributeName,
      nil]];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end
