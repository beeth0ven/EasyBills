//
//  PubicVariable+FetchRequest.m
//  我的账本
//
//  Created by 罗 杰 on 9/21/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "PubicVariable+FetchRequest.h"
#import "NSPredicate+PrivateExtension.h"

@implementation PubicVariable (FetchRequest)

+ (float)sumMoneyWithKind:(Kind *) kind
   inManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self sumMoneyWithKind:kind dateMode:all inManagedObjectContext:context];
    
}

+(float) sumMoneyWithKind:(Kind *) kind
                 dateMode:(NSInteger)dateMode
   inManagedObjectContext:(NSManagedObjectContext *)context

{
    float result = 0.0f;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Bill"];
    NSPredicate *kindPredicate = [NSPredicate predicateWithFormat:@"kind = %@" , kind];
    NSPredicate *datePredicate = [NSPredicate predicateWithbDateMode:dateMode];

    
    request.predicate = [kindPredicate predicateCombineWithPredicate:datePredicate];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"money"];
    NSExpression *sumMoneyExpression = [NSExpression expressionForFunction:@"sum:"
                                                                 arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    [expressionDescription setName:@"sumMoney"];[expressionDescription setExpression:sumMoneyExpression];
    [expressionDescription setExpressionResultType:NSFloatAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    [request setResultType:NSDictionaryResultType];
    
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (objects == nil) {
        // Handle the error.
    }else {
        if ([objects count] > 0) {
            result  = [[[objects objectAtIndex:0] valueForKey:@"sumMoney"] floatValue];
        }
    }
    
    return result;
    
}



+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode
                   withDateMode:(NSInteger) dateMode
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *incomePredicate = [NSPredicate predicateWithIncomeMode:incomeMode];
    NSPredicate *datePredicate = [NSPredicate predicateWithbDateMode:dateMode];
    NSPredicate *predicate = [incomePredicate predicateCombineWithPredicate:datePredicate];
    return [self performeFetchForFunction:@"sum:" WithPredicate:predicate inManagedObjectContext:context];
    
}



+(float) sumMoneyWithIncomeMode:(NSInteger)incomeMode
                      withStyle:(NSInteger) predicateStyle
                       withDate:(NSDate *) date
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSPredicate *incomePredicate = [NSPredicate predicateWithIncomeMode:incomeMode];
    NSPredicate *datePredicate = [NSPredicate predicateStyle:predicateStyle withDate:date];
    NSPredicate *predicate = [incomePredicate predicateCombineWithPredicate:datePredicate];
    return [self performeFetchForFunction:@"sum:" WithPredicate:predicate inManagedObjectContext:context];
    
}




+(float) performeFetchForFunction:(NSString *)name
                    WithPredicate:(NSPredicate *)predicate
           inManagedObjectContext:(NSManagedObjectContext *)context
{
    float result = 0.0f;
    
    if ([name isEqualToString:@"sum:"]|[name isEqualToString:@"max:"]|[name isEqualToString:@"min:"] )
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:context];
        [request setEntity:entity];
        [request setPredicate:predicate];
        
        
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"money"];
        NSExpression *sumMoneyExpression = [NSExpression expressionForFunction:name
                                                                     arguments:[NSArray arrayWithObject:keyPathExpression]];
        
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        [expressionDescription setName:@"sumMoney"];[expressionDescription setExpression:sumMoneyExpression];
        [expressionDescription setExpressionResultType:NSFloatAttributeType];
        
        [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
        
        [request setResultType:NSDictionaryResultType];
        
        
        NSError *error = nil;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if (objects == nil) {
            // Handle the error.
        }else {
            if ([objects count] > 0) {
                result  = [[[objects objectAtIndex:0] valueForKey:@"sumMoney"] floatValue];
            }
        }
    }
    
    
    return result;
}




@end
