//
//  ContactVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/3/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"
#import "PopView.h"

@interface ContactVC : MyVC <UITableViewDataSource, UITableViewDelegate, PopviewButtonsDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

STRONG NSArray* contacts_ontable;
WEAK IBOutlet UITableView* table;
STRONG PopView* popView;
STRONG UIGestureRecognizer* tapRecognizer;

-(IBAction) EditContact:(id)sender;

@end
