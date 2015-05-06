//
//  PubicVariable.h
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>



enum :NSInteger{
    isIncomeNo,
    isIncomeYes,
    isIncomeNil
} IsIncomeType;

enum :NSInteger{
    week,
    month,
    all
} DateMode;

enum :NSInteger{
    predicateDayStyle,
    predicateWeekStyle,
    predicateWeekInMonthStyle,
    predicateMonthStyle
} PredicateTimeStyle;



@interface PubicVariable : NSObject


+ (PubicVariable *)pubicVariable;

+ (NSString *)stringFromDate:(NSDate *)date;

+ (void)setDateMode:(NSInteger)dateMode;
+ (NSInteger)dateMode;

+ (void)setKindIsIncome:(BOOL)isIncome;
+ (BOOL)kindIsIncome;

+ (void)setNextAssignIncomeColorIndex:(NSInteger)nextAssignIncomeColorIndex;
+ (NSInteger)nextAssignIncomeColorIndex;

+ (void)setNextAssignExpenseColorIndex:(NSInteger)nextAssignExpenseColorIndex;
+ (NSInteger)nextAssignExpenseColorIndex;

+ (void)setiCloudEnable:(BOOL)enable;
+ (BOOL)iCloudEnable;

@end
