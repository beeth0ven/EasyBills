//
//  NSNumber+PrivateExtension.m
//  EasyBills
//
//  Created by luojie on 5/3/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSNumber+PrivateExtension.h"

@implementation NSNumber (PrivateExtension)




+(NSNumber *)dayIDWithDate:(NSDate *)date
{
    if (date == nil) return nil;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
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
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitWeekOfYear
                                                fromDate:date];
    NSInteger years = [components year];
    NSInteger weekOfYear = [components weekOfYear];
    NSInteger result = years * 1000 + weekOfYear;
    return [NSNumber numberWithInteger:result];
}

+(NSNumber *)monthIDWithDate:(NSDate *)date
{
    //if (date == nil) return nil;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth
                                                fromDate:date];
    NSInteger years = [components year];
    NSInteger month = [components month];
    NSInteger result = years * 1000 + month;
    return [NSNumber numberWithInteger:result];
}

+(NSNumber *)weekdayWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday
                                                fromDate:date];
    NSInteger weekday  = [components weekday];
    return [NSNumber numberWithInteger:weekday];
}

+(NSNumber *)weekOfMonthWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekOfMonth
                                                fromDate:date];
    NSInteger weekOfMonth   = [components weekOfMonth];
    return [NSNumber numberWithInteger:weekOfMonth];
}

+(NSNumber *)monthWithDate:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitMonth
                                                fromDate:date];
    NSInteger month  = [components month];
    return [NSNumber numberWithInteger:month];
}



@end
