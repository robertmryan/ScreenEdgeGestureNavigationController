//
//  PopAnimator.m
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import "ScreenEdgeGesturePopAnimator.h"

@implementation ScreenEdgeGesturePopAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    CGFloat width = fromViewController.view.frame.size.width;
    CGRect originalFrame = fromViewController.view.frame;
    CGRect rightFrame = CGRectOffset(originalFrame, width, 0);
    CGRect leftFrame  = CGRectOffset(originalFrame, -width / 2.0, 0);
    toViewController.view.frame = leftFrame;

    fromViewController.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    fromViewController.view.layer.shadowRadius = 10.0;
    fromViewController.view.layer.shadowOpacity = 0.5;

    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.frame = rightFrame;
        toViewController.view.frame = originalFrame;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            fromViewController.view.frame = originalFrame;
        } else {
            fromViewController.view.frame = rightFrame;
            toViewController.view.frame = originalFrame;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        });
    }];
}

@end
