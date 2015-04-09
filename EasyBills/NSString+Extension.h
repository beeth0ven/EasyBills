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

+ (NSString *)stringForPlacemark:(CLPlacemark *)placemark;

@end
