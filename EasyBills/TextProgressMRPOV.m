//
//  TextProgressMRPOV.m
//  EasyBills
//
//  Created by luojie on 5/11/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "TextProgressMRPOV.h"
#import "UIColor+Extension.h"
#import "DefaultStyleController.h"
#import "AppDelegate.h"

@interface TextProgressMRPOV ()


@end


@implementation TextProgressMRPOV

+ (instancetype)defaultTextProgressMRPOV {
    TextProgressMRPOV* textProgressMRPOV = [[self alloc] init];
    textProgressMRPOV.mode = MRProgressOverlayViewModeIndeterminateSmall;
    textProgressMRPOV.tintColor = [UIColor globalTintColor];
    textProgressMRPOV.titleLabelText = NSLocalizedString( @"Loading...", "");
    return textProgressMRPOV;
}


@end
