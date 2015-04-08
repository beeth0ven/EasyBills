//
//  CustomDismissAnimationController.h
//  EasyBills
//
//  Created by luojie on 4/8/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import <Foundation/Foundation.h>

enum :NSInteger{
    CustomDismissAnimationControllerEndPointTypeOperator = 0,
    CustomDismissAnimationControllerEndPointTypeSum,
} CustomDismissAnimationControllerEndPointType;

@interface CustomDismissAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) CGPoint operatorPoint;
@property (nonatomic) CGPoint sumPoint;

@property (nonatomic) NSInteger customDismissAnimationControllerEndPointType;

@end
