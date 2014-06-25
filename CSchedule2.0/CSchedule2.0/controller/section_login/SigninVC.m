//
//  SigninVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/19/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "SigninVC.h"
#import "TFCell.h"

@interface SigninVC ()

@end

@implementation SigninVC

@synthesize email_tf = _email_tf;
@synthesize passwd_tf = _passwd_tf;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) signinSuccess:(NSNotification*) note
{
//    NSLog(@"signin success");
    [[NSUserDefaults standardUserDefaults] setValue:_email_tf.text forKey:USEREMAIL];
    [[NSUserDefaults standardUserDefaults] setValue:_passwd_tf.text forKey:USERPASSWORD];
    [self.dataManager processUserInfo:[note userInfo]];
    [self headto:TABPAGES withPackage:nil];
    [self.acitiveIndicator show:NO];
    [self.acitiveIndicator setHidden:YES];

}

- (void) signinFail:(NSNotification*) note
{
    //    NSLog(@"signin success");
    
    [self.acitiveIndicator show:NO];
    [self.acitiveIndicator setHidden:YES];
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Password does not match the email account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    _passwd_tf.text = @"";
}

- (void) registerForNotifications
{
    [super registerForNotifications];
    [self responde:SIGNINSUCCESSNOTE by:@selector(signinSuccess:)];
    [self responde:SIGNINFAILURENOTE by:@selector(signinFail:)];
}

- (IBAction) signin:(id)sender
{
    [self.acitiveIndicator show:YES];
    [self.acitiveIndicator setHidden:NO];
    [[self.syncEngine signinwithEmail:_email_tf.text andPassword:_passwd_tf.text] start];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = SIGNINVC;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFCell* cell = [tableView dequeueReusableCellWithIdentifier:TFCELL];
    switch (indexPath.row) {
        case 0:
            cell.tf.placeholder = @"Email";
            _email_tf = cell.tf;
            if ([self.from isEqualToString:REGISTERVC]) {
                _email_tf.text = [self.package valueForKey:@"useremail"];
            }
            else
            {
                if ([self.dataManager currentUseremail] != nil) {
                    _email_tf.text = [self.dataManager currentUseremail];
                }
//                 _email_tf.text = @"xue5@yahoo.com";
            }
            break;
        case 1:
            cell.tf.placeholder = @"Password";
            _passwd_tf = cell.tf;
            [_passwd_tf setSecureTextEntry:YES];
 //           _passwd_tf.text = @"123";
            if ([[NSUserDefaults standardUserDefaults] valueForKeyPath:USERPASSWORD] != nil) {
                _passwd_tf.text = [[NSUserDefaults standardUserDefaults] valueForKeyPath:USERPASSWORD];
            }
            break;
        default:
            break;
    }
    return cell;
}

@end
