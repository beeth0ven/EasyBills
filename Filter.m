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
            result = @[@"全部",
                       @"本周",
                       @"本月"];
            break;
        }
        default:{
            result = @[
//                       @"全部",
                       @"支出",
                       @"收入" ];
            break;
        }
    }
    
    return result;
}



+ (NSArray *)names {
    return @[@"时间",
             @"分类"];
}


@end
