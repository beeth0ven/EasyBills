//
//  NSNumber+PrivateExtension.h
//  EasyBills
//
//  Created by luojie on 5/3/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (PrivateExtension)



+(NSNumber *)dayIDWithDate:(NSDate *)date;
+(NSNumber *)weekIDWithDate:(NSDate *)date;
+(NSNumber *)monthIDWithDate:(NSDate *)date;
+(NSNumber *)yearIDWithDate:(NSDate *)date;
+(NSNumber *)weekdayWithDate:(NSDate *)date;
+(NSNumber *)weekOfMonthWithDate:(NSDate *)date;
+(NSNumber *)monthWithDate:(NSDate *)date;




@end
