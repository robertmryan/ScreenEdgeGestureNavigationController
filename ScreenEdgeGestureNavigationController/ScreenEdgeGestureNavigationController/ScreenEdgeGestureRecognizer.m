//
//  ScreenEdgeGestureRecognizer.m
//  ScreenEdgeGestureNavigationController
//
//  Created by Robert Ryan on 4/11/14.
//  Copyright (c) 2014 Robert Ryan. All rights reserved.
//
//  This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
//  http://creativecommons.org/licenses/by-sa/4.0/
//

#import "ScreenEdgeGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface ScreenEdgeGestureRecognizer ()

@property (nonatomic, weak)   UINavigationController <ScreenEdgeGestureRecognizerDelegate> *navigationController;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition                         *interactionController;
@property (nonatomic)         UIRectEdge                                                    gestureEdge;

@end


@implementation ScreenEdgeGestureRecognizer

- (instancetype)initWithEdges:(UIRectEdge)edges navigationController:(UINavigationController<ScreenEdgeGestureRecognizerDelegate> *)navigationController;
{
    NSParameterAssert([navigationController conformsToProtocol:@protocol(ScreenEdgeGestureRecognizerDelegate)]);
    
    self = [super initWithTarget:self action:@selector(handleEdgePan:)];
    if (self) {
        self.edges = edges;
        _navigationController = navigationController;
        _gestureEdge = edges;
    }
    return self;
}

- (void)handleEdgePan:(UIScreenEdgePanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.gestureEdge == UIRectEdgeRight) {                                               // push
            UIViewController *controller = [self.navigationController firstPoppedViewController];
            if (controller) {
                self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            } else {
                self.state = UIGestureRecognizerStateFailed;
            }
        } else if (self.gestureEdge == UIRectEdgeLeft) {                                         // pop
            NSArray *controllers = self.navigationController.viewControllers;
            if ([controllers count] > 1) {
                self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                self.state = UIGestureRecognizerStateFailed;
            }
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:gesture.view];
        CGFloat width       = gesture.view.bounds.size.width;

        CGFloat percent     = ABS(translation.x / width);

        [self.interactionController updateInteractiveTransition:percent];
    } else if (gesture.state == UIGestureRecognizerStateEnded ||
               gesture.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint translation  = [gesture translationInView:gesture.view];
        CGPoint velocity     = [gesture velocityInView:gesture.view];
        CGFloat finalPercent = ABS(translation.x + velocity.x * 0.25 / gesture.view.bounds.size.width);

        if (finalPercent < 0.5 || gesture.state == UIGestureRecognizerStateCancelled) {
            [self.interactionController cancelInteractiveTransition];
            [self.navigationController didCancelGesture:gesture];
        } else {
//            self.interactionController.completionCurve = UIViewAnimationCurveEaseOut;
//            self.interactionController.completionSpeed = 1.0;
            [self.interactionController finishInteractiveTransition];
        }

        self.interactionController = nil;
    }
}

@end
