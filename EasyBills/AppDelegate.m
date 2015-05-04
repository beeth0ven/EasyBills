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
#import "UIFont+Extension.h"
#import "Kind+Create.h"
#import "HomeViewController.h"
#import "NSManagedObjectContext+Extension.h"
#import "UIStoryboardSegue+Extension.h"
#import "NSPredicate+PrivateExtension.h"
#import "Bill+Create.h"
#import "NSManagedObject+Extension.h"

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
    

//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//    
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
    
    mainRevealController.rearViewRevealWidth = window.frame.size.width * 2 / 3;
//    NSLog(@"RearViewRevealWidth Width: %.0f",mainRevealController.rearViewRevealWidth);

//    [self enumerateFonts];
    
    self.window = window;
    self.window.rootViewController = mainRevealController;
    [self.window makeKeyAndVisible];
    
    [self showPasscodeIfNeeded];
    
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


- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cn.beeth0ven.test" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    BOOL firstRun = ![storeURL checkResourceIsReachableAndReturnError:NULL];
    
    NSDictionary *storeOptions =
    @{NSPersistentStoreUbiquitousContentNameKey: @"MyAppCloudStore"};

    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:storeOptions
                                                           error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (firstRun)
    {
        
        [Kind createDefaultKindsInManagedObjectContext:self.managedObjectContext];
        [PubicVariable setNextAssignIncomeColorIndex:-1];
        [PubicVariable setNextAssignExpenseColorIndex:-1];
        [self saveContext];
    }
    
    [self registerForiCloudNotifications];

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark - Notification Observers For iCloud support

- (void)registerForiCloudNotifications {
    NSLog(@"registerForiCloudNotifications");
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSPersistentStoreCoordinatorStoresWillChangeNotification
     object:self.managedObjectContext.persistentStoreCoordinator
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         // disable user interface with setEnabled: or an overlay
         NSLog(@"NSPersistentStoreCoordinatorStoresWillChangeNotification");

         [self.managedObjectContext performBlock:^{
             if ([self.managedObjectContext hasChanges]) {
                 NSError *saveError;
                 if (![self.managedObjectContext save:&saveError]) {
                     NSLog(@"Save error: %@", saveError);
                 }
             } else {
                 // drop any managed object references
                 [self.managedObjectContext reset];
             }
         }];
     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSPersistentStoreCoordinatorStoresDidChangeNotification
     object:self.managedObjectContext.persistentStoreCoordinator
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         //Update UI
         NSLog(@"NSPersistentStoreCoordinatorStoresDidChangeNotification");
         [self removingDuplicateRecords];


     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification
     object:self.managedObjectContext.persistentStoreCoordinator
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         NSLog(@"NSPersistentStoreDidImportUbiquitousContentChangesNotification");

         [self.managedObjectContext performBlock:^{
             [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
             [self removingDuplicateRecords];

         }];
     }];
}


- (void)removingDuplicateRecords {
    [self removingDuplicateKindRecordsIsIncome:NO];
    [self removingDuplicateKindRecordsIsIncome:YES];
    
}


- (void)removingDuplicateKindRecordsIsIncome:(BOOL)isIncome {
    NSString *entityName = @"Kind";
    NSString *uniquePropertyKey = @"name";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isIncome = %@",[NSNumber numberWithBool:isIncome]];
    [self removingDuplicateRecordsOfEntityName:entityName
                             uniquePropertyKey:uniquePropertyKey
                               entityPredicate:predicate
                        inManagedObjectContext:self.managedObjectContext];
    
    [self billsAddMissedKindIsIncome:isIncome
             inManagedObjectContext:self.managedObjectContext];
    
}

- (void)billsAddMissedKindIsIncome:(BOOL)isIncome
                   inManagedObjectContext:(NSManagedObjectContext *)aContext {
    
    NSString *entityName = @"Bill";
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = nil;
    NSError *error;
    NSArray *matches = [aContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
    for (Bill *bill in matches) {
        if (bill.kind == nil) {
            bill.kind = [Kind kindWithName:@"其他" isIncome:isIncome inManagedObjectContext:aContext];
        }
    }
}

- (void)removingDuplicateRecordsOfEntityName:(NSString *)entityName
                           uniquePropertyKey:(NSString *)uniquePropertyKey
                                   entityPredicate:(NSPredicate *)aPredicate
                      inManagedObjectContext:(NSManagedObjectContext *)aContext {
    
//    Choose a property or a hash of multiple properties to use as a unique ID for each record.
    
    

    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:uniquePropertyKey];
    NSExpression *countExpression = [NSExpression expressionForFunction: @"count:" arguments:@[keyPathExpression]];
    NSExpressionDescription *countExpressionDescription = [[NSExpressionDescription alloc] init];
    
    [countExpressionDescription setName:@"count"];
    [countExpressionDescription setExpression:countExpression];
    [countExpressionDescription setExpressionResultType:NSInteger64AttributeType];
    NSManagedObjectContext *context = aContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSAttributeDescription *uniqueAttribute = [[entity attributesByName] objectForKey:uniquePropertyKey];

//    Fetch the number of times each unique value appears in the store.
//    The context returns an array of dictionaries, each containing a unique value and the number of times that value appeared in the store.

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.propertiesToFetch = @[uniqueAttribute, countExpressionDescription];
    [fetchRequest setPropertiesToGroupBy:@[uniqueAttribute]];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPredicate:aPredicate];
    NSError *error;
    NSArray *fetchedDictionaries = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }

//    Filter out unique values that have no duplicates.
    NSMutableArray *valuesWithDupes = [NSMutableArray array];
    for (NSDictionary *dict in fetchedDictionaries) {
        NSNumber *count = dict[@"count"];
        if ([count integerValue] > 1) {
            [valuesWithDupes addObject:dict[uniquePropertyKey]];
        }
    }

//    Use a predicate to fetch all of the records with duplicates.
//    Use a sort descriptor to properly order the results for the winner algorithm in the next step.

    NSFetchRequest *dupeFetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    [dupeFetchRequest setIncludesPendingChanges:NO];

    [dupeFetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:uniquePropertyKey ascending:YES]]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ IN (%@)", uniquePropertyKey ,valuesWithDupes];
    predicate = [predicate predicateCombineWithPredicate:aPredicate];
    [dupeFetchRequest setPredicate:aPredicate];
    
    NSArray *dupes = [context executeFetchRequest:dupeFetchRequest error:&error];
    
    if (error) {
        NSLog(@"%@",[error localizedDescription]);
        return;
    }
    
//    Choose the winner.
//    After retrieving all of the duplicates, your app decides which ones to keep. This decision must be deterministic, meaning that every peer should always choose the same winner. Among other methods, your app could store a created or last-changed timestamp for each record and then decide based on that.
    
    
    NSManagedObject *prevObject;
    for (NSManagedObject *duplicate in dupes) {
        if (prevObject) {
            NSString *uniqueProperty = [duplicate valueForKey:uniquePropertyKey];
            NSString *preUniqueProperty = [prevObject valueForKey:uniquePropertyKey];
            if ([uniqueProperty isEqualToString:preUniqueProperty]) {
                if ([duplicate respondsToSelector:@selector(createDate)] &&
                    [prevObject respondsToSelector:@selector(createDate)]) {
                    NSDate *createDate = [duplicate performSelector:@selector(createDate)];
                    NSDate *preCreateDate = [prevObject performSelector:@selector(createDate)];
                    if ([createDate compare:preCreateDate] == NSOrderedAscending) {
                        [duplicate moveAllRelatedObectsTo:prevObject];
                        [context deleteObject:duplicate];
                        NSLog(@"Successfully remove a %@!",[prevObject performSelector:@selector(name)]);
                    } else {
                        [prevObject moveAllRelatedObectsTo:duplicate];
                        [context deleteObject:prevObject];
                        prevObject = duplicate;
                        NSLog(@"Successfully remove a %@!",[prevObject performSelector:@selector(name)]);

                    }
                }
                
            } else {
                prevObject = duplicate;
            }
        } else {
            prevObject = duplicate;
        }
    }
//    Remember to set a batch size on the fetch and whenever you reach the end of a batch, save the context.
    [self saveContext];


}


#pragma mark - Some method

- (void)showPasscodeIfNeeded {
    LTHPasscodeViewController *sharedLTHPasscodeViewController = [LTHPasscodeViewController sharedUser];
    sharedLTHPasscodeViewController.navigationBarTintColor = EBBlue;
    sharedLTHPasscodeViewController.navigationTintColor = [UIColor whiteColor];
    sharedLTHPasscodeViewController.labelFont = [UIFont wawaFontForLabel];
    sharedLTHPasscodeViewController.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                             NSFontAttributeName : [UIFont wawaFontForNavigationTitle]};
    sharedLTHPasscodeViewController.title = @"简单记账";
    sharedLTHPasscodeViewController.enterPasscodeString = @"请输入密码";
    sharedLTHPasscodeViewController.enterNewPasscodeString = @"请输入新密码";
    sharedLTHPasscodeViewController.enablePasscodeString = @"设置密码";
    sharedLTHPasscodeViewController.changePasscodeString = @"修改密码";
    sharedLTHPasscodeViewController.turnOffPasscodeString = @"关闭密码";
    sharedLTHPasscodeViewController.reenterPasscodeString = @"请再次输入密码";
    sharedLTHPasscodeViewController.reenterNewPasscodeString = @"请再次输入新密码";
    
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        [sharedLTHPasscodeViewController showLockScreenWithAnimation:NO
                                                          withLogout:YES
                                                      andLogoutTitle:nil];
    }
}

- (void) enumerateFonts{
    
    for (NSString *familyName in [UIFont familyNames]){
        NSLog(@"%@", familyName);
        for (NSString *fontName in
             [UIFont fontNamesForFamilyName:familyName]){
            NSLog(@"\t%@", fontName);
            
        }
    }
    
}

#pragma mark - Property Setter and Getter method


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
                 [self.managedObjectContext passToViewController:controller];
                 
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



@end
