//
//  Kind.h
//  EasyBills
//
//  Created by Beeth0ven on 3/6/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill;

@interface Kind : NSManagedObject

@property (nonatomic, retain) NSNumber * colorID;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * isIncome;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * visiteTime;
@property (nonatomic, retain) NSSet *bills;
@end

@interface Kind (CoreDataGeneratedAccessors)

- (void)addBillsObject:(Bill *)value;
- (void)removeBillsObject:(Bill *)value;
- (void)addBills:(NSSet *)values;
- (void)removeBills:(NSSet *)values;

@end
