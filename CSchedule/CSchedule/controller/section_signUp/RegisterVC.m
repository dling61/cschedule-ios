//
//  RegisterVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/8/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "RegisterVC.h"
#import "TFCell.h"

@interface RegisterVC ()

@end

@implementation RegisterVC
@synthesize table = _table;
@synthesize email_tf = _email_tf;
@synthesize name_tf = _name_tf;
@synthesize password_tf = _password_tf;
@synthesize mobile_tf = _mobile_tf;

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
    self.title = REGISTERVC;
}

- (void) initAppearance
{
    [super initAppearance];
}

- (void) registerSuccess: (NSNotification*) note
{
    [self headto:SIGNINVC withPackage:[NSDictionary dictionaryWithObjectsAndKeys:_email_tf.text,@"useremail", nil]];
}

- (void) registerForNotifications
{
    [super registerForNotifications];
    [self responde:REGISTERSUCCESSNOTE by:@selector(registerSuccess:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) IsValidEmail: (NSString *)checkString
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:checkString];
}

-(IBAction) create:(id)sender
{
    NSLog(@"_email_tf.text :%@",_email_tf.text);
    if (_email_tf.text == nil || _email_tf.text.length == 0 || ![self IsValidEmail:_email_tf.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Lack information" message:@"You should enter a true email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    if (_name_tf.text == nil || _name_tf.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Lack information" message:@"Name cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    if (_password_tf.text == nil || _password_tf.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Lack information" message:@"Password cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [[self.syncEngine registerwithEmail:_email_tf.text andPassword:_password_tf.text andName:_name_tf.text andMobile:_mobile_tf.text] start];
}

#pragma mark -
#pragma mark UITableView Delegate methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
    {
        return 3;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFCell* cell = [tableView dequeueReusableCellWithIdentifier:TFCELL];
    cell.tf.delegate = self;
    switch (indexPath.section) {
        case 0:
            cell.tf.placeholder = @"Email (*)";
            _email_tf = cell.tf;
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.tf.placeholder = @"Full Name (*)";
                _name_tf = cell.tf;
            }
            else if (indexPath.row == 1)
            {
                cell.tf.placeholder = @"Password (*)";
                _password_tf = cell.tf;
                _password_tf.secureTextEntry = YES;
            }
            else if (indexPath.row == 2)
            {
                cell.tf.placeholder = @"Mobile";
                _mobile_tf = cell.tf;
            }
            break;
            
        default:
            break;
    }
    return  cell;
}

#pragma mark -
#pragma mark UITextField Delegate methods

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
