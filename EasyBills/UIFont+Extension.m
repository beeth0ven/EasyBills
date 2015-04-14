//
//  UIFont+Extension.m
//  EasyBills
//
//  Created by luojie on 4/14/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "UIFont+Extension.h"

NSString *const kWawaFontName = @"DFWaWaSC-W5";


@implementation UIFont (Extension)

+ (UIFont *)wawaFontForNavigationTitle {
    return [UIFont fontWithName:kWawaFontName size:26.0];
}

+ (UIFont *)wawaFontForBarButtonItem {
    return [UIFont fontWithName:kWawaFontName size:20.0];
}

+ (UIFont *)wawaFontForSegmentedTitle {
    return [UIFont fontWithName:kWawaFontName size:16.0];
}

+ (UIFont *)wawaFontForLabel {
    return [UIFont fontWithName:kWawaFontName size:20.0];
}

+ (UIFont *)wawaFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kWawaFontName size:fontSize];
}

@end
