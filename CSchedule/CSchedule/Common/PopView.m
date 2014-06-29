//
//  PopView.m
//  CSchedule
//
//  Created by 郭 晨 on 10/9/13.
//
//

#import "PopView.h"

@implementation PopView

@synthesize edit_btn = _edit_btn;
@synthesize share_btn = _share_btn;
@synthesize mail_btn = _mail_btn;
@synthesize del_btn = _del_btn;
@synthesize view_btn = _view_btn;
@synthesize btnDelegate = _btnDelegate;
@synthesize funcBtns = _funcBtns;

-(void) addBnts
{
    CGFloat btnWidth = self.bounds.size.width;
    CGFloat btnHeight = self.bounds.size.height / _funcBtns.count;
    int count = 0;
    for (UIButton* btn in _funcBtns) {
        [btn setFrame:CGRectMake(0, count * btnHeight, btnWidth, btnHeight)];
        [self addSubview:btn];
        count++;
    }
    if (count > 1) {
        for (count = 1; count < _funcBtns.count; count++) {
            UIImageView* imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seperator.png"]];
            imgv.frame = CGRectMake(0, count * btnHeight, btnWidth, 1);
            [self addSubview:imgv];
        }
    }
}

-(void) initFuncBtnsWithRole: (RoleType) role andSituation: (NSString*) situation
{
    switch (role) {
        case OWNER:
            [_funcBtns addObject:_edit_btn];[_funcBtns addObject:_share_btn];
            [_funcBtns addObject:_mail_btn];[_funcBtns addObject:_del_btn];
            if (![situation isEqualToString:ACTIVITYVC]) {
                [_funcBtns removeObject:_mail_btn];[_funcBtns removeObject:_share_btn];
            }
            break;
//        case ORGANIZER:
//            [_funcBtns addObject:_edit_btn];[_funcBtns addObject:_share_btn];[_funcBtns addObject:_mail_btn];
//            if ([situation isEqualToString:ACTIVITYVC]) {
//                [_funcBtns removeObject:_mail_btn];[_funcBtns removeObject:_share_btn];
//            }
//            break;
        case PARTICIPANT:
            if ([situation isEqualToString:ACTIVITYVC]) {
                [_funcBtns addObject:_mail_btn];
            }
            else
            {
                [_funcBtns addObject:_view_btn];
            }
            
            break;
/*        case VIEWER:
            break;*/
            
        default:
            break;
    }
}

-(id) initWithWidth: (CGFloat) width andBtnHeight: (CGFloat) height andRole:(RoleType) role andSituation: (NSString*) situation
{
    if (self = [super init]) {
//        self.bounds = CGRectMake(0, 0, width, height);
        [self setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        _edit_btn = [[UIButton alloc] init];
        [_edit_btn setBackgroundColor:[UIColor clearColor]];
        [_edit_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_edit_btn setTitle:@"Edit" forState:UIControlStateNormal];
        [_edit_btn addTarget:self action:@selector(editBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _share_btn = [[UIButton alloc] init];
        [_share_btn setBackgroundColor:[UIColor clearColor]];
        [_share_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_share_btn setTitle:@"Share" forState:UIControlStateNormal];
        [_share_btn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _mail_btn = [[UIButton alloc] init];
        [_mail_btn setBackgroundColor:[UIColor clearColor]];
        [_mail_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mail_btn setTitle:@"Mail" forState:UIControlStateNormal];
        [_mail_btn addTarget:self action:@selector(mailBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _del_btn = [[UIButton alloc] init];
        [_del_btn setBackgroundColor:[UIColor clearColor]];
        [_del_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_del_btn setTitle:@"Delete" forState:UIControlStateNormal];
        [_del_btn addTarget:self action:@selector(delBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _del_btn = [[UIButton alloc] init];
        [_del_btn setBackgroundColor:[UIColor clearColor]];
        [_del_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_del_btn setTitle:@"Delete" forState:UIControlStateNormal];
        [_del_btn addTarget:self action:@selector(delBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _view_btn = [[UIButton alloc] init];
        [_view_btn setBackgroundColor:[UIColor clearColor]];
        [_view_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_view_btn setTitle:@"View" forState:UIControlStateNormal];
        [_view_btn addTarget:self action:@selector(viewBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        _funcBtns = [[NSMutableArray alloc] init];
        [self initFuncBtnsWithRole:role andSituation:situation];
        self.bounds = CGRectMake(0, 0, width, height * _funcBtns.count);
        [self setBackgroundColor:[UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1.0]];
        [self addBnts];
    }
    
    return self;
}

-(IBAction) editBtnPressed:(id)sender
{
//    NSLog(@"edit button pressed");
    [_btnDelegate edit];
}
-(IBAction) shareBtnPressed:(id)sender
{
    //    NSLog(@"edit button pressed");
    [_btnDelegate share];
}

-(IBAction) mailBtnPressed:(id)sender
{
    //    NSLog(@"edit button pressed");
    [_btnDelegate mail];
}

-(IBAction) delBtnPressed:(id)sender
{
    //    NSLog(@"edit button pressed");
    [_btnDelegate del];
}

-(IBAction) viewBtnPressed:(id)sender
{
    //    NSLog(@"edit button pressed");
    [_btnDelegate inspect];
}




@end
