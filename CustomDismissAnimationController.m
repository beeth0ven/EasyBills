//
//  CustomDismissAnimationController.m
//  EasyBills
//
//  Created by luojie on 4/8/15.
//  Copyright (c) 2015 beeth0ven. All rights reserved.
//

#import "CustomDismissAnimationController.h"

@implementation CustomDismissAnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrameForVC = [transitionContext finalFrameForViewController:toVC];
    UIView *containerView = [transitionContext containerView];
    toVC.view.frame = finalFrameForVC;
    toVC.view.alpha = 0.5;
    [containerView addSubview:toVC.view];
    [containerView sendSubviewToBack:toVC.view];
    
    UIView *snapshotView = [fromVC.view snapshotViewAfterScreenUpdates:false];
    snapshotView.frame = fromVC.view.frame;
    [containerView addSubview:snapshotView];
    
    [fromVC.view removeFromSuperview];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
                         snapshotView.frame = CGRectInset(snapshotView.frame,
                                                          snapshotView.frame.size.width / 2,
                                                          snapshotView.frame.size.height / 2);
                         snapshotView.center =
                         self.customDismissAnimationControllerEndPointType == CustomDismissAnimationControllerEndPointTypeOperator ?
                         self.operatorPoint :
                         self.sumPoint;
                         
                         toVC.view.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [snapshotView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }
     ];
}


@end
