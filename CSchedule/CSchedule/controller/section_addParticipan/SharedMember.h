//
//  SharedMember.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/5/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedMember : NSObject <NSCoding>

STRONG NSString* member_email;
NOPOINTER int member_id;
NOPOINTER int creator_id;
NOPOINTER int confirm;
STRONG NSString * member_name;
NOPOINTER RoleType shared_role;
NOPOINTER int activity_id;
STRONG NSString * member_mobile;

- (id) initWithMemberid: (int)memberid andAcitityId:(int) activityid andRole: (RoleType) role andName: (NSString*)name andEmail:(NSString*) email andMobile:(NSString*) mobile andCreatorid: (int)creatorid;

@end
