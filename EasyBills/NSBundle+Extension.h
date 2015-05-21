//
//  NSBundle+Extension.h
//  SimpleBilling
//
//  Created by luojie on 5/21/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kLocalizedStringNotFound;

@interface NSBundle (Extension)

+ (NSString *)localizedStringForKey:(NSString *)key
                              value:(NSString *)value
                              table:(NSString *)tableName
                       backupBundle:(NSBundle *)bundle;

@end
