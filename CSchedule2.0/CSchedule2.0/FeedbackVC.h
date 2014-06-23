//
//  FeedbackVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/21/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "MyVC.h"

@interface FeedbackVC : MyVC

WEAK IBOutlet UITextField* desc_TF;
WEAK IBOutlet UITextView* desc_TV;

-(IBAction) uploadFB:(id)sender;

@end
