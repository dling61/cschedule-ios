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
    
    [self.dataManager evacuateAllData];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:FIRSTOPEN];
    

    
    [self.dataManager processUserInfo:[note userInfo]];
    if([self.dataManager currentUserid] >0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:_email_tf.text forKey:USEREMAIL];
        [[NSUserDefaults standardUserDefaults] setValue:_passwd_tf.text forKey:USERPASSWORD];
        
        [self processAddToken];
        
        //[self.acitiveIndicator setLabelText:@"Loading..."];
        //[[self.syncEngine getSetting] start];
    }
    else{
        [self.acitiveIndicator show:NO];
        [self.acitiveIndicator setHidden:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Error" message:LOGIN_FAIL_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        _passwd_tf.text = @"";
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) signinFail:(NSNotification*) note
{
    NSLog(@"signin success %@",note);
    [self.acitiveIndicator show:NO];
    [self.acitiveIndicator setHidden:YES];
    
    [[[UIAlertView alloc] initWithTitle:@"Error" message:LOGIN_FAIL_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    _passwd_tf.text = @"";
}

-(void)processAddToken
{
    NSString *tokenString =[[NSUserDefaults standardUserDefaults] objectForKey:keyDeviceToken];
    if(tokenString.length >0)
    {
        NSString * uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [self.acitiveIndicator setLabelText:@"Adding Token..."];
        [[self.syncEngine setToken:tokenString deviceId:uniqueIdentifier] start];
        
        
    }
    else{
        [self.acitiveIndicator show:NO];
        [self.acitiveIndicator setHidden:YES];
        [self headto:TABPAGES withPackage:nil];
        
    }
}
/*
-(void)getSettingSuccess:(NSNotification*) note
{
    [self.dataManager processSettingInfo:[note userInfo]];
    if([self checkAppVersionAvailable])
    {
        [self processAddToken];
    }
    
    
}
-(void)getSettingFail:(NSNotification*) note
{

    
    [self.acitiveIndicator show:NO];
    [self.acitiveIndicator setHidden:YES];
    [[[UIAlertView alloc] initWithTitle:@"Error" message:GET_SETTING_FAIL_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self.dataManager evacuateAllData];
    
}
 */

#pragma mark Popview button Method

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/cschedule/id596231825?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
    else{
        [self.acitiveIndicator setHidden:NO];
        [self.acitiveIndicator show:YES];
        [self processAddToken];
    }
}
/*
-(BOOL)checkAppVersionAvailable
{
    
    NSArray* allAppSettings = [self.dataManager allAppSetting];
    for(AppSettingInfo *appSetting in allAppSettings)
    {
        //float iOSVersion =[[[UIDevice currentDevice] systemVersion] floatValue];
        if([appSetting.os isEqualToString:DEVICE])
        {
            if([VERSION isEqualToString:appSetting.app_version])//&& iOSVersion==appSetting.osversion
            {
                return YES;
            }
            else{
                [self.acitiveIndicator show:NO];
                [self.acitiveIndicator setHidden:YES];
                if(appSetting.enforce==0)
                {
                    [[[UIAlertView alloc] initWithTitle:@"CSChedule" message:appSetting.msg delegate:self cancelButtonTitle:@"Update" otherButtonTitles:@"Don't Update",nil] show];
                    return NO;
                }
                else{
                    
                    [[[UIAlertView alloc] initWithTitle:@"CSChedule" message:FORCE_APP_UPDATE_MESSAGE delegate:self cancelButtonTitle:@"Update" otherButtonTitles:nil] show];
                }
                return NO;
            }
        }
    }
    return YES;
}
 */

-(void)setTokenSuccess:(NSNotification*) note
{
    NSLog(@"set Token success %@",note);
    [self.acitiveIndicator show:NO];
    [self.acitiveIndicator setHidden:YES];
    [self headto:TABPAGES withPackage:nil];
    
}
-(void)setTokenFail:(NSNotification*) note
{
     NSLog(@"set Token fail %@",note);
    [self.acitiveIndicator show:NO];
    [self.acitiveIndicator setHidden:YES];
    [self headto:TABPAGES withPackage:nil];
    
    //[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Can not set Token for account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    //[self.dataManager evacuateAllData];
}

- (void) registerForNotifications
{
    [super registerForNotifications];
    [self responde:SIGNINSUCCESSNOTE by:@selector(signinSuccess:)];
    [self responde:SIGNINFAILURENOTE by:@selector(signinFail:)];
    
    //[self responde:GETSETTINGSUCCESSNOTE by:@selector(getSettingSuccess:)];
    //[self responde:GETSETTINGFAILNOTE by:@selector(getSettingFail:)];

    [self responde:SETTOKENSUCCESSNOTE by:@selector(setTokenSuccess:)];
    [self responde:SETTOKENFAILURENOTE by:@selector(setTokenFail:)];
    
}



- (IBAction) signin:(id)sender
{
    [self.acitiveIndicator show:YES];
    [self.acitiveIndicator setHidden:NO];
    NSLog(@"_email_tf:%@ _passwd_tf:%@",_email_tf.text, _passwd_tf.text);
    [self.acitiveIndicator setLabelText:@"Login..."];
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
    cell.tf.delegate=self;
    switch (indexPath.row) {
        case 0:
            cell.tf.placeholder = @"Email (*)";
            _email_tf = cell.tf;
            if ([self.from isEqualToString:REGISTERVC]) {
                _email_tf.text = [self.package valueForKey:@"useremail"];
            }
            else
            {
                if ([self.dataManager currentUseremail] != nil) {
                    _email_tf.text = [self.dataManager currentUseremail];
                }
            }
            break;
        case 1:
            cell.tf.placeholder = @"Password (*)";
            _passwd_tf = cell.tf;
            [_passwd_tf setSecureTextEntry:YES];
            if ([[NSUserDefaults standardUserDefaults] valueForKeyPath:USERPASSWORD] != nil) {
                _passwd_tf.text = [[NSUserDefaults standardUserDefaults] valueForKeyPath:USERPASSWORD];
            }
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
@end
