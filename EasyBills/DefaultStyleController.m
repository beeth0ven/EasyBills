//
//  DefaultStyleController.m
//  EasyBills
//
//  Created by 罗 杰 on 12/13/14.
//  Copyright (c) 2014 beeth0ven. All rights reserved.
//



#import "DefaultStyleController.h"
#import "UIFont+Extension.h"

@implementation DefaultStyleController

+(void) applyStyle
{
    
    [self configBackButtonImageOnNavigationBar];
    [self configSwichAppearance];
    
    //Configure UILabel font.
//    [[UILabel appearance] setFont:[UIFont wawaFontForLabel]];
//    Configure UISegmentedControl.
    //    NSDictionary *segmentedTitleAttributes = @{NSFontAttributeName : [UIFont wawaFontForSegmentedTitle]};
//    [[UISegmentedControl appearance] setTitleTextAttributes:segmentedTitleAttributes
//                                                   forState:UIControlStateNormal];
    //Configure UIBarButtonItem.
    //    NSDictionary *barButtonItemTitleAttributes = @{NSFontAttributeName : [UIFont wawaFontForBarButtonItem]};
//    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonItemTitleAttributes
//                                          forState:UIControlStateNormal];
    
    //Configure UITableViewCell selected color.
    UIColor *cellSellectedColor = [EBBlue colorWithAlphaComponent:0.3];
    UIView *colorView = [[UIView alloc] init];
    colorView.backgroundColor = cellSellectedColor;
    [[UITableViewCell appearance] setSelectedBackgroundView:colorView];
    

    
}


+ (void)configBackButtonImageOnNavigationBar{
    
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
    UIImage *backButtonImage = [UIImage imageNamed:@"LeftNavigationBarBackIcon"];
    [barButtonItemAppearance setBackButtonBackgroundImage:backButtonImage
                                                 forState:UIControlStateNormal
                                               barMetrics:UIBarMetricsDefault];
//    [barButtonItemAppearance setBack
}

+ (void)configSwichAppearance{
    
    UISwitch *switchAppearance = [UISwitch appearance];
    switchAppearance.onTintColor = EBBackGround;
    switchAppearance.thumbTintColor = EBBlue;
    
}
@end
