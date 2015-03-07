//
//  AppDelegate.m
//  EasyBills
//
//  Created by 罗 杰 on 10/1/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import "AppDelegate.h"
#import "LTHPasscodeViewController.h"
#import "DefaultStyleController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIStoryboard *storyBoard;


@end


@implementation AppDelegate

//- (void) scheduleLocalNotification{
//    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    
//    /* Time and timezone settings */
//    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:8.0];
//    notification.timeZone = [[NSCalendar currentCalendar] timeZone];
//    
//    notification.alertBody =
//    NSLocalizedString(@"A new item is downloaded.", nil);
//    
//    /* Action settings */
//    notification.hasAction = YES;
//    notification.alertAction = NSLocalizedString(@"View", nil);
//    
//    /* Badge settings */
//    notification.applicationIconBadgeNumber =
//    [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
//    
//    /* Additional information, user info */
//    notification.userInfo = @{@"Key 1": @"Value 1",
//                              @"Key 2" : @"Value 2"};
//    
//    /* Schedule the notification */
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    
//    
//    
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DefaultStyleController applyStyle];

    
    // Override point for customization after application launch.
    
    /*
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] != nil){
        UILocalNotification *notification =
        launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        [self application:application didReceiveLocalNotification:notification];
    } else {
        //[self scheduleLocalNotification];
    }
    */
    
    
    UINavigationController *frontViewController = (UINavigationController *)[self.viewControllers firstObject];
    SidebarViewController *rearViewController = [self.storyBoard
                                                 instantiateViewControllerWithIdentifier:@"rearViewController"];
    
    SWRevealViewController *mainRevealController =
    [[SWRevealViewController alloc] initWithRearViewController:rearViewController
                                           frontViewController:frontViewController];
    
    mainRevealController.toggleAnimationDuration = 0.7;
    
    UIWindow *window = [[UIWindow alloc]
                        initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window = window;
    self.window.rootViewController = mainRevealController;
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)            application:(UIApplication *)application
    didReceiveLocalNotification:(UILocalNotification *)notification{
    
//    NSString *key1Value = notification.userInfo[@"Key 1"];
//    NSString *key2Value = notification.userInfo[@"Key 2"];
//    
//    if ([key1Value length] > 0 &&
//        [key2Value length] > 0){
//        
//        UIAlertView *alert =
//        [[UIAlertView alloc] initWithTitle:nil
//                                   message:@"Handling the local notification"
//                                  delegate:nil
//                         cancelButtonTitle:@"OK"
//                         otherButtonTitles:nil];
//        [alert show];
//        /* cancel the notification */
//        notification.applicationIconBadgeNumber =
//        [UIApplication sharedApplication].applicationIconBadgeNumber - 1;
//        [[UIApplication sharedApplication] cancelLocalNotification:notification];
//
//    }
//    
}

- (NSMutableArray *)viewControllers{
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
        
        NSArray *controllerIdentifiers = @[@"homeNavigationController",
                                           @"categoryNavigationController",
                                           @"mapNavigationController",
                                           @"settingNavigationController",
                                           @"settingNavigationController"];
        
        
        [controllerIdentifiers
         enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSString *identifier = (NSString *)obj;
             id controller = [self.storyBoard
                              instantiateViewControllerWithIdentifier:identifier];
             
             if ([controller isKindOfClass:[UINavigationController class]]) {
                 [_viewControllers addObject:controller];
             }
         }];
        
        if (_viewControllers != nil) {
            NSLog(@"Successfully initailize the view controllers with count %lu .",
                  (unsigned long)_viewControllers.count);
        }else{
            NSLog(@"Failed to initailize the view controllers.");
        }
    }
    return _viewControllers;
}

- (UIStoryboard *)storyBoard{
    
    if (_storyBoard == nil) {
        _storyBoard = [UIStoryboard
                       storyboardWithName:@"Main"
                       bundle:[NSBundle mainBundle]];
        
        if (_storyBoard != nil) {
            NSLog(@"Successfully create the story board.");
        }else{
            NSLog(@"Failed to create the story board.");
        }
    }
    return _storyBoard;
}
                                                 
                                                 

- (void)applicationWillResignActive:(UIApplication *)application
{
    [PubicVariable saveContext];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [PubicVariable saveContext];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [PubicVariable saveContext];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [PubicVariable saveContext];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [PubicVariable saveContext];
}

@end
