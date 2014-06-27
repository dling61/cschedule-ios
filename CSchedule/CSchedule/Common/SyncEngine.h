//
//  SyncEngine.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/18/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncEngine : NSObject

@property AFHTTPClient* client;

/*
 *  return the only instance of SyncEngine
 */
+ (SyncEngine*) sharedEngineInstance;

/*
 *  send client information to server throu
 */
- (AFHTTPRequestOperation*) sendInfo: (NSDictionary*) info To:(NSString*) path through:(NSString*) method
        withNotifications:(NSDictionary*)notes;
 
/*consititute a postfix for url*/
-(NSString*) postfixOfURL;

/*make a url request according to the path and method*/
-(NSURLRequest*) requestWithMethod: (NSString*) method andPath:(NSString*)path andParameters:(NSDictionary*)parameters;

/*sign in with name and password*/
- (AFHTTPRequestOperation*) signinwithEmail: (NSString*) email andPassword: (NSString*) password;

/*create an account*/
- (AFHTTPRequestOperation*) registerwithEmail: (NSString*) email andPassword: (NSString*) password andName: (NSString*)name andMobile: (NSString*) mobile;

/*reset password*/
- (AFHTTPRequestOperation*) resetPasswordForAccount: (NSString*) email;

/*get latest updated activity information*/
- (AFHTTPRequestOperation*) getActivities;

/*get latest updated contact information*/
- (AFHTTPRequestOperation*) getContacts;

- (AFHTTPRequestOperation*) postActivity: (Activity*) activity;

- (AFHTTPRequestOperation*) postContact: (Contact*) contact;

- (AFHTTPRequestOperation*) updateActivity: (Activity*) activity;

- (AFHTTPRequestOperation*) updateContact: (Contact*) contact;

- (AFHTTPRequestOperation*) postSharedMember: (SharedMember*) sharedmember;

- (AFHTTPRequestOperation*) updateSharedMember: (SharedMember*) sharedmember;

- (AFHTTPRequestOperation*) deleteSharedMember: (SharedMember*) sharedmember;

- (AFHTTPRequestOperation*) getSharedMembersForActivity: (int) activity_id;

- (AFHTTPRequestOperation*) getScheduleForActivity: (int) activity_id;

- (void) getAllSchedulesForActivities:(NSArray*) activities;

- (AFHTTPRequestOperation*) postSchedule: (Schedule*) schedule;

- (AFHTTPRequestOperation*) updateSchedule: (Schedule*) schedule;

- (void) handleMutilpleRequests:(NSArray *)ops withCompletionNotification:(NSString*)note;

- (AFHTTPRequestOperation*) deleteActivity: (int) activityid;

- (AFHTTPRequestOperation*) deleteContact: (int) contactid;

- (AFHTTPRequestOperation*) deleteSchedule: (int) scheduleid;

- (AFHTTPRequestOperation*) postFeedback: (NSString*) feedback;

@end
