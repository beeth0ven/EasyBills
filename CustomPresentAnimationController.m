//
//  CustomPresentAnimationController.m
//  EasyBills
//
//  Created by luojie on 4/8/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "CustomPresentAnimationController.h"

@implementation CustomPresentAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    UIView *containerView = [transitionContext containerView];
//    CGRect bounds = [UIScreen mainScreen].bounds;
//    toVC.view.frame = CGRectInset(finalFrameForVC, finalFrameForVC.size.width / 2, finalFrameForVC.size.height / 2);
    [containerView addSubview:toVC.view];

    UIView *snapshotView = [toVC.view snapshotViewAfterScreenUpdates:YES];
    snapshotView.frame = CGRectInset(finalFrameForVC, finalFrameForVC.size.width / 2, finalFrameForVC.size.height / 2);
    snapshotView.center = self.startPoint;
    

    [containerView addSubview:snapshotView];
    [toVC.view removeFromSuperview];

        
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         fromVC.view.alpha = 0.5;
                         snapshotView.frame = finalFrameForVC;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                         fromVC.view.alpha = 1.0;
                         [snapshotView removeFromSuperview];
                         [containerView addSubview:toVC.view];

                     }
     ];
}



@end
