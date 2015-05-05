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

@property (strong, nonatomic) id persistentStoreCoordinatorStoresWillChangeNotificationObserver;
@property (strong, nonatomic) id persistentStoreCoordinatorStoresDidChangeNotificationObserver;
@property (strong, nonatomic) id persistentStoreDidImportUbiquitousContentChangesNotificationObserver;
@property (strong, nonatomic) id managedObjectContextWillSaveNotificationObserver;


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
    
//    [self resetCoordinatorToDefault];
//    
//    return YES;
    
    [DefaultStyleController applyStyle];
    [self registerForiCloudNotifications];


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

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self.persistentStoreCoordinatorStoresWillChangeNotificationObserver];
    [center removeObserver:self.persistentStoreCoordinatorStoresDidChangeNotificationObserver];
    [center removeObserver:self.persistentStoreDidImportUbiquitousContentChangesNotificationObserver];
    [center removeObserver:self.managedObjectContextWillSaveNotificationObserver];
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

- (void)resetCoordinatorToDefault {
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error;
    NSDictionary *storeOptions =
    @{NSPersistentStoreUbiquitousContentNameKey: @"MyAppCloudStore"};
    
    [NSPersistentStoreCoordinator removeUbiquitousContentAndPersistentStoreAtURL:storeURL options:storeOptions error:&error];
    
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




#pragma mark - Notification Observers

- (void)registerForiCloudNotifications {
    NSLog(@"registerForiCloudNotifications");
    self.persistentStoreCoordinatorStoresWillChangeNotificationObserver =
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
    
    self.persistentStoreCoordinatorStoresDidChangeNotificationObserver =
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSPersistentStoreCoordinatorStoresDidChangeNotification
     object:self.managedObjectContext.persistentStoreCoordinator
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         //Update UI
         NSLog(@"NSPersistentStoreCoordinatorStoresDidChangeNotification");
         [self removingDuplicateRecords];


     }];
    
    self.persistentStoreDidImportUbiquitousContentChangesNotificationObserver =
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSPersistentStoreDidImportUbiquitousContentChangesNotification
     object:self.managedObjectContext.persistentStoreCoordinator
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         NSLog(@"NSPersistentStoreDidImportUbiquitousContentChangesNotification");

         [self.managedObjectContext performBlock:^{
             [self.managedObjectContext mergeChangesFromContextDidSaveNotification:note];
//             [self removingDuplicateRecords];

         }];
     }];
    
    self.managedObjectContextWillSaveNotificationObserver =
    [[NSNotificationCenter defaultCenter]
     addObserverForName:NSManagedObjectContextWillSaveNotification
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *note) {
         NSLog(@"NSManagedObjectContextWillSaveNotification");
         
         NSManagedObjectContext *context = [note object];
         NSSet *updatedObject = [context updatedObjects];
         
         for (NSManagedObject *managedObject in [updatedObject allObjects]) {
             if ([managedObject respondsToSelector:@selector(updateUniqueIfNeeded)]) {
                 [managedObject performSelector:@selector(updateUniqueIfNeeded)];
             }
         }
     
     }];
}





NSString *const kEntityName = @"kEntityName";
NSString *const kUniqueProperty = @"kUniqueProperty";


- (void)removingDuplicateRecords {
    
    NSArray *entitysToRemove =
    @[
      @{ kEntityName: @"Kind", kUniqueProperty: @"unique"},
      @{ kEntityName: @"Bill", kUniqueProperty: @"unique"},
    ];
    
    for (NSDictionary *entity in entitysToRemove) {
        NSString *entityName = [entity valueForKey:kEntityName];
        NSString *uniquePropertyKey = [entity valueForKey:kUniqueProperty];
        
        [self removingDuplicateRecordsOfEntityName:entityName
                                 uniquePropertyKey:uniquePropertyKey
                            inManagedObjectContext:self.managedObjectContext];

    }

    
}


- (void)removingDuplicateRecordsOfEntityName:(NSString *)entityName
                           uniquePropertyKey:(NSString *)uniquePropertyKey
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
    [dupeFetchRequest setPredicate:predicate];
    
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
