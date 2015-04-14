//
//  UIFont+Extension.h
//  EasyBills
//
//  Created by luojie on 4/14/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kWawaFontName;


@interface UIFont (Extension)

+ (UIFont *)wawaFontForNavigationTitle;

+ (UIFont *)wawaFontForSegmentedTitle;

+ (UIFont *)wawaFontForLabel;

@end
