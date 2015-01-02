//
//  Bill+Create.h
//  我的账本
//
//  Created by 罗 杰 on 9/11/14.
//  Copyright (c) 2014 罗 杰. All rights reserved.
//

#import "Bill.h"
#import "PubicVariable.h"
#import <CoreLocation/CoreLocation.h>

#define BILL_DATE @"DATE"
#define BILL_ISINCOME @"ISINCOME"
#define BILL_MONEY @"MONEY"
#define BILL_NOTE @"NOTE"
#define BILL_KIND @"KIND"

@interface Bill (Create)

+ (Bill *) billIsIncome:(BOOL)isIncome;
+ (NSArray *) billsWithDateMode:(NSInteger) dateMode;


-(void)setDateAttributes:(NSDate *)date;
+ (Bill *) lastCreateBill;

@end
