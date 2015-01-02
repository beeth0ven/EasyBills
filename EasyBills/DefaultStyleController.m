//
//  DefaultStyleController.m
//  EasyBills
//
//  Created by 罗 杰 on 12/13/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//



#import "DefaultStyleController.h"

@implementation DefaultStyleController

+(void) applyStyle
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    //navigationBarAppearance.barTintColor = EBBlue;
    //navigationBarAppearance.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
    barButtonItemAppearance.tintColor = [UIColor whiteColor];
    
    UISwitch *switchAppearance = [UISwitch appearance];
    switchAppearance.onTintColor = EBBackGround;
    switchAppearance.thumbTintColor = EBBlue;
    /*
    UITableView *tableViewAppearance = [UITableView appearance];
    UIImage *image = [UIImage imageNamed:@"Account details BG.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    tableViewAppearance.backgroundView = imageView;
    */
}


@end
