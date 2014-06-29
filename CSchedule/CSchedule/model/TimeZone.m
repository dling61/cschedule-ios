//
//  TimeZone.m
//  CSchedule
//
//  Created by Zoro Vu on 6/29/14.
//  Copyright (c) 2014 郭 晨. All rights reserved.
//

#import "TimeZone.h"

@implementation TimeZone
@synthesize timezone_abbrtzname=_timezone_abbrtzname;
@synthesize timezone_displayName=_timezone_displayName;
@synthesize timezone_id=_timezone_id;
@synthesize timezone_name=_timezone_name;
@synthesize timezone_order=_timezone_order;
- (id) initWithId:(int)a_id name:(NSString*)a_name displayName:(NSString*)display order: (int)a_order abbrtz:(NSString*)a_abbrtzname
{
    if (self = [super init]) {
        _timezone_abbrtzname = a_abbrtzname;
        _timezone_displayName = display;
        _timezone_id = a_id;
        _timezone_name = a_name;
        _timezone_order = a_order;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.timezone_id = [decoder decodeIntForKey:@"id"];
    self.timezone_name = [decoder decodeObjectForKey:@"name"];
    self.timezone_displayName = [decoder decodeObjectForKey:@"display"];
    self.timezone_abbrtzname = [decoder decodeObjectForKey:@"abbrt"];
    self.timezone_order = [decoder decodeIntForKey:@"order"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.timezone_id forKey:@"id"];
    [encoder encodeObject:self.timezone_name forKey:@"name"];
    [encoder encodeObject:self.timezone_displayName forKey:@"display"];
    [encoder encodeObject:self.timezone_abbrtzname forKey:@"abbrt"];
    [encoder encodeInt:self.timezone_order forKey:@"order"];
}
@end
