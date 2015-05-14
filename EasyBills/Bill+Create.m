//
//  Bill+Create.m
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "Bill+Create.h"
#import "Kind+Create.h"
#import "PubicVariable+FetchRequest.h"
#import "NSNumber+PrivateExtension.h"
#import "NSPredicate+PrivateExtension.h"


@implementation Bill (Create)

+ (Bill *) billIsIncome:(BOOL)isIncome
 inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Bill *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:context];
    Kind *lastVisiteKind = [Kind lastVisiteKindIsIncome:isIncome inManagedObjectContext:context];
    bill.kind = lastVisiteKind;
    bill.createDate = [NSDate date];
    [bill setDateAttributes:[NSDate date]];
    bill.isIncome = [NSNumber numberWithBool:isIncome];
    [bill updateUniqueIDIfNeeded];
    return bill;
}

-(void)setDateAttributes:(NSDate *)date
{
    self.date = date;
    self.dayID =  [NSNumber dayIDWithDate:self.date];
    self.weekID = [NSNumber weekIDWithDate:self.date];
    self.monthID = [NSNumber monthIDWithDate:self.date];
    self.yearID = [NSNumber yearIDWithDate:self.date];
    self.weekday = [NSNumber weekdayWithDate:self.date];
    self.weekOfMonth = [NSNumber weekOfMonthWithDate:self.date];
    self.month = [NSNumber monthWithDate:self.date];
}


+ (NSArray *)billsWithDateMode:(NSInteger) dateMode
        inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    request.predicate = [NSPredicate predicateWithbDateMode:dateMode withDate:[NSDate date]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    NSLog(@"billsCount: %lu",(unsigned long)matches.count);
    return matches;
}



- (void)setMoney:(NSNumber *)money
{
    [self willChangeValueForKey:@"money"];
    [self setPrimitiveValue:money forKey:@"money"];
    [self didChangeValueForKey:@"money"];
    [self.kind calculatorSumMoney];
}



+ (Bill *) lastCreateBillInManagedObjectContext:(NSManagedObjectContext *)context
{
    Bill *bill = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]];
    request.predicate = nil;
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
//    NSLog(@"matches: %lu", (unsigned long)[matches count]);
    
    
    if ([matches count] > 1){
        NSInteger index = [matches count] - 2;
        bill = matches[index];
        
    }
    
    return bill;
}

- (void)updateUniqueIDIfNeeded {
    NSString *uniqueID = [NSString stringWithFormat:@"%@|%@|%@|%@",
                        self.money.description,
                        self.kind.name.description,
                        self.dayID.description,
                        self.note.description];
    if (![self.uniqueID isEqualToString:uniqueID]) {
        self.uniqueID = uniqueID;
        NSLog(@"Successfully  Update Bill Unique: %@", self.uniqueID);
    }
    
    if (self.kind) {
        [self.kind updateUniqueIDIfNeeded];
        if (self.kindUniqueID != self.kind.uniqueID) {
            self.kindUniqueID = self.kind.uniqueID;
        }
        
    }
}

- (void)addMissedKind {
    Kind *kind = [Kind kindWithUniqueID:self.kindUniqueID inManagedObjectContext:self.managedObjectContext];
    if (kind == nil)
        kind = [Kind defaultKindIsIncome:self.isIncome.boolValue inManagedObjectContext:self.managedObjectContext];
    self.kind = kind;
    NSLog(@"Successfully Add Missed Kind Name: %@",kind.name);
}


@end
