//
//  UIViewController+Extension.m
//  EasyBills
//
//  Created by Beeth0ven on 2/22/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"

@implementation UIViewController (Extension)

- (void)setupMenuButton{
    
    UIImage *image = [UIImage imageNamed:@"MenuNavigationBarIcon"];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]
                                              initWithImage:image
                                              style:UIBarButtonItemStylePlain
                                              target:self.revealViewController
                                              action:@selector(revealToggle:)];
    
//    SWRevealViewController *revealController = [self revealViewController];
    
//    [revealController panGestureRecognizer];
//    [revealController tapGestureRecognizer];
    
//    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

//    [self.navigationController.navigationBar
//     addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
}

- (void)setupBackgroundImage {
    [self.view setupBackgroundImage];
}

- (void)enableRevealPanGesture {
    //    UIViewController *topViewController = frontViewController.topViewController;
    if ([self respondsToSelector:@selector(viewForHoldingRevealPanGesture)]) {
        id obj = [self performSelector:@selector(viewForHoldingRevealPanGesture)];
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *view = (UIView *)obj;
            [view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
    }

}


@end
