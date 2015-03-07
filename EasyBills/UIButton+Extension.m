//
//  UIButton+Extension.m
//  EasyBills
//
//  Created by 罗 杰 on 2/7/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIButton+Extension.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Extension)


- (void)setBackgroundColor:(UIColor *)backgroundColor
                  forState:(UIControlState)state{
    
    UIView *colorView = [[UIView alloc] initWithFrame:self.frame];
    colorView.backgroundColor = backgroundColor;
    
    UIGraphicsBeginImageContext(colorView.bounds.size);
    
    [colorView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self setBackgroundImage:colorImage forState:state];
    
}


@end
