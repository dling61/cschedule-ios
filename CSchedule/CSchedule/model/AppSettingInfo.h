//
//  AppSettingInfo.h
//  CSchedule
//
//  Created by Zoro Vu on 7/1/14.
//  Copyright (c) 2014 郭 晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettingInfo : NSObject<NSCoding>
NOPOINTER   int app_id;
STRONG      NSString* app_version;
NOPOINTER   int enforce;
STRONG      NSString* os;
STRONG NSString *msg;
NOPOINTER   float osversion;
-(id) initWithAppID: (int) a_id app_version:(NSString*)a_app_version enforce: (int)a_enforce os: (NSString*)a_os osversion:(float)a_osversion message:(NSString*)message ;
@end
