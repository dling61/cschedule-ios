//
//  SettingVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/8/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "SettingVC.h"
#import "LblCell.h"

@interface SettingVC ()

@end

@implementation SettingVC
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
    self.title = SETTINGVC;
}

- (void) initAppearance
{
    [super initAppearance];
    self.navigationItem.leftBarButtonItem = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [_table reloadData];
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
    return 5;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
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
        default:
            return 1;
            break;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                LblCell* emailcell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"accountcell"];
                emailcell.lbl.text = [self.dataManager currentUseremail];
                cell = emailcell;
            }
            else
            {
                LblCell* namecell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"fullnamecell"];
                namecell.lbl.text = [self.dataManager currentUsername];
                cell = namecell;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                LblCell* activitiescell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"involvedactivitiescell"];
                int num = [[self.dataManager myActivities] count];
                activitiescell.lbl.text = [NSString stringWithFormat:@"%d",num];
                cell = activitiescell;
            }
            else
            {
                LblCell* schedulescell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"assignedschedulescell"];
                int num = [[self.dataManager mySortedSchedules] count];
                schedulescell.lbl.text = [NSString stringWithFormat:@"%d",num];
                cell = schedulescell;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                LblCell* rateuscell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"rateuscell"];
                rateuscell.lbl.text = @"Love CSchedule? Rate us!";
                cell = rateuscell;
            }
/*            else
            {
                LblCell* aboutcell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"aboutcell"];
                aboutcell.lbl.text = @"about";
                cell = aboutcell;
            }*/
            break;
        case 3:
        {
            LblCell* feedbackcell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"feedbackcell"];
            feedbackcell.lbl.text = @"Feedback";
            cell = feedbackcell;
            break;
        }
        case 4:
        {
            LblCell* signoutcell = (LblCell*)[tableView dequeueReusableCellWithIdentifier:@"signoutcell"];
            signoutcell.lbl.text = @"Sign out";
            cell = signoutcell;
            break;
        }
            
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate methods

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
            
        case 2:
        {
            NSURL* url = [NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?type=Purple+Software&id=596231825&mt=8&o=i"];
            [[UIApplication sharedApplication] openURL:url];
        }
        case 3:
        {
            [self headto:FEEDBACKVC withPackage:nil];
            break;
        }
        case 4:
            [self.dataManager evacuateAllData];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:FIRSTOPEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            break;
            
        default:
            break;
    }
    
}

@end
