//
//  PopviewButtonsDelegate.h
//  CSchedule
//
//  Created by 郭 晨 on 10/9/13.
//
//

#import <Foundation/Foundation.h>

@protocol PopviewButtonsDelegate <NSObject>

-(void) edit;
-(void) share;
-(void) mail;
-(void) del;
-(void) inspect;

@end
