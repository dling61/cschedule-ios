//
//  PopView.h
//  CSchedule
//
//  Created by 郭 晨 on 10/9/13.
//
//

#import <UIKit/UIKit.h>
#import "PopviewButtonsDelegate.h"

@interface PopView : UIView

@property (strong,nonatomic) UIButton* edit_btn;
@property (strong,nonatomic) UIButton* share_btn;
@property (strong,nonatomic) UIButton* mail_btn;
@property (strong,nonatomic) UIButton* del_btn;
@property (strong,nonatomic) UIButton* view_btn;

@property (weak,nonatomic) id<PopviewButtonsDelegate> btnDelegate;
@property (strong, nonatomic) NSMutableArray* funcBtns;
@property (strong, nonatomic) NSArray* btnSet;

-(void) addBnts;
-(void) initFuncBtnsWithRole: (RoleType) role andSituation: (NSString*) situation;
-(id) initWithWidth: (CGFloat) width andBtnHeight: (CGFloat) height andRole:(RoleType) role andSituation: (NSString*) situation;
@end
