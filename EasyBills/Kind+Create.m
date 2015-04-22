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

+ (Kind *) kindWithName:(NSString *)name isIncome:(BOOL) isIncome
{
    Kind *kind = nil;
    
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND isIncome = %@",name,[NSNumber numberWithBool:isIncome]];
        
        NSError *error = nil;
        NSArray *matches = [[PubicVariable managedObjectContext] executeFetchRequest:request error:&error];
        
        
        if (!matches || [matches count] > 1) {
            //error
        }else if ([matches count] == 0){
            
            kind = [NSEntityDescription insertNewObjectForEntityForName:@"Kind" inManagedObjectContext:[PubicVariable managedObjectContext]];
            kind.name  = name;
            kind.createDate = [NSDate date];
            kind.isIncome = [NSNumber numberWithBool: isIncome];
            kind.colorID = [ColorCenter assingColorIDIsIncome:isIncome];
            [PubicVariable saveContext];
        }else if ([matches count] == 1){
            kind = [matches lastObject];
        }
    }
    return kind;
}

- (UIColor *)color{
    
    return [ColorCenter colorWithID:self.colorID];
    
}

- (NSString *)isIncomeDescription {
    return self.isIncome.boolValue ? @"收入": @"支出";
    
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


+ (void) kindWithNames:(NSArray *)names isIncome:(BOOL) isIncome
{
    for (id object in names) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString *name = object;
            [self kindWithName:name isIncome:isIncome];
            
        }
    }
}

+ (Kind *) lastVisiteKindIsIncome:(BOOL) isIncome
{
    Kind *kind = nil;

    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"visiteTime" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"isIncome = %@",[NSNumber numberWithBool:isIncome]];
    
    NSError *error = nil;
    NSArray *matches = [[PubicVariable managedObjectContext] executeFetchRequest:request error:&error];
    
    NSLog(@"isincome: %i", isIncome);
    NSLog(@"matches: %lu", (unsigned long)[matches count]);
    
    //NSLog(@"isincome: %i", isIncome);
    
    if ([matches count] == 0){
        kind = [Kind kindWithName:@"其他" isIncome:isIncome];
    }else {
        kind = [matches lastObject];
    }
    
    return kind;
    
    
}

+(NSFetchedResultsController *)fetchedResultsControllerIsincome:(BOOL) isIncome
{
    NSFetchedResultsController *fetchedResultsController = [self performFetchIsincome:isIncome];
    
    NSError *error;
    [fetchedResultsController performFetch:&error];
    
    return fetchedResultsController;
    
}

+ (BOOL) kindIsExistedWithName:(NSString *)name isIncome:(BOOL) isIncome
{
    BOOL result = NO;
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        request.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND isIncome = %@",name,[NSNumber numberWithBool:isIncome]];
        
        NSError *error = nil;
        NSArray *matches = [[PubicVariable managedObjectContext] executeFetchRequest:request error:&error];
        
        
        if ([matches count] == 1){
            result = YES;
        }
    }
    return result;
}



+(NSFetchedResultsController *)performFetchIsincome:(BOOL) isIncome
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Kind"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"isIncome = %@",[NSNumber numberWithBool:isIncome]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:[PubicVariable managedObjectContext]
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    NSError *error;
    [fetchedResultsController performFetch:&error];
    return fetchedResultsController;
}

@end
