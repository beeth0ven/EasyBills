//
//  NSManagedObject+Extension.h
//  EasyBills
//
//  Created by luojie on 5/4/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Extension)

- (void)moveAllRelatedObectsTo:(NSManagedObject *)destinationManagedObject;

@end
