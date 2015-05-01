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
@implementation Bill (Create)

+ (Bill *) billIsIncome:(BOOL)isIncome
 inManagedObjectContext:(NSManagedObjectContext *)context
{
    
    Bill *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:self.managedObjectContext];
    Kind *lastVisiteKind = [Kind lastVisiteKindIsIncome:isIncome];
    bill.kind = lastVisiteKind;
    bill.createDate = [NSDate date];
    [bill setDateAttributes:[NSDate date]];
    bill.isIncome = [NSNumber numberWithBool:isIncome];
//    [PubicVariable saveContext];
    return bill;
}

-(void)setDateAttributes:(NSDate *)date
{
    self.date = date;
    self.dayID =  [PubicVariable dayIDWithDate:self.date];
    self.weekID = [PubicVariable weekIDWithDate:self.date];
    self.monthID = [PubicVariable monthIDWithDate:self.date];
    self.weekday = [PubicVariable weekdayWithDate:self.date];
    self.weekOfMonth = [PubicVariable weekOfMonthWithDate:self.date];
    self.month = [PubicVariable monthWithDate:self.date];
}


+ (NSArray *) billsWithDateMode:(NSInteger) dateMode
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    request.predicate = [PubicVariable predicateWithbDateMode:dateMode];
    
    NSError *error = nil;
    NSArray *matches = [[PubicVariable managedObjectContext] executeFetchRequest:request error:&error];
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



+ (Bill *) lastCreateBill
{
    Bill *bill = nil;
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Bill"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]];
    request.predicate = nil;
    
    NSError *error = nil;
    NSArray *matches = [[PubicVariable managedObjectContext] executeFetchRequest:request error:&error];
    
    NSLog(@"matches: %lu", (unsigned long)[matches count]);
    
    
    if ([matches count] > 1){
        NSInteger index = [matches count] - 2;
        bill = matches[index];
        
    }
    
    return bill;
}



@end
