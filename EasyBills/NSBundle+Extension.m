//
//  NSBundle+Extension.m
//  SimpleBilling
//
//  Created by luojie on 5/21/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

NSString * const kLocalizedStringNotFound = @"kLocalizedStringNotFound";

+ (NSString *)localizedStringForKey:(NSString *)key
                              value:(NSString *)value
                              table:(NSString *)tableName
                       backupBundle:(NSBundle *)bundle
{
    // First try main bundle
    NSString * string = [[NSBundle mainBundle] localizedStringForKey:key
                                                               value:kLocalizedStringNotFound
                                                               table:tableName];
    
    // Then try the backup bundle
    if ([string isEqualToString:kLocalizedStringNotFound])
    {
        string = [bundle localizedStringForKey:key
                                         value:kLocalizedStringNotFound
                                         table:tableName];
    }
    
    // Still not found?
    if ([string isEqualToString:kLocalizedStringNotFound])
    {
        NSLog(@"No localized string for '%@' in '%@'", key, tableName);
        string = value.length > 0 ? value : key;
    }
    
    return string;
}

@end
