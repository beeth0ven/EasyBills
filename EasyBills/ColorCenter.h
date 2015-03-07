//
//  ColorCenter.h
//  EasyBills
//
//  Created by Beeth0ven on 3/5/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PubicVariable+FetchRequest.h"

@interface ColorCenter : NSObject

+ (NSArray *)colors;

+ (UIColor *)colorWithID:(NSNumber *)colorID;
+ (NSNumber *)assingColorIDIsIncome:(BOOL) isIncome;

@end
