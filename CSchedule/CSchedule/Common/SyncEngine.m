//
//  SyncEngine.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/18/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "SyncEngine.h"

static SyncEngine* sharedEngine = nil;

@implementation SyncEngine

@synthesize client = _client;

- (id) init
{
    if (self = [super init]) {
        _client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
        [_client setParameterEncoding:AFJSONParameterEncoding];
    }
    return self;
}

+ (SyncEngine*) sharedEngineInstance
{
    if (sharedEngine == nil)
        sharedEngine = [[SyncEngine alloc] init];
    return sharedEngine;
}

-(NSString*) postfixOfURL
{
    return [[NSString alloc] initWithFormat:@"d=%@&sc=%@&v=%@",DEVICE,SCODE,VERSION];
}

-(NSURLRequest*) requestWithMethod: (NSString*) method andPath:(NSString*)path andParameters:(NSDictionary*)parameters
{
    NSMutableString* newPath = [[NSMutableString alloc] initWithString:path];
    if ([method isEqualToString:@"GET"]) {
        [newPath appendFormat:@"%@%@",@"?",[self postfixOfURL]];
    }
    else if ([method isEqualToString:@"POST"] || [method isEqualToString:@"PUT"])
    {
        if ([newPath rangeOfString:@"?"].location == NSNotFound)
            [newPath appendFormat:@"%@%@",@"?",[self postfixOfURL]];
        else
            [newPath appendFormat:@"%@%@",@"&",[self postfixOfURL]];
    }
    else
    {
        [newPath appendString:[NSString stringWithFormat:@"?ownerid=%d&%@",[[DataManager sharedDataManagerInstance] currentUserid],[self postfixOfURL]]];
    }
    NSMutableURLRequest* request = [_client requestWithMethod:method path:newPath parameters:parameters];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (AFHTTPRequestOperation*) sendInfo: (NSDictionary*) info To:(NSString*) path through:(NSString*) method
        withNotifications:(NSDictionary*)notes
{
    NSLog(@"path %@ parameter is %@",path,info);
    NSURLRequest* request = [self requestWithMethod:method andPath:path andParameters:info];
    return [_client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {

    NSDictionary* response_info = nil;
    if (responseObject) {
        NSData* data = [NSData dataWithBytes:[responseObject bytes] length:[responseObject length]];
#ifdef DEBUG
        NSLog(@"responde is %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
#endif
        NSError* err = nil;
        response_info = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    }
    NSString* response_code_str = [NSString stringWithFormat:@"%d",[[operation response] statusCode]];
#ifdef DEBUG
        NSLog(@"responde code for path %@ is %@",path,response_code_str);
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:[notes valueForKey:response_code_str] object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:response_info,@"response",path,@"path",nil]];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[notes valueForKey:@"fail"] object:nil];
    }];
}

- (AFHTTPRequestOperation*) signinwithEmail: (NSString*) email andPassword: (NSString*) password
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email",password,@"password", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:SIGNINSUCCESSNOTE,@"200",SIGNINFAILURENOTE,@"fail", nil];
    return [self sendInfo:info To:SIGNINPATH through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) registerwithEmail: (NSString*) email andPassword: (NSString*) password andName: (NSString*)name andMobile: (NSString*) mobile
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email",password,@"password",name,@"username",mobile,@"mobile", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:REGISTERSUCCESSNOTE,@"200",REGISTERFAILURENOTE,@"fail", nil];
    return [self sendInfo:info To:REGISTERPATH through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) resetPasswordForAccount: (NSString*) email
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:email,@"email", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:RESETPWSUCCESSNOTE,@"200",RESETPWFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:RESETPWPATH through:@"POST" withNotifications:notes];
}

/*set Token*/
- (AFHTTPRequestOperation*) setToken: (NSString*) tokenString deviceId: (NSString*)deviceId
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:tokenString,@"token",[NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"userid",deviceId,@"udid", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:SETTOKENSUCCESSNOTE,@"200",SETTOKENFAILURENOTE,@"fail", nil];
    return [self sendInfo:info To:SETTOKENPATH through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) getActivities
{
    NSDate* lastupdatetime = [[DataManager sharedDataManagerInstance] lastUpdatetimeActivity];
    NSString* lastupdatetime_str = @"";
    if (lastupdatetime) {
        lastupdatetime_str = [[DatetimeHelper sharedHelper] dateToStringStyle1:lastupdatetime];
    }
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid",lastupdatetime_str,@"lastupdatetime", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:GETACTIVITYSUCCESSNOTE,@"200",GETACTIVITYFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:ACTIVITYPATH through:@"GET" withNotifications:notes];
}

- (AFHTTPRequestOperation*) getContacts
{
    NSDate* lastupdatetime = [[DataManager sharedDataManagerInstance] lastUpdatetimeMember];
    NSString* lastupdatetime_str = @"";
    if (lastupdatetime) {
        lastupdatetime_str = [[DatetimeHelper sharedHelper] dateToStringStyle1:lastupdatetime];
    }
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid",lastupdatetime_str,@"lastupdatetime", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:GETCONTACTSUCCESSNOTE,@"200",GETCONTACTFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:MEMBERPATH through:@"GET" withNotifications:notes];
}


/*get timezone list information*/
- (AFHTTPRequestOperation*) getSetting
{
    NSLog(@"getSetting Request");
    
    NSDate* lastupdatetime = [[DataManager sharedDataManagerInstance] lastUpdatetimeMember];
    NSString* lastupdatetime_str = @"";
    if (lastupdatetime) {
        lastupdatetime_str = [[DatetimeHelper sharedHelper] dateToStringStyle1:lastupdatetime];
    }
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid",lastupdatetime_str,@"lastupdatetime", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:GETSETTINGSUCCESSNOTE,@"200",GETSETTINGFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:SETTINGPATH through:@"GET" withNotifications:notes];
}
- (AFHTTPRequestOperation*) postActivity: (Activity*) activity
{
    NSDictionary* activity_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:activity.activity_id],@"serviceid",
                                   activity.activity_name,@"servicename",
                                   activity.activity_description,@"desp", nil];
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:activity.owner_id],@"ownerid",activity_info,@"services", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:POSTACTIVITYSUCCESSNOTE,@"200",POSTACTIVITYFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:ACTIVITYPATH through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) updateActivity: (Activity*) activity
{
    NSDictionary* activity_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                   activity.activity_name,@"servicename",
                                   activity.activity_description,@"desp", nil];
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:activity.owner_id],@"ownerid",activity_info,@"services", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:PUTACTIVITYSUCCESSNOTE,@"200",PUTACTIVITYFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d",ACTIVITYPATH,activity.activity_id] through:@"PUT" withNotifications:notes]; 
}

- (AFHTTPRequestOperation*) postContact: (Contact*) contact
{
    NSDictionary* contact_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:contact.contact_id],@"memberid",
                                   contact.contact_name,@"membername",
                                   contact.contact_email,@"email",
                                   contact.contact_mobile,@"mobile"
                                   , nil];
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:contact.creator_id],@"ownerid",contact_info,@"members", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:POSTCONTACTSUCCESSNOTE,@"200",POSTCONTACTFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:MEMBERPATH through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) updateContact: (Contact*) contact
{
    NSDictionary* contact_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                  contact.contact_name,@"membername",
                                  contact.contact_email,@"email",
                                  contact.contact_mobile,@"mobile"
                                  , nil];
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:contact.creator_id],@"ownerid",contact_info,@"members", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:PUTCONTACTSUCCESSNOTE,@"200",PUTCONTACTFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d",MEMBERPATH,contact.contact_id] through:@"PUT" withNotifications:notes];
}

- (AFHTTPRequestOperation*) getSharedMembersForActivity: (int) activity_id
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid",
                                        @"",@"lastupdatetime"
                                    , nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:GETSHAREDMEMBERSUCCESSNOTE,@"200",GETSHAREDMEMBERFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d/sharedmembers",ACTIVITYPATH,activity_id] through:@"GET" withNotifications:notes];
}

- (void) handleMutilpleRequests:(NSArray *)ops withCompletionNotification:(NSString*)note
{
    [_client enqueueBatchOfHTTPRequestOperations:ops progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        [[NSNotificationCenter defaultCenter] postNotificationName:note object:nil];
    }];
}

- (AFHTTPRequestOperation*) postSharedMember: (SharedMember*) sharedmember
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt: sharedmember.member_id],@"memberid",
                             [NSNumber numberWithInt: sharedmember.shared_role],@"sharedrole",
                             [NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid"
                                  , nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:POSTSHAREDMEMBERSUCCESSNOTE,@"200",POSTSHAREDMEMBERFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d/sharedmembers",ACTIVITYPATH,sharedmember.activity_id] through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) updateSharedMember: (SharedMember*) sharedmember
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt: sharedmember.shared_role],@"sharedrole",
                          [NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid"
                          , nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:PUTSHAREDMEMBERSUCCESSNOTE,@"200",PUTSHAREDMEMBERFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d/sharedmembers/%d",ACTIVITYPATH,sharedmember.activity_id,sharedmember.member_id] through:@"PUT" withNotifications:notes];
}

- (AFHTTPRequestOperation*) deleteSharedMember: (SharedMember*) sharedmember
{
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:DELETESHAREDMEMBERSUCCESSNOTE,@"200",DELETESHAREDMEMBERFAILNOTE,@"fail", nil];
    return [self sendInfo:nil To:[NSString stringWithFormat:@"%@/%d/sharedmembers/%d",ACTIVITYPATH,sharedmember.activity_id,sharedmember.member_id] through:@"DELETE" withNotifications:notes];
}

- (AFHTTPRequestOperation*) getScheduleForActivity: (int) activity_id
{
    
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid",
                          @"",@"lastupdatetime"
                          , nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:GETSCHEDULESUCCESSNOTE,@"200",GETSCHEDULEFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d/schedules",ACTIVITYPATH,activity_id] through:@"GET" withNotifications:notes];
}

- (void) getAllSchedulesForActivities:(NSArray*) activities
{
    NSMutableArray* ops = [[NSMutableArray alloc] init];
    for (Activity* activity in activities) {
        [ops addObject:[self getScheduleForActivity:activity.activity_id]];
    }
    [self handleMutilpleRequests:ops withCompletionNotification:GETALLSCHEDULESNOTE];
}

- (AFHTTPRequestOperation*) postSchedule: (Schedule*) schedule
{
    NSMutableArray* participantids = [[NSMutableArray alloc] init];
    for (SharedMember* sm in schedule.participants) {
         NSDictionary* participant_dict = [NSDictionary dictionaryWithObjectsAndKeys:@(sm.member_id),@"memberid",@(sm.confirm),@"confirm", nil];
        [participantids addObject:participant_dict];
    }
    NSDictionary* schedule_info = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:schedule.schedule_id],@"scheduleid",
                          schedule.schedule_desp,@"desp",
                          [[DatetimeHelper sharedHelper] dateToStringStyle1:schedule.schedule_start],@"startdatetime",
                          [[DatetimeHelper sharedHelper] dateToStringStyle1:schedule.schedule_end],@"enddatetime",
                          @(schedule.tzid),@"tzid",
                          @(schedule.alert),@"alert",
                          participantids,@"members"
                          , nil];
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:schedule_info,@"schedules",@(schedule.activity_id),@"serviceid",@(schedule.creator_id),@"ownerid", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:POSTSCHEDULESUCCESSNOTE,@"200",POSTSCHEDULEFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:SCHEDULEPATH through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) updateSchedule: (Schedule*) schedule
{
    NSMutableArray* participantids = [[NSMutableArray alloc] init];
    for (SharedMember* sm in schedule.participants) {
        
        NSDictionary* participant_dict = [NSDictionary dictionaryWithObjectsAndKeys:@(sm.member_id),@"memberid",@(sm.confirm),@"confirm", nil];
        [participantids addObject:participant_dict];
        //[participantids addObject:@(sm.member_id)];
    }
    NSDictionary* schedule_info = [NSDictionary dictionaryWithObjectsAndKeys:
                                   schedule.schedule_desp,@"desp",
                                   [[DatetimeHelper sharedHelper] dateToStringStyle1:schedule.schedule_start],@"startdatetime",
                                   [[DatetimeHelper sharedHelper] dateToStringStyle1:schedule.schedule_end],@"enddatetime",
                                   @(schedule.tzid),@"tzid",
                                   @(schedule.alert),@"alert",
                                   participantids,@"members"
                                   , nil];
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:schedule_info,@"schedules",@(schedule.activity_id),@"serviceid",@(schedule.creator_id),@"ownerid", nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:PUTSCHEDULESUCCESSNOTE,@"200",PUTSCHEDULEFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d",SCHEDULEPATH,schedule.schedule_id] through:@"PUT" withNotifications:notes];
}

- (AFHTTPRequestOperation*) deleteSchedule: (int) scheduleid
{
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:DELETESCHEDULESUCCESSNOTE,@"200",DELETESCHEDULEFAILNOTE,@"fail", nil];
    return [self sendInfo:nil To:[NSString stringWithFormat:@"%@/%d",SCHEDULEPATH,scheduleid] through:@"DELETE" withNotifications:notes];
}

- (AFHTTPRequestOperation*) deleteActivity: (int) activityid
{
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:DELETEACTIVITYSUCCESSNOTE,@"200",DELETEACTIVITYFAILNOTE,@"fail", nil];
    return [self sendInfo:nil To:[NSString stringWithFormat:@"%@/%d",ACTIVITYPATH,activityid] through:@"DELETE" withNotifications:notes];
}

- (AFHTTPRequestOperation*) deleteContact: (int) contactid
{
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:DELETECONTACTSUCCESSNOTE,@"200",DELETECONTACTFAILNOTE,@"fail", nil];
    return [self sendInfo:nil To:[NSString stringWithFormat:@"%@/%d",MEMBERPATH,contactid] through:@"DELETE" withNotifications:notes];
}

- (AFHTTPRequestOperation*) postFeedback: (NSString*) feedback
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid", feedback,@"feedback",nil];
    NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:POSTFEEDBACKSUCCESSNOTE,@"200",POSTFEEDBACKFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:FEEDBACKPATH through:@"POST" withNotifications:notes];
}

- (AFHTTPRequestOperation*) confirmSharedMember: (int) memberId  schedule: (int) schedule_id confirmType:(int)valueConfirm;
{
    NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[[DataManager sharedDataManagerInstance] currentUserid]],@"ownerid", @(valueConfirm),@"confirm",nil];
      NSDictionary* notes = [NSDictionary dictionaryWithObjectsAndKeys:CONFIRMSTATUSSUCCESSNOTE,@"200",CONFIRMSTATUSFAILNOTE,@"fail", nil];
    return [self sendInfo:info To:[NSString stringWithFormat:@"%@/%d/onduty/%d",SCHEDULEPATH,schedule_id,memberId] through:@"PUT" withNotifications:notes];
    
    
}
@end
