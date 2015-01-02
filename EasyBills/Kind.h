//
//  Kind.h
//  EasyBills
//
//  Created by 罗 杰 on 10/10/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bill;

@interface Kind : NSManagedObject

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
