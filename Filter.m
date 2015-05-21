//
//  Filter.m
//  PopToFilter
//
//  Created by luojie on 3/29/15.
//  Copyright (c) 2015 luojie. All rights reserved.
//

#import "Filter.h"


@interface Filter ()

@end


@implementation Filter

+ (instancetype)filterWithType:(LJFilterType)type {
    Filter *result;
    result = [[self alloc] init];
    result.name = type < [[self names] count] ? [self names][type] : nil;
    result.filterTypes = [self filterTypesForType:type];
    return result;
}


+ (NSArray *)filterTypesForType:(LJFilterType)type {
    
    NSArray *result = nil;
    
    switch (type) {
        case LJFilterTime:{
            result = @[ NSLocalizedString(@"All", ""),
                        NSLocalizedString(@"This week", ""),
                        NSLocalizedString(@"This month", "")];
            break;
        }
        default:{
            result = @[
//                       @"全部",
                      NSLocalizedString(@"Expenses", ""),
                      NSLocalizedString(@"Income", "") ];
            break;
        }
    }
    
    return result;
}



+ (NSArray *)names {
    return @[NSLocalizedString( @"Date", ""),
             NSLocalizedString( @"Category", "")];
}


@end
