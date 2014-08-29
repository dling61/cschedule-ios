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
@synthesize weekdayStrs_Sort=_weekdayStrs_Sort;
@synthesize monthStrs_Sort=_monthStrs_Sort;

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
        _weekdayStrs = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
        _monthStrs = @[@"January",@"February",@"March",@"April",@"May",@"June", @"July",@"August",@"September",@"October",@"November",@"Decemcber"];
        
        _weekdayStrs_Sort = @[@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat"];
        _monthStrs_Sort = @[@"Jan.",@"Feb.",@"Mar.",@"Apr.",@"May",@"June", @"July",@"Aug.",@"Sept.",@"Oct.",@"Nov.",@"Dec."];

    }
    return self;
}
- (NSString*) dateToStringWithTimeZoneUTC: (NSDate*) date
{
    [_dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [_dateformatter setDateFormat:DATESTYLE1];
    return [_dateformatter stringFromDate:date];
}
- (NSString*) dateToStringStyle1: (NSDate*) date
{
    [_dateformatter setDateFormat:DATESTYLE1];
    return [_dateformatter stringFromDate:date];
}

- (NSDate*) StringStyle1ToDate: (NSString*) date_str
{
    [_dateformatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    //[_dateformatter setTimeZone:[NSTimeZone systemTimeZone]];
    [_dateformatter setDateFormat:DATESTYLE1];
    return [_dateformatter dateFromString:date_str];
}

- (NSString*) GMTDateToSpecificTimeZoneInStringStyle2: (NSDate*) date andTimeZone:(NSTimeZone*)timeZone
{
    [_calendar setTimeZone:timeZone];
    NSDateComponents* components = [_calendar components:NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [components weekday];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%@, %@ %d, %d",_weekdayStrs_Sort[weekday - 1],_monthStrs_Sort[month - 1],day,year];
}

- (NSString*) GMTDateToSpecificTimeZoneInStringStyle4: (NSDate*) date andTimeZone:(NSTimeZone*)timeZone
{
    [_calendar setTimeZone:timeZone];
    NSDateComponents* components = [_calendar components:NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitWeekday fromDate:date];
    NSInteger weekday = [components weekday];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    return [NSString stringWithFormat:@"%@                          %@ %d, %d",_weekdayStrs[weekday - 1],_monthStrs[month - 1],day,year];
}

- (NSString*) GMTDateToSpecificTimeZoneInStringStyle3: (NSDate*) date andTimeZone:(NSTimeZone*)timeZone
{
    [_calendar setTimeZone:timeZone];
    NSDateComponents* components = [_calendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    int newhour = hour > 12 ? (hour - 12) : hour;
    
    NSString *stringMins =@"";
    if(minute==0)
    {
        stringMins=@"00";
    }
    else if(minute <10)
    {
        stringMins =[NSString stringWithFormat:@"0%ld",(long)minute];
    }
    else{
        stringMins =[NSString stringWithFormat:@"%ld",(long)minute];
    }
    
     NSString *stringHours =@"";
    if(newhour==0)
    {
        stringHours=@"00";
    }
    else if(newhour <10)
    {
        stringHours =[NSString stringWithFormat:@"0%d",newhour];
    }
    else{
        stringHours =[NSString stringWithFormat:@"%d",newhour];
    }

    NSString* postfix = hour < 12 ? @"am":@"pm";
    return [NSString stringWithFormat:@"%@:%@ %@",stringHours,stringMins,postfix];
}

@end
