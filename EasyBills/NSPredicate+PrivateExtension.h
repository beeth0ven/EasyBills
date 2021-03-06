//
//  NSPredicate+PrivateExtension.h
//  EasyBills
//
//  Created by luojie on 5/3/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubicVariable+FetchRequest.h"

@interface NSPredicate (PrivateExtension)

+ (NSPredicate *)predicateWithIncomeMode:(NSInteger)incomeMode;
+ (NSPredicate *)predicateWithbDateMode:(NSInteger) dateMode
                              withDate:(NSDate *) date;
+ (NSPredicate *)predicateStyle:(NSInteger) predicateStyle withDate:(NSDate *) date;
+ (NSPredicate *)predicateByCombinePredicate:(NSPredicate *)predicate
                               withPredicate:(NSPredicate *)otherPredicate;
@end
