//
//  RoundedButton.m
//  EasyBills
//
//  Created by luojie on 5/18/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "RoundedButton.h"
#import "UIColor+Extension.h"

@implementation RoundedButton


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.borderWidth = self.bounds.size.height * 3.5/64.0 * 1.2;
    self.layer.borderColor = [UIColor globalTintColor].CGColor;
}




@end
