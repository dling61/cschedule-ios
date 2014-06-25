//
//  ResetPasswdVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/13/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "ResetPasswdVC.h"
#import "TFCell.h"

@interface ResetPasswdVC ()

@end

@implementation ResetPasswdVC
{
    UITextField* email_tf;
}

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
    self.title = FORGETPWVC;
}

- (void) resetpasswordSuccess: (NSNotification*) note
{
    [[[UIAlertView alloc] initWithTitle:@"Congratulations" message:@"Password reset successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registerForNotifications
{
    [super registerForNotifications];
    [self responde:RESETPWSUCCESSNOTE by:@selector(resetpasswordSuccess:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) reset:(id)sender
{
    [[self.syncEngine resetPasswordForAccount:email_tf.text] start];
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFCell* cell = [tableView dequeueReusableCellWithIdentifier:TFCELL];
    email_tf = cell.tf;
    email_tf.delegate = self;
    email_tf.placeholder = @"Email";
    
    return cell;
}

#pragma mark -
#pragma mark UITextField Datasource

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
