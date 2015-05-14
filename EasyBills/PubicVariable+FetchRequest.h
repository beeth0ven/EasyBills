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

+(float) sumMoneyWithKind:(Kind *) kind
   inManagedObjectContext:(NSManagedObjectContext *)context;

+(float) sumMoneyWithKind:(Kind *) kind
                 dateMode:(NSInteger)dateMode
   inManagedObjectContext:(NSManagedObjectContext *)context;

+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode
                   withDateMode:(NSInteger) dateMode
                       withDate:(NSDate *) date
         inManagedObjectContext:(NSManagedObjectContext *)context;

+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode
                      withStyle:(NSInteger) predicateStyle
                       withDate:(NSDate *) date
         inManagedObjectContext:(NSManagedObjectContext *)context;

+(float) performeFetchForFunction:(NSString *)name
                    WithPredicate:(NSPredicate *)predicate
           inManagedObjectContext:(NSManagedObjectContext *)context;


@end
