//
//  ChartDate.h
//  我的账本
//
//  Created by 罗 杰 on 9/21/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubicVariable.h"

@interface ChartDate : NSObject

@property (readonly, strong, nonatomic) NSArray *xLabels;
@property (readonly, strong, nonatomic) NSArray *incomeDataArray;
@property (readonly, strong, nonatomic) NSArray *expenseDataArray;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
