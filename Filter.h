//
//  Filter.h
//  PopToFilter
//
//  Created by luojie on 3/29/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    LJFilterTime = 0,
    LJFilterKind,
} LJFilterType;

typedef enum : NSInteger {
    LJTimeFilterTypeAll = 0,
    LJTimeFilterTypeWeek,
    LJTimeFilterTypeMonth,
} LJTimeFilterType;


typedef enum : NSInteger {
    LJKindFilterTypeExpenses = 0,
    LJKindFilterTypeIncome,
} LJKindFilterType;

@interface Filter : NSObject

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSArray *filterTypes;

@property (nonatomic) NSInteger selectIndex;


+ (instancetype)filterWithType:(LJFilterType)type;


@end
