//
//  PubicVariable.h
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>






@interface PubicVariable : NSObject

enum :NSInteger{
    isIncomeNo,
    isIncomeYes,
    isIncomeNil
};

enum :NSInteger{
    week,
    month,
    all
};

enum :NSInteger{
    predicateDayStyle,
    predicateWeekStyle,
    predicateWeekInMonthStyle,
    predicateMonthStyle
};

+ (PubicVariable *)pubicVariable;
+ (NSManagedObjectContext *)managedObjectContext;
+ (void)saveContext;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (BOOL)managedObjectContextHasChanges;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic) BOOL managedObjectContextHasChanges;
@property (weak ,nonatomic) UITextField *activeField;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (void)setDateMode:(NSInteger)dateMode;
+ (NSInteger)dateMode;

+ (void)setKindIsIncome:(BOOL)isIncome;
+ (BOOL)kindIsIncome;

+ (void)setLastAssignIncomeColorIndex:(NSInteger)lastAssignIncomeColorIndex;
+ (NSInteger)lastAssignIncomeColorIndex;

+ (void)setLastAssignExpenseColorIndex:(NSInteger)lastAssignExpenseColorIndex;
+ (NSInteger)lastAssignExpenseColorIndex;

@end
