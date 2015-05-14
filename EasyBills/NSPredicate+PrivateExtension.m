//
//  NSPredicate+PrivateExtension.m
//  EasyBills
//
//  Created by luojie on 5/3/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSPredicate+PrivateExtension.h"
#import "NSNumber+PrivateExtension.h"

@implementation NSPredicate (PrivateExtension)



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
                              withDate:(NSDate *) date
{
    NSPredicate *dateModePredicate;
    
    switch (dateMode) {
        case week:
            dateModePredicate = [NSPredicate predicateWithFormat:@"weekID = %@",[NSNumber weekIDWithDate:date]];
            break;
        case month:
            dateModePredicate = [NSPredicate predicateWithFormat:@"monthID = %@",[NSNumber monthIDWithDate:date]];
            break;
        default:
            dateModePredicate = [NSPredicate predicateWithFormat:@"yearID = %@",[NSNumber yearIDWithDate:date]];
            break;
    }
    return dateModePredicate;
}

+(NSPredicate *)predicateStyle:(NSInteger) predicateStyle withDate:(NSDate *) date
{
    NSPredicate *predicate;
    
    switch (predicateStyle) {
        case predicateDayStyle:
            predicate = [NSPredicate predicateWithFormat:@"dayID = %@",[NSNumber dayIDWithDate:date]];
            break;
        case predicateWeekStyle:
            predicate = [NSPredicate predicateWithFormat:@"weekID = %@",[NSNumber weekIDWithDate:date]];
            break;
        case predicateWeekInMonthStyle:
            predicate = [NSPredicate predicateWithFormat:@"(monthID = %@) && (weekID = %@)",[NSNumber monthIDWithDate:date],[NSNumber weekIDWithDate:date]];
            break;
        default:
            predicate = [NSPredicate predicateWithFormat:@"monthID = %@",[NSNumber monthIDWithDate:date]];
            break;
    }
    return predicate;
}


+ (NSPredicate *)predicateByCombinePredicate:(NSPredicate *)predicate
                               withPredicate:(NSPredicate *)otherPredicate;
{
    
    NSPredicate *result;
    if (otherPredicate) {
        if (predicate) {
            //incomeModePredicate and dateModePredicate all
            NSArray *array = @[otherPredicate,predicate];
            result =[NSCompoundPredicate andPredicateWithSubpredicates:array];
        }else{
            //incomeModePredicate only
            result = otherPredicate;
        }
        
    }else{
        if (predicate) {
            //dateModePredicate only
            result = predicate;
        }else{
            //all nil
            result = nil;
        }
    }
    return result;
    
}


+(NSNumber *)thisWeekID
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear
                                                fromDate:[NSDate date]];
    NSInteger years = [components year];
    NSInteger weekOfYear = [components weekOfYear];
    NSInteger result = years * 1000 + weekOfYear;
    return [NSNumber numberWithInteger:result];
    
}

+(NSNumber *)thisMonthID
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth
                                                fromDate:[NSDate date]];
    NSInteger years = [components year];
    NSInteger month = [components month];
    NSInteger result = years * 1000 + month;
    return [NSNumber numberWithInteger:result];
}




@end
