//
//  PubicVariable.m
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "PubicVariable.h"
#import "Kind+Create.h"
#import "NSDate+Extension.h"


@implementation PubicVariable


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (PubicVariable *)pubicVariable
{
    static dispatch_once_t pred = 0;
    __strong static PubicVariable *pubicVariable = nil;
    dispatch_once(&pred, ^{
        pubicVariable = [[self alloc] init];
    });
    return pubicVariable;
}

- (void)dealloc {
    NSLog(@"PubicVariable removeObserver");

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (NSManagedObjectContext *)managedObjectContext
{
    PubicVariable *pubicVariable = [PubicVariable pubicVariable];
    return pubicVariable.managedObjectContext;
}

+ (void)saveContext
{
    PubicVariable *pubicVariable = [PubicVariable pubicVariable];
    [pubicVariable saveContext];
}

+ (BOOL)managedObjectContextHasChanges
{
    PubicVariable *pubicVariable = [PubicVariable pubicVariable];
    return [pubicVariable managedObjectContextHasChanges];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] ) {
            self.managedObjectContextHasChanges = YES;
            if (![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
            
        }
    }
}

+(NSString *)stringFromDate:(NSDate *)date
{
//    NSString *dateString;
    if (!date) {
        return @"";
    }
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned int unitFlags =
    NSCalendarUnitDay |
    NSCalendarUnitMonth |
    NSCalendarUnitYear |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal ;
    
    
    NSDateComponents *dateComponents = [gregorianCalendar components:unitFlags fromDate:date];
    NSDateComponents *todayComponents = [gregorianCalendar components:unitFlags fromDate:[NSDate date]];

//    NSDateComponents *components = [gregorianCalendar
//                                    components:unitFlags
//                                    fromDate:date
//                                    toDate:[NSDate date]
//                                    options:0];
//    
////
//    NSLog(@" ");
//    NSLog(@"date: %@",  date);
//    NSLog(@"today: %@",  [NSDate date]);
//    NSLog(@"day: %i",  [components day]);
//    NSLog(@"weekday: %i",  [components weekday]);
//    NSLog(@"weekOfYear: %i",  [components weekOfYear]);
//    NSLog(@"month: %i",  [components month]);
    
    
//    NSInteger numberOfDays = [components day];
//    NSInteger numberOfWeeks = [components weekOfYear];
//    NSInteger numberOfMonths = [components month];
//    NSInteger numberOfYears = [components year];
    
    NSInteger yearOfDate = [dateComponents year];
    NSInteger weekOfYearOfDate = [dateComponents weekOfYear];
    NSInteger weekdayOfDate = [dateComponents weekday];
    
    NSInteger yearOfToday = [todayComponents year];
    NSInteger weekOfYearOfToday = [todayComponents weekOfYear];
//    NSInteger weekdayOfToday = [todayComponents weekday];
    
    if ([NSDate isSameDay:date andDate:[NSDate date]]) {
        return @"今天";

    }else if([NSDate isSameDay:date andDate:[NSDate yesterday]]){
        return @"昨天";

    }else if([NSDate isSameDay:date andDate:[NSDate dayBeforeYesterday]]){
        return @"前天";

    }
//    
//    if (numberOfYears == 0 &&
//        numberOfMonths == 0 &&
//        numberOfWeeks == 0) {
//        switch (numberOfDays) {
//                // Case day
//            case 0:{
//                return @"今天";
//                break;
//            }
//            case 1:{
//                return @"昨天";
//                break;
//            }
//            case 2:{
//                return @"前天";
//                break;
//            }
//            default:{
//                break;
//            }
//                
//        }
//        
//    }
    
    if (yearOfDate == yearOfToday &&
        weekOfYearOfDate == weekOfYearOfToday) {
        return [NSString stringWithFormat:@"本周%@", [self weekDayStrings] [weekdayOfDate]];
    }else if (yearOfDate == yearOfToday &&
              weekOfYearOfDate == weekOfYearOfToday - 1){
        return [NSString stringWithFormat:@"上周%@",[self weekDayStrings] [weekdayOfDate]];
    }
    
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    if (yearOfDate == yearOfToday) {
        [dateFormtter setDateFormat:@"M月d日"];
    }else {
        [dateFormtter setDateFormat:@"Y年M月d日"];

    }
    return [dateFormtter stringFromDate:date];
}

+ (NSArray *)weekDayStrings {
    return @[@"?",
             @"日",
             @"一",
             @"二",
             @"三",
             @"四",
             @"五",
             @"六",
             ];
}




#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        _managedObjectContext.undoManager = [[NSUndoManager alloc] init];

    }
    
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSDictionary *storeOptions =
    @{NSPersistentStoreUbiquitousContentNameKey: @"MyAppCloudStore"};
    BOOL firstRun = ![storeURL checkResourceIsReachableAndReturnError:NULL];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:storeOptions
                                                           error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if (firstRun)
    {
        
        [Kind createDefaultKinds];
        [PubicVariable setNextAssignIncomeColorIndex:-1];
        [PubicVariable setNextAssignExpenseColorIndex:-1];
		[self saveContext];
	}
    [self registerForiCloudNotifications];
    return _persistentStoreCoordinator;
}





#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



#pragma mark - Notification Observers

- (void)registerForiCloudNotifications {
    NSLog(@"registerForiCloudNotifications");
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(storesWillChange:)
                               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                             object:self.persistentStoreCoordinator];
    
    [notificationCenter addObserver:self
                           selector:@selector(storesDidChange:)
                               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                             object:self.persistentStoreCoordinator];
    
    [notificationCenter addObserver:self
                           selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                             object:self.persistentStoreCoordinator];
    
}

- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification *)changeNotification {
    NSLog(@"persistentStoreDidImportUbiquitousContentChanges");
    
    NSManagedObjectContext *context = self.managedObjectContext;
    
//    [context performBlock:^{
        [context mergeChangesFromContextDidSaveNotification:changeNotification];
//    }];
}



- (void)storesWillChange:(NSNotification *)notification {
    NSLog(@"storesWillChange");

    NSManagedObjectContext *context = self.managedObjectContext;
    
//    [context performBlockAndWait:^{
        NSError *error;
        
        if ([context hasChanges]) {
            BOOL success = [context save:&error];
            
            if (!success && error) {
                //error
                
                NSLog(@"%@",[error localizedDescription]);
                
            }
        }
        [context reset];
//    }];
    //Update UI
}

- (void)storesDidChange:(NSNotification *)notification {
    NSLog(@"storesDidChange");

    //Update UI
}

#pragma mark - NSUser Defaults KVC

#define DATEMODE @"DateMode"
#define KINDISINCOME @"kindIsIncome"

+ (void)setDateMode:(NSInteger)dateMode
{
    NSNumber *number = [NSNumber numberWithInteger:dateMode];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:DATEMODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)dateMode
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:DATEMODE];
    return  number.intValue;
}

+(void)setKindIsIncome:(BOOL)isIncome
{
    NSNumber *number = [NSNumber numberWithBool:isIncome];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:KINDISINCOME];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)kindIsIncome
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:KINDISINCOME];
    return  number.boolValue;
}



#define NEXTASSIGNINCOMECOLORINDEX @"nextAssignIncomeColorIndex"
#define NEXTASSIGNEXPENSECOLORINDEX @"nextAssignExpenseColorIndex"



+ (void)setNextAssignIncomeColorIndex:(NSInteger)nextAssignIncomeColorIndex
{
    NSNumber *number = [NSNumber numberWithInteger:nextAssignIncomeColorIndex];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:NEXTASSIGNINCOMECOLORINDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)nextAssignIncomeColorIndex
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:NEXTASSIGNINCOMECOLORINDEX];
    return  number.integerValue;
}

+ (void)setNextAssignExpenseColorIndex:(NSInteger)nextAssignExpenseColorIndex
{
    NSNumber *number = [NSNumber numberWithInteger:nextAssignExpenseColorIndex];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:NEXTASSIGNEXPENSECOLORINDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)nextAssignExpenseColorIndex
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:NEXTASSIGNEXPENSECOLORINDEX];
    return  number.integerValue;
}



@end
