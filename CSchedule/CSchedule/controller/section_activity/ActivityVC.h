//
//  ActivityVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/25/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"
#import "PopView.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface ActivityVC : MyVC <UITableViewDataSource, UITableViewDelegate, PopviewButtonsDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate>

// activities showing on the table
STRONG NSArray* activities_ontable;
WEAK IBOutlet UITableView* table;
STRONG PopView*  popview;
STRONG UIGestureRecognizer* tapRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction) addActivity:(id)sender;

@end
