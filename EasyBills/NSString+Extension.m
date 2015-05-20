//
//  NSString+Extension.m
//  EasyBills
//
//  Created by luojie on 4/9/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (NSString *)stringWithCurrencyStyleForFloat:(float)floatValue {
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
    [currencyFormatter setMaximumFractionDigits:0];
    [currencyFormatter setMinimumFractionDigits:0];
    [currencyFormatter setAlwaysShowsDecimalSeparator:NO];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    NSNumber *someAmount = [NSNumber numberWithFloat:floatValue];
    NSString *string = [currencyFormatter stringFromNumber:someAmount];
    return string;
}

+ (NSString *)stringForFloat:(float)floatValue {
    NSNumber *number = [NSNumber numberWithFloat:floatValue];
    return [self stringForNumber:number];
}

+ (NSString *)stringForNumber:(NSNumber *)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setAlwaysShowsDecimalSeparator:NO];

    NSString *formattedNumberString = [numberFormatter stringFromNumber:number];
    return  formattedNumberString;
}


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

- (NSString *)trimmedString{
    return [self stringByTrimmingCharactersInSet:
            [NSCharacterSet whitespaceCharacterSet]];
}


- (void)drawInMacCoordinateAtPoint:(CGPoint)point
                    withAttributes:(NSDictionary *)attributes{
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGFloat pointY = point.y;
    
    CGContextSaveGState(currentContext);
    
    CGContextScaleCTM(currentContext,
                      1.0f,
                      -1.0f);
    
    CGContextTranslateCTM(currentContext,
                          0.0f,
                          -2 * pointY);
    
    [self drawAtPoint:point
       withAttributes:attributes];
    
    CGContextRestoreGState(currentContext);
    
}

@end
