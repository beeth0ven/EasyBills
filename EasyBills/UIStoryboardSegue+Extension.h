//
//  UIStoryboardSegue+Extension.h
//  EasyBills
//
//  Created by luojie on 5/1/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboardSegue (Extension)

- (void)passManagedObjectContextIfNeeded;

@end
