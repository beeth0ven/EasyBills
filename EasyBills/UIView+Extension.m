//
//  UIView+Extension.m
//  EasyBills
//
//  Created by luojie on 5/12/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setupBackgroundImage {
    UIImage *image = [UIImage imageNamed:@"BackGround"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
    imageView.image = image;
    [self insertSubview:imageView atIndex:0];
}

@end
