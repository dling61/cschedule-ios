//
//  ContactVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/3/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "ContactVC.h"
#import "ContactCell.h"

@interface ContactVC ()

@end

@implementation ContactVC
{
    Contact* selected_contact;
    BOOL popviewOn;
}

@synthesize contacts_ontable = _contacts_ontable;
@synthesize table = _table;
@synthesize popView = _popView;
@synthesize tapRecognizer = _tapRecognizer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)getContactsSuccess: (NSNotification*) note
{
    [self.dataManager processContactInfo:[note userInfo]];
    [self refreshTable];
    [self.acitiveIndicator show:NO];
    self.acitiveIndicator.hidden = YES;
}

- (void)refreshTable
{
    _contacts_ontable = [self.dataManager allSortedContacts];
    [_table reloadData];
}

- (void) refreshContacts: (NSNotification*) note
{
    [self refreshTable];
}
- (void) registerForNotifications
{
    [super registerForNotifications];
    [self responde:GETCONTACTSUCCESSNOTE by:@selector(getContactsSuccess:)];
    [self responde:ADDCONTACTSUCCESSNOTE by:@selector(refreshContacts:)];
    [self responde:UPDATECONTACTSUCCESSNOTE by:@selector(refreshContacts:)];
    
}

- (void) restoreInitialState
{
    [_popView removeFromSuperview];
    [_table setUserInteractionEnabled:YES];
    [self.view removeGestureRecognizer:_tapRecognizer];
    popviewOn = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = CONTACTVC;
    if ([self.dataManager IsFirsttimeOpen] == NO) {
        [self.acitiveIndicator setHidden:NO];
        [self.acitiveIndicator show:YES];
        [[self.syncEngine getContacts] start];
    }
    else
    {
        [self refreshTable];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    
}

-(IBAction) EditContact:(id)sender
{
    Contact* newContact = [[Contact alloc] initWithId:[self.dataManager loadNextContactid] andName:@"" andEmail:@"" andMobile:@"" andCreatorID:[self.dataManager currentUserid]];
    [self headto:EDITCONTACTVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:newContact,CONTACT,@(ADD),@"script",nil]];
}

-(void) viewSignleTapped
{
    [self restoreInitialState];
}

- (void)initProperties
{
    [super initProperties];
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewSignleTapped)];
    popviewOn = NO;
}

- (void) initAppearance
{
    [super initAppearance];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contacts_ontable.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell* cell = (ContactCell*) [tableView dequeueReusableCellWithIdentifier:CONTACTCELL];
    Contact* contact = [_contacts_ontable objectAtIndex:indexPath.row];
    cell.name_lbl.text = contact.contact_name;
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate methods

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Contact* contact = [_contacts_ontable objectAtIndex:indexPath.row];
    selected_contact = contact;
    [self headto:EDITCONTACTVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:selected_contact, CONTACT, @(EDIT),@"script",nil]];
}
@end
