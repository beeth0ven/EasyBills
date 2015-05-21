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

@property (strong, nonatomic) id managedObjectContextWillSaveNotificationObserver;
@property (strong, nonatomic) SWRevealViewController *revealViewController;


@end

NSString *storeFilename = @"SimpleBilling.sqlite";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    [self resetCoordinatorToDefault];
    
    
    [DefaultStyleController applyStyle];
    [self registerNotifications];

    //    [self enumerateFonts];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    
    UIWindow *window = [[UIWindow alloc]
                        initWithFrame:[[UIScreen mainScreen] bounds]];
    window.tintColor = EBBlue;
    window.rootViewController = self.revealViewController;
    self.window = window;
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
//        [[UIApplication sharedApplication] cancelLocalNotification:notification];
//
//    }
//    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self.managedObjectContextWillSaveNotificationObserver];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


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
    
    BOOL firstRun = ![[self storeURL] checkResourceIsReachableAndReturnError:NULL];
    [self addPersistentStore];
    if (firstRun)
    {
        
        [Kind createDefaultKindsInManagedObjectContext:self.managedObjectContext];
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
    [_managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    return _managedObjectContext;
}


#pragma mark - CORE DATA RESET
- (void)resetContext:(NSManagedObjectContext*)context {
    [context performBlockAndWait:^{
        [context reset];
    }];
}
- (BOOL)reloadStore {
    BOOL success = NO;
    NSError *error = nil;
    if (![_persistentStoreCoordinator removePersistentStore:_persistentStore error:&error]) {
        NSLog(@"Unable to remove persistent store : %@", error);
    }
    [self resetContext:_managedObjectContext];
//    [self resetContext:_importContext];
//    [self resetContext:_context];
//    [self resetContext:_parentContext];
    _persistentStore = nil;
    [self addPersistentStore];

//    [self setupCoreData];
//    [self somethingChanged];
    if (_persistentStore) {success = YES;}
    return success;
}


- (void)addPersistentStore{
    NSDictionary *storeOptions = nil;
    //    [PubicVariable iCloudEnable] ? [self iCloudStoreOptions] : nil;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    _persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                 configuration:nil
                                                                           URL:[self storeURL]
                                                                       options:storeOptions
                                                                         error:&error];
    if (!_persistentStore) {
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
    
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    NSLog(@"saveContext");
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

- (void)clearContext {
    _managedObjectContext = nil;
    _persistentStoreCoordinator = nil;
}

#pragma mark - Notification Observers

- (void)registerNotifications {
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
             if ([managedObject respondsToSelector:@selector(updateUniqueIDIfNeeded)]) {
                 [managedObject performSelector:@selector(updateUniqueIDIfNeeded)];
             }
         }

     
     }];
}


#pragma mark - Some method



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

- (SWRevealViewController *)revealViewController {
    if (!_revealViewController) {
        UINavigationController *frontViewController = (UINavigationController *)[self.viewControllers firstObject];
        SidebarViewController *rearViewController = [self.storyBoard
                                                     instantiateViewControllerWithIdentifier:@"rearViewController"];
        
        _revealViewController = [[SWRevealViewController alloc]
                                 initWithRearViewController:rearViewController
                                 frontViewController:frontViewController];
        
        _revealViewController.delegate = rearViewController;
        _revealViewController.toggleAnimationType = SWRevealToggleAnimationTypeEaseOut;
        _revealViewController.rearViewRevealWidth = 240.0f;

    }
    return _revealViewController;
}

- (NSMutableArray *)viewControllers{
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
        
        NSArray *controllerIdentifiers = @[@"homeNavigationController",
                                           @"categoryNavigationController",
                                           @"mapNavigationController",
                                           @"settingNavigationController",
                                           @"sboutNavigationController"];
        
        
        [controllerIdentifiers
         enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSString *identifier = (NSString *)obj;
             UIViewController* controller = [self.storyBoard
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



- (NSURL *)applicationStoresDirectory {

    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
                  }
        else {NSLog(@"FAILED to create Stores directory: %@", error);}
    }
    return storesDirectory;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (NSURL *)storeURL {
   
    return [[self applicationStoresDirectory]
            URLByAppendingPathComponent:storeFilename];
}

//
//- (NSURL *)applicationDocumentsDirectory {
//    // The directory the application uses to store the Core Data store file. This code uses a directory named "cn.beeth0ven.test" in the application's documents directory.
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}


//- (NSURL *)storeURL {
//    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
//}

- (NSString *)appVersion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return  infoDictionary[(NSString*)kCFBundleVersionKey];
}



@end
