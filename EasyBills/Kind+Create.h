//
//  Kind+Create.h
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "Kind.h"
#import "PubicVariable.h"

@interface Kind (Create)

+ (Kind *)kindWithName:(NSString *)name isIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)kindWithNames:(NSArray *)names isIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Kind *)lastVisiteKindIsIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Kind *)lastCreateKindInManagedObjectContext:(NSManagedObjectContext *)context;
+ (BOOL)lastCreatedKindIsIncomeInManagedObjectContext:(NSManagedObjectContext *)context;

- (void)removeAllBills;
+ (void)createDefaultKindsInManagedObjectContext:(NSManagedObjectContext *)context;

+ (BOOL)kindIsExistedWithName:(NSString *)name isIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context;
- (BOOL)isUnique;


+(NSFetchedResultsController *)fetchedResultsControllerIsincome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context;

- (UIColor *)color;
- (void)calculatorSumMoney;
- (NSString *)isIncomeDescription;

- (void)updateUniqueIDIfNeeded;

@end
