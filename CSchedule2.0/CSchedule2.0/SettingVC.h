//
//  SettingVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/8/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface SettingVC : MyVC <UITableViewDataSource,UITableViewDelegate>

WEAK IBOutlet UITableView* table;

@end
