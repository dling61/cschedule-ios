//
//  AppSettingInfo.m
//  CSchedule
//
//  Created by Zoro Vu on 7/1/14.
//  Copyright (c) 2014 郭 晨. All rights reserved.
//

#import "AppSettingInfo.h"

@implementation AppSettingInfo
@synthesize app_id=_app_id;
@synthesize app_version=_app_version;
@synthesize enforce=_enforce;
@synthesize os=_os;
@synthesize osversion=_osversion;
@synthesize msg=_msg;
-(id) initWithAppID: (int) a_id app_version:(NSString*)a_app_version enforce:(int)a_enforce os: (NSString*)a_os osversion:(float)a_osversion message:(NSString*)message
{
    if (self = [super init]) {
        _app_id = a_id;
        _app_version = a_app_version;
        _enforce = a_enforce;
        _os = a_os;
        _osversion = a_osversion;
        _msg= message;
    }
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.app_id = [decoder decodeIntForKey:@"id"];
    self.app_version = [decoder decodeObjectForKey:@"version"];
    self.enforce = [decoder decodeIntForKey:@"enforce"];
    self.os = [decoder decodeObjectForKey:@"os"];
    self.osversion = [decoder decodeFloatForKey:@"osversion"];
    self.msg= [decoder decodeObjectForKey:@"msg"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInt:self.app_id forKey:@"id"];
    [encoder encodeObject:self.app_version forKey:@"version"];
    [encoder encodeInt:self.enforce forKey:@"enforce"];
    [encoder encodeObject:self.os forKey:@"os"];
    [encoder encodeFloat:self.osversion forKey:@"osversion"];
    [encoder encodeObject:self.msg forKey:@"msg"];
}
@end
