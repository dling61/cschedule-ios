//
//  SharedMember.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/5/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "SharedMember.h"

@implementation SharedMember

@synthesize member_id = _member_id;
@synthesize activity_id = _activity_id;
@synthesize member_email = _member_email;
@synthesize member_mobile = _member_mobile;
@synthesize shared_role = _shared_role;
@synthesize member_name = _member_name;
@synthesize creator_id = _creator_id;

- (id) initWithMemberid: (int)memberid andAcitityId:(int) activityid andRole: (RoleType) role andName: (NSString*)name andEmail:(NSString*) email andMobile:(NSString*) mobile andCreatorid: (int)creatorid
{
    if (self = [super init]) {
        _member_id = memberid;
        _activity_id = activityid;
        _shared_role = role;
        _member_name = name;
        _member_email = email;
        _member_mobile = mobile;
        _creator_id = creatorid;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.member_id = [decoder decodeIntForKey:@"memberid"];
    self.member_name = [decoder decodeObjectForKey:@"name"];
    self.member_email = [decoder decodeObjectForKey:@"email"];
    self.member_mobile = [decoder decodeObjectForKey:@"mobile"];
    self.creator_id = [decoder decodeIntForKey:@"creatorid"];
    self.activity_id = [decoder decodeIntForKey:@"activityid"];
    self.shared_role = [decoder decodeIntForKey:@"sharedrole"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.member_id forKey:@"memberid"];
    [encoder encodeObject:self.member_name forKey:@"name"];
    [encoder encodeObject:self.member_email forKey:@"email"];
    [encoder encodeObject:self.member_mobile forKey:@"mobile"];
    [encoder encodeInt:self.creator_id forKey:@"creatorid"];
    [encoder encodeInt:self.shared_role forKey:@"sharedrole"];
    [encoder encodeInt:self.activity_id forKey:@"activityid"];
}


@end
