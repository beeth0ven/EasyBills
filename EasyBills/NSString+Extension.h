//
//  NSString+Extension.h
//  EasyBills
//
//  Created by luojie on 4/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSString (Extension)

+ (NSString *)stringWithCurrencyStyleForFloat:(float)floatValue;
+ (NSString *)stringForFloat:(float)floatValue;
+ (NSString *)stringForNumber:(NSNumber *)number;
+ (NSString *)stringForPlacemark:(CLPlacemark *)placemark;
- (NSString *)trimmedString;

- (void)drawInMacCoordinateAtPoint:(CGPoint)point
                    withAttributes:(NSDictionary *)attributes;

@end
