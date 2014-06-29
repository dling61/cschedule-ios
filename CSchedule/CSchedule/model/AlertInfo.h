//
//  AlertInfo.h
//  CSchedule
//
//  Created by Zoro Vu on 6/29/14.
//  Copyright (c) 2014 郭 晨. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertInfo : NSObject<NSCoding>
NOPOINTER   int alert_id;
STRONG      NSString* alert_name;
- (id) initWithId:(int)a_id name:(NSString*)a_name ;
@end
