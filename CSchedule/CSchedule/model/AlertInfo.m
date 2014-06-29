//
//  AlertInfo.m
//  CSchedule
//
//  Created by Zoro Vu on 6/29/14.
//  Copyright (c) 2014 郭 晨. All rights reserved.
//

#import "AlertInfo.h"

@implementation AlertInfo
@synthesize alert_id=_alert_id;
@synthesize alert_name=_alert_name;
- (id) initWithId:(int)a_id name:(NSString*)a_name
{
    if (self = [super init]) {
        _alert_id = a_id;
        _alert_name = a_name;
    }
    return self;
}
#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.alert_id = [decoder decodeIntForKey:@"id"];
    self.alert_name = [decoder decodeObjectForKey:@"name"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.alert_id forKey:@"id"];
    [encoder encodeObject:self.alert_name forKey:@"name"];
}

@end
