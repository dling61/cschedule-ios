//
//  DatetimeHelper.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/27/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatetimeHelper : NSObject

STRONG NSCalendar* calendar;
STRONG NSDateFormatter* dateformatter;
STRONG NSArray* weekdayStrs;
STRONG NSArray* monthStrs;

+ (DatetimeHelper*) sharedHelper;

// tranform date to string style xxxx-xx-xx xx:xx:xx
- (NSString*) dateToStringStyle1: (NSDate*) date;

- (NSDate*) StringStyle1ToDate: (NSString*) date_str;


/*convert a GMT time to a specific time zone and presents in format: "Weekday(string), Month(string) Day, Year"*/
- (NSString*) GMTDateToSpecificTimeZoneInStringStyle2: (NSDate*) date andUtcoff:(int)utcoff;

/*convert a GMT time to a specific time zone and presents in format: "HH:mm am/pm"*/
- (NSString*) GMTDateToSpecificTimeZoneInStringStyle3: (NSDate*) date andUtcoff:(int)utcoff;
- (NSString*) GMTDateToSpecificTimeZoneInStringStyle4: (NSDate*) date andUtcoff:(int)utcoff;

@end
