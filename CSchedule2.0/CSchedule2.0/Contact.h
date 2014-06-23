//
//  Contact.h
//  CSchedule2.0
//
//  Created by 郭 晨 on 2/3/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject <NSCoding>

NOPOINTER int creator_id;
NOPOINTER int contact_id;
STRONG NSString* contact_name;
STRONG NSString* contact_email;
STRONG NSString* contact_mobile;

-(id) initWithId:(int) c_id andName:(NSString*) name andEmail:(NSString*) email andMobile:(NSString*) mobile andCreatorID:(int)creator_id;

@end
