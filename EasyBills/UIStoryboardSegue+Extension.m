//
//  UIStoryboardSegue+Extension.m
//  EasyBills
//
//  Created by luojie on 5/1/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIStoryboardSegue+Extension.h"
#import "UIViewController+Extension.h"
#import "NSManagedObjectContext+Extension.h"

@implementation UIStoryboardSegue (Extension)

- (void)passManagedObjectContextIfNeeded {

    if ([self.sourceViewController isKindOfClass:[UIViewController class]] &&
        [self.destinationViewController isKindOfClass:[UIViewController class]])
        if ([self.sourceViewController respondsToSelector:@selector(managedObjectContext)]) {
            NSManagedObjectContext *managedObjectContext = [self.sourceViewController performSelector:@selector(managedObjectContext)];
            [managedObjectContext passToViewController:self.destinationViewController];
        }
    
}

@end
