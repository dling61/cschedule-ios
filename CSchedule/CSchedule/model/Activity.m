//
//  Activity.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/27/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "Activity.h"

@implementation Activity

@synthesize activity_id = _activity_id;
@synthesize activity_name = _activity_name;
@synthesize activity_description = _activity_description;
@synthesize shared_role = _shared_role;
@synthesize owner_id = _owner_id;
@synthesize startdatetime = _startdatetime;
@synthesize enddatetime = _enddatetime;

- (id) initWithId:(int)a_id name:(NSString*)a_name desp:(NSString*)desp role:(int)a_role owner: (int)owne_id start:(NSDate*) a_start end:(NSDate*) a_end
{
    if (self = [super init]) {
        _activity_id = a_id;
        _activity_name = a_name;
        _activity_description = desp;
        _shared_role = a_role;
        _owner_id = owne_id;
        _startdatetime = a_start;
        _enddatetime = a_end;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.activity_id = [decoder decodeIntForKey:@"id"];
    self.activity_name = [decoder decodeObjectForKey:@"name"];
    self.activity_description = [decoder decodeObjectForKey:@"desp"];
    self.shared_role = [decoder decodeIntForKey:@"role"];
    self.owner_id = [decoder decodeIntForKey:@"ownerid"];
    self.startdatetime = [decoder decodeObjectForKey:@"start"];
    self.enddatetime = [decoder decodeObjectForKey:@"end"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.activity_id forKey:@"id"];
    [encoder encodeObject:self.activity_name forKey:@"name"];
    [encoder encodeObject:self.activity_description forKey:@"desp"];
    [encoder encodeInt:self.shared_role forKey:@"role"];
    [encoder encodeInt:self.owner_id forKey:@"ownerid"];
    [encoder encodeObject:self.startdatetime forKey:@"start"];
    [encoder encodeObject:self.enddatetime forKey:@"end"];
}

@end
