//
//  NSString+Extension.m
//  EasyBills
//
//  Created by luojie on 4/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)stringForPlacemark:(CLPlacemark *)placemark {
    
    NSMutableString *string = [[NSMutableString alloc] init];
    
    
    if (placemark.thoroughfare) {
        [string appendString:placemark.thoroughfare];
    }
    
    if (placemark.locality) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendString:placemark.locality];
    }
    
    if (placemark.administrativeArea) {
        if (string.length > 0)
            [string appendString:@", "];
        [string appendString:placemark.administrativeArea];
    }
    
    
    if (string.length == 0 && placemark.name)
        [string appendString:placemark.name];
    
    return string;
}

@end
