//
//  UIAlertView+Extension.h
//  EasyBills
//
//  Created by luojie on 4/22/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCLAuthorizationStatusDeniedTitle;

extern NSString *const kCLAuthorizationStatusDeniedMessage;

extern NSString *const kCLAuthorizationStatusRestrictedTitle;
extern NSString *const kCLAuthorizationStatusRestrictedMessage;


@interface UIAlertView (Extension)

+ (void)displayAlertWithTitle:(NSString *)title
                      message:(NSString *)message;
    
@end
