//
//  MyVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/15/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface MyVC ()

@end

@implementation MyVC
@synthesize registeredNotes = _registeredNotes;
@synthesize from = _from;
@synthesize package = _package;
@synthesize syncEngine = _syncEngine;
@synthesize dataManager = _dataManager;
@synthesize datetimeHelper = _datetimeHelper;
@synthesize acitiveIndicator = _acitiveIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) initProperties
{
    _registeredNotes = [[NSMutableArray alloc] init];
    _syncEngine = [SyncEngine sharedEngineInstance];
    _dataManager = [DataManager sharedDataManagerInstance];
    _datetimeHelper = [DatetimeHelper sharedHelper];
}


- (void) initAppearance
{
    [self setupBackButton];
    _acitiveIndicator = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 376)];
    [_acitiveIndicator setLabelText:@"Loading..."];
    [self.view addSubview:_acitiveIndicator];
}

- (void) registerForNotifications
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view
    
/*    AcitiveIndicator = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, 320, 376)];
    [self.view addSubview:AcitiveIndicator];
    AcitiveIndicator.hidden = YES;
    [AcitiveIndicator setLabelText:@"Data Loading..."];*/
//    [self unpack];
    [self initProperties];
    [self initAppearance];
    [self registerForNotifications];
}

-(void) headto: (NSString*) nextVC withPackage: (NSDictionary*) package
{
    [self performSegueWithIdentifier:nextVC sender:package];
}

- (void) setupBackButton
{
    UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    [self.navigationItem setLeftBarButtonItem:back];
    [self.navigationItem setHidesBackButton:YES];
}

-(IBAction) goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) responde:(NSString *)note by:(SEL)func
{
    if ([_registeredNotes containsObject:note])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:note object:nil];
        [_registeredNotes removeObject:note];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:func name:note object:nil];
    [_registeredNotes addObject:note];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController* vc = segue.destinationViewController;
    if ([segue.destinationViewController isKindOfClass:[MyVC class]]) {
        ((MyVC*)vc).from = self.title;
        ((MyVC*)vc).package = (NSDictionary*)sender;
    }
}

@end
