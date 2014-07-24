//
//  Constants.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/15/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#ifndef CSchedule2_0_Constants_h
#define CSchedule2_0_Constants_h

#define STRONG                          @property (nonatomic, strong)
#define WEAK                            @property (nonatomic, weak)
#define NOPOINTER                       @property

//#define BASEURL                         @"http://apitest2.servicescheduler.net/"
#define BASEURL                         @"http://apitest1.servicescheduler.net/"
#define DEVICE                          @"IOS"
#define SCODE                           @"28e336ac6c9423d946ba02dddd6a2632"
#define VERSION                         @"1.4.0"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < 0.1 )
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#pragma mark -
#pragma mark sub paths

#define SIGNINPATH                      @"creator?action=signin"
#define REGISTERPATH                    @"creator?action=register"
#define RESETPWPATH                     @"creator?action=resetpw"
#define SETTOKENPATH                    @"creator?action=settoken"
#define ACTIVITYPATH                    @"services"
#define MEMBERPATH                      @"members"
#define SCHEDULEPATH                    @"schedules"
#define FEEDBACKPATH                    @"feedback"

#define SETTINGPATH                    @"serversetting"

#pragma mark -
#pragma mark notifications

#define SIGNINSUCCESSNOTE               @"signinsuccess"
#define SIGNINFAILURENOTE               @"signinfailed"

#define REGISTERSUCCESSNOTE             @"registersuccess"
#define REGISTERFAILURENOTE             @"registerfailed"

#define RESETPWSUCCESSNOTE              @"resetpasswordsuccessnote"
#define RESETPWFAILNOTE                 @"resetpasswordfailnote"

#define SETTOKENSUCCESSNOTE             @"settokensuccess"
#define SETTOKENFAILURENOTE             @"settokenfailed"

#define GETACTIVITYSUCCESSNOTE          @"getactivitiesuccess"
#define GETACTIVITYFAILNOTE             @"getactivitiesfail"
#define POSTACTIVITYSUCCESSNOTE         @"postactivitysuccess"
#define POSTACTIVITYFAILNOTE            @"postactivityfail"
#define PUTACTIVITYSUCCESSNOTE          @"putactivitysuccess"
#define PUTACTIVITYFAILNOTE             @"putactivityfail"
#define DELETEACTIVITYSUCCESSNOTE       @"deleteactivitysuccessfully"
#define DELETEACTIVITYFAILNOTE          @"deleteactivityfail"


#define GETSETTINGSUCCESSNOTE          @"getsettingsuccess"
#define GETSETTINGFAILNOTE             @"getsettingfail"

#define GETCONTACTSUCCESSNOTE           @"getcontactssuccess"
#define GETCONTACTFAILNOTE              @"getcontanctsfail"
#define POSTCONTACTSUCCESSNOTE          @"postcontactsuccess"
#define POSTCONTACTFAILNOTE             @"postcontactfail"
#define PUTCONTACTSUCCESSNOTE           @"putcontactsuccess"
#define PUTCONTACTFAILNOTE              @"putcontactfail"
#define DELETECONTACTSUCCESSNOTE        @"deletecontactsuccessfully"
#define DELETECONTACTFAILNOTE           @"deletecontactfail"

#define GETSHAREDMEMBERSUCCESSNOTE      @"getsharedmemberssuccess"
#define GETSHAREDMEMBERFAILNOTE         @"getsharedmembersfail"
#define GETALLSHAREDMEMBERSNOTE         @"getallsharedmembersdone"
#define UPDATEALLSHAREDMEMBERSNOTE      @"updateallsharedmembersdone"
#define POSTSHAREDMEMBERSUCCESSNOTE     @"postsharedmemberssuccess"
#define POSTSHAREDMEMBERFAILNOTE        @"postsharedmembersfail"
#define PUTSHAREDMEMBERSUCCESSNOTE      @"putallsharedmemberssuccess"
#define PUTSHAREDMEMBERFAILNOTE         @"putallsharedmembersfail"
#define DELETESHAREDMEMBERSUCCESSNOTE   @"deleteallsharedmemberssuccess"
#define DELETESHAREDMEMBERFAILNOTE      @"deleteallsharedmembersfail"

#define GETSCHEDULESUCCESSNOTE          @"getschedulesuccess"
#define GETSCHEDULEFAILNOTE             @"getschedulefail"
#define POSTSCHEDULESUCCESSNOTE         @"postschedulesuccess"
#define POSTSCHEDULEFAILNOTE            @"postschedulefail"
#define PUTSCHEDULESUCCESSNOTE          @"putschedulesuccess"
#define PUTSCHEDULEFAILNOTE             @"putschedulefail"

#define DELETESCHEDULESUCCESSNOTE       @"deleteschedulesuccessfully"
#define DELETESCHEDULEFAILNOTE          @"deleteschedulefail"

#define EDITPARTICIPANTSDONE            @"editparticipantsdone"

#define GETALLSCHEDULESNOTE             @"getallschedulesdone"
#define ADDACTIVITYSUCCESSNOTE          @"addactivitysuccess"
#define UPDATEACTIVITYSUCCESSNOTE       @"updateactivitysuccess"
#define ADDCONTACTSUCCESSNOTE           @"addcontactsuccess"
#define UPDATECONTACTSUCCESSNOTE        @"updatecontactsuccess"
#define ADDSCHEDULESUCCESSNOTE          @"addschedulesuccess"
#define UPDATESCHEDULESUCCESSNOTE       @"updateschedulesuccess"

#define POSTFEEDBACKSUCCESSNOTE         @"postfeedbacksuccess"
#define POSTFEEDBACKFAILNOTE            @"postfeedbackfail"

#define CONFIRMSTATUSSUCCESSNOTE         @"confirmstatussuccess"
#define CONFIRMSTATUSFAILNOTE            @"confirmstatusfail"

#pragma mark -
#pragma mark VC titles

#define REGISTERVC                      @"Create Account"
#define SIGNINVC                        @"Sign in"
#define FORGETPWVC                      @"Forget password"
#define TABPAGES                        @"tabpages"
#define ACTIVITYVC                      @"Activity"
#define ADDACTIVITYVC                   @"New Activity"
#define EDITACTIVITYVC                  @"Activity Info"
#define CONTACTVC                       @"Contact"
#define EDITCONTACTVC                   @"Contact Info"
#define ADDCONTACTVC                    @"New Contact"
#define SHAREMEMBERVC                   @"Share"
#define PARTICIPANTVC                   @"Add Participant"
#define SCHEDULEVC                      @"Schedule"
#define EDITSCHEDULEVC                  @"Schedule Info"
#define ADDSCHEDULEVC                   @"New Schedule"
#define VIEWSCHEDULEVC                  @"Schedule Info"
#define ONDUTYVC                        @"Participant"
#define SETTINGVC                       @"Account"
#define FEEDBACKVC                      @"Feedback"

#pragma mark -
#pragma mark cell indentifiers

#define TFCELL                          @"tfcell"
#define ACTIVITYCELL                    @"activitycell"
#define ACTNAMECELL                     @"activitytitlecell"
#define ACTDESPCELL                     @"activitydespcell"
#define ACTALERTCELL                    @"activityalertcell"
#define ACTREPEATCELL                   @"activityrepeatcell"
#define ACTTIMEZONECELL                 @"activitytimezonecell"
#define CONTACTCELL                     @"contactcell"
#define SHAREMEMBERCELL                 @"sharedmembercell"
#define SCHEDULECELL                    @"schedulecell"
#define SCHEDULEACTIVITYCELL            @"scheduleactivitycell"
#define SCHEDULESTARTCELL               @"schedulestartcell"
#define SCHEDULEENDCELL                 @"scheduleendcell"
#define SCHEDULEONDUTYCELL              @"scheduleondutycell"
#define SCHEDULEDESPCELL                @"scheduledespcell"
#define SCHEDULEBUTTONCELL              @"schedulebuttoncell"

#define SCHEDULEALERTCELL               @"schedulealertcell"
#define SCHEDULETIMEZONECELL            @"scheduletimezonecell"
#define ONDUTYCELL                      @"ondutycell"


#pragma mark -
#pragma mark Message Define

#define LOGIN_FAIL_MESSAGE @"Invalid email or password"
#define FORCE_APP_UPDATE_MESSAGE @"App is out of update."
#define GET_SETTING_FAIL_MESSAGE @"Can not get list Setting"
#define EMAIL_INVALID_MESSAGE @"You should enter an invalid email address"
#define USERNAME_EMPTY_MESSAGE @"Name cannot be empty" 
#define PASSWORD_EMPTY_MESSAGE @"Password cannot be empty" 
#define CONTACT_NAME_EMPTY_MESSAGE @"Contact name cannot empty"
#define ACTIVITY_NAME_EMPTY_MESSAGE @"An activity name is required"
#define ACTIVITY_DELETE_MESSAGE @"Are you sure you want to delete this activity and related schedules ?"



#pragma mark -
#pragma mark local data keys

#define FIRSTOPEN                       @"whetherfirsttime"
#define USERID                          @"currentuserid"
#define USERNAME                        @"currentusername"
#define USEREMAIL                       @"currentuseremail"
#define USERPASSWORD                    @"userpassword"    
#define NEXTMEMBERID                    @"nextmemberid"
#define NEXTSERVICEID                   @"nextserviceid"
#define NEXTSCHEDULEID                  @"nextscheduleid"
#define ALLACTIVITIES                   @"allactivities"
#define ALLCONTACTS                     @"allcontacts"
#define ALLSHAREDMEMBERS                @"allsharedmembers"
#define ALLSCHEDULES                    @"allschedules"
#define LSTACTIVITYUPDATE               @"lateupdatetimeofactivity"
#define LSTMEMBERUPDATE                 @"lateupdatetimeofmember"

#define ALLAPPSETTING                  @"allappsetting"
#define ALLTIMEZONES                   @"alltimezones"
#define ALLALERTS                      @"allalerts"

#pragma mark -
#pragma mark local object keys
#define keyDeviceToken                  @"DEVICE_TOKEN"
#define SYNCHRONIZED                    @"synchronized"
#define DELETED                         @"deleted"

#define ACTIVITY                        @"activity"
#define CONTACT                         @"contact"
#define SHAREDMEMBER                    @"sharedmember"
#define SCHEDULE                        @"schedule"
#define TIMEZONES                       @"timezones"
#define ALERTS                          @"alerts"
#define APPVERSION                      @"appversion"


#pragma mark -
#pragma mark script type

#define ADD                             0
#define EDIT                            1
#define VIEW                            2

#pragma mark -
#pragma mark local tags

#define ACTIVITY_DESP_LBL              20


#pragma mark -
#pragma mark date format

#define DATESTYLE1                      @"yyyy-MM-dd HH:mm:ss"

#pragma mark -
#pragma mark colors

#define LightBlue [UIColor colorWithRed:0.14 green:0.40 blue:0.60 alpha:1.0f]
#define LightGrey [UIColor colorWithRed:0.46 green:0.46 blue:0.46 alpha:1.0f]


#pragma mark -
#pragma mark sizes

#define MYPICKERVIEWHEIGHT              206.0
#define TABBARHEIGHT                    49.0
#define NAVBARHEIGHT                    44.0

#define SCHEDULEACTIVITYCELLTAG         20  


#define DEBUG       1

#endif 
