//
//  NSDate+Extension.m
//  EasyBills
//
//  Created by luojie on 4/15/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


+ (NSInteger)numberOfDaysBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned int unitFlags = NSCalendarUnitDay;

    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return [components day];
}

+ (NSInteger)numberOfWeeksBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    unsigned int unitFlags = NSCalendarUnitWeekOfYear | NSCalendarUnitYear;

    NSDateComponents *components = [gregorianCalendar components:unitFlags
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    return [components weekOfYear] + [components year] * 52;
}

+ (NSDate *)yesterday {
    NSTimeInterval secendsFromNow = - 24 * 60 * 60;
    return [[NSDate date] dateByAddingTimeInterval:secendsFromNow];
}

+ (NSDate *)dayBeforeYesterday {
    NSTimeInterval secendsFromNow = -2 * 24 * 60 * 60;
    return [[NSDate date] dateByAddingTimeInterval:secendsFromNow];
}

+ (BOOL)isSameDay:(NSDate *)firstDate andDate:(NSDate *)secendDate {
    BOOL result = NO;
    
    if (!firstDate || !secendDate) {
        return result;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *firstDateComponents = [calendar components:unitFlags fromDate:firstDate];
    NSDateComponents *secendDateComponents = [calendar components:unitFlags fromDate:secendDate];
    
    if ([firstDateComponents year] == [secendDateComponents year] &&
        [firstDateComponents month] == [secendDateComponents month] &&
        [firstDateComponents day] == [secendDateComponents day]) {
        result = YES;
    }

    return result;
}

@end
