//
//  UIAlertView+Extension.m
//  EasyBills
//
//  Created by luojie on 4/22/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIAlertView+Extension.h"



@implementation UIAlertView (Extension)

+ (void)displayAlertWithTitle:(NSString *)title
                      message:(NSString *)message{
    
    UIAlertView *alertView =
    [[UIAlertView alloc]
     initWithTitle:title
     message:message
     delegate:nil
     cancelButtonTitle:NSLocalizedString( @"Ok", "")
     otherButtonTitles: nil];
    
    [alertView show];
    
}
@end
