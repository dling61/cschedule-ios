//
//  MyTypes.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/1/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#ifndef CSchedule2_0_MyTypes_h
#define CSchedule2_0_MyTypes_h

typedef enum
{
    Norepeat,
    Everyday,
    Everyweek,
    Every2weeks,
    EveryMonth,
    EveryYear
} RepeatType;

typedef enum
{
    Noalert,
    _5MinutesBefore,
    _15minutesBefore,
    _30minutesBefore,
    _1hourBefore,
    _2hoursBefore,
    _1dayBefore,
    _2daysBefore,
    _3daysBefore,
    _7daysBefore
} AlertType;

typedef enum
{
    US_Samoa,
    US_Hawaii,
    US_Alaska,
    US_Pacific,
    US_Arizona_Mountain,
    US_East,
    Canada_Atlantic,
    Canada_Newfoundland
} TimezoneType;

typedef enum
{
    OWNER=0,
    PARTICIPANT=2,
    NOSHARE=3
} RoleType;

typedef enum
{
    Unknown=0,
    Confirmed=1,
    Denied=2
} ConfirmType;

typedef enum
{
    DeleteButtonCell=0,
    ConfirmButtonCell,
    DenyButtonCell,
    AddParticiantButtonCell
} ButtonCellType;


#endif
