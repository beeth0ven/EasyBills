//
//  NSManagedObjectContext+Extension.h
//  EasyBills
//
//  Created by luojie on 5/1/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Extension)

- (void)passToViewController:(UIViewController *)toViewController;

@end
