//
//  FeedbackVC.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/21/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "FeedbackVC.h"

@interface FeedbackVC ()

@end

@implementation FeedbackVC

@synthesize desc_TF = _desc_TF;
@synthesize desc_TV = _desc_TV;

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
    _desc_TV.text = @"";
    [_desc_TV becomeFirstResponder];
    self.title = FEEDBACKVC;
}

- (void) postFeedbackSuccess: (NSNotification*) note
{
    [[[UIAlertView alloc] initWithTitle:@"Received" message:@"Thanks for your feedback." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) registerForNotifications
{
    [super registerForNotifications];
    [self responde:POSTFEEDBACKSUCCESSNOTE by:@selector(postFeedbackSuccess:)];
}

- (void) initAppearance
{
    [super initAppearance];
    _desc_TF.frame = CGRectMake(10, 20, 300, 170);
    _desc_TF.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) uploadFB:(id)sender
{
    [[self.syncEngine postFeedback:_desc_TV.text] start];
}

@end
