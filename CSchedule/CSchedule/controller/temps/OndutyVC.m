//
//  OndutyVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/6/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "OndutyVC.h"
#import "LblCell.h"

@interface OndutyVC ()

@end

@implementation OndutyVC
{
    int activity_id;
}
@synthesize allcandidates = _allcandidates;
@synthesize selectedMemberids = _selectedMemberids;
@synthesize table = _table;

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
    self.title = ONDUTYVC;
}

- (void) initProperties
{
    [super initProperties];
    [self unpack];
    _allcandidates = [self.dataManager allSortedSharedmembersForActivityid:activity_id];
}

- (void) unpack
{
    activity_id = [[self.package valueForKey:ACTIVITY] intValue];
    _selectedMemberids = [self.package valueForKey:@"members"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) EditParticipantsDone:(id)sender
{
    NSMutableArray* current_participants = [[NSMutableArray alloc] init];
    for (SharedMember* sm in _allcandidates) {
        if ([_selectedMemberids containsObject:@(sm.member_id)]) {
            [current_participants addObject:sm];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:EDITPARTICIPANTSDONE object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:current_participants,@"newmembers", nil]];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITableView Datasource methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allcandidates.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LblCell* cell = (LblCell*) [tableView dequeueReusableCellWithIdentifier:ONDUTYCELL];
    SharedMember* sm = [_allcandidates objectAtIndex:indexPath.row];
    cell.lbl.text = sm.member_name;
    if ([_selectedMemberids containsObject:@(sm.member_id)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LblCell* cell = (LblCell*)[tableView cellForRowAtIndexPath:indexPath];
    SharedMember* sm = [_allcandidates objectAtIndex:indexPath.row];
    if ([_selectedMemberids containsObject:@(sm.member_id)]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectedMemberids removeObject:@(sm.member_id)];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [_selectedMemberids addObject:@(sm.member_id)];
    }
}

@end
