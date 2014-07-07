//
//  ShareMemberVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/3/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "ShareMemberVC.h"
#import "LblBtnCell.h"

@interface ShareMemberVC ()

@end

@implementation ShareMemberVC
{
    int _activity_id;
    int script;
    NSMutableArray* savedones;
    NSMutableArray* deletedones;
}

@synthesize table = _table;
@synthesize sharedmembers_ontable = _sharedmembers_ontable;
@synthesize former_sharedmembers = _former_sharedmembers;
@synthesize contacts = _contacts;
@synthesize addContactView = _addContactView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = PARTICIPANTVC;
    [self refreshTable];
}

- (void) updateAllSharedmembersSuccess: (NSNotification*) note
{
    for (SharedMember* sm in savedones) {
        [self.dataManager saveSharedmember:sm of:_activity_id synced:YES];
    }
    for (SharedMember* sm in deletedones) {
        [self.dataManager deleteSharedmember:sm.member_id of:_activity_id Synced:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:UPDATEACTIVITYSUCCESSNOTE object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void) addContactSuccess: (NSNotification*) note
{
    _contacts = [self.dataManager allSortedContacts];
    [self refreshTable];
}

- (void) refreshTable
{
    if (script == EDIT) {
        _former_sharedmembers = [self.dataManager allSortedSharedmembersForActivityid:_activity_id];
        [self initSharedmembersOntableWithExitedAndContancts];
    }
    else
    {
        [self initSharedmembersOntableWithContacts];
    }
    [_table reloadData];
}

- (void) registerForNotifications
{
    [super registerForNotifications];
    [self responde:UPDATEALLSHAREDMEMBERSNOTE by:@selector(updateAllSharedmembersSuccess:)];
    [self responde:ADDCONTACTSUCCESSNOTE by:@selector(addContactSuccess:)];
}

- (void) unpack
{
    _activity_id = [[self.package valueForKey:ACTIVITY] intValue];
    script = [[self.package valueForKey:@"script"] intValue];
}

- (void) initSharedmembersOntableWithContacts
{
    [_sharedmembers_ontable removeAllObjects];
    for (Contact* contact in _contacts) {
        SharedMember* new_sm = [[SharedMember alloc] initWithMemberid:contact.contact_id andAcitityId:_activity_id andRole:NOSHARE andName:contact.contact_name andEmail:contact.contact_name andMobile:contact.contact_name andCreatorid:contact.creator_id];
        [_sharedmembers_ontable addObject:new_sm];
    }
}

- (BOOL) existedContainsContact: (Contact*) contact
{
    for (SharedMember* sm in _former_sharedmembers) {
        if (sm.member_id == contact.contact_id) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) existedContainsSharedMember: (SharedMember*) sharedmember
{
    for (SharedMember* sm in _former_sharedmembers) {
        if (sm.member_id == sharedmember.member_id) {
            return YES;
        }
    }
    return NO;
}

- (void) initSharedmembersOntableWithExitedAndContancts;
{
    [_sharedmembers_ontable removeAllObjects];
    [_sharedmembers_ontable addObjectsFromArray:_former_sharedmembers];
    for (Contact* contact in _contacts) {
        if (![self existedContainsContact:contact]) {
            SharedMember* new_sm = [[SharedMember alloc] initWithMemberid:contact.contact_id andAcitityId:_activity_id andRole:NOSHARE andName:contact.contact_name andEmail:contact.contact_name andMobile:contact.contact_name andCreatorid:contact.creator_id];
            [_sharedmembers_ontable addObject:new_sm];
        }
    }
}

- (void) initProperties
{
    [super initProperties];
    [self unpack];
    _sharedmembers_ontable = [[NSMutableArray alloc] init];
    _contacts = [self.dataManager allSortedContacts];
    savedones = [[NSMutableArray alloc] init];
    deletedones = [[NSMutableArray alloc] init];
    _addContactView = [[[NSBundle mainBundle] loadNibNamed:@"addConView" owner:self options:nil] objectAtIndex:0];
    [_addContactView setFrame:CGRectMake(0, self.view.bounds.size.height - TABBARHEIGHT - 40.0, 320.0, 40.0)];
}

-(void)initAppearance
{
    [super initAppearance];
    [self.view addSubview:_addContactView];
}

-(IBAction) ShareDone:(id)sender
{
    NSMutableArray* ops = [[NSMutableArray alloc] init];
    for (SharedMember* sm in _sharedmembers_ontable) {
        if ([self existedContainsSharedMember:sm]) {
            if (sm.shared_role == NOSHARE) {
                [ops addObject:[self.syncEngine deleteSharedMember:sm]];
                [deletedones addObject:sm];
            }
            else
            {
                [ops addObject:[self.syncEngine updateSharedMember:sm]];
                [savedones addObject:sm];
            }
        }
        else
        {
            if (sm.shared_role != NOSHARE) {
                [ops addObject:[self.syncEngine postSharedMember:sm]];
                [savedones addObject:sm];
            }
        }
    }
    [self.syncEngine handleMutilpleRequests:ops withCompletionNotification:UPDATEALLSHAREDMEMBERSNOTE];
}

-(IBAction) addNewContact:(id)sender
{
    Contact* contact = [[Contact alloc] initWithId:[self.dataManager loadNextContactid] andName:@"" andEmail:@"" andMobile:@"" andCreatorID:[self.dataManager currentUserid]];
    [self headto:EDITCONTACTVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:contact,CONTACT,@(ADD),@"script", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UITableView Datasource methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _sharedmembers_ontable.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LblBtnCell* sharedmembercell = (LblBtnCell*) [tableView dequeueReusableCellWithIdentifier:SHAREMEMBERCELL];
    SharedMember* sharedmember = [_sharedmembers_ontable objectAtIndex:indexPath.row];
    sharedmembercell.lbl.text = sharedmember.member_name;
    
    switch (sharedmember.shared_role) {
        case NOSHARE:
            sharedmembercell.btn.hidden=YES;
            sharedmembercell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case PARTICIPANT:
            sharedmembercell.btn.hidden=YES;
            sharedmembercell.accessoryType = UITableViewCellAccessoryCheckmark;
            break;
        case OWNER:
            sharedmembercell.btn.hidden=NO;
            [sharedmembercell.btn setImage:[UIImage imageNamed:@"creator.png"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    if (sharedmember.shared_role == OWNER) {
        [sharedmembercell setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
    }
    return sharedmembercell;
}
#pragma mark -
#pragma mark UITableView Delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LblBtnCell* cell = (LblBtnCell*)[_table cellForRowAtIndexPath:indexPath];
    SharedMember* sm = [_sharedmembers_ontable objectAtIndex:indexPath.row];
    RoleType role = sm.shared_role;
    int newrole = -1;
    if (role == NOSHARE) {
        newrole = PARTICIPANT;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if(role==PARTICIPANT)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        newrole =NOSHARE;
    }
    else if(role==OWNER)
    {
        return;
    }
    sm.shared_role = newrole;
    
}



@end
