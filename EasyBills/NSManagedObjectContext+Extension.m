//
//  NSManagedObjectContext+Extension.m
//  EasyBills
//
//  Created by luojie on 5/1/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "NSManagedObjectContext+Extension.h"
#import "HomeViewController.h"

@implementation NSManagedObjectContext (Extension)


- (void)passToViewController:(UIViewController *)toViewController {
    
    UIViewController *destinationVC;
    
    if ([toViewController isKindOfClass:[UINavigationController class]]) {
        //toViewController is UINavigationController.
        UINavigationController *navigationController = (UINavigationController *)toViewController;
        destinationVC = navigationController.topViewController;
    } else {
        //toViewController is UIViewController.
        destinationVC = toViewController;
    }
    
    
    if (self && [destinationVC respondsToSelector:@selector(setManagedObjectContext:)]) {
            [destinationVC performSelector:@selector(setManagedObjectContext:) withObject:self];
            NSLog(@"Successfully passed managedObjectContext to controller.");
    }
    
}


@end
