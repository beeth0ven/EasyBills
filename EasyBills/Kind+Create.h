//
//  Kind+Create.h
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "Kind.h"
#import "PubicVariable.h"

@interface Kind (Create)

+ (Kind *) kindWithName:(NSString *)name isIncome:(BOOL) isIncome;
+ (void) kindWithNames:(NSArray *)names isIncome:(BOOL) isIncome;
+ (Kind *) lastVisiteKindIsIncome:(BOOL) isIncome;

+ (BOOL) kindIsExistedWithName:(NSString *)name isIncome:(BOOL) isIncome;

+(NSFetchedResultsController *)fetchedResultsControllerIsincome:(BOOL) isIncome;



@end
