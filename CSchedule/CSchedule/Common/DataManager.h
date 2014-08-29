//
//  DataManager.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/20/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager*) sharedDataManagerInstance;

- (int) currentUserid;

- (NSString*) currentUsername;

- (NSString*) currentUseremail;

- (void) processUserInfo: (NSDictionary*) userinfo;

- (NSDate*) lastUpdatetimeActivity;

- (NSDate*) lastUpdatetimeMember;



- (NSArray*) allSettingTimeZones;
- (NSArray*) allSettingAlerts;
- (NSArray*) allAppSetting;

// all local activities sorted by keys
- (NSArray*) allSortedActivities;

- (NSArray*) myActivities;

- (Activity*) getActivityWithID:(int)activityid;

// all local contacts sorted by name
- (NSArray*) allSortedContacts;

// all local shared members sorted by role for an activity
- (NSArray*) allSortedSharedmembersForActivityid:(int)activityid;

- (SharedMember*) getSharedMemberWithID:(int)memberid andActivityID:(int) activityid;

// all local schedules sorted by start date
- (NSArray*) allSortedSchedules;
- (NSArray*) mySortedSchedules;

- (NSArray*) groupedSchedules: (NSArray*) raw_schedules;

// get the id of my next activity id
- (int) loadNextActivityid;

// get the id of my next contact id
- (int) loadNextContactid;

// get the id of my next schedule id
- (int) loadNextScheduleid;

// update local activities
- (void) setAllActivities: (NSDictionary*) activities;

// save a new activity
- (void) saveActivity: (Activity*) activity synced: (BOOL) synced;

// save a new contact
- (void) saveContact: (Contact*) contact synced: (BOOL) synced;

// save a new schedule
- (void) saveSchedule: (Schedule*) schedule synced: (BOOL) synced;

// save a shared member
- (void) saveSharedmember: (SharedMember*) sharedmember of:(int) activityid synced: (BOOL) synced;

- (void) changeSharedmemberByContact: (Contact*) contact;

// process original activties info
- (void) processActivityInfo:(NSDictionary *)userinfo;
- (void) processContactInfo:(NSDictionary *)userinfo;
- (void) processSharedmemberInfo:(NSDictionary *)userinfo;
- (void) processScheduleInfo:(NSDictionary *)userinfo;

-(void) processSettingInfo:(NSDictionary *)userinfo;

- (void) saveNextActivityid:(int)activityid;
- (void) saveNextMemberid:(int) memberid;
- (void) saveNextScheduleid:(int) scheduleid;

- (BOOL) IsParticipatedinSchedules: (int) participantid;

- (void) deleteActivityAndRelatedSchedules: (int) activityid Synced: (BOOL) synced;
- (void) deleteContact: (int) contactid Synced: (BOOL) synced;
- (void) deleteSchedule: (int) scheduleid Synced: (BOOL) synced;
- (void) deleteSharedmember: (int) memberid of:(int) activityid Synced: (BOOL) synced;

- (void) evacuateAllData;

- (BOOL) IsFirsttimeOpen;
- (BOOL) haveANewActivity;
@end
