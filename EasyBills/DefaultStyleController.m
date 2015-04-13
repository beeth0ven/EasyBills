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
    
    [self configBackButtonImageOnNavigationBar];
    [self configSwichAppearance];
    
    [[UILabel appearance] setFont:[UIFont fontWithName:@"DFWaWaSC-W5" size:20.0]];

}


+ (void)configBackButtonImageOnNavigationBar{
    
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
    UIImage *backButtonImage = [UIImage imageNamed:@"LeftNavigationBarBackIcon"];
    UIEdgeInsets insets = UIEdgeInsetsMake(0,
                                           backButtonImage.size.width - 1,
                                           0,
                                           0);
    backButtonImage = [backButtonImage
                       resizableImageWithCapInsets:insets];
    
    
    [barButtonItemAppearance setBackButtonBackgroundImage:backButtonImage
                                                 forState:UIControlStateNormal
                                               barMetrics:UIBarMetricsDefault];
    
    
}

+ (void)configSwichAppearance{
    
    UISwitch *switchAppearance = [UISwitch appearance];
    switchAppearance.onTintColor = EBBackGround;
    switchAppearance.thumbTintColor = EBBlue;
    
}
@end
