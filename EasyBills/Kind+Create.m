//
//  Kind+Create.m
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "Kind+Create.h"
#import "PubicVariable.h"
#import "ColorCenter.h"
#import "Bill+Create.h"

@implementation Kind (Create)




+ (Kind *)kindWithName:(NSString *)name isIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context
{
    Kind *kind = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND isIncome = %@",name,[NSNumber numberWithBool:isIncome]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if (!matches ) {
        //error
        NSLog(@"error: kind match");
    }else if ([matches count] > 1) {
        //error
        NSLog(@"error: kind match > 1");

    }else if ([matches count] == 0){
        
        kind = [NSEntityDescription insertNewObjectForEntityForName:@"Kind" inManagedObjectContext:context];
        kind.name  = name;
        kind.createDate = [NSDate date];
        kind.visiteTime = kind.createDate;
        kind.isIncome = [NSNumber numberWithBool: isIncome];
        kind.colorID = [ColorCenter assingColorIDIsIncome:isIncome];
        BOOL isDefault = [name isEqualToString:[self kKindDefaultName]] ? YES : NO;
        kind.isDefault = [NSNumber numberWithBool:isDefault];
        [kind updateUniqueIDIfNeeded];
        
    }else if ([matches count] == 1){
        kind = [matches lastObject];
    }
    return kind;
}

+ (Kind *)kindWithUniqueID:(NSString *)uniqueID inManagedObjectContext:(NSManagedObjectContext *)context
{
    Kind *kind = nil;
    NSLog(@"kindWithUniqueID: %@",uniqueID);

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uniqueID" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@",uniqueID];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if ([matches count] > 0 ) {
        kind = [matches lastObject];
        NSLog(@"Successfully get kind uniqueID: %@",uniqueID);

    } else {
        //error
        NSLog(@"Failed get kind uniqueID: %@",uniqueID);
    }
    return kind;
}


- (void)updateUniqueIDIfNeeded {
    NSString *uniqueID = [NSString stringWithFormat:@"%@|%@",
                        self.name.description,
                        self.isIncome.description];
    if (![self.uniqueID isEqualToString:uniqueID]) {
        self.uniqueID = uniqueID;
        NSLog(@"Successfully  Update Kind Unique: %@", self.uniqueID);
    }
}

- (UIColor *)color{
    
    return [ColorCenter colorWithID:self.colorID];
    
}

- (NSString *)isIncomeDescription {
    return self.isIncome.boolValue ? NSLocalizedString( @"Income", ""): NSLocalizedString( @"Expenses", "");
    
}


- (void)addBillsObject:(Bill *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"bills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"bills"] addObject:value];
    [self didChangeValueForKey:@"bills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [self calculatorSumMoney];
}

- (void)removeBillsObject:(Bill *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"bills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"bills"] removeObject:value];
    [self didChangeValueForKey:@"bills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [self calculatorSumMoney];

}

- (void)addBills:(NSSet *)values {
    [self willChangeValueForKey:@"bills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"bills"] unionSet:values];
    [self didChangeValueForKey:@"bills" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];
    [self calculatorSumMoney];

}

- (void)removeBills:(NSSet *)values {
    [self willChangeValueForKey:@"bills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"bills"] minusSet:values];
    [self didChangeValueForKey:@"bills" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];
    [self calculatorSumMoney];

}




- (void)calculatorSumMoney {
    __block float result = 0;
    [self.bills enumerateObjectsUsingBlock:^(Bill *obj, BOOL *stop) {
        result += obj.money.floatValue;
    }];
    self.sumMoney = [NSNumber numberWithFloat:result];
}


+ (void)kindWithNames:(NSArray *)names isIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context
{
    for (id object in names) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *name = object;
            [self kindWithName:name isIncome:isIncome inManagedObjectContext:context];
            
        }
    }
}


+ (Kind *)lastVisiteKindIsIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context
{
    Kind *kind = nil;

    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"isIncome = %@",[NSNumber numberWithBool:isIncome]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
//    NSLog(@"isincome: %i", isIncome);
//    NSLog(@"matches: %lu", (unsigned long)[matches count]);
    
    //NSLog(@"isincome: %i", isIncome);
    
    if ([matches count] == 0){
        kind =[self defaultKindIsIncome:isIncome inManagedObjectContext:context];
    }else {
        kind = [matches lastObject];
    }
    
    return kind;
    
    
}





+ (NSString *)kKindDefaultName {
    return NSLocalizedString( @"Others", "");
}

+ (Kind *)defaultKindIsIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context {
    Kind *kind;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"isDefault = %@ AND isIncome = %@",[NSNumber numberWithBool:YES],[NSNumber numberWithBool:isIncome]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    
    if ([matches count] > 1) {
        //error
        NSLog(@"error: kind match > 1");
        kind = [matches lastObject];
    }else if ([matches count] == 1){
        kind = [matches lastObject];
    }else if ([matches count] == 0){
        kind = [self kindWithName:[self kKindDefaultName] isIncome:isIncome inManagedObjectContext:context];
    }
    
    return kind;

}


+ (Kind *)lastCreateKindInManagedObjectContext:(NSManagedObjectContext *)context
{
    Kind *kind = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]];
    request.predicate = nil;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    

    if ([matches count] > 0){
        kind = [matches lastObject];
    }
    
    return kind;
}

+ (BOOL)lastCreatedKindIsIncomeInManagedObjectContext:(NSManagedObjectContext *)context
 {
    return [self lastCreateKindInManagedObjectContext:context].isIncome.boolValue;
}

- (void)removeAllBills {
    if (self.bills.count > 0) {
        Kind *kind = [Kind defaultKindIsIncome:self.isIncome.boolValue inManagedObjectContext:self.managedObjectContext];
//        [Kind kindWithName:@"其他" isIncome:self.isIncome.boolValue inManagedObjectContext:self.managedObjectContext];
//        [Kind kindWithName:@"其他" isIncome:self.isIncome.boolValue];
        [self.bills enumerateObjectsUsingBlock:^(Bill *bill, BOOL *stop) {
            bill.kind = kind;
        }];
    }
}



+ (BOOL)kindIsExistedWithName:(NSString *)name isIncome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self numberOfkindsWithName:name isIncome:isIncome inManagedObjectContext:context] >= 1;
}

- (BOOL)isUnique {
    return [Kind numberOfkindsWithName:self.name isIncome:self.isIncome.boolValue inManagedObjectContext:self.managedObjectContext] == 1;
}

+ (NSInteger)numberOfkindsWithName:(NSString *)name isIncome:(BOOL) isIncome  inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSInteger result = 0;
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND isIncome = %@",name,[NSNumber numberWithBool:isIncome]];
        
        NSError *error = nil;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        
        
        result = [matches count];
    }
    return result;
}


+ (void)createDefaultKindsInManagedObjectContext:(NSManagedObjectContext *)context
 {
    [self kindWithNames:[self incomeKinds] isIncome:YES inManagedObjectContext:context];
    [self kindWithNames:[self expenseKinds] isIncome:NO inManagedObjectContext:context];
}

+ (NSArray *)incomeKinds
{
    return @[
             NSLocalizedString( @"Wage", ""),
             NSLocalizedString( @"Gift", ""),
             NSLocalizedString( @"Others", "")];
}

+ (NSArray *)expenseKinds
{
    return @[
             NSLocalizedString( @"Entertainment", ""),
             NSLocalizedString( @"Clothes", ""),
             NSLocalizedString( @"Food", ""),
             NSLocalizedString( @"Gift", ""),
             NSLocalizedString( @"Others", "")];
}




+(NSFetchedResultsController *)fetchedResultsControllerIsincome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchedResultsController *fetchedResultsController = [self performFetchIsincome:isIncome inManagedObjectContext:context];
    
    NSError *error;
    [fetchedResultsController performFetch:&error];
    
    return fetchedResultsController;
    
}

+(NSFetchedResultsController *)performFetchIsincome:(BOOL) isIncome inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"isIncome = %@",[NSNumber numberWithBool:isIncome]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:context
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    NSError *error;
    [fetchedResultsController performFetch:&error];
    return fetchedResultsController;
}

@end
