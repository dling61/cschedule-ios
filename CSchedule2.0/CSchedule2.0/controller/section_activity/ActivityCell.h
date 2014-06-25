//
//  ActivityCell.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/27/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCell : UITableViewCell

WEAK IBOutlet UILabel* activity_name_lbl;
WEAK IBOutlet UILabel* activity_session_lbl;
WEAK IBOutlet UILabel* activity_description_lbl;

@end
