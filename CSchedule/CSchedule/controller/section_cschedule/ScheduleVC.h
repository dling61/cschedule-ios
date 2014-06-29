//
//  ScheduleVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/5/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"
#import "PopView.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

@interface ScheduleVC : MyVC <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PopviewButtonsDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

WEAK IBOutlet UITableView* table;
WEAK IBOutlet UIBarButtonItem* today_barbtn;

-(IBAction) today: (id)sender;
-(IBAction) allme: (id)sender;
-(IBAction) refresh:(id)sender;
-(IBAction) addSchedule:(id)sender;
NOPOINTER   int scheduleButtonSelected;
STRONG NSMutableArray* table_headers;
STRONG NSArray* groupedSchedules_ontable;
STRONG PopView* popview;
STRONG UITapGestureRecognizer* tapRecognizer;

@end