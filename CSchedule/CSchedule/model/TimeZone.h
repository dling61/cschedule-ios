//
//  TimeZone.h
//  CSchedule
//
//  Created by Zoro Vu on 6/29/14.
//  Copyright (c) 2014 郭 晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeZone : NSObject<NSCoding>
NOPOINTER   int timezone_id;
STRONG      NSString* timezone_name;
STRONG      NSString* timezone_displayName;
NOPOINTER   int timezone_order;
STRONG      NSString* timezone_abbrtzname;

- (id) initWithId:(int)a_id name:(NSString*)a_name displayName:(NSString*)display order: (int)a_order abbrtz:(NSString*)a_abbrtzname;
@end
