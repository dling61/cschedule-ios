//
//  OndutyVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/6/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface OndutyVC : MyVC <UITableViewDataSource,UITableViewDelegate>


WEAK IBOutlet UITableView* table;
STRONG NSArray* allcandidates;
STRONG NSMutableArray* selectedMemberids;

- (IBAction) EditParticipantsDone:(id)sender;

@end
