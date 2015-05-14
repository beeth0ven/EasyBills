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

+ (NSDate *)dateSinceNowByWeeks:(NSUInteger)weeks {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger day = 7 * weeks;
    [comps setDay:day];
    NSDate *date = [gregorian dateByAddingComponents:comps
                                              toDate:[NSDate date]
                                             options:0];
    return date;
}

+ (NSDate *)dateSinceNowByMonths:(NSUInteger)months {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger month = months;
    [comps setMonth:month];
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:[NSDate date]  options:0];
    return date;
}

+ (NSDate *)dateSinceNowByYears:(NSUInteger)years {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger year = years;
    [comps setYear:year];
    NSDate *date = [gregorian dateByAddingComponents:comps toDate:[NSDate date]  options:0];
    return date;
}

- (void)showDetail {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:
                                    NSCalendarUnitWeekOfMonth |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitYear |
                                    NSCalendarUnitDay
                                                fromDate:self];
        
    NSLog(@"year:%i month:%i day:%i",
          [components year],
          [components month],
          [components day]
          );
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

- (NSDate *)lastDayOfMonth {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar
                               components:NSCalendarUnitYear
                               |NSCalendarUnitMonth
                               |NSCalendarUnitWeekOfYear
                               |NSCalendarUnitWeekday
                               fromDate:self]; // Get necessary date components
    
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    return [calendar dateFromComponents:comps];
}

- (NSDate *)firstDayOfMonth {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar
                               components:NSCalendarUnitYear
                               |NSCalendarUnitMonth
                               |NSCalendarUnitWeekOfYear
                               |NSCalendarUnitWeekday
                               fromDate:self]; // Get necessary date components
    
    [comps setDay:1];
    return [calendar dateFromComponents:comps];
}

- (NSDate *)firstDayOfYear {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar
                               components:NSCalendarUnitYear
                               |NSCalendarUnitMonth
                               |NSCalendarUnitWeekOfYear
                               |NSCalendarUnitWeekday
                               fromDate:self]; // Get necessary date components
    
    [comps setMonth:1];
    [comps setDay:1];
    return [calendar dateFromComponents:comps];
}

- (NSDate *)lastDayOfYear {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar
                               components:NSCalendarUnitYear
                               |NSCalendarUnitMonth
                               |NSCalendarUnitWeekOfYear
                               |NSCalendarUnitWeekday
                               fromDate:self]; // Get necessary date components
    
    [comps setYear:[comps year]+1];
    [comps setMonth:1];
    [comps setDay:0];
    return [calendar dateFromComponents:comps];
}

@end
