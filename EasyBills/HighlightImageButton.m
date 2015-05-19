//
//  HighlightImageButton.m
//  EasyBills
//
//  Created by luojie on 5/18/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "HighlightImageButton.h"
#import "UIColor+Extension.h"


@implementation HighlightImageButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
//    UIColor *highlightedColor = [[UIColor globalTintColor] colorWithAlphaComponent: 0.2];
//    UIColor *normalColor = [UIColor globalTintColor];
//    self.tintColor = highlighted ? highlightedColor : normalColor;
    self.alpha = highlighted ? 0.2 : 1.0;
}

@end
