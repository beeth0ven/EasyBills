//
//  NSDate+Extension.h
//  EasyBills
//
//  Created by luojie on 4/15/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

+ (NSInteger)numberOfDaysBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSInteger)numberOfWeeksBetweenStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

+ (NSDate *)yesterday;

+ (NSDate *)dayBeforeYesterday;


+ (NSDate *)dateSinceNowByWeeks:(NSUInteger)weeks;

+ (NSDate *)dateSinceNowByMonths:(NSUInteger)months;

+ (NSDate *)dateSinceNowByYears:(NSUInteger)years;
   
- (void)showDetail;

+ (BOOL)isSameDay:(NSDate *)firstDate andDate:(NSDate *)secendDate;

- (NSDate *)lastDayOfMonth;

- (NSDate *)firstDayOfMonth;

- (NSDate *)firstDayOfYear;

- (NSDate *)lastDayOfYear;
@end
