//
//  Schedule.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/5/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject

NOPOINTER int schedule_id;
NOPOINTER int activity_id;
NOPOINTER int creator_id;
NOPOINTER int utcoff;
STRONG NSString* schedule_desp;
STRONG NSDate* schedule_start;
STRONG NSDate* schedule_end;
STRONG NSArray* participants;

-(id) initWithScheduleID: (int) s_id andActivityid: (int) a_id andDescription: (NSString*) desp andStart: (NSDate*) start andEnd: (NSDate*) end andParticipants:(NSArray*) participants andCreatorid: (int) creatorid andUtcoff: (int) utcoff;

@end
