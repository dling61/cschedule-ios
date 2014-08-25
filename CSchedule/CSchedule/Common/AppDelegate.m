//
//  AppDelegate.m
//  CSchedule2.0
//
//  Created by 郭 晨 on 1/15/14.
//  Copyright (c) 2014 E2WSTUDY. All rights reserved.
//

#import "AppDelegate.h"
@implementation AppDelegate
@synthesize syncEngine=_syncEngine;
@synthesize registeredNotes=_registeredNotes;
@synthesize dataManager = _dataManager;
@synthesize isOpenAlertUpdate;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x067AB5)];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      NSForegroundColorAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      NSBaselineOffsetAttributeName,
      [UIFont fontWithName:@"Arial-Bold" size:20.0],
      NSFontAttributeName,
      nil]];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:FIRSTOPEN];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    [self responde:GETSETTINGSUCCESSNOTE by:@selector(getSettingSuccess:)];
    [self responde:GETSETTINGFAILNOTE by:@selector(getSettingFail:)];
    
    _syncEngine = [SyncEngine sharedEngineInstance];
    _dataManager = [DataManager sharedDataManagerInstance];
    [self checkUpdateApp];
    
    self.isOpenAlertUpdate=NO;
    return YES;
}

- (void)checkUpdateApp
{
    [[self.syncEngine getSetting] start];
}


-(void)getSettingSuccess:(NSNotification*) note
{
    [self.dataManager processSettingInfo:[note userInfo]];
    [self checkAppVersionAvailable];
}
-(BOOL)checkAppVersionAvailable
{
    
    NSArray* allAppSettings = [self.dataManager allAppSetting];
    for(AppSettingInfo *appSetting in allAppSettings)
    {
        //float iOSVersion =[[[UIDevice currentDevice] systemVersion] floatValue];
        if([appSetting.os isEqualToString:DEVICE])
        {
            if([VERSION isEqualToString:appSetting.app_version])//&& iOSVersion==appSetting.osversion
            {
                return YES;
            }
            else if(self.isOpenAlertUpdate==NO) {
                
                self.isOpenAlertUpdate=YES;
                if(appSetting.enforce==0)
                {
                    [[[UIAlertView alloc] initWithTitle:@"CSChedule" message:appSetting.msg delegate:self cancelButtonTitle:@"Update" otherButtonTitles:@"Don't Update",nil] show];
                }
                else{
                    
                    [[[UIAlertView alloc] initWithTitle:@"CSChedule" message:FORCE_APP_UPDATE_MESSAGE delegate:self cancelButtonTitle:@"Update" otherButtonTitles:nil] show];
                }
                return NO;
            }
            else{
                return YES;
            }
        }
    }
    return YES;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.isOpenAlertUpdate=NO;
    if (buttonIndex == 0) {
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/cschedule/id596231825?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}
-(void)getSettingFail:(NSNotification*) note
{
    [[[UIAlertView alloc] initWithTitle:@"Error" message:GET_SETTING_FAIL_MESSAGE delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
}
- (void) responde:(NSString *)note by:(SEL)func
{
    if ([_registeredNotes containsObject:note])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:note object:nil];
        [_registeredNotes removeObject:note];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:func name:note object:nil];
    [_registeredNotes addObject:note];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:FIRSTOPEN];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self checkUpdateApp];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    NSLog(@"token :%@",token);
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:keyDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:keyDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceiveRemoteNotification %@",userInfo);
    NSDictionary *aps=[userInfo objectForKey:@"aps"];
    if([aps objectForKey:@"alert"])
    {
        NSString *alertString =[aps objectForKey:@"alert"];
        [[[UIAlertView alloc] initWithTitle:@"Push notication" message:alertString delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    }
    else{
        [[[UIAlertView alloc] initWithTitle:@"Push notication" message:@"You have a new push notification" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    }
}

@end
