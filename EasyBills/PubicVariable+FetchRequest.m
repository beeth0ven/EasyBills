//
//  PubicVariable+FetchRequest.m
//  我的账本
//
//  Created by 罗 杰 on 9/21/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "PubicVariable+FetchRequest.h"

@implementation PubicVariable (FetchRequest)

+(float) sumMoneyWithKind:(Kind *) kind
{
    float result = 0.0f;

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Bill"];
    request.predicate = [NSPredicate predicateWithFormat:@"kind = %@" , kind];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"money"];
    NSExpression *sumMoneyExpression = [NSExpression expressionForFunction:@"sum:"
                                                                 arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"sumMoney"];[expressionDescription setExpression:sumMoneyExpression];
    [expressionDescription setExpressionResultType:NSFloatAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    [request setResultType:NSDictionaryResultType];
    
    
    NSError *error = nil;
    NSArray *objects = [[PubicVariable managedObjectContext] executeFetchRequest:request error:&error];
    
    if (objects == nil) {
        // Handle the error.
    }else {
        if ([objects count] > 0) {
            result  = [[[objects objectAtIndex:0] valueForKey:@"sumMoney"] floatValue];
        }
    }
    
    return result;
    
}



+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode withDateMode:(NSInteger) dateMode
{
    NSPredicate *incomePredicate = [self predicateWithIncomeMode:incomeMode];
    NSPredicate *datePredicate = [self predicateWithbDateMode:dateMode];
    NSPredicate *predicate = [self addPredicate:incomePredicate withPredicate:datePredicate];
    return [self performeFetchForFunction:@"sum:" WithPredicate:predicate];
    
}



+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode withStyle:(NSInteger) predicateStyle withDate:(NSDate *) date
{
    NSPredicate *incomePredicate = [self predicateWithIncomeMode:incomeMode];
    NSPredicate *datePredicate = [self predicateStyle:predicateStyle withDate:date];
    NSPredicate *predicate = [self addPredicate:incomePredicate withPredicate:datePredicate];
    return [self performeFetchForFunction:@"sum:" WithPredicate:predicate];;
    
}




+(float) performeFetchForFunction:(NSString *)name WithPredicate:(NSPredicate *)predicate
{
    float result = 0.0f;
    
    if ([name isEqualToString:@"sum:"]|[name isEqualToString:@"max:"]|[name isEqualToString:@"min:"] )
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:[PubicVariable managedObjectContext]];
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"money"];
        NSExpression *sumMoneyExpression = [NSExpression expressionForFunction:name
                                                                     arguments:[NSArray arrayWithObject:keyPathExpression]];
        
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        [expressionDescription setName:@"sumMoney"];[expressionDescription setExpression:sumMoneyExpression];
        [expressionDescription setExpressionResultType:NSFloatAttributeType];
        
        [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
        
        [request setResultType:NSDictionaryResultType];
        
        
        NSError *error = nil;
        NSArray *objects = [[PubicVariable managedObjectContext] executeFetchRequest:request error:&error];
        
        if (objects == nil) {
            // Handle the error.
        }else {
            if ([objects count] > 0) {
                result  = [[[objects objectAtIndex:0] valueForKey:@"sumMoney"] floatValue];
            }
        }
    }
    
    
    return result;
}


+(NSPredicate *)predicateWithIncomeMode:(NSInteger)incomeMode
{
    NSPredicate *incomeModePredicate;
    
    switch (incomeMode) {
        case isIncomeYes:
            incomeModePredicate = [NSPredicate predicateWithFormat:@"isIncome = %@",@YES];
            break;
        case isIncomeNo:
            incomeModePredicate = [NSPredicate predicateWithFormat:@"isIncome = %@",@NO];
            break;
        default:
            incomeModePredicate = nil;
            break;
    }
    return incomeModePredicate;
}

+(NSPredicate *)predicateWithbDateMode:(NSInteger) dateMode
{
    NSPredicate *dateModePredicate;
    
    switch (dateMode) {
        case week:
            dateModePredicate = [NSPredicate predicateWithFormat:@"weekID = %@",[self thisWeekID]];
            break;
        case month:
            dateModePredicate = [NSPredicate predicateWithFormat:@"monthID = %@",[self thisMonthID]];
            break;
        default:
            dateModePredicate = nil;
            break;
    }
    return dateModePredicate;
}

+(NSPredicate *)predicateStyle:(NSInteger) predicateStyle withDate:(NSDate *) date
{
    NSPredicate *predicate;
    
    switch (predicateStyle) {
        case predicateDayStyle:
            predicate = [NSPredicate predicateWithFormat:@"dayID = %@",[self dayIDWithDate:date]];
            break;
        case predicateWeekStyle:
            predicate = [NSPredicate predicateWithFormat:@"weekID = %@",[self weekIDWithDate:date]];
            break;
        case predicateWeekInMonthStyle:
            predicate = [NSPredicate predicateWithFormat:@"(monthID = %@) && (weekID = %@)",[self monthIDWithDate:[NSDate date]],[self weekIDWithDate:date]];
            break;
        default:
            predicate = [NSPredicate predicateWithFormat:@"monthID = %@",[self monthIDWithDate:date]];
            break;
    }
    return predicate;
}


+(NSPredicate *)addPredicate:(NSPredicate *)firstPredicate withPredicate:(NSPredicate *) secondPredicate
{

    NSPredicate *predicate;
    if (firstPredicate) {
        if (secondPredicate) {
            //incomeModePredicate and dateModePredicate all
            NSArray *array = @[firstPredicate,secondPredicate];
            predicate =[NSCompoundPredicate andPredicateWithSubpredicates:array];
        }else{
            //incomeModePredicate only
            predicate =firstPredicate;
        }
        
    }else{
        if (secondPredicate) {
            //dateModePredicate only
            predicate =secondPredicate;
        }else{
            //all nil
            predicate = nil;
        }
    }
    return predicate;
    
}


+(NSNumber *)thisWeekID
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSWeekOfYearCalendarUnit
                                                    fromDate:[NSDate date]];
    NSInteger years = [components year];
    NSInteger weekOfYear = [components weekOfYear];
    NSInteger result = years * 1000 + weekOfYear;
    return [NSNumber numberWithInteger:result];

}

+(NSNumber *)thisMonthID
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit
                                                    fromDate:[NSDate date]];
    NSInteger years = [components year];
    NSInteger month = [components month];
    NSInteger result = years * 1000 + month;
    return [NSNumber numberWithInteger:result];
}


+(NSNumber *)dayIDWithDate:(NSDate *)date
{
    if (date == nil) return nil;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:date];
    NSInteger years = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    NSInteger result = years * 1000 * 1000+ month* 1000 + day;
    return [NSNumber numberWithInteger:result];
}

+(NSNumber *)weekIDWithDate:(NSDate *)date
{
    if (date == nil) return nil;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSWeekOfYearCalendarUnit
                                                fromDate:date];
    NSInteger years = [components year];
    NSInteger weekOfYear = [components weekOfYear];
    NSInteger result = years * 1000 + weekOfYear;
    return [NSNumber numberWithInteger:result];
}

+(NSNumber *)monthIDWithDate:(NSDate *)date
{
    //if (date == nil) return nil;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit
                                                fromDate:date];
    NSInteger years = [components year];
    NSInteger month = [components month];
    NSInteger result = years * 1000 + month;
    return [NSNumber numberWithInteger:result];
}

+(NSNumber *)weekdayWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit
                                                fromDate:date];
    NSInteger weekday  = [components weekday];
    return [NSNumber numberWithInteger:weekday];
}

+(NSNumber *)weekOfMonthWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekOfMonthCalendarUnit
                                                fromDate:date];
    NSInteger weekOfMonth   = [components weekOfMonth];
    return [NSNumber numberWithInteger:weekOfMonth];
}

+(NSNumber *)monthWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit
                                                fromDate:date];
    NSInteger month  = [components month];
    return [NSNumber numberWithInteger:month];
}




@end
