//
//  UINavigationController+Style.m
//  123
//
//  Created by Beeth0ven on 2/22/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UINavigationController+Style.h"
#import "DefaultStyleController.h"
#import "SWRevealViewController.h"


@implementation UINavigationController (Style)


- (void)applyDefualtStyle:(BOOL)defualt{
    
    UIColor *white = [UIColor whiteColor];
    
    UIColor *navigationBarBarTintColor  = defualt ? EBBlue   :   white;
    UIColor *navigationBarTintColor     = defualt ? white    :   EBBackGround;
    UIColor *navigationBarTitleColor    = defualt ? white    :   EBBackGround;
    UIStatusBarStyle stateBarStyle      = defualt ? UIStatusBarStyleLightContent  : UIStatusBarStyleDefault;
    
    [self setNavigationBarTintColor:navigationBarBarTintColor
                          tintColor:navigationBarTintColor
                         titleColor:navigationBarTitleColor];
    
    [[UIApplication sharedApplication]
     setStatusBarStyle:stateBarStyle
     animated:YES];
}

- (void)setNavigationBarTintColor:(UIColor *)barTintColor
                        tintColor:(UIColor *)tintColor
                       titleColor:(UIColor *)titleColor
{
    if (barTintColor == nil) {
        return;
    }
    
    if (tintColor == nil) {
        return;
    }
    
    if (titleColor == nil) {
        return;
    }
    
    UINavigationBar *navigationBar = [self navigationBar];
    
    NSDictionary *textAttributes = [self titleAttributesWithTitleColor:titleColor];
    
    navigationBar.barTintColor = barTintColor;
    navigationBar.tintColor = tintColor;
    navigationBar.titleTextAttributes = textAttributes;
}

- (NSDictionary *)titleAttributesWithTitleColor:(UIColor *)titleColor{
    
    NSDictionary *result = nil;
    
    if (titleColor == nil) {
        return nil;
    }
    
    UIFont *font = [UIFont fontWithName:@"DFWaWaSC-W5" size:24.0];

//    [UIFont boldSystemFontOfSize:20.0f];
    result =@{NSFontAttributeName : font,
              NSForegroundColorAttributeName : titleColor};
    
    return result;
    
}

@end
