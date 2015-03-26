//
//  PubicVariable.m
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "PubicVariable.h"
#import "Kind+Create.h"



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
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString=[dateFormtter stringFromDate:date];
    return dateString;
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
//    NSDictionary *storeOptions =
//    @{NSPersistentStoreUbiquitousContentNameKey: @"MyAppCloudStore"};
    BOOL firstRun = ![storeURL checkResourceIsReachableAndReturnError:NULL];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
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
        
        [Kind kindWithNames:[PubicVariable incomeKinds] isIncome:YES];
        [Kind kindWithNames:[PubicVariable expenseKinds] isIncome:NO];
        [PubicVariable setLastAssignIncomeColorIndex:-1];
        [PubicVariable setLastAssignExpenseColorIndex:-1];
		[self saveContext];
	}
    return _persistentStoreCoordinator;
}



+(NSArray *)incomeKinds
{
    return @[@"工资",@"人情",@"其他"];
}

+(NSArray *)expenseKinds
{
    return @[@"衣服",@"餐饮",@"住宿",@"交通",@"人情",@"其他"];
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

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



#define LASTASSIGNINCOMECOLORINDEX @"lastAssignIncomeColorIndex"
#define LASTASSIGNEXPENSECOLORINDEX @"lastAssignExpenseColorIndex"



+ (void)setLastAssignIncomeColorIndex:(NSInteger)lastAssignIncomeColorIndex
{
    NSNumber *number = [NSNumber numberWithInteger:lastAssignIncomeColorIndex];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:LASTASSIGNINCOMECOLORINDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)lastAssignIncomeColorIndex
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:LASTASSIGNINCOMECOLORINDEX];
    return  number.integerValue;
}

+ (void)setLastAssignExpenseColorIndex:(NSInteger)lastAssignExpenseColorIndex
{
    NSNumber *number = [NSNumber numberWithInteger:lastAssignExpenseColorIndex];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:LASTASSIGNEXPENSECOLORINDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)lastAssignExpenseColorIndex
{
    NSNumber *number =[[NSUserDefaults standardUserDefaults] objectForKey:LASTASSIGNEXPENSECOLORINDEX];
    return  number.integerValue;
}

@end
