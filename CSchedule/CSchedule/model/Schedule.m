//
//  Schedule.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/5/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule

@synthesize schedule_id = _schedule_id;
@synthesize activity_id = _activity_id;
@synthesize schedule_desp = _schedule_desp;
@synthesize schedule_start = _schedule_start;
@synthesize schedule_end = _schedule_end;
@synthesize participants = _participants;
@synthesize creator_id = _creator_id;
@synthesize tzid = _tzid;
@synthesize alert =_alert;

-(id) initWithScheduleID: (int) s_id andActivityid: (int) a_id andDescription: (NSString*) desp andStart: (NSDate*) start andEnd: (NSDate*) end andParticipants:(NSArray*) participants andCreatorid: (int) creatorid andUtcoff: (int) tzid alert:(int) alert
{
    if (self = [super init]) {
        _schedule_id = s_id;
        _activity_id = a_id;
        _schedule_desp = desp;
        _schedule_start = start;
        _schedule_end = end;
        _participants = participants;
        _creator_id = creatorid;
        _tzid = tzid;
        _alert=alert;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.schedule_id = [decoder decodeIntForKey:@"scheduleid"];
    self.schedule_start = [decoder decodeObjectForKey:@"start"];
    self.schedule_end = [decoder decodeObjectForKey:@"end"];
    self.schedule_desp = [decoder decodeObjectForKey:@"desp"];
    self.creator_id = [decoder decodeIntForKey:@"creatorid"];
    self.activity_id = [decoder decodeIntForKey:@"activityid"];
    self.participants = [decoder decodeObjectForKey:@"participants"];
    self.tzid = [decoder decodeIntForKey:@"tzid"];
    self.alert = [decoder decodeIntForKey:@"alert"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.schedule_id forKey:@"scheduleid"];
    [encoder encodeObject:self.schedule_start forKey:@"start"];
    [encoder encodeObject:self.schedule_end forKey:@"end"];
    [encoder encodeObject:self.schedule_desp forKey:@"desp"];
    [encoder encodeInt:self.creator_id forKey:@"creatorid"];
    [encoder encodeInt:self.activity_id forKey:@"activityid"];
    [encoder encodeObject:self.participants forKey:@"participants"];
    [encoder encodeInt:self.tzid forKey:@"tzid"];
    [encoder encodeInt:self.alert forKey:@"alert"];
}

@end
