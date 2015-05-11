//
//  UIColor+Extension.m
//  EasyBills
//
//  Created by luojie on 5/11/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIColor+Extension.h"
#import "AppDelegate.h"

@implementation UIColor (Extension)

+ (UIColor *)globalTintColor {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.window.tintColor;
}

@end
