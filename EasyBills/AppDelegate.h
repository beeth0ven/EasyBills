//
//  AppDelegate.h
//  EasyBills
//
//  Created by 罗 杰 on 10/1/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PubicVariable.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSPersistentStore *persistentStore;

- (void)saveContext;
- (void)clearContext;
- (NSString *)applicationDocumentsDirectory;
- (NSURL *)applicationStoresDirectory;
- (NSURL *)storeURL;
- (BOOL)reloadStore;

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (weak, nonatomic, readonly) NSString *appVersion;



@end
