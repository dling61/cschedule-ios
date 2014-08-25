//
//  AppDelegate.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/15/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UIWindow *window;
STRONG SyncEngine* syncEngine;
STRONG DataManager* dataManager;

NOPOINTER BOOL isOpenAlertUpdate;

STRONG NSMutableArray* registeredNotes;
@end
