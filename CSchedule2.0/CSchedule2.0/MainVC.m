//
//  ViewController.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/15/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    [self.dataManager evacuateAllData];
}

- (void) initAppearance
{
    [super initAppearance];
    [self.navigationItem setLeftBarButtonItem:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
