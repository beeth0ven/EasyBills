//
//  UIViewController+Extension.m
//  EasyBills
//
//  Created by Beeth0ven on 2/22/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "SWRevealViewController.h"

@implementation UIViewController (Extension)

- (void)setupMenuButton{
    
    UIImage *image = [UIImage imageNamed:@"MenuNavigationBarIcon"];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]
                                              initWithImage:image
                                              style:UIBarButtonItemStylePlain
                                              target:self.revealViewController
                                              action:@selector(revealToggle:)];
    
    [self.navigationController.navigationBar
     addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

@end
