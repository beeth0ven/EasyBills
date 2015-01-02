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
{
    Bill *bill = [NSEntityDescription insertNewObjectForEntityForName:@"Bill" inManagedObjectContext:[PubicVariable managedObjectContext]];
    Kind *lastVisiteKind = [Kind lastVisiteKindIsIncome:isIncome];
    bill.kind = lastVisiteKind;
    bill.createDate = [NSDate date];
    [bill setDateAttributes:[NSDate date]];
    bill.isIncome = [NSNumber numberWithBool:isIncome];
    bill.locationIsOn = [NSNumber numberWithBool:[self checkLocationState]];
    [PubicVariable saveContext];
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

+(BOOL)checkLocationState
{
    BOOL checkLocationState = NO;
    //last bill location state is on And location service enable, then bill location is on;
    Bill *lastCreateBill = [self lastCreateBill];
    NSLog(@"lastCreateBill.locationIsOn.boolValue: %i   %f" ,lastCreateBill.locationIsOn.boolValue ,lastCreateBill.money.floatValue);

    if (lastCreateBill.locationIsOn.boolValue) {
        if ([CLLocationManager locationServicesEnabled]) {
            checkLocationState = YES;
        }
    }
    
    
    return checkLocationState;
}

@end
