//
//  DataManager.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/20/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "DataManager.h"

DataManager* sharedDataManager = nil;

@implementation DataManager
+ (DataManager*) sharedDataManagerInstance
{
    if (sharedDataManager == nil) {
        sharedDataManager = [[DataManager alloc] init];
    }
    return sharedDataManager;
}

- (int) currentUserid
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:USERID];
}

- (NSString*) currentUsername
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USERNAME];
}

- (NSString*) currentUseremail
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL];
}
- (NSArray*) allAppSetting
{
    NSDictionary* appVersion_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLAPPSETTING];
    NSMutableArray* appVersion_arr = [[NSMutableArray alloc] init];
    NSArray* allAppVersions = [appVersion_dict allValues];
    
    for (NSDictionary* appDict_dict in allAppVersions) {
        AppSettingInfo* appVersion = [NSKeyedUnarchiver unarchiveObjectWithData:[appDict_dict valueForKey:APPVERSION]];
        [appVersion_arr addObject:appVersion];
    }
    
    return appVersion_arr;
}

- (NSArray*) allSettingTimeZones
{
    NSDictionary* timezones_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLTIMEZONES];
    NSMutableArray* timezones_arr = [[NSMutableArray alloc] init];
    NSArray* allTimezones = [timezones_dict allValues];
    
    for (NSDictionary* timezone_dict in allTimezones) {
        TimeZone* timzone = [NSKeyedUnarchiver unarchiveObjectWithData:[timezone_dict valueForKey:TIMEZONES]];
            [timezones_arr addObject:timzone];
    }
    
    [timezones_arr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TimeZone* sm1 = (TimeZone*)obj1;
        TimeZone* sm2 = (TimeZone*)obj2;
        if (sm1.timezone_order > sm2.timezone_order)
            return NSOrderedDescending;
        else if (sm1.timezone_order < sm2.timezone_order)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    return timezones_arr;
}
- (NSArray*) allSettingAlerts
{
    NSDictionary* alerts_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLALERTS];
    NSMutableArray* alerts_arr = [[NSMutableArray alloc] init];
    NSArray* allkeys = [[alerts_dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue])
            return NSOrderedDescending;
        else if ([obj1 intValue] < [obj2 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    for (NSString* key in allkeys)
    {
        NSDictionary* alert_dict = [alerts_dict objectForKey:key];
        AlertInfo* alert = [NSKeyedUnarchiver unarchiveObjectWithData:[alert_dict valueForKey:ALERTS]];
        [alerts_arr addObject:alert];
    }
    return alerts_arr;

}

- (NSArray*) allSortedActivities
{
    NSDictionary* activities_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLACTIVITIES];
    NSMutableArray* activities_arr = [[NSMutableArray alloc] init];
    NSArray* allkeys = [[activities_dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue])
            return NSOrderedDescending;
        else if ([obj1 intValue] < [obj2 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    for (NSString* key in allkeys)
    {
        NSDictionary* activity_dict = [activities_dict objectForKey:key];
        if ([[activity_dict valueForKey:DELETED] isEqualToString:@"0"]) {
            Activity* activity = [NSKeyedUnarchiver unarchiveObjectWithData:[activity_dict valueForKey:ACTIVITY]];
            [activities_arr addObject:activity];
        }
    }
    return activities_arr;
}

- (NSArray*) myActivities
{
    NSDictionary* activities_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLACTIVITIES];
    NSMutableArray* activities_arr = [[NSMutableArray alloc] init];
    NSArray* allkeys = [[activities_dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] > [obj2 intValue])
            return NSOrderedDescending;
        else if ([obj1 intValue] < [obj2 intValue])
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    for (NSString* key in allkeys)
    {
        NSDictionary* activity_dict = [activities_dict objectForKey:key];
        if ([[activity_dict valueForKey:DELETED] isEqualToString:@"0"]) {
            Activity* activity = [NSKeyedUnarchiver unarchiveObjectWithData:[activity_dict valueForKey:ACTIVITY]];
            if (activity.shared_role == OWNER) {
                [activities_arr addObject:activity];
            }
        }
    }
    return activities_arr;
}

- (NSArray*) allSortedContacts
{
    NSDictionary* contacts_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLCONTACTS];
    NSMutableArray* contacts_arr = [[NSMutableArray alloc] init];
    NSArray* allContacts = [[contacts_dict allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Contact* contact1 = [NSKeyedUnarchiver unarchiveObjectWithData:[obj1 valueForKey:CONTACT]];
        Contact* contact2 = [NSKeyedUnarchiver unarchiveObjectWithData:[obj2 valueForKey:CONTACT]];
        unichar f1 = [contact1.contact_name characterAtIndex:0];
        unichar f2 = [contact2.contact_name characterAtIndex:0];
        if (f1 > f2)
            return NSOrderedDescending;
        else if (f1 < f2)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    for (NSDictionary* c_dict in allContacts) {
        if ([[c_dict valueForKey:DELETED] isEqualToString:@"0"]) {
            Contact* contact = [NSKeyedUnarchiver unarchiveObjectWithData:[c_dict valueForKey:CONTACT]];
            if (![contact.contact_email isEqualToString:[self currentUseremail]]) {
                [contacts_arr addObject:contact];
            }
        }
    }
    return contacts_arr;
}

- (NSArray*) allSortedSharedmembersForActivityid:(int)activityid
{
    NSDictionary* sharedmembersdict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLSHAREDMEMBERS];
    NSArray* allValues = [sharedmembersdict allValues];
    NSMutableArray* membersInActivity = [[NSMutableArray alloc] init];
    for (NSDictionary* sm_dict in allValues) {
        SharedMember* sm = [NSKeyedUnarchiver unarchiveObjectWithData:[sm_dict valueForKey:SHAREDMEMBER]];
        if (sm !=nil && [[sm_dict valueForKey:DELETED] isEqualToString:@"0"] && sm.activity_id == activityid) {
            [membersInActivity addObject:sm];
        }
    }
    [membersInActivity sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        SharedMember* sm1 = (SharedMember*)obj1;
        SharedMember* sm2 = (SharedMember*)obj2;
        if (sm1.shared_role > sm2.shared_role)
            return NSOrderedDescending;
        else if (sm1.shared_role < sm2.shared_role)
            return NSOrderedAscending;
        else
            return NSOrderedSame;
    }];
    return membersInActivity;
}

- (NSArray*) allSortedSchedules
{
    NSDictionary* allschedules = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLSCHEDULES];
    NSArray* raw_schedules = [allschedules allValues];
    NSMutableArray* schedules = [[NSMutableArray alloc] init];
    for (NSDictionary* schedule_dict in raw_schedules) {
        Schedule* schedule = [NSKeyedUnarchiver unarchiveObjectWithData:[schedule_dict valueForKey:SCHEDULE]];
        if (schedule!=nil && [[schedule_dict valueForKey:DELETED] isEqualToString:@"0"]) {
            [schedules addObject:schedule];
        }
    }
    [schedules sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Schedule* schedule1 = (Schedule*) obj1;
        Schedule* schedule2 = (Schedule*) obj2;
        if ([schedule1.schedule_start timeIntervalSinceDate:schedule2.schedule_end] > 0) {
            return NSOrderedDescending;
        }
        else if ([schedule1.schedule_start timeIntervalSinceDate:schedule2.schedule_end] < 0)
        {
            return NSOrderedAscending;
        }
        else{
            return NSOrderedSame;
        }
    }];
    return schedules;
}

- (NSArray*) mySortedSchedules
{
    NSDictionary* allschedules = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLSCHEDULES];
    NSArray* raw_schedules = [allschedules allValues];
    NSMutableArray* schedules = [[NSMutableArray alloc] init];
    for (NSDictionary* schedule_dict in raw_schedules) {
        Schedule* schedule = [NSKeyedUnarchiver unarchiveObjectWithData:[schedule_dict valueForKey:SCHEDULE]];
        if (schedule!=nil && [[schedule_dict valueForKey:DELETED] isEqualToString:@"0"]) {
            for (SharedMember* sm in schedule.participants) {
                if ([sm.member_email isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:USEREMAIL]]) {
                    [schedules addObject:schedule];
                    break;
                }
            }
        }
    }
    [schedules sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        Schedule* schedule1 = (Schedule*) obj1;
        Schedule* schedule2 = (Schedule*) obj2;
        if ([schedule1.schedule_start timeIntervalSinceDate:schedule2.schedule_end] > 0) {
            return NSOrderedDescending;
        }
        else if ([schedule1.schedule_start timeIntervalSinceDate:schedule2.schedule_end] < 0)
        {
            return NSOrderedAscending;
        }
        else{
            return NSOrderedSame;
        }
    }];
    return schedules;
}

- (NSArray*) groupedSchedules: (NSArray*) raw_schedules
{
    NSMutableDictionary* grouped_schedules = [[NSMutableDictionary alloc] init];
    for (Schedule* schedule in raw_schedules) {
        NSString* date_str = [[DatetimeHelper sharedHelper] GMTDateToSpecificTimeZoneInStringStyle2:schedule.schedule_start andUtcoff:schedule.tzid];
        NSArray* group = (NSArray*)[grouped_schedules valueForKey:date_str];
        if (group == nil) {
            NSMutableArray* new_group = [[NSMutableArray alloc] init];
            [new_group addObject:schedule];
            [grouped_schedules setValue:new_group forKey:date_str];
        }
        else
        {
            NSMutableArray* new_group = [[NSMutableArray alloc] initWithArray:group];
            [new_group addObject:schedule];
            [grouped_schedules setValue:new_group forKey:date_str];
        }
    }
    NSArray* allGroups = [grouped_schedules allValues];
    return [allGroups sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSArray* arr1 = (NSArray*) obj1;
        NSArray* arr2 = (NSArray*) obj2;
        Schedule* s1 = [arr1 objectAtIndex:0];
        Schedule* s2 = [arr2 objectAtIndex:0];
        if ([s1.schedule_start timeIntervalSinceDate:s2.schedule_start] > 0) {
            return NSOrderedDescending;
        }
        else if([s1.schedule_start timeIntervalSinceDate:s2.schedule_start] < 0)
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedSame;
        }
    }] ;
}

-(NSDictionary*)allTimezones
{
    NSDictionary* timezones_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLTIMEZONES];
    if (timezones_dict == nil)
        timezones_dict = [[NSDictionary alloc] init];
    return timezones_dict;
}

-(NSDictionary*)allAlerts
{
    NSDictionary* alerts_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLALERTS];
    if (alerts_dict == nil)
        alerts_dict = [[NSDictionary alloc] init];
    return alerts_dict;
}
-(NSDictionary*)allAppSettingDict
{
    NSDictionary* alerts_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLAPPSETTING];
    if (alerts_dict == nil)
        alerts_dict = [[NSDictionary alloc] init];
    return alerts_dict;
}


- (NSDictionary*) allActivities
{
    NSDictionary* activities_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLACTIVITIES];
    if (activities_dict == nil)
        activities_dict = [[NSDictionary alloc] init];
    return activities_dict;
}

- (NSDictionary*) allContacts
{
    NSDictionary* contacts_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLCONTACTS];
    if (contacts_dict == nil)
        contacts_dict = [[NSDictionary alloc] init];
    return contacts_dict;
}

- (NSDictionary*) allSharedMembers
{
    NSDictionary* contacts_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLSHAREDMEMBERS];
    if (contacts_dict == nil)
        contacts_dict = [[NSDictionary alloc] init];
    return contacts_dict;
}

- (NSDictionary*) allSchedules
{
    NSDictionary* schedules_dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALLSCHEDULES];
    if (schedules_dict == nil)
        schedules_dict = [[NSDictionary alloc] init];
    return schedules_dict;
}

- (void) setAppSetting: (NSDictionary*) settingapps
{
    [[NSUserDefaults standardUserDefaults] setValue:settingapps forKey:ALLAPPSETTING];
}
- (void) setAllTimezones: (NSDictionary*) timezones
{
    [[NSUserDefaults standardUserDefaults] setValue:timezones forKey:ALLTIMEZONES];
}
- (void) setAllAlerts: (NSDictionary*) alerts
{
    [[NSUserDefaults standardUserDefaults] setValue:alerts forKey:ALLALERTS];
}

- (void) setAllActivities: (NSDictionary*) activities
{
    [[NSUserDefaults standardUserDefaults] setValue:activities forKey:ALLACTIVITIES];
}

- (void) setAllContacts: (NSDictionary*) contacts
{
    [[NSUserDefaults standardUserDefaults] setValue:contacts forKey:ALLCONTACTS];
}

- (void) setAllSharedmembers: (NSDictionary*) sharedmembers
{
    [[NSUserDefaults standardUserDefaults] setValue:sharedmembers forKey:ALLSHAREDMEMBERS];
}

- (void) setAllSchedules: (NSDictionary*) schedules
{
    [[NSUserDefaults standardUserDefaults] setValue:schedules forKey:ALLSCHEDULES];
}

- (void) saveActivity: (Activity*) activity  synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* local_activities = [self allActivities];
    NSMutableDictionary* new_local_activities = [[NSMutableDictionary alloc] initWithDictionary:local_activities];
    NSDictionary* activity_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:activity], ACTIVITY, sync, SYNCHRONIZED,@"0",DELETED,nil];
    [new_local_activities setValue:activity_dic forKey:[NSString stringWithFormat:@"%d",activity.activity_id]];
    [self setAllActivities:new_local_activities];
}

- (Activity*) getActivityWithID:(int)activityid
{
    NSDictionary* local_activities = [self allActivities];
    NSDictionary* activity_dict = [local_activities valueForKey:[NSString stringWithFormat:@"%d",activityid]];
    if (activity_dict != nil) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[activity_dict valueForKey:ACTIVITY]];
    }
    return nil;
}

- (void) saveContact: (Contact*) contact  synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* local_contacts = [self allContacts];
    NSMutableDictionary* new_local_contacts = [[NSMutableDictionary alloc] initWithDictionary:local_contacts];
    NSDictionary* contact_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:contact], CONTACT, sync, SYNCHRONIZED,@"0",DELETED,nil];
    [new_local_contacts setValue:contact_dic forKey:[NSString stringWithFormat:@"%d",contact.contact_id]];
    [self setAllContacts:new_local_contacts];
}

- (void) saveSchedule: (Schedule*) schedule synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* local_schedules = [self allSchedules];
    NSMutableDictionary* new_local_schedules = [[NSMutableDictionary alloc] initWithDictionary:local_schedules];
    NSDictionary* schedule_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:schedule], SCHEDULE, sync, SYNCHRONIZED,@"0",DELETED,nil];
    [new_local_schedules setValue:schedule_dic forKey:[NSString stringWithFormat:@"%d",schedule.schedule_id]];
    [self setAllSchedules:new_local_schedules];
}

- (void) saveSharedmember: (SharedMember*) sharedmember of:(int) activityid synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* local_sharedmembers = [self allSharedMembers];
    NSMutableDictionary* new_local_sharedmembers = [[NSMutableDictionary alloc] initWithDictionary:local_sharedmembers];
    NSDictionary* sharedmember_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:sharedmember], SHAREDMEMBER, sync, SYNCHRONIZED,@"0",DELETED,nil];
    [new_local_sharedmembers setValue:sharedmember_dic forKey:[NSString stringWithFormat:@"%d %d",sharedmember.member_id,sharedmember.activity_id]];
    [self setAllSharedmembers:new_local_sharedmembers];
}

- (void) changeSharedmemberByContact: (Contact*) contact
{
    NSDictionary* local_sharedmembers = [self allSharedMembers];
    NSMutableDictionary* new_local_sharedmembers = [[NSMutableDictionary alloc] initWithDictionary:local_sharedmembers];
    for (NSDictionary* sm_dict in [new_local_sharedmembers allValues]) {
        SharedMember* sm = [NSKeyedUnarchiver unarchiveObjectWithData:[sm_dict valueForKey:SHAREDMEMBER]];
        if (sm !=nil && [[sm_dict valueForKey:DELETED] isEqualToString:@"0"] && sm.member_id == contact.contact_id) {
            sm.member_mobile = contact.contact_mobile;
            sm.member_email = contact.contact_email;
            sm.member_name = contact.contact_name;
            NSDictionary* sharedmember_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:sm], SHAREDMEMBER, @"1", SYNCHRONIZED,@"0",DELETED,nil];
            [new_local_sharedmembers setValue:sharedmember_dic forKey:[NSString stringWithFormat:@"%d %d",sm.member_id,sm.activity_id]];
        }
    }
    [self setAllSharedmembers:new_local_sharedmembers];
}

- (SharedMember*) getSharedMemberWithID:(int)memberid andActivityID:(int) activityid
{
    NSDictionary* allSharedmembers = [self allSharedMembers];
    NSDictionary* sharedmember_dict = [allSharedmembers valueForKey:[NSString stringWithFormat:@"%d %d",memberid, activityid]];
    if (sharedmember_dict != nil) {
         return [NSKeyedUnarchiver unarchiveObjectWithData:[sharedmember_dict valueForKey:SHAREDMEMBER]];
    }
    return nil;
}

- (void) saveCurrentUserid:(int)userid
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:userid] forKey:USERID];
}

- (void) saveCurrentUsername:(NSString*)username
{
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:USERNAME];
}

- (void) saveNextActivityid:(int)activityid
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:activityid] forKey:NEXTSERVICEID];
}

- (void) saveNextMemberid:(int) memberid
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:memberid] forKey:NEXTMEMBERID];
}

- (void) saveNextScheduleid:(int)scheduleid
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:scheduleid] forKey:NEXTSCHEDULEID];
}

- (int) loadNextActivityid
{
    int nextid = [[NSUserDefaults standardUserDefaults] integerForKey:NEXTSERVICEID];
    if (nextid == 1) {
        nextid = [self currentUserid] * 10000 + 1;
    }
    return nextid;
}

- (int) loadNextContactid
{
    int nextid = [[NSUserDefaults standardUserDefaults] integerForKey:NEXTMEMBERID];
    if (nextid == 1) {
        nextid = [self currentUserid] * 10000 + 1;
    }
    return nextid;
}

- (int) loadNextScheduleid
{
    int nextid = [[NSUserDefaults standardUserDefaults] integerForKey:NEXTSCHEDULEID];
    if (nextid == 1) {
        nextid = [self currentUserid] * 10000 + 1;
    }
    return nextid;
}


- (NSDate*) lastUpdatetimeActivity
{
    NSDate* date = (NSDate*)[[NSUserDefaults standardUserDefaults] valueForKey:LSTACTIVITYUPDATE];
    return date;
}

- (NSDate*) lastUpdatetimeMember
{
    NSDate* date = (NSDate*)[[NSUserDefaults standardUserDefaults] valueForKey:LSTMEMBERUPDATE];
    return date;
}

- (void) setLastUpdatetimeActivity
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:LSTACTIVITYUPDATE];
}

- (void) setLastUpdatetimeMember
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate date] forKey:LSTMEMBERUPDATE];
}

-(void) processSettingInfo:(NSDictionary *)userinfo
{
    NSDictionary* local_timezones = [self allTimezones];
    NSMutableDictionary* local_timezones_new = nil;
    local_timezones_new = [NSMutableDictionary dictionaryWithDictionary:local_timezones];
    NSArray* all_setting_timezones = [[userinfo valueForKey:@"response"] valueForKey:@"timezones"];
    for (NSDictionary* origin_timezones in all_setting_timezones) {
        int a_id = [[origin_timezones valueForKey:@"id"] intValue];
        NSString* a_name = [origin_timezones valueForKey:@"tzname"];
        NSString* display = [origin_timezones valueForKey:@"displayname"];
        int order = [[origin_timezones valueForKey:@"displayorder"] intValue];
        NSString* abbrt = [origin_timezones valueForKey:@"abbrtzname"];
        TimeZone *timezone =[[TimeZone alloc]initWithId:a_id name:a_name displayName:display order:order abbrtz:abbrt];
        NSDictionary* timezone_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:timezone], TIMEZONES, @"1", SYNCHRONIZED,nil];
        [local_timezones_new setValue:timezone_dic forKey:[NSString stringWithFormat:@"%d",timezone.timezone_id]];
    }
    [self setAllTimezones:local_timezones_new];
    
    
    NSDictionary* local_alerts = [self allAlerts];
    NSMutableDictionary* local_alerts_new = nil;
    local_alerts_new = [NSMutableDictionary dictionaryWithDictionary:local_alerts];
    NSArray* all_setting_alerts = [[userinfo valueForKey:@"response"] valueForKey:@"alerts"];
    
    for (NSDictionary* origin_alert in all_setting_alerts) {
        int a_id = [[origin_alert valueForKey:@"id"] intValue];
        NSString* a_name = [origin_alert valueForKey:@"aname"];
        AlertInfo *alertInfo =[[AlertInfo alloc]initWithId:a_id name:a_name];
        NSDictionary* alert_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:alertInfo], ALERTS, @"1", SYNCHRONIZED,nil];
        [local_alerts_new setValue:alert_dic forKey:[NSString stringWithFormat:@"%d",alertInfo.alert_id]];
    }
    [self setAllAlerts:local_alerts_new];
    
    
    NSDictionary* local_appSettings = [self allAppSettingDict];
    NSMutableDictionary* local_appsetting_new = nil;
    local_appsetting_new = [NSMutableDictionary dictionaryWithDictionary:local_appSettings];
    NSArray* all_setting_apps = [[userinfo valueForKey:@"response"] valueForKey:@"appversions"];
    for (NSDictionary* origin_app in all_setting_apps) {
        int a_id = [[origin_app valueForKey:@"id"] intValue];
        NSString* a_version = [origin_app valueForKey:@"appversion"];
        NSString* os = [origin_app valueForKey:@"os"];
        int enforce = [[origin_app valueForKey:@"enforce"] intValue];
        float osversion = [[origin_app valueForKey:@"osversion"] floatValue];
        
        AppSettingInfo *appInfo =[[AppSettingInfo alloc]initWithAppID:a_id app_version:a_version enforce:enforce os:os osversion:osversion];
        NSDictionary* app_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:appInfo], APPVERSION, @"1", SYNCHRONIZED,nil];
        [local_appsetting_new setValue:app_dic forKey:[NSString stringWithFormat:@"%d",appInfo.app_id]];
    }
    [self setAppSetting:local_appsetting_new];
    
    
    
}

- (void) processUserInfo: (NSDictionary*) userinfo
{
    [self saveCurrentUserid:[[[userinfo valueForKey:@"response"] valueForKey:@"ownerid"] intValue]];
    [self saveCurrentUsername:[[userinfo valueForKey:@"response"] valueForKey:@"username"]];
    [self saveNextActivityid:[[[userinfo valueForKey:@"response"] valueForKey:@"serviceid"] intValue] + 1];
    [self saveNextMemberid:[[[userinfo valueForKey:@"response"] valueForKey:@"memberid"] intValue] + 1];
    [self saveNextScheduleid:[[[userinfo valueForKey:@"response"] valueForKey:@"scheduleid"] intValue] + 1];
}

- (void) processActivityInfo:(NSDictionary *)userinfo
{
    NSDictionary* local_activities = [self allActivities];
    NSMutableDictionary* local_activities_new = nil;
    local_activities_new = [NSMutableDictionary dictionaryWithDictionary:local_activities];
    NSArray* latest_activities = [[userinfo valueForKey:@"response"] valueForKey:@"services"];
    for (NSDictionary* origin_activity in latest_activities) {
        int a_id = [[origin_activity valueForKey:@"serviceid"] intValue];
        NSString* a_name = [origin_activity valueForKey:@"servicename"];
        NSString* desp = [origin_activity valueForKey:@"desp"];
        if (desp == nil || [desp isEqualToString:@" "] || desp.length == 0)
            desp = @"";
        int owner_id = [[origin_activity valueForKey:@"creatorid"] intValue];
        NSDate* startdatetime = [[DatetimeHelper sharedHelper] StringStyle1ToDate:[origin_activity valueForKey:@"startdatetime"]];
        NSDate* enddatetime = [[DatetimeHelper sharedHelper] StringStyle1ToDate:[origin_activity valueForKey:@"enddatetime"]];
        int role = [[origin_activity valueForKey:@"sharedrole"] intValue];
        Activity* activity = [[Activity alloc] initWithId:a_id name:a_name desp:desp role:role owner:owner_id start:startdatetime end:enddatetime];
        NSDictionary* activity_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:activity], ACTIVITY, @"1", SYNCHRONIZED,@"0",DELETED,nil];
        [local_activities_new setValue:activity_dic forKey:[NSString stringWithFormat:@"%d",activity.activity_id]];
    }
    [self setAllActivities:local_activities_new];
    NSArray* deletedactivities = [[userinfo valueForKey:@"response"] valueForKey:@"deletedservices"];
    for (NSString* activity_str in deletedactivities) {
        [self deleteActivityAndRelatedSchedules:activity_str.intValue Synced:YES];
    }
    
//    [self setLastUpdatetimeActivity];
    
#ifdef DEBUG
    NSLog(@"process activity info done!");
#endif
}

- (void) processContactInfo:(NSDictionary *)userinfo
{
    NSDictionary* local_contacts = [self allContacts];
    NSMutableDictionary* local_contacts_new = nil;
    local_contacts_new = [NSMutableDictionary dictionaryWithDictionary:local_contacts];
    NSArray* latest_contacts =  [[userinfo valueForKey:@"response"] valueForKey:@"members"];
    for (NSDictionary* origin_contact in latest_contacts) {
        int c_id = [[origin_contact valueForKey:@"memberid"] intValue];
        int c_creator_id = [[origin_contact valueForKey:@"creatorid"] intValue];
        NSString* c_name = [origin_contact valueForKey:@"membername"];
        NSString* c_email = [origin_contact valueForKey:@"memberemail"];
        NSString* c_mobile = [origin_contact valueForKey:@"mobilenumber"];
        Contact* contact = [[Contact alloc] initWithId:c_id andName:c_name andEmail:c_email andMobile:c_mobile andCreatorID:c_creator_id];
        NSDictionary* contact_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:contact], CONTACT, @"1", SYNCHRONIZED,@"0",DELETED,nil];
        [local_contacts_new setValue:contact_dic forKey:[NSString stringWithFormat:@"%d",contact.contact_id]];
    }
    [self setAllContacts:local_contacts_new];
    
    NSArray* deletedcontacts = [[userinfo valueForKey:@"response"] valueForKey:@"deletedmembers"];
    for (NSString* member_str in deletedcontacts) {
        [self deleteContact:member_str.intValue Synced:YES];
    }
#ifdef DEBUG
    NSLog(@"process contact info done!");
#endif
}

- (void) processSharedmemberInfo:(NSDictionary *)userinfo
{
    NSDictionary* local_sharedmembers = [self allSharedMembers];
    NSMutableDictionary* local_sharedmembers_new = nil;
    local_sharedmembers_new = [NSMutableDictionary dictionaryWithDictionary:local_sharedmembers];
    NSArray* latest_sharedmembers =  [[userinfo valueForKey:@"response"] valueForKey:@"sharedmembers"];
    for (NSDictionary* origin_sm in latest_sharedmembers) {
        int sm_id = [[origin_sm valueForKey:@"memberid"] intValue];
        int sm_creator_id = [[origin_sm valueForKey:@"creatorid"] intValue];
        int sm_activity_id = [[origin_sm valueForKey:@"serviceid"] intValue];
        RoleType role = [[origin_sm valueForKey:@"sharedrole"] intValue];
        NSString* sm_name = [origin_sm valueForKey:@"membername"];
        NSString* sm_email = [origin_sm valueForKey:@"memberemail"];
        NSString* sm_mobile = [origin_sm valueForKey:@"mobilenumber"];
        SharedMember* sm = [[SharedMember alloc] initWithMemberid:sm_id andAcitityId:sm_activity_id andRole:role andName:sm_name andEmail:sm_email andMobile:sm_mobile andCreatorid:sm_creator_id];
        NSDictionary* sharedmember_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:sm], SHAREDMEMBER, @"1", SYNCHRONIZED,@"0",DELETED,nil];
        [local_sharedmembers_new setValue:sharedmember_dic forKey:[NSString stringWithFormat:@"%d %d",sm.member_id, sm_activity_id]];
    }
    [self setAllSharedmembers:local_sharedmembers_new];
    
    NSArray* deletedsms = [[userinfo valueForKey:@"response"] valueForKey:@"deletedsmembers"];
    NSString* path = [userinfo valueForKey:@"path"];
    int activity_id = [[[path componentsSeparatedByString:@"/"] lastObject] intValue];
    for (NSString* smember_str in deletedsms) {
        [self deleteSharedmember:smember_str.intValue of:activity_id Synced:YES];
    }
#ifdef DEBUG
    NSLog(@"process shared members info done!");
#endif
}

- (void) processScheduleInfo:(NSDictionary *)userinfo
{
    NSDictionary* local_schedules = [self allSchedules];
    NSMutableDictionary* local_schedules_new = nil;
    local_schedules_new = [NSMutableDictionary dictionaryWithDictionary:local_schedules];
    NSArray* latest_schedules =  [[userinfo valueForKey:@"response"] valueForKey:@"schedules"];
    for (NSDictionary* origin_schedule in latest_schedules) {
        int s_id = [[origin_schedule valueForKey:@"scheduleid"] intValue];
        int s_creator_id = [[origin_schedule valueForKey:@"creatorid"] intValue];
        int s_activity_id = [[origin_schedule valueForKey:@"serviceid"] intValue];
        int utcoff = [[origin_schedule valueForKey:@"tzid"] intValue];
        int alert = [[origin_schedule valueForKey:@"alert"] intValue];
        NSString* desp = [origin_schedule valueForKey:@"desp"];
        NSString* start_str = [origin_schedule valueForKey:@"startdatetime"];
        NSDate* start = [[DatetimeHelper sharedHelper] StringStyle1ToDate:start_str];
        NSString* end_str = [origin_schedule valueForKey:@"enddatetime"];
        NSDate* end = [[DatetimeHelper sharedHelper] StringStyle1ToDate:end_str];
        
        NSArray* participants_arr =  [origin_schedule valueForKey:@"members"];
        NSMutableArray* participants = [[NSMutableArray alloc] init];
        
        for (NSDictionary* participant_dict in participants_arr) {
            NSString* p_id = [participant_dict valueForKey:@"memberid"];
            int confirm = [[participant_dict valueForKey:@"confirm"] intValue];
            NSDictionary* sm_dict = [[self allSharedMembers] valueForKey:[NSString stringWithFormat:@"%@ %d",p_id,s_activity_id]];
            if (sm_dict) {
                SharedMember* sm = [NSKeyedUnarchiver unarchiveObjectWithData:[sm_dict valueForKey:SHAREDMEMBER]];
                sm.confirm= confirm;
                [participants addObject:sm];
            }

        }
        
        
        
        /*
        NSString* participants_str = [origin_schedule valueForKey:@"members"];
        NSArray* participants_id_arr = [participants_str componentsSeparatedByString:@","];
        //NSMutableArray* participants = [[NSMutableArray alloc] init];
        for (NSString* p_id in participants_id_arr) {
            NSDictionary* sm_dict = [[self allSharedMembers] valueForKey:[NSString stringWithFormat:@"%@ %d",p_id,s_activity_id]];
            if (sm_dict) {
                SharedMember* sm = [NSKeyedUnarchiver unarchiveObjectWithData:[sm_dict valueForKey:SHAREDMEMBER]];
                [participants addObject:sm];
            }
        }*/
        Schedule* schedule = [[Schedule alloc] initWithScheduleID:s_id andActivityid:s_activity_id andDescription:desp andStart:start andEnd:end andParticipants:participants andCreatorid:s_creator_id andUtcoff:utcoff alert:alert];
        NSDictionary* schedule_dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSKeyedArchiver archivedDataWithRootObject:schedule], SCHEDULE, @"1", SYNCHRONIZED,@"0",DELETED,nil];
        [local_schedules_new setValue:schedule_dic forKey:[NSString stringWithFormat:@"%d",schedule.schedule_id]];
    }
    [self setAllSchedules:local_schedules_new];
    
    NSArray* deletedscheduels = [[userinfo valueForKey:@"response"] valueForKey:@"deletedschedules"];
    for (NSString* schedule_str in deletedscheduels) {
        [self deleteSchedule:schedule_str.intValue Synced:YES];
    }
    
#ifdef DEBUG
    NSLog(@"process schedules info done!");
#endif
}

- (BOOL) IsParticipatedinSchedules: (int) participantid
{
    NSArray* schedules = [self allSortedSchedules];
    for (Schedule* schedule in schedules) {
        for (SharedMember* sm in schedule.participants) {
            if (sm.member_id == participantid) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark -
#pragma mark delete methods

- (void) deleteActivityAndRelatedSchedules: (int) activityid Synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* allactivities = [self allActivities];
    NSMutableDictionary* newallactivities = [NSMutableDictionary dictionaryWithDictionary:allactivities];
    NSDictionary* activity_dict = [allactivities valueForKey:[NSString stringWithFormat:@"%d",activityid]];
    NSMutableDictionary* activity_new = [NSMutableDictionary dictionaryWithDictionary:activity_dict];
    [activity_new setValue:@"1" forKey:DELETED];
    [activity_new setValue:sync forKey:SYNCHRONIZED];
    [newallactivities setValue:activity_new forKey:[NSString stringWithFormat:@"%d",activityid]];
    [self setAllActivities:newallactivities];
}

- (void) deleteContact: (int) contactid Synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* allcontacts = [self allContacts];
    NSMutableDictionary* newallcontacts = [NSMutableDictionary dictionaryWithDictionary:allcontacts];
    NSDictionary* contact_dict = [allcontacts valueForKey:[NSString stringWithFormat:@"%d",contactid]];
    NSMutableDictionary* contact_new = [NSMutableDictionary dictionaryWithDictionary:contact_dict];
    [contact_new setValue:@"1" forKey:DELETED];
    [contact_new setValue:sync forKey:SYNCHRONIZED];
    [newallcontacts setValue:contact_new forKey:[NSString stringWithFormat:@"%d",contactid]];
    [self setAllContacts:newallcontacts];
}

- (void) deleteSchedule: (int) scheduleid Synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* allschedules = [self allSchedules];
    NSMutableDictionary* newallschedules = [NSMutableDictionary dictionaryWithDictionary:allschedules];
    NSDictionary* schedule_dict = [allschedules valueForKey:[NSString stringWithFormat:@"%d",scheduleid]];
    NSMutableDictionary* schedule_new = [NSMutableDictionary dictionaryWithDictionary:schedule_dict];
    [schedule_new setValue:@"1" forKey:DELETED];
    [schedule_new setValue:sync forKey:SYNCHRONIZED];
    [newallschedules setValue:schedule_new forKey:[NSString stringWithFormat:@"%d",scheduleid]];
    [self setAllSchedules:newallschedules];
}

- (void) deleteSharedmember: (int) memberid of:(int) activityid Synced: (BOOL) synced
{
    NSString* sync = (synced == YES)? @"1":@"0";
    NSDictionary* allsharedmembers = [self allSharedMembers];
    NSMutableDictionary* newallsharedmembers = [NSMutableDictionary dictionaryWithDictionary:allsharedmembers];
    NSDictionary* sharedmember_dict = [allsharedmembers valueForKey:[NSString stringWithFormat:@"%d %d",memberid,activityid]];
    NSMutableDictionary* sharedmember_new = [NSMutableDictionary dictionaryWithDictionary:sharedmember_dict];
    [sharedmember_new setValue:@"1" forKey:DELETED];
    [sharedmember_new setValue:sync forKey:SYNCHRONIZED];
    [newallsharedmembers setValue:sharedmember_new forKey:[NSString stringWithFormat:@"%d %d",memberid,activityid]];
    [self setAllSharedmembers:newallsharedmembers];
}

- (void) evacuateAllData
{
    [self setAllActivities:nil];
    [self setAllContacts:nil];
    [self setAllSchedules:nil];
    [self setAllSharedmembers:nil];
    [self setAllAlerts:nil];
    [self setAllTimezones:nil];
    [self setAppSetting:nil];
    
}

- (BOOL) IsFirsttimeOpen
{
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:FIRSTOPEN] boolValue] == YES) {
        return YES;
    }
    return NO;
}

@end
