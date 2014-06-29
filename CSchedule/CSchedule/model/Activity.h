//
//  Activity.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/27/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Activity : NSObject <NSCoding>

NOPOINTER   int activity_id;
NOPOINTER   RoleType shared_role;
NOPOINTER   int owner_id;
STRONG      NSString* activity_name;
STRONG      NSString* activity_description;
STRONG      NSDate* startdatetime;
STRONG      NSDate* enddatetime;

- (id) initWithId:(int)a_id name:(NSString*)a_name desp:(NSString*)desp role: (int)a_role owner: (int)owne_id start:(NSDate*) a_start end:(NSDate*) a_end;

@end
