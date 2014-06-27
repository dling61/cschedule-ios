//
//  MyVC.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/15/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyVC : UIViewController

STRONG NSMutableArray* registeredNotes;

//from which VC to get here
STRONG NSString* from;
STRONG NSDictionary* package;
STRONG SyncEngine* syncEngine;
STRONG DataManager* dataManager;
STRONG DatetimeHelper* datetimeHelper;
STRONG MBProgressHUD* acitiveIndicator;

/*
 *  respond to a specific notification by funtion
 */
-(void) responde: (NSString*) note by:(SEL) func;

/*
 *  UI customization
 */
-(void) initAppearance;

/*
 *  initialize own properties
 */
- (void) initProperties;

/*
 *  register for nofificatons to responde to
 */
-(void) registerForNotifications;

/*
 *  make left navigation button as the default back button
 */
-(void) setupBackButton;

/*
 *  back to the previous VC
 */
-(IBAction) goBack;

/*
 *  go to nexy VC with package contains information
 *  for next VC's property or specific actions
 */
-(void) headto: (NSString*) nextVC withPackage: (NSDictionary*) package;

/*unpake the package come from previous VC*/
-(void) unpack;



@end
