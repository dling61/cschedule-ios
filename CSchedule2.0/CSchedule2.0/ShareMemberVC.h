//
//  ShareMemberVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/3/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface ShareMemberVC : MyVC <UITableViewDataSource, UITableViewDelegate>

WEAK IBOutlet UITableView* table;

STRONG NSMutableArray* sharedmembers_ontable;
STRONG NSArray* contacts;
STRONG NSArray* former_sharedmembers;
STRONG UIView* addContactView;

-(IBAction) ShareDone:(id)sender;
-(IBAction) addNewContact:(id)sender;

@end
