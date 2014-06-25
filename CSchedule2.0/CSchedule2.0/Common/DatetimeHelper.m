//
//  DatetimeHelper.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/27/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "DatetimeHelper.h"

DatetimeHelper* sharedDatetimeHelper = nil;

@implementation DatetimeHelper
@synthesize calendar = _calendar;
@synthesize dateformatter = _dateformatter;
@synthesize weekdayStrs = _weekdayStrs;
@synthesize monthStrs = _monthStrs;

+ (DatetimeHelper*) sharedHelper
{
    if (sharedDatetimeHelper == nil) {
        sharedDatetimeHelper = [[DatetimeHelper alloc] init];
    }
    return sharedDatetimeHelper;
}

- (id) init
{
    if (self = [super init]) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _dateformatter = [[NSDateFormatter alloc] init];
        _weekdayStrs = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
        _monthStrs = @[@"Jan.",@"Feb.",@"Mar.",@"Apr.",@"May",@"June", @"July",@"Aug.",@"Sept.",@"Oct.",@"Nov.",@"Dec."];
    }
    return self;
}

- (NSString*) dateToStringStyle1: (NSDate*) date
{
    [_dateformatter setDateFormat:DATESTYLE1];
    return [_dateformatter stringFromDate:date];
}

- (NSDate*) StringStyle1ToDate: (NSString*) date_str
{
    [_dateformatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [_dateformatter setDateFormat:DATESTYLE1];
    return [_dateformatter dateFromString:date_str];
}

- (NSString*) GMTDateToSpecificTimeZoneInStringStyle2: (NSDate*) date andUtcoff:(int)utcoff
{
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:utcoff]];
    NSDateComponents* components = [_calendar components:NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [components weekday];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%@, %@ %d, %d",_weekdayStrs[weekday - 1],_monthStrs[month - 1],day,year];
}

- (NSString*) GMTDateToSpecificTimeZoneInStringStyle3: (NSDate*) date andUtcoff:(int)utcoff
{
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:utcoff]];
    NSDateComponents* components = [_calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    int newhour = hour > 12 ? (hour - 12) : hour;
    NSString* postfix = hour < 12 ? @"am":@"pm";
    if (minute == 0) {
        return [NSString stringWithFormat:@"%d. %@",newhour,postfix];
    }
    else
    {
        return [NSString stringWithFormat:@"%d:%d %@",newhour,minute,postfix];
    }
}

@end
