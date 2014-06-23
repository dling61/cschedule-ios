//
//  Contact.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/3/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "Contact.h"

@implementation Contact
@synthesize contact_id = _contact_id;
@synthesize contact_name = _contact_name;
@synthesize contact_mobile = _contact_mobile;
@synthesize contact_email = _contact_email;
@synthesize creator_id = _creator_id;

-(id) initWithId:(int) c_id andName:(NSString*) name andEmail:(NSString*) email andMobile:(NSString*) mobile andCreatorID:(int)creator_id
{
    if (self = [super init]) {
        _contact_id = c_id;
        _contact_name = name;
        _contact_email = email;
        _contact_mobile = mobile;
        _creator_id = creator_id;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.contact_id = [decoder decodeIntForKey:@"id"];
    self.contact_name = [decoder decodeObjectForKey:@"name"];
    self.contact_email = [decoder decodeObjectForKey:@"email"];
    self.contact_mobile = [decoder decodeObjectForKey:@"mobile"];
    self.creator_id = [decoder decodeIntForKey:@"creatorid"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.contact_id forKey:@"id"];
    [encoder encodeObject:self.contact_name forKey:@"name"];
    [encoder encodeObject:self.contact_email forKey:@"email"];
    [encoder encodeObject:self.contact_mobile forKey:@"mobile"];
    [encoder encodeInt:self.creator_id forKey:@"creatorid"];
}


@end
