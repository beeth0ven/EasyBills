//
//  Bill.h
//  EasyBills
//
//  Created by Beeth0ven on 3/6/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Kind;

@interface Bill : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * dayID;
@property (nonatomic, retain) NSNumber * isIncome;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSNumber * locationIsOn;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * monthID;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSNumber * weekday;
@property (nonatomic, retain) NSNumber * weekID;
@property (nonatomic, retain) NSNumber * weekOfMonth;
@property (nonatomic, retain) Kind *kind;

@end
