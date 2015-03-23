//
//  UIImage+Extension.m
//  EasyBills
//
//  Created by luojie on 3/23/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)pointerImageWithColor:(UIColor *)color{
    
    UIImage *result = nil;
    UIImage *image  = [UIImage imageNamed:@"PointerIcon"];
    if (image != nil) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        CGFloat scale = 0.5;
        UIImageView *imageView = [[UIImageView alloc]
                                  initWithFrame:CGRectMake(0,
                                                           0,
                                                           image.size.width  * scale,
                                                           image.size.height * scale)];
        imageView.image = image;
        imageView.tintColor = color;
        
        //  Use Core Graphics to redrew image with color, Then get it back.
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size,
                                               imageView.opaque,
                                               0);
        
        [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        result = UIGraphicsGetImageFromCurrentImageContext();
    }
    return result;
}


@end
