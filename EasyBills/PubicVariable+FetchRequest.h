//
//  PubicVariable+FetchRequest.h
//  我的账本
//
//  Created by 罗 杰 on 9/21/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "PubicVariable.h"
#import "Kind+Create.h"

@interface PubicVariable (FetchRequest)

+(float) sumMoneyWithKind:(Kind *) kind;
+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode withDateMode:(NSInteger) dateMode;
+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode withStyle:(NSInteger) predicateStyle withDate:(NSDate *) date;
+(float) performeFetchForFunction:(NSString *)name WithPredicate:(NSPredicate *)predicate;


+(NSPredicate *)predicateWithIncomeMode:(NSInteger)incomeMode;
+(NSPredicate *)predicateWithbDateMode:(NSInteger) dateMode;
+(NSPredicate *)predicateStyle:(NSInteger) predicateStyle withDate:(NSDate *) date;
+(NSPredicate *)addPredicate:(NSPredicate *)firstPredicate withPredicate:(NSPredicate *) secondPredicate;

+(NSNumber *)dayIDWithDate:(NSDate *)date;
+(NSNumber *)weekIDWithDate:(NSDate *)date;
+(NSNumber *)monthIDWithDate:(NSDate *)date;
+(NSNumber *)weekdayWithDate:(NSDate *)date;
+(NSNumber *)weekOfMonthWithDate:(NSDate *)date;
+(NSNumber *)monthWithDate:(NSDate *)date;

@end
